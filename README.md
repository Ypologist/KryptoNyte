# KryptoNyte RISC-V Processor Family

The KryptoNyte family is a comprehensive collection of RISC-V processor implementations designed for education, research, and practical applications. The family consists of four distinct processor architectures, each available in both RV32I and RV64I variants:

- **ZeroNyte**: Simple fetch-execute architecture for educational purposes
- **PipeNyte**: 4-stage pipelined architecture with stall-on-hazard
- **TetraNyte**: 4-threaded architecture eliminating pipeline hazards through threading
- **OctoNyte**: 8-stage, 8-threaded high-performance architecture

All processor cores are implemented in Chisel and generate Verilog for synthesis and simulation. The repository follows a monorepo approach with shared components and comprehensive verification infrastructure.

# Installation

See [INSTALL.md](INSTALL.md) for the full fresh-clone setup, including Docker/devcontainer usage and native Ubuntu/WSL installation.

## Github Codespace

Create a normal github codespace. By default, sbt and gcc are installed.

## Ubuntu 24.04 including WSL

1. OS prerequisites: sudo .devcontainer/00_install_ubuntu_packages.sh
2. Basic SBT/Scala tools: .devcontainer/install_sbt_and_gcc.sh
3. RTL tools: .devcontainer/install_rtl_tools.sh
4. RISCV compiler toolchain: .devcontainer/install_riscv_compiler_tools.sh
5. Conformance tests: .devcontainer/install_riscv_conformance_tests.sh
6. Physical design: .devcontainer/install_physical_design_tools.sh

The install scripts place repo-owned tools under `.venv`. Source `.devcontainer/dev_env.sh`
in the current shell to use the installed tools immediately.


## Building and Testing ZeroNyte

To build a fresh repository, generate the Verilog RTL, run the test suite, and execute physical design:

1. **Compile the Chisel RTL**
   ```bash
   cd rtl
   sbt compile
   ```
2. **Generate the Verilog Library and Core**
   ```bash
   sbt genLibrary genZeroNyte
   ```
3. **Run Unit Tests and Architecture Conformance Tests**
   ```bash
   sbt test
   cd ../tests
   ./run_rv32i_conformance.sh --processor zeronyte
   ```
4. **Run Physical Design (OpenLane)**
   ```bash
   cd ../physical_design
   ./generate_physical_design.sh --config config.ZeroNyteRV32ICore.json
   ```

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
