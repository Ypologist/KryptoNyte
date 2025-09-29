# Native RISC-V Toolchain Builder

## Overview

The `install_native_riscv_toolchain.sh` script builds a complete RISC-V development environment from source, ensuring full compatibility with the current system's GLIBC version. This solves the compatibility issues encountered with pre-built toolchains that require newer GLIBC versions.

## What It Builds

### 1. RISC-V GNU Toolchain
- **GCC**: Cross-compiler for RISC-V targets
- **Binutils**: Assembler, linker, and other binary utilities
- **Newlib**: C library for embedded systems
- **GDB**: Debugger (optional)
- **Multilib Support**: Both RV32 and RV64 architectures

### 2. Spike RISC-V ISA Simulator
- Reference implementation of RISC-V ISA
- Supports all standard RISC-V extensions
- Used for conformance testing and simulation

### 3. RISC-V Proxy Kernel (PK)
- Minimal kernel for running RISC-V programs
- Provides system call interface
- Essential for running tests on Spike

## Usage

### Basic Build (Recommended)
```bash
cd /path/to/KryptoNyte
.devcontainer/install_native_riscv_toolchain.sh --with-sudo
```

### Custom Installation Directory
```bash
.devcontainer/install_native_riscv_toolchain.sh --with-sudo --prefix /usr/local/riscv
```

### Rebuild Everything
```bash
.devcontainer/install_native_riscv_toolchain.sh --with-sudo --upgrade --clean
```

### Build Only Specific Components
```bash
# Build only toolchain
.devcontainer/install_native_riscv_toolchain.sh --with-sudo --no-spike --no-pk

# Build only Spike and PK (requires existing toolchain)
.devcontainer/install_native_riscv_toolchain.sh --with-sudo --no-toolchain
```

## Build Requirements

### System Requirements
- **OS**: Ubuntu 22.04 or later (tested)
- **RAM**: 4GB minimum, 8GB recommended
- **Disk Space**: 5GB for build, 2GB for installation
- **CPU**: Multi-core recommended (build uses all available cores)

### Dependencies
The script automatically installs required dependencies when run with `--with-sudo`:

**Essential Build Tools**:
- build-essential, git, make, gcc, g++
- autoconf, automake, cmake, ninja-build
- pkg-config, curl, wget

**Toolchain Dependencies**:
- libmpc-dev, libmpfr-dev, libgmp-dev
- zlib1g-dev, libexpat1-dev, libglib2.0-dev
- libncurses-dev, libssl-dev

**Additional Utilities**:
- gawk, bison, flex, texinfo, gperf
- libtool, patchutils, bc, m4
- device-tree-compiler, python3

## Build Process

### Phase 1: RISC-V GNU Toolchain (20-40 minutes)
1. Clone riscv-gnu-toolchain repository
2. Update all submodules (GCC, Binutils, Newlib, etc.)
3. Configure with multilib support
4. Build cross-compiler and libraries
5. Install to specified prefix

### Phase 2: Spike Simulator (2-5 minutes)
1. Clone riscv-isa-sim repository
2. Configure build system
3. Compile Spike simulator
4. Install simulator binary

### Phase 3: Proxy Kernel (1-3 minutes)
1. Clone riscv-pk repository
2. Configure for cross-compilation
3. Build proxy kernel
4. Install PK binary

## Environment Setup

After successful build, the script creates `~/.riscv_native_env` with:

```bash
# Native RISC-V Toolchain Environment Variables
export RISCV="/opt/riscv"
export RISCV_TOOLCHAIN_ROOT="/opt/riscv"
export PATH="/opt/riscv/bin:$PATH"
export RISCV_PREFIX="riscv64-unknown-elf-"
export SPIKE_ROOT="/opt/riscv"
export PK_ROOT="/opt/riscv"
```

### Loading Environment
```bash
# For current session
source ~/.riscv_native_env

# Automatically added to shell profile (.bashrc/.zshrc)
# Will be available in new terminal sessions
```

## Verification

After build completion, verify installation:

```bash
# Load environment
source ~/.riscv_native_env

# Test toolchain
riscv64-unknown-elf-gcc --version
riscv32-unknown-elf-gcc --version

# Test Spike
spike --help

# Test PK
ls -la $RISCV/bin/pk
```

## Integration with Conformance Tests

The native toolchain integrates seamlessly with the existing conformance test infrastructure:

1. **Update conformance script** to detect native toolchain
2. **Use native tools** instead of collab toolchain
3. **Run tests** with compatible environment

### Modified Conformance Test Usage
```bash
# Load native environment first
source ~/.riscv_native_env

# Run conformance tests
.devcontainer/install_riscv_conformance_tests.sh --with-sudo
```

## Troubleshooting

### Build Failures

**Insufficient Disk Space**:
- Ensure 5GB+ free space in build directory
- Use `--build-dir` to specify location with more space

**Missing Dependencies**:
- Run with `--with-sudo` to auto-install dependencies
- Manually install missing packages if needed

**Network Issues**:
- Ensure internet connectivity for git clones
- Check firewall/proxy settings

**Memory Issues**:
- Reduce parallel jobs: `--jobs 2`
- Close other applications during build

### Runtime Issues

**Command Not Found**:
- Ensure environment is loaded: `source ~/.riscv_native_env`
- Check PATH includes `/opt/riscv/bin`

**Permission Errors**:
- Verify ownership of installation directory
- Use `--with-sudo` for system-wide installation

## Performance Notes

### Build Time Estimates
- **Full Build**: 30-60 minutes (depending on CPU)
- **Toolchain Only**: 20-40 minutes
- **Spike + PK Only**: 5-10 minutes

### Optimization Tips
- Use SSD for build directory
- Maximize parallel jobs (default uses all CPU cores)
- Ensure adequate RAM (8GB+ recommended)

## Advantages Over Pre-built Toolchains

1. **GLIBC Compatibility**: Built against system GLIBC version
2. **Customization**: Configure build options as needed
3. **Latest Features**: Use latest upstream versions
4. **No Dependencies**: Self-contained installation
5. **Debugging**: Full debug symbols available

## File Locations

After installation:
- **Toolchain**: `/opt/riscv/bin/riscv*-gcc`
- **Spike**: `/opt/riscv/bin/spike`
- **Proxy Kernel**: `/opt/riscv/bin/pk`
- **Environment**: `~/.riscv_native_env`
- **Build Logs**: `/tmp/riscv-build/` (if not cleaned)

## Maintenance

### Updates
```bash
# Rebuild with latest versions
.devcontainer/install_native_riscv_toolchain.sh --with-sudo --upgrade --clean
```

### Cleanup
```bash
# Remove build directory
rm -rf /tmp/riscv-build

# Remove installation (if needed)
sudo rm -rf /opt/riscv
```

This native build approach ensures a fully compatible RISC-V development environment for KryptoNyte processor development and conformance testing.
