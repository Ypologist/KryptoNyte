# KryptoNyte RISC-V Processor Family

The KryptoNyte family is a comprehensive collection of RISC-V processor implementations designed for education, research, and practical applications. The family consists of four distinct processor architectures, each available in both RV32I and RV64I variants:

- **ZeroNyte**: Simple fetch-execute architecture for educational purposes
- **PipeNyte**: 4-stage pipelined architecture with stall-on-hazard
- **TetraNyte**: 4-threaded architecture eliminating pipeline hazards through threading
- **OctoNyte**: 8-stage, 8-threaded high-performance architecture

All processor cores are implemented in Chisel and generate Verilog for synthesis and simulation. The repository follows a monorepo approach with shared components and comprehensive verification infrastructure.

# Installation

## Github Codespace

Create a normal github codespace. By default, the base RTL tools are included.


## Ubuntu 24.04

Run the following shell scripts from the ROOT respository directory. You can pick and choose.

For example, if you don't need to do physical design, don't run the last script.

1. Base RTL Tools: .devcontainer/install_base_rtl_tools.sh --with-sudo
2. RISCV Compiler Toolchain: .devcontainer/install_riscv_compiler_tools.sh --with-sudo
3. Spike Simulator: .devcontainer/install_uv_python_and_spike_simulator.sh --with-sudo
4. Conformance Tests: .devcontainer/install_riscv_conformance_tests.sh --with-sudo
5. Physical Design and RTL generation: .devcontainer/install_skywater_pdk.sh --with-sudo


# KryptoNyte Directory Tree

## First Level
```
KryptoNyte/
├── .devcontainer/                    # GitHub Codespaces configuration
├── rtl/                           # Individual processor families
├── shared/                          # Global shared components
├── docs/                            # Family-wide documentation
├── verification/                    # Family-wide verification
├── physical-design/                 # Physical implementation
└── tools/                           # External tools and dependencies
```

## Second Level
```
KryptoNyte/
├── .devcontainer/                    # GitHub Codespaces configuration
│   ├── devcontainer.json            # Dev container configuration
│   ├── Dockerfile                   # Container build instructions
│   └── install.sh                   # Setup script for development environment
│
├── rtl/                           # Individual processor families
│   ├── ZeroNyte/                    # ZeroNyte: Simple fetch-execute architecture
│   ├── PipeNyte/                    # PipeNyte: 4-stage pipelined architecture
│   ├── TetraNyte/                   # TetraNyte: 4-threaded architecture
│   ├── OctoNyte/                    # OctoNyte: 8-stage 8-threaded architecture
│   └── family-shared/               # Components shared across all processor families
│
├── shared/                          # Global shared components
│   ├── rtl/                         # Shared RTL components
│   ├── include/                     # Shared header files
│   ├── verification/                # Shared verification components
│   └── tools/                       # Shared tool scripts
│
├── docs/                            # Family-wide documentation
│   ├── family-overview/             # KryptoNyte family overview
│   ├── specifications/              # Technical specifications
│   ├── user-guides/                 # User documentation
│   ├── verification/                # Verification documentation
│   ├── implementation/              # Implementation guides
│   ├── tutorials/                   # Step-by-step tutorials
│   └── assets/                      # Documentation assets
│
├── verification/                    # Family-wide verification
│   ├── conformance/                 # RISC-V conformance tests
│   ├── cross-core/                  # Cross-core verification
│   ├── system-level/                # System-level verification
│   ├── simulation/                  # Simulation environment
│   ├── regression/                  # Family-wide regression
│   ├── formal/                      # Formal verification
│   ├── coverage/                    # Coverage analysis
│   └── tools/                       # Verification tools
│
├── physical-design/                 # Physical implementation
│   ├── family-configs/              # Family-wide configurations
│   ├── core-implementations/        # Core-specific implementations
│   ├── shared-blocks/               # Shared physical blocks
│   ├── integration/                 # Multi-core integration
│   ├── scripts/                     # Physical design scripts
│   └── pdks/                        # Process Design Kits (submodule)
│
└── tools/                           # External tools and dependencies
    ├── riscv-toolchain/             # RISC-V GNU toolchain (submodule)
    ├── riscv-spike/                 # RISC-V ISA simulator (submodule)
    ├── family-tools/                # KryptoNyte family-specific tools
    ├── scripts/                     # Tool management scripts
    ├── docker/                      # Docker configurations
    ├── ci-cd/                       # CI/CD pipeline tools
    └── utilities/                   # General utility tools
```

# KryptoNyte Directory Tree - Third Level

```
KryptoNyte/
├── .devcontainer/                    # GitHub Codespaces configuration
│   ├── devcontainer.json            # Dev container configuration
│   ├── Dockerfile                   # Container build instructions
│   └── install.sh                   # Setup script for development environment
│
├── rtl/                           # Individual processor families
│   ├── ZeroNyte/                    # ZeroNyte: Simple fetch-execute architecture
│   │   ├── rv32i/                   # RV32I implementation
│   │   ├── rv64i/                   # RV64I implementation
│   │   ├── shared/                  # Shared components between RV32I and RV64I
│   │   └── docs/                    # ZeroNyte family documentation
│   ├── PipeNyte/                    # PipeNyte: 4-stage pipelined architecture
│   │   ├── rv32i/                   # RV32I implementation
│   │   ├── rv64i/                   # RV64I implementation
│   │   ├── shared/                  # Shared components between RV32I and RV64I
│   │   └── docs/                    # PipeNyte family documentation
│   ├── TetraNyte/                   # TetraNyte: 4-threaded architecture
│   │   ├── rv32i/                   # RV32I implementation
│   │   ├── rv64i/                   # RV64I implementation
│   │   ├── shared/                  # Shared components between RV32I and RV64I
│   │   └── docs/                    # TetraNyte family documentation
│   ├── OctoNyte/                    # OctoNyte: 8-stage 8-threaded architecture
│   │   ├── rv32i/                   # RV32I implementation
│   │   ├── rv64i/                   # RV64I implementation
│   │   ├── shared/                  # Shared components between RV32I and RV64I
│   │   └── docs/                    # OctoNyte family documentation
│   └── family-shared/               # Components shared across all processor families
│       ├── rtl/                     # Family-wide shared RTL
│       ├── verification/            # Family-wide verification components
│       └── docs/                    # Family-wide shared documentation
│
├── shared/                          # Global shared components
│   ├── rtl/                         # Shared RTL components
│   │   ├── common/                  # Common modules
│   │   ├── peripherals/             # Shared peripheral IP
│   │   ├── interconnect/            # Interconnect fabric
│   │   └── packages/                # Shared SystemVerilog packages
│   ├── include/                     # Shared header files
│   │   ├── defines/                 # Global defines
│   │   ├── interfaces/              # Interface definitions
│   │   └── macros/                  # Useful macros
│   ├── verification/                # Shared verification components
│   │   ├── agents/                  # Verification agents
│   │   ├── monitors/                # Protocol monitors
│   │   ├── checkers/                # Assertion checkers
│   │   ├── scoreboards/             # Scoreboards
│   │   └── utilities/               # Verification utilities
│   └── tools/                       # Shared tool scripts
│       ├── generators/              # Code generators
│       ├── analyzers/               # Analysis tools
│       └── utilities/               # General utilities
│
├── docs/                            # Family-wide documentation
│   ├── family-overview/             # KryptoNyte family overview
│   │   ├── introduction.md          # Family introduction
│   │   ├── core-comparison.md       # Core comparison matrix
│   │   ├── roadmap.md               # Development roadmap
│   │   └── architecture-overview.md # High-level architecture
│   ├── specifications/              # Technical specifications
│   │   ├── isa-compliance/          # ISA compliance documentation
│   │   ├── interfaces/              # Interface specifications
│   │   ├── memory-model/            # Memory model specification
│   │   └── debug-spec/              # Debug specification
│   ├── user-guides/                 # User documentation
│   │   ├── getting-started/         # Getting started guides
│   │   ├── core-selection/          # Core selection guide
│   │   ├── integration/             # Integration guides
│   │   └── programming/             # Programming guides
│   ├── verification/                # Verification documentation
│   │   ├── methodology/             # Verification methodology
│   │   ├── test-plans/              # Test plans
│   │   ├── coverage-plans/          # Coverage plans
│   │   └── results/                 # Verification results
│   ├── implementation/              # Implementation guides
│   │   ├── synthesis/               # Synthesis guidelines
│   │   ├── physical-design/         # Physical design guides
│   │   ├── fpga/                    # FPGA implementation
│   │   └── asic/                    # ASIC implementation
│   ├── tutorials/                   # Step-by-step tutorials
│   │   ├── basic-usage/             # Basic usage tutorials
│   │   ├── advanced-features/       # Advanced feature tutorials
│   │   └── customization/           # Customization tutorials
│   └── assets/                      # Documentation assets
│       ├── images/                  # Images and diagrams
│       ├── diagrams/                # Architecture diagrams
│       └── templates/               # Document templates
│
├── verification/                    # Family-wide verification
│   ├── conformance/                 # RISC-V conformance tests
│   │   ├── riscv-arch-test/         # Official RISC-V architecture tests
│   │   ├── custom-tests/            # Custom conformance tests
│   │   ├── compliance-reports/      # Conformance test reports
│   │   └── scripts/                 # Test execution scripts
│   ├── cross-core/                  # Cross-core verification
│   │   ├── compatibility/           # Cross-core compatibility tests
│   │   ├── migration/               # Code migration tests
│   │   ├── performance/             # Performance comparison
│   │   └── integration/             # Multi-core integration tests
│   ├── system-level/                # System-level verification
│   │   ├── testbenches/             # System testbenches
│   │   ├── tests/                   # System-level tests
│   │   └── models/                  # System models
│   ├── simulation/                  # Simulation environment
│   │   ├── scripts/                 # Simulation control scripts
│   │   ├── configs/                 # Simulation configurations
│   │   ├── models/                  # Simulation models
│   │   ├── waves/                   # Waveform dumps
│   │   └── logs/                    # Simulation logs
│   ├── regression/                  # Family-wide regression
│   │   ├── nightly/                 # Nightly regression tests
│   │   ├── weekly/                  # Weekly comprehensive tests
│   │   ├── release/                 # Release qualification tests
│   │   ├── scripts/                 # Regression automation
│   │   └── results/                 # Regression results
│   ├── formal/                      # Formal verification
│   │   ├── properties/              # Formal properties
│   │   ├── scripts/                 # Formal verification scripts
│   │   └── results/                 # Formal verification results
│   ├── coverage/                    # Coverage analysis
│   │   ├── family-wide/             # Family-wide coverage
│   │   ├── core-specific/           # Core-specific coverage
│   │   ├── cross-core/              # Cross-core coverage
│   │   └── reports/                 # Coverage reports
│   └── tools/                       # Verification tools
│       ├── test-generators/         # Test generators
│       ├── coverage-tools/          # Coverage analysis tools
│       └── comparison-tools/        # Core comparison tools
│
├── physical-design/                 # Physical implementation
│   ├── family-configs/              # Family-wide configurations
│   │   ├── common/                  # Common configurations
│   │   ├── technology/              # Technology-specific configs
│   │   └── targets/                 # Target-specific configs
│   ├── core-implementations/        # Core-specific implementations
│   │   ├── ZeroNyte/                # ZeroNyte implementations
│   │   ├── PipeNyte/                # PipeNyte implementations
│   │   ├── TetraNyte/               # TetraNyte implementations
│   │   └── OctoNyte/                # OctoNyte implementations
│   ├── shared-blocks/               # Shared physical blocks
│   │   ├── memory-compilers/        # Memory compiler outputs
│   │   ├── standard-cells/          # Standard cell libraries
│   │   └── io-pads/                 # I/O pad libraries
│   ├── integration/                 # Multi-core integration
│   │   ├── dual-core/               # Dual-core configurations
│   │   ├── quad-core/               # Quad-core configurations
│   │   └── custom/                  # Custom configurations
│   ├── scripts/                     # Physical design scripts
│   │   ├── synthesis/               # Synthesis scripts
│   │   ├── place-route/             # Place and route scripts
│   │   ├── verification/            # Physical verification scripts
│   │   └── analysis/                # Analysis scripts
│   └── pdks/                        # Process Design Kits (submodule)
│       └── skywater-pdk/            # SkyWater PDK (Git submodule)
│
└── tools/                           # External tools and dependencies
    ├── riscv-toolchain/             # RISC-V GNU toolchain (submodule)
    ├── riscv-spike/                 # RISC-V ISA simulator (submodule)
    ├── family-tools/                # KryptoNyte family-specific tools
    │   ├── core-selector/           # Core selection tool
    │   ├── config-generator/        # Configuration generator
    │   ├── performance-analyzer/    # Performance analysis tool
    │   └── comparison-tool/         # Core comparison tool
    ├── scripts/                     # Tool management scripts
    │   ├── install_tools.sh         # Tool installation script
    │   ├── setup_family_env.sh      # Family environment setup
    │   └── core_tools.py            # Core-specific tool management
    ├── docker/                      # Docker configurations
    │   ├── family-dev/              # Family development container
    │   ├── core-specific/           # Core-specific containers
    │   └── ci-cd/                   # CI/CD containers
    ├── ci-cd/                       # CI/CD pipeline tools
    │   ├── github-actions/          # GitHub Actions workflows
    │   ├── scripts/                 # CI/CD scripts
    │   └── configs/                 # Pipeline configurations
    └── utilities/                   # General utility tools
        ├── family-utils/            # Family-specific utilities
        ├── core-utils/              # Core-specific utilities
        └── analysis-utils/          # Analysis utilities
```



