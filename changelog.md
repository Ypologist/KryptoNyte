# 06:48 - Corrected OpenLane 2 Floorplan Target Utilization

**Why these changes were made:**
A recent OpenLane 2 pass inflated the floorplan footprint of `RegFileMT2R1WMem` to ~46.2 mm², spacing out standard cells across a massive die area. This caused profound RC interconnect delays that resulted in severe setup logic timing violations (-1.48 ns slack @ 100 MHz target). This anomaly happened because `FP_CORE_UTIL` constraints within config files were specified using decimal ratio bounds (like 0.5 or 0.7), which OpenLane 2 misinterpreted directly as sparse percentages (e.g., 0.5% utilization).

**What the changes are:**
* Refactored `FP_CORE_UTIL` assignment values across all 8 distinct layout config JSON files natively located in `/physical_design`, converting them from scalar floats to rigid percentage integers (e.g. 0.5 -> 50, 0.7 -> 70).
* Modified default environment arguments parsing in the `generate_physical_design.sh` baseline script to expect and distribute integer utilization percentages instead of numeric ratios.

# 21:57 - Fixed MRF IO Pin Constraints

**Why these changes were made:**
The custom IO pin constraint configuration file (`pin_order.mrf.cfg`) was previously modified to exclude the `reset` pin because the new memory-based block eliminated the global reset logic. However, Chisel implicitly generates a default `reset` port for all modules regardless of internal usage, causing OpenLane's strict unmatched pin validation to crash during the IO placement stage.

**What the changes are:**
* Restored the `reset` pin assignment back to the Northern edge in `physical_design/constraints/pin_order.mrf.cfg` to satisfy OpenLane IO constraints and safely complete the physical design flow execution.

# 16:11 - Fixed TetraNyte MRF Conformance Test Simulator

**Why these changes were made:**
Invoking the RV32I conformance runner with `--processor tetranyte-mrf` triggered a script missing error because the discrete Verilator build scripts and the underlying C++ testbench instances for the new `TetraNyteRV32ICoreMRF` target had not yet been created.

**What the changes are:**
* Appended the new memory-based core definition to the primary `generateTetraNyteRTL` target in `GenerateHierarchicalRTL.scala` so that compiling `TetraNyte` modules automatically outputs the hierarchical Verilog for both core iterations.
* Created a standalone simulator build script `/tests/sim/build_tetranyte_mrf_sim.sh` ensuring that Verilator compilation targets compile strictly to `tetranyte_mrf_obj` leveraging `TetraNyteRV32ICoreMRF.v`.
* Created the C++ simulator runtime driver `/tests/sim/tetranyte_mrf_sim.cpp` by duplicating the base component and overriding instantiation calls to utilize the designated `VTetraNyteRV32ICoreMRF` top module.

# 16:08 - Added RV32I Conformance Support for TetraNyte MRF

**Why these changes were made:**
The `TetraNyteRV32ICoreMRF` core was recently created but lacked the necessary test harness configuration to evaluate it across the RV32I conformance regression suite. 

**What the changes are:**
Enhanced the `/tests/run_rv32i_conformance.sh` script to explicitly support a `--processor tetranyte-mrf` argument:
* Wired `DUT_NAME`, simulation logic (`tetranyte_mrf_sim`, `tetranyte_mrf_obj`), and `RTL_TOP` configuration to point to the newly synthesized `TetraNyteRV32ICoreMRF` target.
* Reused the `tetranyte` config and ISA configurations to prevent redundant definition entries while keeping logic completely distinct per-processor flag.
* Handled the fallback conditional strings for the smoke test execution sequence so that the target `VTetraNyteRV32ICoreMRF` binary correctly tracks generated multi-thread architectural signatures.

# 16:03 - TetraNyte Core MRF Integration

**Why these changes were made:**
A new core module was needed to instantiate and utilize the highly optimized, memory-based multithreaded register file (`RegFileMT2R1WMem`) without disrupting or overwriting the existing `TetraNyteRV32ICore` configuration.

**What the changes are:**
* Created `TetraNyteRV32ICoreMRF.scala`, which is a direct derived instance of the original `TetraNyte` RV32I processor module.
* Overrode the register file instance from `RegFileMT2R1WVec` to `RegFileMT2R1WMem` within the new module.

# 15:50 - Register File Optimizations

**Why these changes were made:**
The multithreaded register file (`RegFileMT2R1WVec`) was previously implemented as a vector of initialized registers. This implementation caused massive physical area usage (due to ~4000 D-flip-flops padding the die) and resulted in severely slow clock frequencies that failed the 100MHz timing target. This was primarily driven by the massive reset fanout required to initialize every bit and the giant combinational multiplexer trees required for the read data paths.

**What the changes are:**
Created a new memory-based version of the multithreaded register file, named `RegFileMT2R1WMem.scala`, with the following architectural optimizations:
* **Memory Primitives**: Replaced the explicit discrete `Vec(RegInit(...))` flip-flops with Chisel's asynchronous `Mem` primitive. This enables synthesis tools (like Yosys) to map the logic to dedicated memory arrays or tighter logic cells instead of standalone standard sequential logic cells.
* **Eliminated Global Reset**: By utilizing `Mem`, the register file drops initialization requirements, resolving severe reset fanout routing congestion. 
* **Hardwired `x0` to Zero**: Added bypass logic ensuring that any thread evaluating a read from `x0` statically returns `0`. Writes targeting `x0` are ignored.
* **Retained Asynchronous Reads**: Maintained combinatorial read ports so that the `TetraNyte` core does not require a new pipeline stage, avoiding new data hazards in its Fetch-Decode-Execute-Writeback pipeline.
