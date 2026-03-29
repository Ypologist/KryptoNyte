# 03/28/2026 19:04 - OctoNyte Pipelined Multiplier Hardware

**Why these changes were made:**
* **OctoNyte Superscalar Architecture:** In preparation for expanding `OctoNyte` into a 4-issue 8-stage superscalar barrel processor natively, its execution pipeline topologically stretches across 3 discrete physical stages (`EX1 -> EX2 -> EX3`). 
* **Retiming Tradeoffs:** A 3-cycle Pipelined Multiplier design efficiently allows the combinational multiplication matrix to topologically align with the `EX` stages seamlessly. By explicitly retiming logic exactly across 3 cycles, the product organically converges at the Writeback (`WB`) boundaries mathematically while gracefully allowing modern ASIC synthesizers (OpenLane/Yosys) to distribute netlist gating without introducing stall logic.

**What the changes are:**
* **`library/src/main/scala/ALUs/Mul32Pipelined.scala`:** Engineered a highly parameterizable combinational standard multiplier wrapped inherently within a Chisel `ShiftRegister` retiming barrier (`val numCycles: Int = 3`). Automatically tracks signed/unsigned boundaries seamlessly allowing upstream RTL generators to parameterize standard arithmetic latency on the fly.

**Why these changes were made:**
* **ZeroNyte Physical Design Floorplan Capacity:** The OpenLane 2 toolchain blocked structural synthesis of the `ZeroNyte` core with `[GPL-0302] Use a higher -density or re-floorplan with a larger core area` natively during the OpenROAD Global Placement stage. The netlist complexity organically breached the previously allocated combinatorial logic boundaries (`65%` target density across a `70%` core area).
* **SBT Top-Level Task Hooking:** To cleanly compile the newly implemented multithreaded processor variants directly via terminal sequences natively, `build.sbt` globally required command alias assignments binding up to the task executor tree (e.g. `sbt genTetraNyteIM`).

**What the changes are:**
* **OpenLane Placement Tuning:** Re-authored `physical_design/config.ZeroNyteRV32ICore.json` to significantly open structural placement buffers. Lowered `FP_CORE_UTIL` to `60` (establishing a physically wider standard cell die grid layout base) while explicitly increasing `PL_TARGET_DENSITY_PCT` to `75` (giving internal combinational logic gates adequate local cell density tolerance over extended route topologies).
* **SBT Command Registry:** Hooked `lazy val generateTetraNyteIMRTL` and `generateTetraNyteZmmulRTL` master Tasks into the top tier structure of point-to-point generators inside `build.sbt` natively and securely evaluated aliases `genTetraNyteIM` and `genTetraNyteZmmul` sequentially through `genAllRtl` master generation trees!

# 03/28/2026 15:21 - TetraNyte Multi-Cycle Divider Pipeline Stall Resolution

**Why these changes were made:**
Although `ZeroNyte` natively passed the `DIV`/`REM` hardware instruction evaluation bounds structurally successfully using the standalone `Div32Radix4` integration, identical arithmetic instructions sequentially failed executing on the newly deployed multi-threaded `TetraNyte` architecture mapping logic. The root cause involved the barrel-scheduler stalling threads incorrectly exclusively against the active computational window `divActive` while completely overlooking the intermediate write-back scheduling window `divDoneSticky`. As a result, computation threads preemptively resumed fetching instruction iterations and dynamically resolved sequential ALU commands mathematically accessing destination registers before their required multi-cycle `divWrite` arbitration finalized.

**What the changes are:**
* **Pipeline Thread State Halt Logic:** Refactored `TetraNyteRV32IMCore.scala` tracking equations to explicitly validate `threadStalled(t) := (divActive || divDoneSticky) && divThread === t.U`. By anchoring subsequent PC fetches against both boolean evaluations concurrently, `threadStalled` correctly delays issuing `if_id.valid == true` transitions indefinitely until the division dynamically identifies an eligible NO-OP back-propagation pipeline slice securely avoiding structural hardware data races organically. 
* **State Hijacking Prevention:** Because `TetraNyte` currently instantiates exactly one shared arithmetic divider globally across the barrel, a race condition uniquely manifested when running `--thread-mask 15`. After Thread 0 finished computation (`divActive` transitioned to `false`), Thread 1 would unexpectedly slide into the EX stage and trigger `divLaunch := true.B` while Thread 0's output was still blocked against the `divDoneSticky` write-back wait queue. Because Thread 1 violently hijacked `divThread` and `divRd`, Thread 0's final quotient was physically written into Thread 1's destination registers via the register-file crossbar! This was resolved by extending the `structuralHazard` validation envelope strictly over both the active cycle counter *and* the write-back commit queue (`!(divActive || divDoneSticky)`). 
* **Zero-Register Deadlock Timeout Prevention:** The `div-01.S` conformance executable inherently tests cases bound to the zero register (`div zero, t6, t5`). Originally, `TetraNyteRV32IMCore.scala` explicitly prevented writing dummy divisions by wrapping `divWrite` in a mandatory `divRd =/= 0.U` guard. Because `divWrite` theoretically failed to evaluate true during a `zero` dump, `divDoneSticky` failed to receive its reset clearance token `divDoneSticky := false.B`. This permanently locked Thread 0's instruction fetch stream and consequently triggered infinite structural hazard loops on Threads 1-3 (hitting the 2,000,000 cycle threshold). Fix removed the `divRd` guard since the base `RegFileMTMem` component already organically drops writes to `x0`.
* **Zmmul Fallback Defense:** Similarly synchronized the exact stall constraints into the `TetraNyteRV32IZmmulCore.scala` instantiation interface to strictly mirror identical pipeline halting specifications natively in the event any unexpected formal compliance evaluation queries multi-layer extensions improperly!