## Complete Directory Structure

```
KryptoNyte/
├── .devcontainer/                    # GitHub Codespaces configuration
│   ├── devcontainer.json            # Dev container configuration
│   ├── Dockerfile                   # Container build instructions
│   └── install.sh                   # Setup script for development environment
│
├── rtl/                           # Individual processor families
│   ├── ZeroNyte/                    # ZeroNyte: Simple fetch-execute architecture
│   │   ├── rv32i/                   # RV32I implementation
│   │   │   ├── rtl/                 # RTL source and generation
│   │   │   │   ├── chisel/          # Chisel source implementation
│   │   │   │   │   ├── src/         # Chisel source files
│   │   │   │   │   │   ├── main/    # Main Chisel source
│   │   │   │   │   │   │   └── scala/ # Scala source files
│   │   │   │   │   │   │       └── ZeroNyte/ # ZeroNyte-specific package
│   │   │   │   │   │   │           ├── core/    # Core modules
│   │   │   │   │   │   │           │   ├── fetch/   # Instruction fetch unit
│   │   │   │   │   │   │           │   ├── decode/  # Instruction decode
│   │   │   │   │   │   │           │   ├── execute/ # Execution unit
│   │   │   │   │   │   │           │   ├── alu/     # Arithmetic Logic Unit
│   │   │   │   │   │   │           │   ├── regfile/ # Register file (32-bit)
│   │   │   │   │   │   │           │   └── csr/     # Control and Status Registers
│   │   │   │   │   │   │           ├── memory/      # Memory interface
│   │   │   │   │   │   │           │   ├── bus/     # Bus interface logic
│   │   │   │   │   │   │           │   └── cache/   # Cache implementation (if any)
│   │   │   │   │   │   │           └── top/         # Top-level integration
│   │   │   │   │   │   └── test/    # Chisel unit tests
│   │   │   │   │   │       └── scala/ # Scala test files
│   │   │   │   │   │           └── ZeroNyte/ # ZeroNyte-specific tests
│   │   │   │   │   │               ├── core/    # Core unit tests
│   │   │   │   │   │               ├── memory/  # Memory tests
│   │   │   │   │   │               └── integration/ # Integration tests
│   │   │   │   │   ├── generated/   # Generated Verilog from Chisel
│   │   │   │   │   │   ├── verilog/ # Generated Verilog files
│   │   │   │   │   │   │   ├── zeronyte_rv32i_core.v     # Generated core
│   │   │   │   │   │   │   ├── zeronyte_rv32i_alu.v      # Generated ALU
│   │   │   │   │   │   │   ├── zeronyte_rv32i_regfile.v  # Generated register file
│   │   │   │   │   │   │   └── zeronyte_rv32i_cache.v    # Generated cache
│   │   │   │   │   │   ├── firrtl/  # Intermediate FIRRTL files
│   │   │   │   │   │   └── annotations/ # Chisel annotations
│   │   │   │   │   ├── build.sbt    # SBT build configuration
│   │   │   │   │   ├── Makefile     # Chisel build automation
│   │   │   │   │   └── configs/     # Chisel configurations
│   │   │   │   │       ├── ZeroNyteConfig.scala # Processor configuration
│   │   │   │   │       ├── synthesis/   # Synthesis configurations
│   │   │   │   │       └── simulation/  # Simulation configurations
│   │   │   │   ├── include/         # Generated and shared includes
│   │   │   │   │   ├── generated/   # Generated from Chisel
│   │   │   │   │   │   ├── defines/ # Generated defines
│   │   │   │   │   │   └── packages/ # Generated SystemVerilog packages
│   │   │   │   │   └── shared/      # Shared definitions
│   │   │   │   │       ├── interfaces/ # Interface definitions
│   │   │   │   │       └── protocols/  # Protocol specifications
│   │   │   │   └── constraints/     # Physical and timing constraints
│   │   │   │       ├── timing/      # Timing constraints
│   │   │   │       ├── physical/    # Physical constraints
│   │   │   │       └── power/       # Power constraints
│   │   │   ├── verification/        # Verification environment
│   │   │   │   ├── chisel-tests/    # Chisel-native verification
│   │   │   │   │   ├── unit/        # Chisel unit tests
│   │   │   │   │   │   ├── core/    # Core module tests
│   │   │   │   │   │   │   ├── AluSpec.scala    # ALU test specification
│   │   │   │   │   │   │   ├── RegFileSpec.scala # Register file tests
│   │   │   │   │   │   │   ├── FetchSpec.scala  # Fetch stage tests
│   │   │   │   │   │   │   ├── DecodeSpec.scala # Decode stage tests
│   │   │   │   │   │   │   └── ExecuteSpec.scala # Execute stage tests
│   │   │   │   │   │   ├── memory/  # Memory system tests
│   │   │   │   │   │   │   ├── CacheSpec.scala  # Cache tests
│   │   │   │   │   │   │   └── BusSpec.scala    # Bus interface tests
│   │   │   │   │   │   └── integration/ # Integration tests
│   │   │   │   │   │       ├── CoreSpec.scala   # Full core tests
│   │   │   │   │   │       └── SystemSpec.scala # System integration tests
│   │   │   │   │   ├── formal/      # Chisel formal verification
│   │   │   │   │   │   ├── properties/ # Formal properties in Chisel
│   │   │   │   │   │   │   ├── CoreProperties.scala     # Core correctness properties
│   │   │   │   │   │   │   └── MemoryProperties.scala   # Memory consistency properties
│   │   │   │   │   │   └── proofs/  # Formal proofs and verification
│   │   │   │   │   ├── performance/ # Performance testing
│   │   │   │   │   │   ├── benchmarks/ # Benchmark tests
│   │   │   │   │   │   └── latency/ # Latency analysis
│   │   │   │   │   ├── utilities/   # Chisel test utilities
│   │   │   │   │   │   ├── TestUtils.scala      # Common test utilities
│   │   │   │   │   │   ├── Generators.scala     # Test data generators
│   │   │   │   │   │   └── Checkers.scala       # Result checkers
│   │   │   │   │   └── scripts/     # Chisel test scripts
│   │   │   │   │       ├── run-chisel-tests.sh  # Run Chisel tests
│   │   │   │   │       ├── generate-verilog.sh  # Generate Verilog from Chisel
│   │   │   │   │       ├── run-formal.sh        # Run formal verification
│   │   │   │   │       └── performance-analysis.sh # Performance analysis
│   │   │   │   ├── systemverilog-tests/ # SystemVerilog verification (hand-written)
│   │   │   │   │   ├── unit/        # SystemVerilog unit tests
│   │   │   │   │   │   ├── core/    # Core module tests
│   │   │   │   │   │   │   ├── tb_alu.sv        # ALU testbench
│   │   │   │   │   │   │   ├── tb_regfile.sv    # Register file testbench
│   │   │   │   │   │   │   ├── tb_fetch.sv      # Fetch stage testbench
│   │   │   │   │   │   │   ├── tb_decode.sv     # Decode stage testbench
│   │   │   │   │   │   │   └── tb_execute.sv    # Execute stage testbench
│   │   │   │   │   │   ├── memory/  # Memory system testbenches
│   │   │   │   │   │   │   ├── tb_cache.sv      # Cache testbench
│   │   │   │   │   │   │   └── tb_bus.sv        # Bus interface testbench
│   │   │   │   │   │   └── integration/ # Integration testbenches
│   │   │   │   │   │       ├── tb_core.sv       # Core integration testbench
│   │   │   │   │   │       └── tb_system.sv     # System integration testbench
│   │   │   │   │   ├── formal/      # SystemVerilog formal verification
│   │   │   │   │   │   ├── properties/ # SVA properties
│   │   │   │   │   │   │   ├── core_properties.sv       # Core correctness properties
│   │   │   │   │   │   │   └── memory_properties.sv     # Memory consistency properties
│   │   │   │   │   │   ├── binds/   # Bind files for properties
│   │   │   │   │   │   │   ├── core_bind.sv     # Core property bindings
│   │   │   │   │   │   │   └── system_bind.sv   # System property bindings
│   │   │   │   │   │   └── scripts/ # Formal verification scripts
│   │   │   │   │   │       ├── run_formal.sh    # Run formal verification
│   │   │   │   │   │       └── analyze_results.sh # Analyze formal results
│   │   │   │   │   ├── performance/ # Performance verification
│   │   │   │   │   │   ├── benchmarks/ # Benchmark testbenches
│   │   │   │   │   │   │   ├── tb_dhrystone.sv  # Dhrystone benchmark
│   │   │   │   │   │   │   └── tb_coremark.sv   # CoreMark benchmark
│   │   │   │   │   │   └── latency/ # Latency analysis testbenches
│   │   │   │   │   ├── utilities/   # SystemVerilog test utilities
│   │   │   │   │   │   ├── test_utils.sv        # Common test utilities
│   │   │   │   │   │   ├── generators.sv        # Test data generators
│   │   │   │   │   │   ├── checkers.sv          # Result checkers
│   │   │   │   │   │   └── monitors.sv          # Protocol monitors
│   │   │   │   │   ├── configs/     # Test configurations
│   │   │   │   │   │   ├── test_configs.sv      # Test configuration parameters
│   │   │   │   │   │   └── simulation_configs.sv # Simulation configurations
│   │   │   │   │   └── scripts/     # SystemVerilog test scripts
│   │   │   │   │       ├── run-sv-tests.sh      # Run SystemVerilog tests
│   │   │   │   │       ├── compile-tests.sh     # Compile test suite
│   │   │   │   │       ├── run-benchmarks.sh    # Run performance benchmarks
│   │   │   │   │       └── coverage-analysis.sh # Coverage analysis
│   │   │   │   ├── cross-verification/ # Cross-verification between Chisel and generated Verilog
│   │   │   │   │   ├── equivalence/ # Equivalence checking
│   │   │   │   │   │   ├── chisel-vs-generated/ # Compare Chisel behavior vs generated Verilog
│   │   │   │   │   │   │   ├── core_equivalence.sv      # Core equivalence checks
│   │   │   │   │   │   │   └── memory_equivalence.sv    # Memory equivalence checks
│   │   │   │   │   │   ├── scripts/ # Equivalence checking scripts
│   │   │   │   │   │   │   ├── run_equivalence.sh       # Run equivalence checks
│   │   │   │   │   │   │   ├── setup_comparison.sh      # Setup comparison environment
│   │   │   │   │   │   │   └── analyze_results.sh       # Analyze equivalence results
│   │   │   │   │   │   └── reports/ # Equivalence reports
│   │   │   │   │   ├── co-simulation/ # Co-simulation between Chisel and SystemVerilog tests
│   │   │   │   │   │   ├── testbenches/ # Co-simulation testbenches
│   │   │   │   │   │   │   ├── chisel_sv_cosim.sv       # Chisel-SystemVerilog co-simulation
│   │   │   │   │   │   │   └── mixed_verification.sv    # Mixed verification testbench
│   │   │   │   │   │   ├── interfaces/ # Cross-verification interfaces
│   │   │   │   │   │   └── scripts/ # Co-simulation scripts
│   │   │   │   │   └── validation/  # Validation of generated Verilog
│   │   │   │   │       ├── syntax/  # Syntax validation of generated Verilog
│   │   │   │   │       ├── lint/    # Linting of generated Verilog
│   │   │   │   │       └── synthesis/ # Synthesis validation of generated Verilog
│   │   │   │   ├── simulation/      # Simulation environment
│   │   │   │   │   ├── chisel-sim/  # Chisel simulation
│   │   │   │   │   │   ├── configs/ # Simulation configurations
│   │   │   │   │   │   ├── scripts/ # Simulation scripts
│   │   │   │   │   │   │   ├── run_chisel_sim.sh    # Run Chisel simulation
│   │   │   │   │   │   │   ├── generate_waves.sh    # Generate waveforms
│   │   │   │   │   │   │   └── analyze_results.sh   # Analyze simulation results
│   │   │   │   │   │   ├── waves/   # Waveform dumps
│   │   │   │   │   │   └── logs/    # Simulation logs
│   │   │   │   │   ├── verilog-sim/ # Generated Verilog simulation
│   │   │   │   │   │   ├── configs/ # Simulation configurations
│   │   │   │   │   │   ├── scripts/ # Simulation scripts
│   │   │   │   │   │   │   ├── run_verilog_sim.sh   # Run Verilog simulation
│   │   │   │   │   │   │   ├── compile_rtl.sh       # Compile generated RTL
│   │   │   │   │   │   │   └── run_regression.sh    # Run regression tests
│   │   │   │   │   │   ├── waves/   # Waveform dumps
│   │   │   │   │   │   └── logs/    # Simulation logs
│   │   │   │   │   └── shared/      # Shared simulation components
│   │   │   │   │       ├── models/  # Simulation models
│   │   │   │   │       ├── utilities/ # Simulation utilities
│   │   │   │   │       └── configs/ # Common configurations
│   │   │   │   ├── coverage/        # Coverage analysis
│   │   │   │   │   ├── chisel-coverage/ # Chisel coverage analysis
│   │   │   │   │   │   ├── functional/ # Functional coverage
│   │   │   │   │   │   ├── code/    # Code coverage
│   │   │   │   │   │   ├── reports/ # Coverage reports
│   │   │   │   │   │   └── scripts/ # Coverage scripts
│   │   │   │   │   ├── verilog-coverage/ # Generated Verilog coverage analysis
│   │   │   │   │   │   ├── functional/ # Functional coverage
│   │   │   │   │   │   ├── code/    # Code coverage
│   │   │   │   │   │   ├── assertion/ # Assertion coverage
│   │   │   │   │   │   ├── reports/ # Coverage reports
│   │   │   │   │   │   └── scripts/ # Coverage scripts
│   │   │   │   │   ├── cross-coverage/ # Cross-verification coverage
│   │   │   │   │   │   ├── equivalence/ # Equivalence coverage
│   │   │   │   │   │   ├── validation/ # Validation coverage
│   │   │   │   │   │   └── reports/ # Cross-verification coverage reports
│   │   │   │   │   └── merged-coverage/ # Merged coverage analysis
│   │   │   │   │       ├── combined-reports/ # Combined coverage reports
│   │   │   │   │       ├── gap-analysis/ # Coverage gap analysis
│   │   │   │   │       └── scripts/ # Merged coverage scripts
│   │   │   │   └── tools/           # Verification tools
│   │   │   │       ├── chisel-tools/ # Chisel-specific tools
│   │   │   │       │   ├── test-generators/ # Chisel test generators
│   │   │   │       │   ├── coverage-tools/ # Chisel coverage tools
│   │   │   │       │   └── debug-tools/ # Chisel debugging tools
│   │   │   │       ├── verilog-tools/ # Generated Verilog tools
│   │   │   │       │   ├── lint-tools/ # Verilog linting tools
│   │   │   │       │   ├── synthesis-tools/ # Synthesis validation tools
│   │   │   │       │   └── debug-tools/ # Verilog debugging tools
│   │   │   │       ├── cross-verification-tools/ # Cross-verification tools
│   │   │   │       │   ├── equivalence-checkers/ # Equivalence checking tools
│   │   │   │       │   ├── validation-tools/ # Validation tools
│   │   │   │       │   └── comparison-tools/ # Comparison tools
│   │   │   │       └── shared-tools/ # Shared verification tools
│   │   │   │           ├── report-generators/ # Report generation tools
│   │   │   │           ├── analysis-tools/ # Analysis tools
│   │   │   │           └── automation-scripts/ # Automation scripts
│   │   │   ├── docs/                # RV32I documentation
│   │   │   │   ├── architecture/    # Architecture documentation
│   │   │   │   ├── user-guide/      # User guide
│   │   │   │   └── specifications/  # Technical specifications
│   │   │   └── configs/             # Configuration files
│   │   │       ├── synthesis/       # Synthesis configurations
│   │   │       └── simulation/      # Simulation configurations
│   │   │
│   │   ├── rv64i/                   # RV64I implementation
│   │   │   ├── rtl/                 # RTL source and generation
│   │   │   │   ├── chisel/          # Chisel source implementation
│   │   │   │   │   ├── src/         # Chisel source files
│   │   │   │   │   │   ├── main/    # Main Chisel source
│   │   │   │   │   │   │   └── scala/ # Scala source files
│   │   │   │   │   │   │       └── ZeroNyte/ # ZeroNyte-specific package
│   │   │   │   │   │   │           ├── core/    # Core modules
│   │   │   │   │   │   │           │   ├── fetch/   # Instruction fetch unit
│   │   │   │   │   │   │           │   ├── decode/  # Instruction decode
│   │   │   │   │   │   │           │   ├── execute/ # Execution unit
│   │   │   │   │   │   │           │   ├── alu/     # Arithmetic Logic Unit (64-bit)
│   │   │   │   │   │   │           │   ├── regfile/ # Register file (64-bit)
│   │   │   │   │   │   │           │   └── csr/     # Control and Status Registers
│   │   │   │   │   │   │           ├── memory/      # Memory interface
│   │   │   │   │   │   │           │   ├── bus/     # Bus interface logic (64-bit)
│   │   │   │   │   │   │           │   └── cache/   # Cache implementation
│   │   │   │   │   │   │           └── top/         # Top-level integration
│   │   │   │   │   │   └── test/    # Chisel unit tests
│   │   │   │   │   │       └── scala/ # Scala test files
│   │   │   │   │   │           └── ZeroNyte/ # ZeroNyte-specific tests
│   │   │   │   │   │               ├── core/    # Core unit tests
│   │   │   │   │   │               ├── memory/  # Memory tests
│   │   │   │   │   │               └── integration/ # Integration tests
│   │   │   │   │   ├── generated/   # Generated Verilog from Chisel
│   │   │   │   │   │   ├── verilog/ # Generated Verilog files
│   │   │   │   │   │   │   ├── zeronyte_rv64i_core.v     # Generated core
│   │   │   │   │   │   │   ├── zeronyte_rv64i_alu.v      # Generated ALU
│   │   │   │   │   │   │   ├── zeronyte_rv64i_regfile.v  # Generated register file
│   │   │   │   │   │   │   └── zeronyte_rv64i_cache.v    # Generated cache
│   │   │   │   │   │   ├── firrtl/  # Intermediate FIRRTL files
│   │   │   │   │   │   └── annotations/ # Chisel annotations
│   │   │   │   │   ├── build.sbt    # SBT build configuration
│   │   │   │   │   ├── Makefile     # Chisel build automation
│   │   │   │   │   └── configs/     # Chisel configurations
│   │   │   │   │       ├── ZeroNyteConfig.scala # Processor configuration
│   │   │   │   │       ├── synthesis/   # Synthesis configurations
│   │   │   │   │       └── simulation/  # Simulation configurations
│   │   │   │   ├── include/         # Generated and shared includes
│   │   │   │   │   ├── generated/   # Generated from Chisel
│   │   │   │   │   │   ├── defines/ # Generated defines
│   │   │   │   │   │   └── packages/ # Generated SystemVerilog packages
│   │   │   │   │   └── shared/      # Shared definitions
│   │   │   │   │       ├── interfaces/ # Interface definitions
│   │   │   │   │       └── protocols/  # Protocol specifications
│   │   │   │   └── constraints/     # Physical and timing constraints
│   │   │   │       ├── timing/      # Timing constraints
│   │   │   │       ├── physical/    # Physical constraints
│   │   │   │       └── power/       # Power constraints
│   │   │   ├── verification/        # Verification environment (similar structure to RV32I)
│   │   │   ├── docs/                # RV64I documentation
│   │   │   └── configs/             # Configuration files
│   │   │
│   │   ├── shared/                  # Shared components between RV32I and RV64I
│   │   │   ├── rtl/                 # Shared RTL components
│   │   │   │   ├── common/          # Common modules
│   │   │   │   ├── interfaces/      # Interface definitions
│   │   │   │   └── utilities/       # Utility modules
│   │   │   ├── verification/        # Shared verification components
│   │   │   └── docs/                # Shared documentation
│   │   │
│   │   └── docs/                    # ZeroNyte family documentation
│   │       ├── overview/            # ZeroNyte overview
│   │       ├── comparison/          # RV32I vs RV64I comparison
│   │       └── migration/           # Migration guide between variants
│   │
│   ├── PipeNyte/                    # PipeNyte: 4-stage pipelined architecture
│   │   ├── rv32i/                   # RV32I implementation
│   │   │   ├── rtl/                 # RTL source and generation
│   │   │   │   ├── chisel/          # Chisel source implementation
│   │   │   │   │   ├── src/         # Chisel source files
│   │   │   │   │   │   ├── main/    # Main Chisel source
│   │   │   │   │   │   │   └── scala/ # Scala source files
│   │   │   │   │   │   │       └── PipeNyte/ # PipeNyte-specific package
│   │   │   │   │   │   │           ├── core/    # Core modules
│   │   │   │   │   │   │           │   ├── fetch/   # Instruction fetch stage
│   │   │   │   │   │   │           │   ├── decode/  # Instruction decode stage
│   │   │   │   │   │   │           │   ├── execute/ # Execute stage
│   │   │   │   │   │   │           │   ├── writeback/ # Writeback stage
│   │   │   │   │   │   │           │   ├── pipeline/ # Pipeline control logic
│   │   │   │   │   │   │           │   ├── hazard/  # Hazard detection and stall logic
│   │   │   │   │   │   │           │   ├── alu/     # Arithmetic Logic Unit
│   │   │   │   │   │   │           │   ├── regfile/ # Register file (32-bit)
│   │   │   │   │   │   │           │   └── csr/     # Control and Status Registers
│   │   │   │   │   │   │           ├── memory/      # Memory subsystem
│   │   │   │   │   │   │           │   ├── cache/   # Cache hierarchy
│   │   │   │   │   │   │           │   │   ├── icache/ # Instruction cache
│   │   │   │   │   │   │           │   │   └── dcache/ # Data cache
│   │   │   │   │   │   │           │   └── bus/     # Bus interface
│   │   │   │   │   │   │           └── top/         # Top-level integration
│   │   │   │   │   │   └── test/    # Chisel unit tests
│   │   │   │   │   │       └── scala/ # Scala test files
│   │   │   │   │   │           └── PipeNyte/ # PipeNyte-specific tests
│   │   │   │   │   │               ├── core/    # Core unit tests
│   │   │   │   │   │               ├── hazard/  # Hazard detection tests
│   │   │   │   │   │               ├── memory/  # Memory tests
│   │   │   │   │   │               └── integration/ # Integration tests
│   │   │   │   │   ├── generated/   # Generated Verilog from Chisel
│   │   │   │   │   │   ├── verilog/ # Generated Verilog files
│   │   │   │   │   │   │   ├── pipenyte_rv32i_core.v     # Generated core
│   │   │   │   │   │   │   ├── pipenyte_rv32i_pipeline.v # Generated pipeline
│   │   │   │   │   │   │   ├── pipenyte_rv32i_hazard.v   # Generated hazard unit
│   │   │   │   │   │   │   └── pipenyte_rv32i_cache.v    # Generated cache
│   │   │   │   │   │   ├── firrtl/  # Intermediate FIRRTL files
│   │   │   │   │   │   └── annotations/ # Chisel annotations
│   │   │   │   │   ├── build.sbt    # SBT build configuration
│   │   │   │   │   ├── Makefile     # Chisel build automation
│   │   │   │   │   └── configs/     # Chisel configurations
│   │   │   │   │       ├── PipeNyteConfig.scala # Processor configuration
│   │   │   │   │       ├── synthesis/   # Synthesis configurations
│   │   │   │   │       └── simulation/  # Simulation configurations
│   │   │   │   ├── include/         # Generated and shared includes
│   │   │   │   └── constraints/     # Physical and timing constraints
│   │   │   ├── verification/        # Verification environment
│   │   │   │   ├── chisel-tests/    # Chisel-native verification
│   │   │   │   │   ├── unit/        # Chisel unit tests
│   │   │   │   │   │   ├── core/    # Core module tests
│   │   │   │   │   │   │   ├── AluSpec.scala    # ALU test specification
│   │   │   │   │   │   │   ├── RegFileSpec.scala # Register file tests
│   │   │   │   │   │   │   ├── FetchSpec.scala  # Fetch stage tests
│   │   │   │   │   │   │   ├── DecodeSpec.scala # Decode stage tests
│   │   │   │   │   │   │   ├── ExecuteSpec.scala # Execute stage tests
│   │   │   │   │   │   │   └── WritebackSpec.scala # Writeback tests
│   │   │   │   │   │   ├── hazard/  # Hazard detection tests
│   │   │   │   │   │   │   ├── HazardDetectionSpec.scala # Hazard detection tests
│   │   │   │   │   │   │   └── StallLogicSpec.scala      # Stall logic tests
│   │   │   │   │   │   ├── memory/  # Memory system tests
│   │   │   │   │   │   └── integration/ # Integration tests
│   │   │   │   │   ├── formal/      # Chisel formal verification
│   │   │   │   │   ├── performance/ # Performance testing
│   │   │   │   │   ├── utilities/   # Chisel test utilities
│   │   │   │   │   └── scripts/     # Chisel test scripts
│   │   │   │   ├── systemverilog-tests/ # SystemVerilog verification
│   │   │   │   │   ├── unit/        # SystemVerilog unit tests
│   │   │   │   │   │   ├── core/    # Core module tests
│   │   │   │   │   │   │   ├── tb_alu.sv        # ALU testbench
│   │   │   │   │   │   │   ├── tb_regfile.sv    # Register file testbench
│   │   │   │   │   │   │   ├── tb_fetch.sv      # Fetch stage testbench
│   │   │   │   │   │   │   ├── tb_decode.sv     # Decode stage testbench
│   │   │   │   │   │   │   ├── tb_execute.sv    # Execute stage testbench
│   │   │   │   │   │   │   └── tb_writeback.sv  # Writeback testbench
│   │   │   │   │   │   ├── hazard/  # Hazard detection testbenches
│   │   │   │   │   │   │   ├── tb_hazard_detection.sv # Hazard detection testbench
│   │   │   │   │   │   │   └── tb_stall_logic.sv      # Stall logic testbench
│   │   │   │   │   │   ├── memory/  # Memory system testbenches
│   │   │   │   │   │   └── integration/ # Integration testbenches
│   │   │   │   │   ├── formal/      # SystemVerilog formal verification
│   │   │   │   │   │   ├── properties/ # SVA properties
│   │   │   │   │   │   │   ├── core_properties.sv       # Core correctness properties
│   │   │   │   │   │   │   ├── pipeline_properties.sv   # Pipeline properties
│   │   │   │   │   │   │   └── memory_properties.sv     # Memory consistency properties
│   │   │   │   │   │   ├── binds/   # Bind files for properties
│   │   │   │   │   │   └── scripts/ # Formal verification scripts
│   │   │   │   │   ├── performance/ # Performance verification
│   │   │   │   │   ├── utilities/   # SystemVerilog test utilities
│   │   │   │   │   ├── configs/     # Test configurations
│   │   │   │   │   └── scripts/     # SystemVerilog test scripts
│   │   │   │   ├── cross-verification/ # Cross-verification
│   │   │   │   ├── simulation/      # Simulation environment
│   │   │   │   ├── coverage/        # Coverage analysis
│   │   │   │   └── tools/           # Verification tools
│   │   │   ├── docs/                # RV32I documentation
│   │   │   └── configs/             # Configuration files
│   │   │
│   │   ├── rv64i/                   # RV64I implementation (similar structure to RV32I)
│   │   │   ├── rtl/                 # RTL source and generation
│   │   │   │   ├── chisel/          # Chisel source implementation
│   │   │   │   │   ├── src/         # Chisel source files
│   │   │   │   │   │   ├── main/    # Main Chisel source
│   │   │   │   │   │   │   └── scala/ # Scala source files
│   │   │   │   │   │   │       └── PipeNyte/ # PipeNyte-specific package
│   │   │   │   │   │   │           ├── core/    # Core modules (64-bit variants)
│   │   │   │   │   │   │           │   ├── fetch/   # Instruction fetch stage
│   │   │   │   │   │   │           │   ├── decode/  # Instruction decode stage
│   │   │   │   │   │   │           │   ├── execute/ # Execute stage
│   │   │   │   │   │   │           │   ├── writeback/ # Writeback stage
│   │   │   │   │   │   │           │   ├── pipeline/ # Pipeline control logic
│   │   │   │   │   │   │           │   ├── hazard/  # Hazard detection and stall logic
│   │   │   │   │   │   │           │   ├── alu/     # Arithmetic Logic Unit (64-bit)
│   │   │   │   │   │   │           │   ├── regfile/ # Register file (64-bit)
│   │   │   │   │   │   │           │   └── csr/     # Control and Status Registers
│   │   │   │   │   │   │           ├── memory/      # Memory subsystem
│   │   │   │   │   │   │           │   ├── cache/   # Cache hierarchy
│   │   │   │   │   │   │           │   └── bus/     # Bus interface (64-bit)
│   │   │   │   │   │   │           └── top/         # Top-level integration
│   │   │   │   │   │   └── test/    # Chisel unit tests
│   │   │   │   │   ├── generated/   # Generated Verilog from Chisel
│   │   │   │   │   │   ├── verilog/ # Generated Verilog files
│   │   │   │   │   │   │   ├── pipenyte_rv64i_core.v     # Generated core
│   │   │   │   │   │   │   ├── pipenyte_rv64i_pipeline.v # Generated pipeline
│   │   │   │   │   │   │   ├── pipenyte_rv64i_hazard.v   # Generated hazard unit
│   │   │   │   │   │   │   └── pipenyte_rv64i_cache.v    # Generated cache
│   │   │   │   │   │   ├── firrtl/  # Intermediate FIRRTL files
│   │   │   │   │   │   └── annotations/ # Chisel annotations
│   │   │   │   │   ├── build.sbt    # SBT build configuration
│   │   │   │   │   ├── Makefile     # Chisel build automation
│   │   │   │   │   └── configs/     # Chisel configurations
│   │   │   │   ├── include/         # Generated and shared includes
│   │   │   │   └── constraints/     # Physical and timing constraints
│   │   │   ├── verification/        # Verification environment (similar to RV32I)
│   │   │   ├── docs/                # RV64I documentation
│   │   │   └── configs/             # Configuration files
│   │   │
│   │   ├── shared/                  # Shared components between RV32I and RV64I
│   │   │   ├── rtl/                 # Shared RTL components
│   │   │   │   ├── pipeline/        # Pipeline control logic
│   │   │   │   ├── hazard/          # Hazard detection (parameterized)
│   │   │   │   └── cache/           # Cache controllers
│   │   │   ├── verification/        # Shared verification components
│   │   │   └── docs/                # Shared documentation
│   │   │
│   │   └── docs/                    # PipeNyte family documentation
│   │       ├── overview/            # PipeNyte overview
│   │       ├── pipeline/            # Pipeline architecture
│   │       └── comparison/          # RV32I vs RV64I comparison
│   │
│   ├── TetraNyte/                   # TetraNyte: 4-threaded architecture
│   │   ├── rv32i/                   # RV32I implementation
│   │   │   ├── rtl/                 # RTL source and generation
│   │   │   │   ├── chisel/          # Chisel source implementation
│   │   │   │   │   ├── src/         # Chisel source files
│   │   │   │   │   │   ├── main/    # Main Chisel source
│   │   │   │   │   │   │   └── scala/ # Scala source files
│   │   │   │   │   │   │       └── TetraNyte/ # TetraNyte-specific package
│   │   │   │   │   │   │           ├── core/    # Core modules
│   │   │   │   │   │   │           │   ├── threads/ # Thread management
│   │   │   │   │   │   │           │   │   ├── scheduler/ # Thread scheduler
│   │   │   │   │   │   │           │   │   ├── context/   # Thread context (32-bit)
│   │   │   │   │   │   │           │   │   └── control/   # Thread control
│   │   │   │   │   │   │           │   ├── fetch/   # Multi-threaded fetch
│   │   │   │   │   │   │           │   ├── decode/  # Multi-threaded decode
│   │   │   │   │   │   │           │   ├── execute/ # Shared execution units
│   │   │   │   │   │   │           │   ├── writeback/ # Multi-threaded writeback
│   │   │   │   │   │   │           │   ├── pipeline/ # Pipeline control with threading
│   │   │   │   │   │   │           │   ├── regfile/ # Multi-threaded register file (32-bit)
│   │   │   │   │   │   │           │   └── csr/     # Per-thread CSRs
│   │   │   │   │   │   │           ├── memory/      # Shared memory subsystem
│   │   │   │   │   │   │           │   ├── cache/   # Shared cache hierarchy
│   │   │   │   │   │   │           │   └── coherence/ # Cache coherence (if needed)
│   │   │   │   │   │   │           └── top/         # Top-level integration
│   │   │   │   │   │   └── test/    # Chisel unit tests
│   │   │   │   │   │       └── scala/ # Scala test files
│   │   │   │   │   │           └── TetraNyte/ # TetraNyte-specific tests
│   │   │   │   │   │               ├── core/    # Core unit tests
│   │   │   │   │   │               ├── threading/ # Threading tests
│   │   │   │   │   │               ├── memory/  # Memory tests
│   │   │   │   │   │               └── integration/ # Integration tests
│   │   │   │   │   ├── generated/   # Generated Verilog from Chisel
│   │   │   │   │   │   ├── verilog/ # Generated Verilog files
│   │   │   │   │   │   │   ├── tetranyte_rv32i_core.v      # Generated core
│   │   │   │   │   │   │   ├── tetranyte_rv32i_scheduler.v # Generated scheduler
│   │   │   │   │   │   │   ├── tetranyte_rv32i_context.v   # Generated context
│   │   │   │   │   │   │   └── tetranyte_rv32i_cache.v     # Generated cache
│   │   │   │   │   │   ├── firrtl/  # Intermediate FIRRTL files
│   │   │   │   │   │   └── annotations/ # Chisel annotations
│   │   │   │   │   ├── build.sbt    # SBT build configuration
│   │   │   │   │   ├── Makefile     # Chisel build automation
│   │   │   │   │   └── configs/     # Chisel configurations
│   │   │   │   │       ├── TetraNyteConfig.scala # Processor configuration
│   │   │   │   │       ├── synthesis/   # Synthesis configurations
│   │   │   │   │       └── simulation/  # Simulation configurations
│   │   │   │   ├── include/         # Generated and shared includes
│   │   │   │   └── constraints/     # Physical and timing constraints
│   │   │   ├── verification/        # Verification environment
│   │   │   │   ├── chisel-tests/    # Chisel-native verification
│   │   │   │   │   ├── unit/        # Chisel unit tests
│   │   │   │   │   │   ├── core/    # Core module tests
│   │   │   │   │   │   │   ├── AluSpec.scala    # ALU test specification
│   │   │   │   │   │   │   ├── RegFileSpec.scala # Register file tests
│   │   │   │   │   │   │   ├── FetchSpec.scala  # Fetch stage tests
│   │   │   │   │   │   │   ├── DecodeSpec.scala # Decode stage tests
│   │   │   │   │   │   │   ├── ExecuteSpec.scala # Execute stage tests
│   │   │   │   │   │   │   └── WritebackSpec.scala # Writeback tests
│   │   │   │   │   │   ├── threading/ # Threading tests
│   │   │   │   │   │   │   ├── SchedulerSpec.scala   # Thread scheduler tests
│   │   │   │   │   │   │   ├── ContextSpec.scala     # Context switching tests
│   │   │   │   │   │   │   └── ArbiterSpec.scala     # Resource arbitration tests
│   │   │   │   │   │   ├── memory/  # Memory system tests
│   │   │   │   │   │   └── integration/ # Integration tests
│   │   │   │   │   ├── formal/      # Chisel formal verification
│   │   │   │   │   │   ├── properties/ # Formal properties in Chisel
│   │   │   │   │   │   │   ├── CoreProperties.scala     # Core correctness properties
│   │   │   │   │   │   │   ├── ThreadingProperties.scala # Threading properties
│   │   │   │   │   │   │   └── MemoryProperties.scala   # Memory consistency properties
│   │   │   │   │   │   └── proofs/  # Formal proofs and verification
│   │   │   │   │   ├── performance/ # Performance testing
│   │   │   │   │   │   ├── benchmarks/ # Benchmark tests
│   │   │   │   │   │   ├── throughput/ # Throughput analysis (threading cores)
│   │   │   │   │   │   └── latency/ # Latency analysis
│   │   │   │   │   ├── utilities/   # Chisel test utilities
│   │   │   │   │   │   ├── TestUtils.scala      # Common test utilities
│   │   │   │   │   │   ├── Generators.scala     # Test data generators
│   │   │   │   │   │   ├── ThreadingUtils.scala # Threading test utilities
│   │   │   │   │   │   └── Checkers.scala       # Result checkers
│   │   │   │   │   └── scripts/     # Chisel test scripts
│   │   │   │   ├── systemverilog-tests/ # SystemVerilog verification
│   │   │   │   │   ├── unit/        # SystemVerilog unit tests
│   │   │   │   │   │   ├── core/    # Core module tests
│   │   │   │   │   │   ├── threading/ # Threading testbenches
│   │   │   │   │   │   │   ├── tb_scheduler.sv  # Thread scheduler testbench
│   │   │   │   │   │   │   ├── tb_context.sv    # Context management testbench
│   │   │   │   │   │   │   └── tb_arbiter.sv    # Resource arbitration testbench
│   │   │   │   │   │   ├── memory/  # Memory system testbenches
│   │   │   │   │   │   └── integration/ # Integration testbenches
│   │   │   │   │   ├── formal/      # SystemVerilog formal verification
│   │   │   │   │   │   ├── properties/ # SVA properties
│   │   │   │   │   │   │   ├── core_properties.sv       # Core correctness properties
│   │   │   │   │   │   │   ├── threading_properties.sv  # Threading properties
│   │   │   │   │   │   │   └── memory_properties.sv     # Memory consistency properties
│   │   │   │   │   │   ├── binds/   # Bind files for properties
│   │   │   │   │   │   └── scripts/ # Formal verification scripts
│   │   │   │   │   ├── performance/ # Performance verification
│   │   │   │   │   │   ├── benchmarks/ # Benchmark testbenches
│   │   │   │   │   │   │   ├── tb_dhrystone.sv  # Dhrystone benchmark
│   │   │   │   │   │   │   ├── tb_coremark.sv   # CoreMark benchmark
│   │   │   │   │   │   │   └── tb_threading.sv  # Threading performance
│   │   │   │   │   │   ├── throughput/ # Throughput analysis testbenches
│   │   │   │   │   │   └── latency/ # Latency analysis testbenches
│   │   │   │   │   ├── utilities/   # SystemVerilog test utilities
│   │   │   │   │   │   ├── test_utils.sv        # Common test utilities
│   │   │   │   │   │   ├── generators.sv        # Test data generators
│   │   │   │   │   │   ├── threading_utils.sv   # Threading utilities
│   │   │   │   │   │   ├── checkers.sv          # Result checkers
│   │   │   │   │   │   └── monitors.sv          # Protocol monitors
│   │   │   │   │   ├── configs/     # Test configurations
│   │   │   │   │   └── scripts/     # SystemVerilog test scripts
│   │   │   │   ├── cross-verification/ # Cross-verification
│   │   │   │   ├── simulation/      # Simulation environment
│   │   │   │   ├── coverage/        # Coverage analysis
│   │   │   │   └── tools/           # Verification tools
│   │   │   ├── docs/                # RV32I documentation
│   │   │   └── configs/             # Configuration files
│   │   │
│   │   ├── rv64i/                   # RV64I implementation (similar structure to RV32I)
│   │   │   ├── rtl/                 # RTL source and generation
│   │   │   │   ├── chisel/          # Chisel source implementation
│   │   │   │   │   ├── src/         # Chisel source files
│   │   │   │   │   │   ├── main/    # Main Chisel source
│   │   │   │   │   │   │   └── scala/ # Scala source files
│   │   │   │   │   │   │       └── TetraNyte/ # TetraNyte-specific package
│   │   │   │   │   │   │           ├── core/    # Core modules
│   │   │   │   │   │   │           │   ├── threads/ # Thread management
│   │   │   │   │   │   │           │   │   ├── scheduler/ # Thread scheduler
│   │   │   │   │   │   │           │   │   ├── context/   # Thread context (64-bit)
│   │   │   │   │   │   │           │   │   └── control/   # Thread control
│   │   │   │   │   │   │           │   ├── fetch/   # Multi-threaded fetch
│   │   │   │   │   │   │           │   ├── decode/  # Multi-threaded decode
│   │   │   │   │   │   │           │   ├── execute/ # Shared execution units
│   │   │   │   │   │   │           │   ├── writeback/ # Multi-threaded writeback
│   │   │   │   │   │   │           │   ├── pipeline/ # Pipeline control with threading
│   │   │   │   │   │   │           │   ├── regfile/ # Multi-threaded register file (64-bit)
│   │   │   │   │   │   │           │   └── csr/     # Per-thread CSRs
│   │   │   │   │   │   │           ├── memory/      # Shared memory subsystem
│   │   │   │   │   │   │           │   ├── cache/   # Shared cache hierarchy
│   │   │   │   │   │   │           │   └── coherence/ # Cache coherence
│   │   │   │   │   │   │           └── top/         # Top-level integration
│   │   │   │   │   │   └── test/    # Chisel unit tests
│   │   │   │   │   ├── generated/   # Generated Verilog from Chisel
│   │   │   │   │   │   ├── verilog/ # Generated Verilog files
│   │   │   │   │   │   │   ├── tetranyte_rv64i_core.v      # Generated core
│   │   │   │   │   │   │   ├── tetranyte_rv64i_scheduler.v # Generated scheduler
│   │   │   │   │   │   │   ├── tetranyte_rv64i_context.v   # Generated context
│   │   │   │   │   │   │   └── tetranyte_rv64i_cache.v     # Generated cache
│   │   │   │   │   │   ├── firrtl/  # Intermediate FIRRTL files
│   │   │   │   │   │   └── annotations/ # Chisel annotations
│   │   │   │   │   ├── build.sbt    # SBT build configuration
│   │   │   │   │   ├── Makefile     # Chisel build automation
│   │   │   │   │   └── configs/     # Chisel configurations
│   │   │   │   ├── include/         # Generated and shared includes
│   │   │   │   └── constraints/     # Physical and timing constraints
│   │   │   ├── verification/        # Verification environment (similar to RV32I)
│   │   │   ├── docs/                # RV64I documentation
│   │   │   └── configs/             # Configuration files
│   │   │
│   │   ├── shared/                  # Shared components between RV32I and RV64I
│   │   │   ├── rtl/                 # Shared RTL components
│   │   │   │   ├── threads/         # Thread management (parameterized)
│   │   │   │   ├── pipeline/        # Pipeline control logic
│   │   │   │   ├── cache/           # Cache controllers
│   │   │   │   └── coherence/       # Cache coherence protocol
│   │   │   ├── verification/        # Shared verification components
│   │   │   └── docs/                # Shared documentation
│   │   │
│   │   └── docs/                    # TetraNyte family documentation
│   │       ├── overview/            # TetraNyte overview
│   │       ├── threading/           # Threading architecture
│   │       └── comparison/          # RV32I vs RV64I comparison
│   │
│   ├── OctoNyte/                    # OctoNyte: 8-stage 8-threaded architecture
│   │   ├── rv32i/                   # RV32I implementation
│   │   │   ├── rtl/                 # RTL source and generation
│   │   │   │   ├── chisel/          # Chisel source implementation
│   │   │   │   │   ├── src/         # Chisel source files
│   │   │   │   │   │   ├── main/    # Main Chisel source
│   │   │   │   │   │   │   └── scala/ # Scala source files
│   │   │   │   │   │   │       └── OctoNyte/ # OctoNyte-specific package
│   │   │   │   │   │   │           ├── core/    # Core modules
│   │   │   │   │   │   │           │   ├── threads/ # Advanced thread management
│   │   │   │   │   │   │           │   │   ├── scheduler/ # Advanced scheduler
│   │   │   │   │   │   │           │   │   ├── context/   # Thread contexts (32-bit)
│   │   │   │   │   │   │           │   │   ├── control/   # Thread control
│   │   │   │   │   │   │           │   │   └── arbiter/   # Resource arbitration
│   │   │   │   │   │   │           │   ├── fetch/   # Multi-threaded fetch (stages 1-2)
│   │   │   │   │   │   │           │   │   ├── ifetch1/ # Instruction fetch stage 1
│   │   │   │   │   │   │           │   │   └── ifetch2/ # Instruction fetch stage 2
│   │   │   │   │   │   │           │   ├── decode/  # Multi-threaded decode (stages 3-4)
│   │   │   │   │   │   │           │   │   ├── decode1/ # Decode stage 1
│   │   │   │   │   │   │           │   │   └── decode2/ # Decode stage 2
│   │   │   │   │   │   │           │   ├── execute/ # Execution stages (stages 5-6)
│   │   │   │   │   │   │           │   │   ├── execute1/    # Execute stage 1
│   │   │   │   │   │   │           │   │   ├── execute2/    # Execute stage 2
│   │   │   │   │   │   │           │   │   ├── alu/         # Multiple ALUs (32-bit)
│   │   │   │   │   │   │           │   │   ├── multiplier/  # Multiplier unit
│   │   │   │   │   │   │           │   │   └── divider/     # Divider unit
│   │   │   │   │   │   │           │   ├── memory/  # Memory stages (stage 7)
│   │   │   │   │   │   │           │   │   ├── load_store/  # Load/store unit
│   │   │   │   │   │   │           │   │   └── memory_arbiter/ # Memory arbitration
│   │   │   │   │   │   │           │   ├── writeback/ # Writeback stage (stage 8)
│   │   │   │   │   │   │           │   ├── pipeline/ # Advanced pipeline control
│   │   │   │   │   │   │           │   │   ├── control/     # Pipeline control
│   │   │   │   │   │   │           │   │   └── stages/      # Stage management
│   │   │   │   │   │   │           │   ├── regfile/ # Multi-ported register file (32-bit)
│   │   │   │   │   │   │           │   └── csr/     # Per-thread CSRs
│   │   │   │   │   │   │           ├── memory/      # Advanced memory subsystem
│   │   │   │   │   │   │           │   ├── cache/   # Cache hierarchy
│   │   │   │   │   │   │           │   │   ├── l1_icache/   # L1 instruction cache
│   │   │   │   │   │   │           │   │   ├── l1_dcache/   # L1 data cache
│   │   │   │   │   │   │           │   │   └── l2_cache/    # L2 unified cache
│   │   │   │   │   │   │           │   ├── coherence/ # Cache coherence protocol
│   │   │   │   │   │   │           │   └── interconnect/ # Memory interconnect
│   │   │   │   │   │   │           └── top/         # Top-level integration
│   │   │   │   │   │   └── test/    # Chisel unit tests
│   │   │   │   │   │       └── scala/ # Scala test files
│   │   │   │   │   │           └── OctoNyte/ # OctoNyte-specific tests
│   │   │   │   │   │               ├── core/    # Core unit tests
│   │   │   │   │   │               ├── threading/ # Threading tests
│   │   │   │   │   │               ├── memory/  # Memory tests
│   │   │   │   │   │               └── integration/ # Integration tests
│   │   │   │   │   ├── generated/   # Generated Verilog from Chisel
│   │   │   │   │   │   ├── verilog/ # Generated Verilog files
│   │   │   │   │   │   │   ├── octonyte_rv32i_core.v      # Generated core
│   │   │   │   │   │   │   ├── octonyte_rv32i_scheduler.v # Generated scheduler
│   │   │   │   │   │   │   ├── octonyte_rv32i_pipeline.v  # Generated pipeline
│   │   │   │   │   │   │   ├── octonyte_rv32i_cache.v     # Generated cache
│   │   │   │   │   │   │   └── octonyte_rv32i_coherence.v # Generated coherence
│   │   │   │   │   │   ├── firrtl/  # Intermediate FIRRTL files
│   │   │   │   │   │   └── annotations/ # Chisel annotations
│   │   │   │   │   ├── build.sbt    # SBT build configuration
│   │   │   │   │   ├── Makefile     # Chisel build automation
│   │   │   │   │   └── configs/     # Chisel configurations
│   │   │   │   │       ├── OctoNyteConfig.scala # Processor configuration
│   │   │   │   │       ├── synthesis/   # Synthesis configurations
│   │   │   │   │       └── simulation/  # Simulation configurations
│   │   │   │   ├── include/         # Generated and shared includes
│   │   │   │   └── constraints/     # Physical and timing constraints
│   │   │   ├── verification/        # Verification environment
│   │   │   │   ├── chisel-tests/    # Chisel-native verification
│   │   │   │   │   ├── unit/        # Chisel unit tests
│   │   │   │   │   │   ├── core/    # Core module tests
│   │   │   │   │   │   │   ├── AluSpec.scala    # ALU test specification
│   │   │   │   │   │   │   ├── RegFileSpec.scala # Register file tests
│   │   │   │   │   │   │   ├── FetchSpec.scala  # Fetch stage tests
│   │   │   │   │   │   │   ├── DecodeSpec.scala # Decode stage tests
│   │   │   │   │   │   │   ├── ExecuteSpec.scala # Execute stage tests
│   │   │   │   │   │   │   └── WritebackSpec.scala # Writeback tests
│   │   │   │   │   │   ├── threading/ # Threading tests
│   │   │   │   │   │   │   ├── SchedulerSpec.scala   # Thread scheduler tests
│   │   │   │   │   │   │   ├── ContextSpec.scala     # Context switching tests
│   │   │   │   │   │   │   └── ArbiterSpec.scala     # Resource arbitration tests
│   │   │   │   │   │   ├── memory/  # Memory system tests
│   │   │   │   │   │   │   ├── CacheSpec.scala  # Cache tests
│   │   │   │   │   │   │   ├── CoherenceSpec.scala # Coherence tests
│   │   │   │   │   │   │   └── InterconnectSpec.scala # Interconnect tests
│   │   │   │   │   │   └── integration/ # Integration tests
│   │   │   │   │   ├── formal/      # Chisel formal verification
│   │   │   │   │   │   ├── properties/ # Formal properties in Chisel
│   │   │   │   │   │   │   ├── CoreProperties.scala     # Core correctness properties
│   │   │   │   │   │   │   ├── ThreadingProperties.scala # Threading properties
│   │   │   │   │   │   │   ├── PipelineProperties.scala  # Pipeline properties
│   │   │   │   │   │   │   └── MemoryProperties.scala   # Memory consistency properties
│   │   │   │   │   │   └── proofs/  # Formal proofs and verification
│   │   │   │   │   ├── performance/ # Performance testing
│   │   │   │   │   │   ├── benchmarks/ # Benchmark tests
│   │   │   │   │   │   ├── throughput/ # Throughput analysis
│   │   │   │   │   │   └── latency/ # Latency analysis
│   │   │   │   │   ├── utilities/   # Chisel test utilities
│   │   │   │   │   │   ├── TestUtils.scala      # Common test utilities
│   │   │   │   │   │   ├── Generators.scala     # Test data generators
│   │   │   │   │   │   ├── ThreadingUtils.scala # Threading test utilities
│   │   │   │   │   │   └── Checkers.scala       # Result checkers
│   │   │   │   │   └── scripts/     # Chisel test scripts
│   │   │   │   ├── systemverilog-tests/ # SystemVerilog verification
│   │   │   │   │   ├── unit/        # SystemVerilog unit tests
│   │   │   │   │   │   ├── core/    # Core module tests
│   │   │   │   │   │   ├── threading/ # Threading testbenches
│   │   │   │   │   │   │   ├── tb_scheduler.sv  # Thread scheduler testbench
│   │   │   │   │   │   │   ├── tb_context.sv    # Context management testbench
│   │   │   │   │   │   │   └── tb_arbiter.sv    # Resource arbitration testbench
│   │   │   │   │   │   ├── memory/  # Memory system testbenches
│   │   │   │   │   │   │   ├── tb_cache.sv      # Cache testbench
│   │   │   │   │   │   │   ├── tb_coherence.sv  # Coherence testbench
│   │   │   │   │   │   │   └── tb_interconnect.sv # Interconnect testbench
│   │   │   │   │   │   └── integration/ # Integration testbenches
│   │   │   │   │   ├── formal/      # SystemVerilog formal verification
│   │   │   │   │   │   ├── properties/ # SVA properties
│   │   │   │   │   │   │   ├── core_properties.sv       # Core correctness properties
│   │   │   │   │   │   │   ├── threading_properties.sv  # Threading properties
│   │   │   │   │   │   │   ├── pipeline_properties.sv   # Pipeline properties
│   │   │   │   │   │   │   └── memory_properties.sv     # Memory consistency properties
│   │   │   │   │   │   ├── binds/   # Bind files for properties
│   │   │   │   │   │   └── scripts/ # Formal verification scripts
│   │   │   │   │   ├── performance/ # Performance verification
│   │   │   │   │   │   ├── benchmarks/ # Benchmark testbenches
│   │   │   │   │   │   │   ├── tb_dhrystone.sv  # Dhrystone benchmark
│   │   │   │   │   │   │   ├── tb_coremark.sv   # CoreMark benchmark
│   │   │   │   │   │   │   └── tb_threading.sv  # Threading performance
│   │   │   │   │   │   ├── throughput/ # Throughput analysis testbenches
│   │   │   │   │   │   └── latency/ # Latency analysis testbenches
│   │   │   │   │   ├── utilities/   # SystemVerilog test utilities
│   │   │   │   │   │   ├── test_utils.sv        # Common test utilities
│   │   │   │   │   │   ├── generators.sv        # Test data generators
│   │   │   │   │   │   ├── threading_utils.sv   # Threading utilities
│   │   │   │   │   │   ├── checkers.sv          # Result checkers
│   │   │   │   │   │   └── monitors.sv          # Protocol monitors
│   │   │   │   │   ├── configs/     # Test configurations
│   │   │   │   │   └── scripts/     # SystemVerilog test scripts
│   │   │   │   ├── cross-verification/ # Cross-verification
│   │   │   │   ├── simulation/      # Simulation environment
│   │   │   │   ├── coverage/        # Coverage analysis
│   │   │   │   └── tools/           # Verification tools
│   │   │   ├── docs/                # RV32I documentation
│   │   │   └── configs/             # Configuration files
│   │   │
│   │   ├── rv64i/                   # RV64I implementation (similar structure to RV32I)
│   │   │   ├── rtl/                 # RTL source and generation
│   │   │   │   ├── chisel/          # Chisel source implementation
│   │   │   │   │   ├── src/         # Chisel source files
│   │   │   │   │   │   ├── main/    # Main Chisel source
│   │   │   │   │   │   │   └── scala/ # Scala source files
│   │   │   │   │   │   │       └── OctoNyte/ # OctoNyte-specific package
│   │   │   │   │   │   │           ├── core/    # Core modules
│   │   │   │   │   │   │           │   ├── threads/ # Advanced thread management
│   │   │   │   │   │   │           │   │   ├── scheduler/ # Advanced scheduler
│   │   │   │   │   │   │           │   │   ├── context/   # Thread contexts (64-bit)
│   │   │   │   │   │   │           │   │   ├── control/   # Thread control
│   │   │   │   │   │   │           │   │   └── arbiter/   # Resource arbitration
│   │   │   │   │   │   │           │   ├── fetch/   # Multi-threaded fetch (stages 1-2)
│   │   │   │   │   │   │           │   ├── decode/  # Multi-threaded decode (stages 3-4)
│   │   │   │   │   │   │           │   ├── execute/ # Execution stages (stages 5-6)
│   │   │   │   │   │   │           │   │   ├── execute1/    # Execute stage 1
│   │   │   │   │   │   │           │   │   ├── execute2/    # Execute stage 2
│   │   │   │   │   │   │           │   │   ├── alu/         # Multiple ALUs (64-bit)
│   │   │   │   │   │   │           │   │   ├── multiplier/  # Multiplier unit (64-bit)
│   │   │   │   │   │   │           │   │   └── divider/     # Divider unit (64-bit)
│   │   │   │   │   │   │           │   ├── memory/  # Memory stages (stage 7)
│   │   │   │   │   │   │           │   ├── writeback/ # Writeback stage (stage 8)
│   │   │   │   │   │   │           │   ├── pipeline/ # Advanced pipeline control
│   │   │   │   │   │   │           │   ├── regfile/ # Multi-ported register file (64-bit)
│   │   │   │   │   │   │           │   └── csr/     # Per-thread CSRs
│   │   │   │   │   │   │           ├── memory/      # Advanced memory subsystem
│   │   │   │   │   │   │           │   ├── cache/   # Cache hierarchy
│   │   │   │   │   │   │           │   ├── coherence/ # Cache coherence protocol
│   │   │   │   │   │   │           │   └── interconnect/ # Memory interconnect (64-bit)
│   │   │   │   │   │   │           └── top/         # Top-level integration
│   │   │   │   │   │   └── test/    # Chisel unit tests
│   │   │   │   │   ├── generated/   # Generated Verilog from Chisel
│   │   │   │   │   │   ├── verilog/ # Generated Verilog files
│   │   │   │   │   │   │   ├── octonyte_rv64i_core.v      # Generated core
│   │   │   │   │   │   │   ├── octonyte_rv64i_scheduler.v # Generated scheduler
│   │   │   │   │   │   │   ├── octonyte_rv64i_pipeline.v  # Generated pipeline
│   │   │   │   │   │   │   ├── octonyte_rv64i_cache.v     # Generated cache
│   │   │   │   │   │   │   └── octonyte_rv64i_coherence.v # Generated coherence
│   │   │   │   │   │   ├── firrtl/  # Intermediate FIRRTL files
│   │   │   │   │   │   └── annotations/ # Chisel annotations
│   │   │   │   │   ├── build.sbt    # SBT build configuration
│   │   │   │   │   ├── Makefile     # Chisel build automation
│   │   │   │   │   └── configs/     # Chisel configurations
│   │   │   │   ├── include/         # Generated and shared includes
│   │   │   │   └── constraints/     # Physical and timing constraints
│   │   │   ├── verification/        # Verification environment (similar to RV32I)
│   │   │   ├── docs/                # RV64I documentation
│   │   │   └── configs/             # Configuration files
│   │   │
│   │   ├── shared/                  # Shared components between RV32I and RV64I
│   │   │   ├── rtl/                 # Shared RTL components
│   │   │   │   ├── threads/         # Thread management (parameterized)
│   │   │   │   ├── pipeline/        # Pipeline control logic
│   │   │   │   ├── cache/           # Cache controllers
│   │   │   │   └── coherence/       # Cache coherence protocol
│   │   │   ├── verification/        # Shared verification components
│   │   │   └── docs/                # Shared documentation
│   │   │
│   │   └── docs/                    # OctoNyte family documentation
│   │       ├── overview/            # OctoNyte overview
│   │       ├── pipeline/            # 8-stage pipeline architecture
│   │       ├── threading/           # 8-thread architecture
│   │       └── comparison/          # RV32I vs RV64I comparison
│   │
│   └── family-shared/               # Components shared across all processor families
│       ├── rtl/                     # Family-wide shared RTL
│       │   ├── interfaces/          # Standard interfaces
│       │   ├── utilities/           # Common utilities
│       │   └── packages/            # Family-wide packages
│       ├── verification/            # Family-wide verification components
│       └── docs/                    # Family-wide shared documentation
│
├── shared/                          # Global shared components
│   ├── rtl/                         # Shared RTL components
│   │   ├── common/                  # Common modules
│   │   │   ├── interfaces/          # Standard interfaces
│   │   │   │   ├── axi/             # AXI interface definitions
│   │   │   │   ├── ahb/             # AHB interface definitions
│   │   │   │   ├── wishbone/        # Wishbone interface definitions
│   │   │   │   └── custom/          # Custom interfaces
│   │   │   ├── utilities/           # Utility modules
│   │   │   │   ├── fifos/           # FIFO implementations
│   │   │   │   ├── arbiters/        # Arbitration logic
│   │   │   │   ├── muxes/           # Multiplexer implementations
│   │   │   │   └── counters/        # Counter implementations
│   │   │   ├── memory/              # Memory components
│   │   │   │   ├── sram/            # SRAM models
│   │   │   │   ├── rom/             # ROM models
│   │   │   │   └── controllers/     # Memory controllers
│   │   │   └── debug/               # Debug infrastructure
│   │   │       ├── jtag/            # JTAG debug interface
│   │   │       ├── trace/           # Trace infrastructure
│   │   │       └── monitors/        # Debug monitors
│   │   ├── peripherals/             # Shared peripheral IP
│   │   │   ├── uart/                # UART controllers
│   │   │   ├── gpio/                # GPIO controllers
│   │   │   ├── spi/                 # SPI controllers
│   │   │   ├── i2c/                 # I2C controllers
│   │   │   ├── timer/               # Timer modules
│   │   │   ├── interrupt/           # Interrupt controllers
│   │   │   └── dma/                 # DMA controllers
│   │   ├── interconnect/            # Interconnect fabric
│   │   │   ├── crossbar/            # Crossbar switches
│   │   │   ├── network-on-chip/     # NoC implementation
│   │   │   └── bridges/             # Protocol bridges
│   │   └── packages/                # Shared SystemVerilog packages
│   │       ├── riscv_pkg.sv         # RISC-V definitions
│   │       ├── KryptoNyte_pkg.sv      # KryptoNyte family definitions
│   │       ├── cache_pkg.sv         # Cache-related definitions
│   │       └── debug_pkg.sv         # Debug-related definitions
│   ├── include/                     # Shared header files
│   │   ├── defines/                 # Global defines
│   │   │   ├── riscv_defines.svh    # RISC-V standard defines
│   │   │   ├── KryptoNyte_defines.svh # KryptoNyte family defines
│   │   │   └── config_defines.svh   # Configuration defines
│   │   ├── interfaces/              # Interface definitions
│   │   └── macros/                  # Useful macros
│   ├── verification/                # Shared verification components
│   │   ├── agents/                  # Verification agents
│   │   │   ├── axi_agent/           # AXI protocol agent
│   │   │   ├── ahb_agent/           # AHB protocol agent
│   │   │   └── memory_agent/        # Memory agent
│   │   ├── monitors/                # Protocol monitors
│   │   ├── checkers/                # Assertion checkers
│   │   ├── scoreboards/             # Scoreboards
│   │   └── utilities/               # Verification utilities
│   └── tools/                       # Shared tool scripts
│       ├── generators/              # Code generators
│       │   ├── config_gen.py        # Configuration generator
│       │   ├── testbench_gen.py     # Testbench generator
│       │   └── doc_gen.py           # Documentation generator
│       ├── analyzers/               # Analysis tools
│       │   ├── coverage_analyzer.py # Coverage analysis
│       │   ├── timing_analyzer.py   # Timing analysis
│       │   └── power_analyzer.py    # Power analysis
│       └── utilities/               # General utilities
│           ├── file_utils.py        # File utilities
│           ├── report_utils.py      # Report utilities
│           └── config_utils.py      # Configuration utilities
│
├── docs/                            # Family-wide documentation
│   ├── family-overview/             # KryptoNyte family overview
│   │   ├── introduction.md          # Family introduction
│   │   ├── core-comparison.md       # Core comparison matrix
│   │   ├── roadmap.md               # Development roadmap
│   │   └── architecture-overview.md # High-level architecture
│   ├── specifications/              # Technical specifications
│   │   ├── isa-compliance/          # ISA compliance documentation
│   │   ├── interfaces/              # Interface specifications
│   │   ├── memory-model/            # Memory model specification
│   │   └── debug-spec/              # Debug specification
│   ├── user-guides/                 # User documentation
│   │   ├── getting-started/         # Getting started guides
│   │   ├── core-selection/          # Core selection guide
│   │   ├── integration/             # Integration guides
│   │   └── programming/             # Programming guides
│   ├── verification/                # Verification documentation
│   │   ├── methodology/             # Verification methodology
│   │   ├── test-plans/              # Test plans
│   │   ├── coverage-plans/          # Coverage plans
│   │   └── results/                 # Verification results
│   ├── implementation/              # Implementation guides
│   │   ├── synthesis/               # Synthesis guidelines
│   │   ├── physical-design/         # Physical design guides
│   │   ├── fpga/                    # FPGA implementation
│   │   └── asic/                    # ASIC implementation
│   ├── tutorials/                   # Step-by-step tutorials
│   │   ├── basic-usage/             # Basic usage tutorials
│   │   ├── advanced-features/       # Advanced feature tutorials
│   │   └── customization/           # Customization tutorials
│   └── assets/                      # Documentation assets
│       ├── images/                  # Images and diagrams
│       ├── diagrams/                # Architecture diagrams
│       └── templates/               # Document templates
│
├── verification/                    # Family-wide verification
│   ├── conformance/                 # RISC-V conformance tests
│   │   ├── riscv-arch-test/         # Official RISC-V architecture tests
│   │   │   ├── rv32i/               # RV32I instruction tests
│   │   │   ├── rv32m/               # RV32M multiplication tests
│   │   │   ├── rv32a/               # RV32A atomic instruction tests
│   │   │   ├── rv32c/               # RV32C compressed instruction tests
│   │   │   ├── rv64i/               # RV64I instruction tests (for 64-bit variants)
│   │   │   └── privilege/           # Privilege mode tests
│   │   ├── custom-tests/            # Custom conformance tests
│   │   │   ├── KryptoNyte-specific/   # KryptoNyte family specific tests
│   │   │   ├── threading/           # Multi-threading tests
│   │   │   ├── pipeline/            # Pipeline-specific tests
│   │   │   └── performance/         # Performance validation tests
│   │   ├── compliance-reports/      # Conformance test reports
│   │   └── scripts/                 # Test execution scripts
│   │       ├── run-conformance.sh   # Main conformance test runner
│   │       ├── core-specific/       # Core-specific test scripts
│   │       └── compare-results.sh   # Result comparison utilities
│   ├── cross-core/                  # Cross-core verification
│   │   ├── compatibility/           # Cross-core compatibility tests
│   │   ├── migration/               # Code migration tests
│   │   ├── performance/             # Performance comparison
│   │   └── integration/             # Multi-core integration tests
│   ├── system-level/                # System-level verification
│   │   ├── testbenches/             # System testbenches
│   │   │   ├── multi-core-tb/       # Multi-core system testbench
│   │   │   ├── soc-tb/              # SoC-level testbench
│   │   │   └── platform-tb/         # Platform testbench
│   │   ├── tests/                   # System-level tests
│   │   │   ├── boot-tests/          # Boot sequence tests
│   │   │   ├── os-tests/            # Operating system tests
│   │   │   └── application-tests/   # Application-level tests
│   │   └── models/                  # System models
│   │       ├── memory-models/       # Memory system models
│   │       └── peripheral-models/   # Peripheral models
│   ├── simulation/                  # Simulation environment
│   │   ├── scripts/                 # Simulation control scripts
│   │   │   ├── run_sim.sh           # Main simulation runner
│   │   │   ├── family_sim.py        # Family-wide simulation
│   │   │   └── compare_cores.py     # Core comparison simulation
│   │   ├── configs/                 # Simulation configurations
│   │   │   ├── family-wide/         # Family-wide configs
│   │   │   ├── core-specific/       # Core-specific configs
│   │   │   └── comparison/          # Comparison configs
│   │   ├── models/                  # Simulation models
│   │   ├── waves/                   # Waveform dumps
│   │   └── logs/                    # Simulation logs
│   ├── regression/                  # Family-wide regression
│   │   ├── nightly/                 # Nightly regression tests
│   │   │   ├── all-rtl/           # All cores regression
│   │   │   ├── cross-core/          # Cross-core regression
│   │   │   └── performance/         # Performance regression
│   │   ├── weekly/                  # Weekly comprehensive tests
│   │   ├── release/                 # Release qualification tests
│   │   ├── scripts/                 # Regression automation
│   │   │   ├── run_family_regression.py # Family regression runner
│   │   │   ├── core_comparison.py       # Core comparison tests
│   │   │   └── report_generator.py      # Report generation
│   │   └── results/                 # Regression results
│   ├── formal/                      # Formal verification
│   │   ├── properties/              # Formal properties
│   │   │   ├── common/              # Common properties
│   │   │   └── core-specific/       # Core-specific properties
│   │   ├── scripts/                 # Formal verification scripts
│   │   └── results/                 # Formal verification results
│   ├── coverage/                    # Coverage analysis
│   │   ├── family-wide/             # Family-wide coverage
│   │   ├── core-specific/           # Core-specific coverage
│   │   ├── cross-core/              # Cross-core coverage
│   │   └── reports/                 # Coverage reports
│   └── tools/                       # Verification tools
│       ├── test-generators/         # Test generators
│       ├── coverage-tools/          # Coverage analysis tools
│       └── comparison-tools/        # Core comparison tools
│
├── physical-design/                 # Physical implementation
│   ├── family-configs/              # Family-wide configurations
│   │   ├── common/                  # Common configurations
│   │   │   ├── constraints/         # Common constraints
│   │   │   ├── scripts/             # Common scripts
│   │   │   └── flows/               # Common flows
│   │   ├── technology/              # Technology-specific configs
│   │   │   ├── skywater130/         # SkyWater 130nm configs
│   │   │   ├── tsmc28/              # TSMC 28nm configs
│   │   │   └── generic/             # Generic technology configs
│   │   └── targets/                 # Target-specific configs
│   │       ├── fpga/                # FPGA target configs
│   │       ├── asic/                # ASIC target configs
│   │       └── emulation/           # Emulation configs
│   ├── core-implementations/        # Core-specific implementations
│   │   ├── ZeroNyte/                # ZeroNyte implementations
│   │   │   ├── rv32i/               # RV32I implementation results
│   │   │   │   ├── synthesis/       # Synthesis results
│   │   │   │   ├── place-route/     # Place and route results
│   │   │   │   └── outputs/         # Final outputs
│   │   │   ├── rv64i/               # RV64I implementation results
│   │   │   └── comparison/          # RV32I vs RV64I comparison
│   │   ├── PipeNyte/                # PipeNyte implementations
│   │   │   ├── rv32i/               # RV32I implementation results
│   │   │   ├── rv64i/               # RV64I implementation results
│   │   │   └── comparison/          # RV32I vs RV64I comparison
│   │   ├── TetraNyte/               # TetraNyte implementations
│   │   │   ├── rv32i/               # RV32I implementation results
│   │   │   ├── rv64i/               # RV64I implementation results
│   │   │   └── comparison/          # RV32I vs RV64I comparison
│   │   └── OctoNyte/                # OctoNyte implementations
│   │       ├── rv32i/               # RV32I implementation results
│   │       ├── rv64i/               # RV64I implementation results
│   │       └── comparison/          # RV32I vs RV64I comparison
│   ├── shared-blocks/               # Shared physical blocks
│   │   ├── memory-compilers/        # Memory compiler outputs
│   │   ├── standard-cells/          # Standard cell libraries
│   │   └── io-pads/                 # I/O pad libraries
│   ├── integration/                 # Multi-core integration
│   │   ├── dual-core/               # Dual-core configurations
│   │   ├── quad-core/               # Quad-core configurations
│   │   └── custom/                  # Custom configurations
│   ├── scripts/                     # Physical design scripts
│   │   ├── synthesis/               # Synthesis scripts
│   │   ├── place-route/             # Place and route scripts
│   │   ├── verification/            # Physical verification scripts
│   │   └── analysis/                # Analysis scripts
│   └── pdks/                        # Process Design Kits (submodule)
│       └── skywater-pdk/            # SkyWater PDK (Git submodule)
│
└── tools/                           # External tools and dependencies
    ├── riscv-toolchain/             # RISC-V GNU toolchain (submodule)
    ├── riscv-spike/                 # RISC-V ISA simulator (submodule)
    ├── family-tools/                # KryptoNyte family-specific tools
    │   ├── core-selector/           # Core selection tool
    │   ├── config-generator/        # Configuration generator
    │   ├── performance-analyzer/    # Performance analysis tool
    │   └── comparison-tool/         # Core comparison tool
    ├── scripts/                     # Tool management scripts
    │   ├── install_tools.sh         # Tool installation script
    │   ├── setup_family_env.sh      # Family environment setup
    │   └── core_tools.py            # Core-specific tool management
    ├── docker/                      # Docker configurations
    │   ├── family-dev/              # Family development container
    │   ├── core-specific/           # Core-specific containers
    │   └── ci-cd/                   # CI/CD containers
    ├── ci-cd/                       # CI/CD pipeline tools
    │   ├── github-actions/          # GitHub Actions workflows
    │   │   ├── family-ci.yml        # Family-wide CI
    │   │   ├── core-ci.yml          # Core-specific CI
    │   │   └── cross-core-ci.yml    # Cross-core CI
    │   ├── scripts/                 # CI/CD scripts
    │   └── configs/                 # Pipeline configurations
    └── utilities/                   # General utility tools
        ├── family-utils/            # Family-specific utilities
        ├── core-utils/              # Core-specific utilities
        └── analysis-utils/          # Analysis utilities
```


