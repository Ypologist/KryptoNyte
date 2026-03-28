# 03/28/2026 11:16 - Stabilized ZeroNyte Architectural Compliance (StoreUnit)

**Why these changes were made:**
Although `zeronyte` and `zeronyte-im` processors previously passed the RV32I conformance tests, `zeronyte-zmmul` experienced failures specifically on `sb-align` and `sh-align` assertions. This happened because its core omitted full Read-Modify-Write logic while the others relied on archaic but functional local byte-masking hooks. The entire `ZeroNyte` core family was uncoupled from the formal `StoreUnit` library module standard which is used natively by `TetraNyte` and `OctoNyte`.

**What the changes are:**
* Refactored `ZeroNyteRV32ICore`, `ZeroNyteRV32IZmmulCore`, and `ZeroNyteRV32IMCore` to uniformly instantiate and respect the library `StoreUnit` module boundary.
* Eliminated the hardcoded inline byte-shifting logic natively across the `ZeroNyte` architectures, establishing consistent standard data alignments and memory-mask derivations.
* Upgraded the Verilator C++ simulation harnesses (`zeronyte_im_sim.cpp`, `zeronyte_zmmul_sim.cpp`) to evaluate generated test binaries across explicit byte-driven `dmem_wmask` hardware constraints instead of relying on legacy 32-bit overwrites.

# 03/28/2026 10:52 - Unified RISC-V Conformance Tests & Integrated M/Zmmul Targets

**Why these changes were made:**
The RISC-V regression tests were previously fragmented into multiple architecture-specific bash drivers (`run_rv32i_conformance.sh`, `run_rv32m_conformance.sh`). A singular, intelligent driver logic was needed to consolidate the testbed routing. Additionally, the newly isolated `rv32im` and `rv32i_Zmmul` processors lacked dedicated integration points in both the Chisel RTL Verilator configuration pipelines and the Python RISCOF harnesses.

**What the changes are:**
* Created a unified `tests/run_riscv_conformance_tests.sh` driver equipped with a `--processor` arguments parser to dynamically proxy execution subsets (e.g. `Zmmul` conditionally truncates the `rv32i_m/M` architectural validations to just pure multipliers natively without Division logic).
* Decommissioned the legacy `run_rv32i_conformance.sh` and `run_rv32m_conformance.sh` scripts.
* Updated `rtl/build.sbt` and `GenerateHierarchicalRTL.scala` to formally register `zeroNyteZmmul` and `zeroNyteIM` SBT sub-projects properly enforcing inheritance of the core `zeroNyte` peripheral libraries.
* Drafted Verilator compilation scripts `build_zeronyte_im_sim.sh`, `build_zeronyte_zmmul_sim.sh`, and their associated C++ driver runtime tests while successfully restoring the base legacy simulation masking loop.
* Initialized isolated `tests/riscof/` Python verification extensions and validation matrices (`isa.yaml`) to integrate the unified framework directly for the `IM` and `Zmmul` boundaries.

# 03/28/2026 10:21 - Propagated Fetch-Execute RV32I Optimization across Core Family

**Why these changes were made:**
The `TetraNyte` and `OctoNyte` cores needed to be aligned with the newly simplified and high-performance `RV32I` baseline established for `ZeroNyte`, removing legacy hardware multiplier/divider blocks and logic where applicable. Additionally, a new variant `ZeroNyte Zmmul` was needed to host the hardware multiplier while inheriting the new optimized Fetch-Execute foundation.

**What the changes are:**
* Created `ZeroNyte/rv32i_Zmmul` and the `ZeroNyteRV32IZmmulCore.scala` module which cleanly injects the `Mul32OneCycle` logic back into the optimized Fetch-Execute `ZeroNyte` foundation.
* Stripped `TetraNyteRV32ICore.scala` of all M-Extension hardware (`Div32Radix4`, `Mul32OneCycle`) and associated stall synchronizations, reverting it to a pure RV32I baseline.
* Verified that `OctoNyteRV32ICore` natively implemented the pure `storeUnit.io.mask` pipeline without M-extensions or legacy FSM stalls.
* Fixed a bash syntax error in the `tests/run_rv32i_conformance.sh` script (removed invalid `local` keyword outside function) that was causing multi-threaded conformance assertions to crash.
* Executed RISCOF RV32I conformance smoke tests against both `TetraNyte` and `OctoNyte` with functional execution succeeding across all threads.

# 03/28/2026 08:10 - Removed M Extension from ZeroNyte RV32I Core

**Why these changes were made:**
The baseline `rv32i` architecture inside the `ZeroNyte` core was originally bloated with 'M' extension components (a 32-bit multiplier and radix-4 divider unit) including associated stall synchronization logic. Since dedicated hardware architectures (`rv32im` and `rv32i_Zmmul`) have now been explicitly branched and isolated in the repository, the core `rv32i` target required cleanup to directly conform to the strict Baseline Integer Instruction Set (RV32I) profile. 

**What the changes are:**
* Stripped `ZeroNyteRV32ICore.scala` of all traces of the `Mul32OneCycle` and `Div32Radix4` submodule instantiations.
* Removed the `isMulInstr` and `isDivInstr` decoding and functional matching assignments.
* Eliminated the division status registers (`divActive`, `divDone`), clearing the dynamic multi-cycle computation hooks from the global execution `stall` pipeline.
* Verified that the resulting core RTL is purely RV32I integer-compliant and safely avoids consuming unnecessary area footprint from disabled execution paths during hardware synthesis.

# 03/28/2026 06:48 - Corrected OpenLane 2 Floorplan Target Utilization