**Divisor Architectural Tradeoffs:**
* *Area vs. Throughput:* `TetraNyte` strictly shares a single sequential `Div32Radix4` instanced hardware block across all 4 threaded segments. Instantiating a pipelined spatial unrolled `16-deep` implementation (or duplicating the block 4 times) ensures zero structural collisions mathematically, but requires massive combinational slice utilization on targeted FPGA hardware. Because simultaneous multi-thread divisions represent exceedingly rare software behavior organically, `TetraNyte` guarantees optimal logical footprint by naturally penalizing collision overlaps transparently as bounded execution `EX` replay loops instead!

# 03/28/2026 15:03 - TetraNyte RISCOF Environment and ISA Schema Fixes

**Why these changes were made:**
After the RTL generators successfully launched, the standard RISC-V compliance tester crashed during two sequential verification loops: initially failing during C-header inclusion (`fatal error: model_test.h`) because the required local simulation stubs were missing internally, and secondly during the `riscv_config` extraction sequence validating mathematically incorrect `misa` attributes.

**What the changes are:**
* **RISCOF Linker Skeleton Recovery:** Replicated the standard architectural `tests/riscof/tetranyte/env` logic directory recursively over to `tests/riscof/tetranyte_zmmul/env` and `tests/riscof/tetranyte_im/env` (and established the underlying `__init__.py` files) allowing the standard GCC compilation loops to access their mandatory initialization payloads (`link.ld` and `model_test.h`) appropriately.
* **ISA Machine Register Alignment:** Configured `tests/riscof/tetranyte_zmmul/tetranyte_zmmul_isa.yaml` and `tests/riscof/tetranyte_im/tetranyte_im_isa.yaml` securely so their physical `misa` -> `reset-val` masks correctly bitshift the multiplication register payload (`0x40001100`), thereby satisfying the formal specification engine for configuring multicycle `M` hardware definitions directly.

# 03/28/2026 14:39 - TetraNyte IM and Zmmul Compilation Generator Fixes

**Why these changes were made:**
Although the native simulation C++ wrappers and RISCOF Python scripts were successfully integrated, running the conformance scripts crashed parsing `GenerateHierarchicalRTL.scala` because the Chisel backend SBT graph didn't track the newly declared processor variants. 

**What the changes are:**
* **SBT Module Mapping:** Added `tetraNyteIM` and `tetraNyteZmmul` explicitly as project variables linking back to their discrete `TetraNyte/rv32i_.../` root structure and added them to both the `generators` `.dependsOn` logic and the root project's `.aggregate(...)` loops to guarantee global classpath resolution during clean builds.
* **Namespace Imports:** Streamlined `GenerateHierarchicalRTL.scala` internally to strictly declare `import TetraNyte.{TetraNyteRV32IMCore, TetraNyteRV32IZmmulCore}` immediately in the top-level Scala domain rather than incorrectly wrapping inline case class evaluations as `new TetraNyte.TetraNyteRV32IZmmulCore`.

# 03/28/2026 14:07 - TetraNyte IM and Zmmul Multithreaded Compliance Test Integration

**Why these changes were made:**
Although the base `TetraNyte` multithreaded core and the `ZeroNyte` extended series possessed native simulation architectures testing directly against the generic RISCOF compliance frameworks natively, the advanced `TetraNyteRV32IMCore` and `TetraNyteRV32IZmmulCore` multithreaded cores lacked the distinct Verilator C++ wrappers and Python configurations necessary to explicitly stress their algorithmic division and iterative multiplication structures inside the test matrix.

**What the changes are:**
* **Native C++ Multithreaded Simulation Hooks**: Constructed `tests/sim/tetranyte_im_sim.cpp` and `tests/sim/tetranyte_zmmul_sim.cpp`, applying the `0xF` dynamic CPU execution mask out of the box to consistently drive thread interleaving across multi-cycle algorithmic workloads during tests.
* **RISCOF Architectural Modeling**: Engineered `tests/riscof/tetranyte_im` and `tests/riscof/tetranyte_zmmul` target directories natively expressing the formal specification requirements (RV32IM vs RV32I+Zmmul) into the physical `tetranyte_<variant>_isa.yaml` structures to constrain compliance payloads dynamically.
* **Framework Automation Pipeline**: Overhauled `tests/run_riscv_conformance_tests.sh` to officially provision `--processor tetranyte-im` and `--processor tetranyte-zmmul` arguments mapping automatically into the physical `GenerateHierarchicalRTL.scala` SBT workflow target aliases in the backend.