## Directory Structure Explanation

### Top-Level Organization

The KryptoNyte repository is organized as a **monorepo** containing all four processor families with their RV32I and RV64I variants. This structure provides several key advantages:

- **Unified Development**: All cores share common infrastructure and tools
- **Cross-Core Verification**: Easy comparison and compatibility testing between cores
- **Shared Components**: Efficient reuse of common RTL, verification, and documentation
- **Coordinated Releases**: Family-wide version control and release management

### Core Family Structure (`rtl/`)

Each processor family follows a consistent three-level hierarchy:

#### Level 1: Processor Family
- `ZeroNyte/` - Simple fetch-execute architecture
- `PipeNyte/` - 4-stage pipelined architecture  
- `TetraNyte/` - 4-threaded architecture
- `OctoNyte/` - 8-stage, 8-threaded architecture

#### Level 2: ISA Variant
- `rv32i/` - 32-bit RISC-V implementation
- `rv64i/` - 64-bit RISC-V implementation
- `shared/` - Components shared between ISA variants

#### Level 3: Implementation Areas
- `rtl/` - RTL source code and generation
- `verification/` - Comprehensive verification environment
- `docs/` - Core-specific documentation
- `configs/` - Configuration files

### RTL Organization (`rtl/`)

The RTL structure reflects the **Chisel-first** development approach:

