# KryptoNyte RISC-V Processor Family

The KryptoNyte family is a comprehensive collection of RISC-V processor implementations designed for education, research, and practical applications. The family consists of four distinct processor architectures, each available in both RV32I and RV64I variants:

- **ZeroNyte**: Simple fetch-execute architecture for educational purposes
- **PipeNyte**: 4-stage pipelined architecture with stall-on-hazard
- **TetraNyte**: 4-threaded architecture eliminating pipeline hazards through threading
- **OctoNyte**: 8-stage, 8-threaded high-performance architecture

All processor cores are implemented in Chisel and generate Verilog for synthesis and simulation. The repository follows a monorepo approach with shared components and comprehensive verification infrastructure.

# Installation

## Github Codespace

Create a normal github codespace. By default, sbt and gcc are installed.

## Ubuntu 24.04 including WSL

1. RTL Tools: .devcontainer/install_rtl_tools.sh --with-sudo
2. RISCV Compiler Toolchain: .devcontainer/install_riscv_compiler_tools.sh --with-sudo
3. Conformance Tests: .devcontainer/install_riscv_conformance_tests.sh --with-sudo
4. Physical Design: .devcontainer/install_physical_design_tools.sh --with-sudo


# KryptoNyte Directory Tree

## First Level
```
KryptoNyte/
├── .devcontainer/                    # GitHub Codespaces configuration
├── rtl/                             # Individual processor families
├── docs/                            # Family-wide documentation
├── tests/                           # Family-wide verification
├── physical_design/                 # Physical implementation
```