# 03/28/2026 12:35 - TetraNyte 4-Stage Architecture & Local Stall Squashing

**Why these changes were made:**
The `TetraNyte` core variants previously utilized aggressive global machine stalls whenever a thread encountered a multi-cycle block like an Instruction Cache miss or algorithmic division. This needlessly froze unaffected threads and severely crippled multi-threaded processing throughput. Furthermore, the pipeline retained legacy combinational forwarding logic that consumed unused standard cell area, despite the 4-thread / 4-stage barrel processor physically negating all overlapping data dependencies structurally.

**What the changes are:**
* **Dead Logic Eradication**: Removed legacy `rs1Fwd`/`rs2Fwd` data-hazard forwarding paths strictly from the Decode stage in all 6 processor variations (`RV32I`, `RV32IM`, `RV32IZmmul`, and their `WithCache` modules). Due to strict 4-thread barrel interleaving on the guaranteed 4-stage layout (`IF`, `ID`, `EX`, `MEM+WB`), results natively retire prior to subsequent thread fetches, rendering combinational forwarding bloat obsolete and improving routing logic paths.
* **Non-Blocking Cache Squashing**: Modified `ICache.scala` to latch metadata during cache misses dynamically (`latchedBlockBase`, `latchedIdx`, `latchedTag`), decoupling the ICache state machine from continuous `io.pc` dependence map tracking. Unlocked `threadSel` to persistently iterate natively during single-thread cache misses, allowing hitting threads to bypass the miss and seamlessly stream pipelined bubbles (`valid := false.B`) exclusively for the stalling thread's logic stream.
* **Multi-Cycle Thread-Local Arbitration**: Revamped the global `stall` mechanism linked to the `Div32Radix4` integration inside `TetraNyteRV32IMCore`. Division instructions now trigger thread-local fetch-squashing hooks (`threadStalled`), preserving PC iteration for the engaged thread harmlessly in the background. Concurrent division attempts from adjacent threads dynamically assert a `structuralHazard`, resolving deterministically via strict `pcRegs` rewind replays (busy-waiting) without physically paralyzing parallel pipeline progress.

# 03/28/2026 12:09 - Enhanced Physical Design CLI Helper

**Why these changes were made:**
The standard backend synthesis loop (e.g. `generate_physical_design.sh`) typically accepted arbitrary argument inputs directly executing without user review. Erroneous processor targets passed directly to OpenLane would spin out resources endlessly.

**What the changes are:**
* Rebuilt `physical_design/generate_physical_design.sh` to gracefully default its behavior to presenting a robust terminal help-menu enumerating standard module arguments explicitly, enforcing safety and documenting acceptable physical design footprints automatically.

# 03/28/2026 12:02 - Upgraded TetraNyte Simulation to Multithreaded Default

**Why these changes were made:**
The `TetraNyte` simulator (`tetranyte_sim`) and its corresponding RISCOF validation driver previously defaulted to executing conformance tests solely across Thread 0 (using a single-thread mask of `0x1`). To rigorously validate architectural coherency and ensure the barrel threading structure is consistently stressed, the default simulation constraints have been upgraded to forcefully execute tests simultaneously across all 4 available hardware threads.

**What the changes are:**
* Updated the `tetranyte_sim.cpp` execution harness to initialize `thread_mask` to `0xF` (15) natively instead of `0x1`.
* Modified the `riscof_tetranyte.py` Python orchestrator to systematically inject `--thread-mask 15` during regression suite assembly so all validation payloads execute in a true multi-threaded environment.

# 03/28/2026 11:39 - Standardized TetraNyte Register Files (MRF Deprecation)

**Why these changes were made:**
Maintaining standalone `-mrf` variants (Memory Register File) of the multithreaded TetraNyte cores created unnecessary technical debt and compilation redundancy. Since the area-optimized `RegFileMT2R1WMem` (memory-based) register file performs impeccably across all TetraNyte multithreaded designs, it was elevated to the default register file implementation, rendering the specialized MRF duplicates obsolete.

**What the changes are:**
* Refactored `TetraNyteRV32ICore`, `TetraNyteRV32IMCore`, `TetraNyteRV32IZmmulCore`, and their `WithCache` counterparts to natively instantiate and map to the array-driven `RegFileMT2R1WMem` module.
* Completely deleted the redundant `TetraNyteRV32ICoreMRF.scala`, `TetraNyteRV32IMCoreMRF.scala`, and `TetraNyteRV32IZmmulCoreMRF.scala` core variants.
* Purged the obsolete `build_tetranyte_mrf_sim.sh` and `tetranyte_mrf_sim.cpp` Verilator components.
* Removed `tetranyte-mrf` processor targeting from `run_riscv_conformance_tests.sh` and `GenerateHierarchicalRTL.scala`.
* Fixed a cascading `ZeroNyte` compilation failure by restoring `byteOffset` declarations that were improperly stripped during previous load/store optimizations.

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