#### Chisel Source (`rtl/chisel/`)
- **Single Source of Truth**: All RTL originates from Chisel implementations
- **Scala Organization**: Standard SBT project structure with `src/main/scala/` and `src/test/scala/`
- **Generated Artifacts**: Verilog generation in `generated/verilog/` directory
- **Build System**: SBT configuration with automated Verilog generation

#### Architecture-Specific Modules
Each processor has tailored module organization:

**ZeroNyte**: Simple modules (fetch, decode, execute, regfile, alu)
**PipeNyte**: Pipeline stages plus hazard detection logic
**TetraNyte**: Threading components (scheduler, context, arbiter) with no hazard logic
**OctoNyte**: Advanced threading plus deep pipeline stages (8 stages, 8 threads)

#### Generated Verilog (`rtl/chisel/generated/`)
- **Build Artifacts**: Generated Verilog is treated as build output, not source
- **FIRRTL Intermediate**: Preserves FIRRTL files for debugging and analysis
- **Annotations**: Chisel annotations for synthesis and verification tools

### Verification Strategy (`verification/`)

The verification environment supports the **dual HDL approach** with comprehensive cross-verification:

#### Chisel-Native Testing (`chisel-tests/`)
- **ChiselTest Framework**: Scala-based unit and integration testing
- **Formal Verification**: Chisel-native formal properties and proofs
- **Performance Testing**: Benchmark and throughput analysis in Chisel