**Why these changes were made:**
A recent OpenLane 2 pass inflated the floorplan footprint of `RegFileMT2R1WMem` to ~46.2 mm², spacing out standard cells across a massive die area. This caused profound RC interconnect delays that resulted in severe setup logic timing violations (-1.48 ns slack @ 100 MHz target). This anomaly happened because `FP_CORE_UTIL` constraints within config files were specified using decimal ratio bounds (like 0.5 or 0.7), which OpenLane 2 misinterpreted directly as sparse percentages (e.g., 0.5% utilization).

**What the changes are:**
* Refactored `FP_CORE_UTIL` assignment values across all 8 distinct layout config JSON files natively located in `/physical_design`, converting them from scalar floats to rigid percentage integers (e.g. 0.5 -> 50, 0.7 -> 70).
* Modified default environment arguments parsing in the `generate_physical_design.sh` baseline script to expect and distribute integer utilization percentages instead of numeric ratios.

# 03/27/2026 21:57 - Fixed MRF IO Pin Constraints

**Why these changes were made:**
The custom IO pin constraint configuration file (`pin_order.mrf.cfg`) was previously modified to exclude the `reset` pin because the new memory-based block eliminated the global reset logic. However, Chisel implicitly generates a default `reset` port for all modules regardless of internal usage, causing OpenLane's strict unmatched pin validation to crash during the IO placement stage.

**What the changes are:**
* Restored the `reset` pin assignment back to the Northern edge in `physical_design/constraints/pin_order.mrf.cfg` to satisfy OpenLane IO constraints and safely complete the physical design flow execution.

# 03/27/2026 16:11 - Fixed TetraNyte MRF Conformance Test Simulator

**Why these changes were made:**
Invoking the RV32I conformance runner with `--processor tetranyte-mrf` triggered a script missing error because the discrete Verilator build scripts and the underlying C++ testbench instances for the new `TetraNyteRV32ICoreMRF` target had not yet been created.

**What the changes are:**
* Appended the new memory-based core definition to the primary `generateTetraNyteRTL` target in `GenerateHierarchicalRTL.scala` so that compiling `TetraNyte` modules automatically outputs the hierarchical Verilog for both core iterations.
* Created a standalone simulator build script `/tests/sim/build_tetranyte_mrf_sim.sh` ensuring that Verilator compilation targets compile strictly to `tetranyte_mrf_obj` leveraging `TetraNyteRV32ICoreMRF.v`.
* Created the C++ simulator runtime driver `/tests/sim/tetranyte_mrf_sim.cpp` by duplicating the base component and overriding instantiation calls to utilize the designated `VTetraNyteRV32ICoreMRF` top module.

# 03/27/2026 16:08 - Added RV32I Conformance Support for TetraNyte MRF

**Why these changes were made:**
The `TetraNyteRV32ICoreMRF` core was recently created but lacked the necessary test harness configuration to evaluate it across the RV32I conformance regression suite. 

**What the changes are:**
Enhanced the `/tests/run_rv32i_conformance.sh` script to explicitly support a `--processor tetranyte-mrf` argument:
* Wired `DUT_NAME`, simulation logic (`tetranyte_mrf_sim`, `tetranyte_mrf_obj`), and `RTL_TOP` configuration to point to the newly synthesized `TetraNyteRV32ICoreMRF` target.
* Reused the `tetranyte` config and ISA configurations to prevent redundant definition entries while keeping logic completely distinct per-processor flag.
* Handled the fallback conditional strings for the smoke test execution sequence so that the target `VTetraNyteRV32ICoreMRF` binary correctly tracks generated multi-thread architectural signatures.

# 03/27/2026 16:03 - TetraNyte Core MRF Integration

**Why these changes were made:**
A new core module was needed to instantiate and utilize the highly optimized, memory-based multithreaded register file (`RegFileMT2R1WMem`) without disrupting or overwriting the existing `TetraNyteRV32ICore` configuration.

**What the changes are:**
* Created `TetraNyteRV32ICoreMRF.scala`, which is a direct derived instance of the original `TetraNyte` RV32I processor module.
* Overrode the register file instance from `RegFileMT2R1WVec` to `RegFileMT2R1WMem` within the new module.

# 03/27/2026 15:50 - Register File Optimizations

**Why these changes were made:**
The multithreaded register file (`RegFileMT2R1WVec`) was previously implemented as a vector of initialized registers. This implementation caused massive physical area usage (due to ~4000 D-flip-flops padding the die) and resulted in severely slow clock frequencies that failed the 100MHz timing target. This was primarily driven by the massive reset fanout required to initialize every bit and the giant combinational multiplexer trees required for the read data paths.

**What the changes are:**
Created a new memory-based version of the multithreaded register file, named `RegFileMT2R1WMem.scala`, with the following architectural optimizations:
* **Memory Primitives**: Replaced the explicit discrete `Vec(RegInit(...))` flip-flops with Chisel's asynchronous `Mem` primitive. This enables synthesis tools (like Yosys) to map the logic to dedicated memory arrays or tighter logic cells instead of standalone standard sequential logic cells.
* **Eliminated Global Reset**: By utilizing `Mem`, the register file drops initialization requirements, resolving severe reset fanout routing congestion. 
* **Hardwired `x0` to Zero**: Added bypass logic ensuring that any thread evaluating a read from `x0` statically returns `0`. Writes targeting `x0` are ignored.
* **Retained Asynchronous Reads**: Maintained combinatorial read ports so that the `TetraNyte` core does not require a new pipeline stage, avoiding new data hazards in its Fetch-Decode-Execute-Writeback pipeline.
