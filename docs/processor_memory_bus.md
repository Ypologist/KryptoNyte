# Processor-to-Memory Bus Architecture (TileLink + AXI4 Bridge)

## Background and Current State
- `rtl/TetraNyte/rv32i/src/main/scala/TetraNyteRV32ICore.scala` exposes a thread-local instruction fetch vector plus a shared data-memory port (`memAddr`, `memWrite`, `memMask`, `dataMemResp`).
- The existing memory model in `tests/sim/tetranyte_sim.cpp` is a flat SRAM that services fetches combinationally and writes via byte masks. There is no notion of latency, back-pressure, or multiple outstanding requests.
- To tape-out the core inside a modern SoC we need a packetized bus that (a) tolerates latency, (b) supports full/partial writes, and (c) can bridge into industry-standard memory controllers. Chipyard’s TileLink plus an AXI4 bridge is the practical pairing.

## Requirements
1. **Protocol Choice**: Use TileLink-Uncached Lite (TL-UL) for simplicity—one A channel (requests) and one D channel (responses). No B/C/E channels needed because the core behaves as an uncached master.
2. **Data Width**: Maintain a 32-bit data path at the core boundary to avoid widening register files, but allow the TileLink bus to be parameterized (default 64-bit) so the AXI bridge can burst against wider DRAM ports.
3. **Outstanding Transactions**: Each of the four interleaved threads must be able to issue at least one in-flight memory request so the barrel pipeline stays full. Loads require write-back upon response; stores may retire once the Put is accepted.
4. **Misaligned Accesses**: Reuse the existing `StoreUnit`/`LoadUnit` logic. Misaligned stores must be split into legal TileLink transactions; misaligned loads either trap (future work) or are handled by the Load unit by reassembling the word from a single aligned fetch if possible.
5. **Bridge**: Provide a synchronous TileLink-to-AXI4 adapter that translates TL puts/gets into AXI write/read bursts while preserving ordering for each TileLink source ID.

## Proposed Architecture
### 1. Core MemPort Wrapper
Introduce a `TetraNyteMemPort` module that lives beside the core:
- Accepts per-thread enqueue requests consisting of `{addr, wdata, mask, isLoad, isStore, threadId}` plus `instrFetch` requests for each PC.
- Arbitrates between data requests (round-robin) and instruction fetch prefetches. Instruction fetch uses TL `Get` commands tagged with source IDs 0–3; data requests use IDs 4–7 to keep completion bookkeeping isolated.
- Stores the metadata for each outstanding load (`threadId`, `rd`, `isLoad`) inside a small CAM indexed by `source`.
- Emits TileLink A-channel beats with ready/valid handshake. Loads become `Get` (size=log2(bytes)); aligned stores become `PutFullData`; partial stores take `PutPartialData` with `mask` bits derived from `StoreUnit`.

### 2. Response Handling
- D-channel responses are routed back using the `source` field. For loads, the stored metadata drives write-back data and rd. For instruction fetch responses, data is written into a per-thread I-cache scratchpad that feeds `instrMem(t)` the next cycle.
- Stores simply free their source ID when the grant is observed (TL-UL grants are either AccessAck or AccessAckData for loads).

### 3. Flow Control and FIFOs
- Separate depth-2 FIFOs for instruction fetch and data requests decouple the pipeline from TileLink stalls. Back-pressure signals propagate to the core via a simple `memBusy` flag so the pipeline can insert bubbles if all FIFOs are full (future enhancement; today the queue depth hides moderate latency).
- A thread cannot issue a new load until its outstanding entry is free, but stores can be pipelined so long as the TileLink A-channel accepts Put requests.

## TileLink-to-AXI4 Bridge
Implement a standalone `TileLinkAXI4Bridge` module:
1. **Request Translation**
   - Map TL `Get` to AXI `AR` transactions; TL `Put*` to paired `AW/W` beats.
   - Compute AXI burst `len=0` (single beat) initially; leave hooks for future bursts once we support TL `Acquire`.
   - Preserve the TL `source` inside the AXI `id` field so responses can be routed unchanged back to the MemPort wrapper.
2. **Write Path**
   - TL `PutFull/Partial` drives AXI `AW` (addr, prot) and `W` (data, strb). Buffer writes until both AW and W have been fired; wait for `B` response before sending TL `AccessAck` on D channel.
3. **Read Path**
   - TileLink `Get` drives AXI `AR`. When the AXI `R` beat arrives, package the payload plus original `source` into a TL `AccessAckData` on D channel.
4. **Clock/Reset & Width**
   - Single synchronous clock for the first integration. Parameterize data width (default 64b) so the TL side can be 32b but the bridge upsizes to 64b using `mask`/`addr` alignment logic.

## Integration Steps
1. **Define the TileLink Bundle**: Add a lightweight TL record (channels A/D) under `rtl/library/src/main/scala/TileLink/` to avoid pulling the full Rocket-Chip dependency. Include only the signals we need: opcode, param, size, source, address, mask, data, corrupt, valid/ready.
2. **MemPort Module**:
   - Instantiate inside `TetraNyteRV32ICore` and reroute existing `memAddr`, `memWrite`, etc., through this module.
   - Provide per-thread instruction fetch requests by exporting `pcRegs(t)` and consuming the returned TL data to update `if_id(t).instr` instead of the raw `instrMem` vector.
3. **Bridge Module**: Place `TileLinkAXI4Bridge` under `rtl/library/src/main/scala/TileLink/`. Connect it to the MemPort TL master and expose AXI4 pins outward (AW, W, B, AR, R).
4. **Top-Level IO Changes**: Replace the ad-hoc IO bundle in `TetraNyteRV32ICoreIO` with TileLink master pins for memory plus AXI pins at the SoC boundary. Maintain the old simple interface temporarily behind a compatibility shim to keep the software simulator running.
5. **Simulation Hooks**: Update `tests/sim/tetranyte_sim.cpp` with a simple TileLink memory model so we can regress without AXI. Later, add a co-sim AXI DRAM model for end-to-end testing.

## Verification Strategy
- **Unit Tests**: Create Chisel testers for the TileLink bundles ensuring correct encoding of opcode/size/mask across byte/half/word stores. Simulate FIFO overflow and ensure back-pressure is propagated.
- **Bridge Testbench**: Use a simple AXI memory BFM (Verilator or cocotb) that injects wait states to validate that outstanding read/write IDs are preserved and that TL D-channel responses are ordered per source.
- **Core Integration**: Extend `TetraNyteRV32ICoreTest.scala` to toggle between the legacy SRAM interface and the TileLink port. Check that each thread still advances round-robin even when the TL bus inserts random stalls.
- **System-Level**: Once the AXI side exists, run the `tests/sim/tetranyte_sim.cpp` harness against a DRAM init file to confirm loads/stores still match the existing reference log.

## Next Actions
1. Implement the TileLink bundle definitions and enums.
2. Build the `TetraNyteMemPort` request queues + response tracker.
3. Add the TileLink-to-AXI4 bridge and an AXI memory model for simulation.
4. Replace the legacy SRAM hookups with the new bus in both RTL and C++ sim harness.