#### SystemVerilog Testing (`systemverilog-tests/`)
- **Hand-Written Tests**: SystemVerilog testbenches for generated Verilog
- **Industry Standards**: UVM methodology and SVA assertions
- **System-Level Testing**: Complex scenarios and performance validation

#### Cross-Verification (`cross-verification/`)
- **Equivalence Checking**: Verify Chisel behavior matches generated Verilog
- **Co-Simulation**: Mixed Chisel/SystemVerilog testbenches
- **Validation**: Comprehensive validation of generated RTL

#### Architecture-Specific Verification
**ZeroNyte**: Basic instruction execution and sequential operation
**PipeNyte**: Pipeline correctness and stall-on-hazard logic
**TetraNyte**: Thread scheduling and context switching (no hazard verification)
**OctoNyte**: Advanced threading and deep pipeline verification

### Shared Components (`shared/`)

The shared directory provides family-wide reusable components:

#### RTL Components (`shared/rtl/`)
- **Interfaces**: Standard bus protocols (AXI, AHB, Wishbone)
- **Utilities**: FIFOs, arbiters, multiplexers, counters
- **Peripherals**: UART, GPIO, SPI, I2C, timers, interrupt controllers
- **Memory**: SRAM/ROM models and memory controllers
- **Debug**: JTAG interface, trace infrastructure, debug monitors

