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

