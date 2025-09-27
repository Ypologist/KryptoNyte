# KryptoNyte Development Environment Installation Guide

## Overview

The KryptoNyte RISC-V processor development environment consists of modular installation scripts that provide comprehensive toolchain setup with intelligent tool detection and upgrade capabilities.

## Installation Scripts

### 📦 **Basic Development Tools**
- **`install_sbt_and_gcc.sh`** - GCC 14 compiler and SDKMAN with Java/Scala/SBT
- **`install_rtl_tools.sh`** - RTL development tools (Verilator, FIRRTL, OSS-CAD Suite)

### 🔧 **RISC-V Toolchain**
- **`install_riscv_compiler_tools.sh`** - Prebuilt RISC-V cross-compilers (32-bit & 64-bit)

### 🏗️ **Physical Design Tools**
- **`install_physical_design_tools.sh`** - SkyWater PDK, Magic VLSI, Open PDK, OpenROAD

### 🧪 **Testing & Verification**
- **`install_riscv_conformance_tests.sh`** - UV Python, Spike simulator, RISC-V conformance tests

## Key Features

### 🔍 **Intelligent Tool Detection**
All scripts automatically detect existing installations and provide clear status:
```bash
Tool Detection Summary:
  🔧 GCC 14: Found
  ☕ SDKMAN Tools: Found
  🛠️ Verilator: Not Found
  🔧 RISC-V 32-bit: Found
  🔧 RISC-V 64-bit: Not Found
```

### 🔄 **Upgrade Control**
- **Default behavior**: Skip tools that are already installed
- **`--upgrade` flag**: Force reinstallation of existing tools
- **Selective installation**: Install only what's missing

### 🎯 **Environment Detection**
- **GitHub Codespace**: Automatic detection and optimization
- **Standalone Environment**: Local development setup
- **Container Support**: Works in Docker and devcontainer environments

## Quick Start

### 1. Basic Development Setup
```bash
# Install GCC 14 and SDKMAN tools (Java 23, Scala 2.13, SBT)
.devcontainer/install_sbt_and_gcc.sh --with-sudo

# Install RTL development tools
.devcontainer/install_rtl_tools.sh --with-sudo
```

### 2. RISC-V Cross-Compilation
```bash
# Install prebuilt RISC-V toolchain
.devcontainer/install_riscv_compiler_tools.sh --with-sudo
```

### 3. Physical Design Flow
```bash
# Install ASIC design tools
.devcontainer/install_physical_design_tools.sh --with-sudo
```

### 4. Testing & Verification
```bash
# Install conformance testing environment
.devcontainer/install_riscv_conformance_tests.sh --with-sudo
```

## Detailed Installation Options

### Common Options (All Scripts)
```bash
--with-sudo              # Use sudo for system-level installations
--quiet                  # Reduce output verbosity
--upgrade                # Force upgrade/reinstall existing tools
--help, -h               # Show detailed help information
```

### Script-Specific Options

#### install_sbt_and_gcc.sh
```bash
# Basic installation
./install_sbt_and_gcc.sh --with-sudo

# Force upgrade existing tools
./install_sbt_and_gcc.sh --with-sudo --upgrade

# Quiet installation for automation
./install_sbt_and_gcc.sh --with-sudo --quiet
```

#### install_rtl_tools.sh
```bash
# Full RTL toolchain
./install_rtl_tools.sh --with-sudo

# Skip specific tools
./install_rtl_tools.sh --with-sudo --no-verilator --no-oss-cad

# Custom installation directory
./install_rtl_tools.sh --with-sudo --install-dir /home/user/rtl-tools
```

#### install_riscv_compiler_tools.sh
```bash
# Default installation
./install_riscv_compiler_tools.sh --with-sudo

# Custom directory and version
./install_riscv_compiler_tools.sh --with-sudo \
  --install-dir /opt/riscv-custom \
  --version 2025.08.08

# Force upgrade existing toolchain
./install_riscv_compiler_tools.sh --with-sudo --upgrade
```

#### install_physical_design_tools.sh
```bash
# Complete ASIC design environment
./install_physical_design_tools.sh --with-sudo

# Custom PDK installation directory
./install_physical_design_tools.sh --with-sudo \
  --install-dir /home/user/pdk

# Skip specific tools
./install_physical_design_tools.sh --with-sudo --no-openroad
```