#### Verification Infrastructure (`shared/verification/`)
- **Protocol Agents**: Reusable verification agents for standard interfaces
- **Monitors and Checkers**: Protocol compliance and assertion libraries
- **Utilities**: Common verification functions and test generators

### Documentation Structure (`docs/`)

Comprehensive documentation organized by audience and purpose:

#### Family Overview (`family-overview/`)
- **Core Comparison**: Feature matrix and selection guidance
- **Architecture**: High-level family architecture and design philosophy
- **Roadmap**: Development timeline and future enhancements

#### Technical Specifications (`specifications/`)
- **ISA Compliance**: RISC-V standard compliance documentation
- **Interfaces**: Detailed interface specifications and protocols
- **Memory Model**: Memory consistency and cache coherence specifications

#### User Guides (`user-guides/`)
- **Getting Started**: Quick start guides for each core
- **Integration**: How to integrate cores into larger systems
- **Programming**: Software development guides and examples

### Physical Design (`physical-design/`)

Complete physical implementation flow supporting multiple technologies:

#### Technology Support
- **SkyWater 130nm**: Open-source PDK integration
- **Commercial PDKs**: TSMC and other commercial process support
- **FPGA Targets**: Xilinx and Intel FPGA implementations

#### Implementation Results
- **Per-Core Results**: Synthesis, place-and-route results for each core/ISA combination
- **Comparison Data**: Area, power, and timing comparisons across the family
- **Integration Examples**: Multi-core system implementations

