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

### Common Options (All Scripts)
```bash
--with-sudo              # Use sudo for system-level installations
--quiet                  # Reduce output verbosity
--upgrade                # Force upgrade/reinstall existing tools
--help, -h               # Show detailed help information
```