#### install_riscv_conformance_tests.sh
```bash
# Full testing environment
./install_riscv_conformance_tests.sh --with-sudo

# Skip specific components
./install_riscv_conformance_tests.sh --with-sudo \
  --no-spike --no-pk

# Custom test suite version
./install_riscv_conformance_tests.sh --with-sudo \
  --arch-test-version main \
  --spike-version master
```

## Installation Workflows

### Complete Development Environment
```bash
# 1. Basic tools (required for all development)
.devcontainer/install_sbt_and_gcc.sh --with-sudo

# 2. RTL development tools
.devcontainer/install_rtl_tools.sh --with-sudo

# 3. RISC-V cross-compilation
.devcontainer/install_riscv_compiler_tools.sh --with-sudo

# 4. Physical design (for ASIC development)
.devcontainer/install_physical_design_tools.sh --with-sudo

# 5. Testing and verification
.devcontainer/install_riscv_conformance_tests.sh --with-sudo
```

### Minimal RTL Development
```bash
# Essential tools only
.devcontainer/install_sbt_and_gcc.sh --with-sudo
.devcontainer/install_rtl_tools.sh --with-sudo --no-oss-cad
```

### ASIC Design Focus
```bash
# Tools for physical implementation
.devcontainer/install_sbt_and_gcc.sh --with-sudo
.devcontainer/install_rtl_tools.sh --with-sudo
.devcontainer/install_physical_design_tools.sh --with-sudo
```

### Verification & Testing Focus
```bash
# Tools for processor verification
.devcontainer/install_sbt_and_gcc.sh --with-sudo
.devcontainer/install_riscv_compiler_tools.sh --with-sudo
.devcontainer/install_riscv_conformance_tests.sh --with-sudo
```

## Tool Verification

After installation, verify your environment:

### Basic Tools
```bash
# Check GCC
gcc --version

# Check SDKMAN tools
source ~/.sdkman/bin/sdkman-init.sh
java --version
scala --version
sbt --version
```

### RTL Tools
```bash
# Check Verilator
verilator --version

# Check FIRRTL
firtool --version

# Check Yosys (OSS-CAD Suite)
yosys -V
```

### RISC-V Toolchain
```bash
# Check cross-compilers
riscv32-unknown-elf-gcc --version
riscv64-unknown-elf-gcc --version
```

### Physical Design Tools
```bash
# Check Magic VLSI
magic -version

# Check OpenROAD
openroad -version

# Check SkyWater PDK
ls $SKYWATER_PDK_ROOT
```

### Testing Tools
```bash
# Load conformance test environment
source ~/.riscv_conformance_env

# Check UV Python
uv --version

# Check Spike simulator
spike --help

# Check test framework
python3 -c "import riscv_ctg; print('RISC-V test framework ready')"
```

## Environment Variables

After installation, these environment variables are configured:

### RTL Development
```bash
export VERILATOR_ROOT="/usr/local/share/verilator"
export OSS_CAD_SUITE_ROOT="/opt/oss-cad-suite"
export PATH="$OSS_CAD_SUITE_ROOT/bin:$PATH"
```

### RISC-V Toolchain
```bash
export PATH="/opt/riscv/collab/bin:$PATH"
```

### Physical Design
```bash
export SKYWATER_PDK_ROOT="/opt/skywater-pdk"
export MAGIC_ROOT="/opt/magic"
export OPENROAD_ROOT="/opt/openroad"
export PATH="$MAGIC_ROOT/bin:$OPENROAD_ROOT/bin:$PATH"
```

### Testing Environment
```bash
export RISCV_CONFORMANCE_ROOT="/opt/riscv-conformance"
export RISCV_ARCH_TEST_ROOT="$RISCV_CONFORMANCE_ROOT/riscv-arch-test"
export SPIKE_ROOT="$RISCV_CONFORMANCE_ROOT/spike"
export PATH="$SPIKE_ROOT/bin:$HOME/.cargo/bin:$PATH"
```

## Flexible RTL Generator Setup

### Repository Structure
```
KryptoNyte/
├── cores/                           
│   ├── build.sbt                   # ← Multi-project sbt configuration
│   ├── generators/                 # ← RTL generation scripts
│   │   ├── GenerateHierarchicalRTL.scala
│   │   └── GeneratePhysicalDesign.scala
│   ├── generated/                  # ← Generated RTL output
│   │   ├── firrtl/
│   │   ├── systemverilog_hierarchical/
│   │   ├── verilog_hierarchical/
│   │   └── annotations/
│   ├── physical_design/            # ← Physical design output
│   │   ├── synthesis/
│   │   ├── placement/
│   │   ├── routing/
│   │   └── gds/
│   ├── ZeroNyte/                   # ← Core implementations
│   └── library/                    # ← Shared modules
```