### Tool Integration (`tools/`)

External tool management and family-specific utilities:

#### External Dependencies (Submodules)
- **RISC-V Toolchain**: GNU compiler toolchain for software development
- **Spike Simulator**: Reference RISC-V ISA simulator for golden model comparison
- **SkyWater PDK**: Open-source process design kit

#### Family-Specific Tools
- **Core Selector**: Interactive tool for choosing the right core
- **Configuration Generator**: Automated configuration file generation
- **Performance Analyzer**: Cross-core performance analysis and comparison

### Verification Hierarchy (`verification/`)

Family-wide verification strategy with multiple levels:

#### Conformance Testing (`conformance/`)
- **Official Tests**: RISC-V architecture test suite compliance
- **Custom Tests**: KryptoNyte-specific conformance validation
- **Threading Tests**: Multi-threading compliance verification

#### Cross-Core Verification (`cross-core/`)
- **Compatibility**: Ensure software compatibility across cores
- **Migration**: Validate code portability between architectures
- **Performance**: Comparative performance analysis

#### System-Level Testing (`system-level/`)
- **Multi-Core Systems**: Integration testing for multi-core configurations
- **SoC Integration**: System-on-chip level verification
- **Platform Testing**: Complete platform and OS-level testing

### Build and Development Workflow

#### Chisel Development Flow
1. **Edit Chisel Source**: Modify Scala source files in `rtl/chisel/src/`
2. **Run Chisel Tests**: Execute `sbt test` for unit testing
3. **Generate Verilog**: Use `sbt run` to generate Verilog output
4. **Validate Generated RTL**: Lint and syntax check generated Verilog
5. **Run SystemVerilog Tests**: Execute system-level verification
6. **Cross-Verify**: Compare Chisel simulation with generated Verilog

#### Family-Wide Integration
1. **Core Development**: Individual core development and testing
2. **Cross-Core Testing**: Compatibility and migration testing
3. **System Integration**: Multi-core system assembly and testing
4. **Physical Implementation**: Synthesis and place-and-route
5. **Family Release**: Coordinated release with documentation

### Key Design Principles

#### Architectural Simplifications
- **No Hazard Logic in Multithreaded Cores**: TetraNyte and OctoNyte use threading to eliminate pipeline hazards
- **Stall-on-Hazard for PipeNyte**: Simple educational approach with pipeline stalls
- **Chisel-Generated Verilog Only**: Single source of truth eliminates hand-coded Verilog maintenance

#### Verification Philosophy
- **Chisel-First Testing**: Primary verification in Chisel with comprehensive unit tests
- **SystemVerilog System Testing**: Complex scenarios and performance validation
- **Cross-Verification**: Ensure Chisel and generated Verilog equivalence
- **Family-Wide Regression**: Coordinated testing across all cores

#### Scalability and Maintenance
- **Parameterized Components**: Shared components scale across 32-bit and 64-bit variants
- **Consistent Structure**: Uniform organization enables easy navigation and maintenance
- **Automated Generation**: Minimize manual maintenance through code generation
- **Comprehensive Documentation**: Self-documenting structure with embedded explanations

This directory structure supports the KryptoNyte family from initial development through production deployment, providing a professional foundation for RISC-V processor development, research, and education.