### Generator Installation
```bash
cd KryptoNyte/cores

# Create generators directory
mkdir -p generators

# Copy generator scripts (provided separately)
cp /path/to/GenerateHierarchicalRTL.scala generators/
cp /path/to/GeneratePhysicalDesign.scala generators/

# Update build.sbt (provided separately)
cp /path/to/updated_build.sbt build.sbt
```

### Generator Usage
```bash
# From KryptoNyte/cores directory

# Generate hierarchical RTL
sbt "generators/runMain generators.GenerateHierarchicalRTL"

# Generate with custom settings
sbt "generators/runMain generators.GenerateHierarchicalRTL --core-family ZeroNyte --optimize-asic"

# Run physical design flow
sbt "generators/runMain generators.GeneratePhysicalDesign --module-name ZeroNyteRV32ICore"

# Use predefined aliases (after build.sbt update)
sbt genZeroNyte
sbt physicalZeroNyte
sbt completeZeroNyte
```

## Troubleshooting

### Common Issues

#### Permission Errors
```bash
# Solution: Use --with-sudo flag
./install_script.sh --with-sudo
```

#### Tool Not Found After Installation
```bash
# Solution: Reload environment
source ~/.bashrc
# or start a new terminal session
```

#### SDKMAN Not Detected
```bash
# Check if directory exists
ls ~/.sdkman/
# If exists, the script should detect it correctly
```

#### Build Dependencies Missing
```bash
# Solution: Install with sudo to get all dependencies
./install_script.sh --with-sudo
```

#### Network Issues During Download
```bash
# Check connectivity and retry
wget --spider https://github.com
./install_script.sh --with-sudo
```

### Debug Commands

#### Check Tool Detection
```bash
# Test detection without installation
echo "n" | ./install_script.sh --quiet
```

#### Verify Environment
```bash
# Check PATH
echo $PATH

# Check environment files
cat ~/.bashrc | grep -A5 -B5 "KryptoNyte"
```

#### Test Individual Tools
```bash
# Test each tool individually
command -v gcc && echo "GCC found"
command -v verilator && echo "Verilator found"
command -v riscv32-unknown-elf-gcc && echo "RISC-V 32-bit found"
```

## Advanced Configuration

### Custom Installation Directories
```bash
# Use custom paths for all tools
export CUSTOM_INSTALL_ROOT="/home/user/kryptonyte-tools"

./install_rtl_tools.sh --with-sudo --install-dir "$CUSTOM_INSTALL_ROOT/rtl"
./install_physical_design_tools.sh --with-sudo --install-dir "$CUSTOM_INSTALL_ROOT/pdk"
```

### Automated Installation
```bash
#!/bin/bash
# automated_setup.sh

set -e  # Exit on any error

echo "Installing KryptoNyte development environment..."

# Install all tools with minimal interaction
.devcontainer/install_sbt_and_gcc.sh --with-sudo --quiet
.devcontainer/install_rtl_tools.sh --with-sudo --quiet
.devcontainer/install_riscv_compiler_tools.sh --with-sudo --quiet
.devcontainer/install_physical_design_tools.sh --with-sudo --quiet
.devcontainer/install_riscv_conformance_tests.sh --with-sudo --quiet

echo "Installation complete! Please restart your terminal."
```

### Container Integration
```dockerfile
# Dockerfile example
FROM ubuntu:24.04

# Copy installation scripts
COPY .devcontainer/ /opt/kryptonyte-install/

# Run installations
RUN /opt/kryptonyte-install/install_sbt_and_gcc.sh --with-sudo --quiet
RUN /opt/kryptonyte-install/install_rtl_tools.sh --with-sudo --quiet

# Set environment
ENV PATH="/opt/riscv/collab/bin:$PATH"
```

## Next Steps

1. **Choose your workflow** based on development focus
2. **Run the appropriate installation scripts** with `--with-sudo`
3. **Verify the installation** using the verification commands
4. **Set up the RTL generators** if doing RTL development
5. **Begin developing** KryptoNyte processor cores!

The modular installation system ensures you only install what you need while maintaining the flexibility to add more tools as your project grows.
