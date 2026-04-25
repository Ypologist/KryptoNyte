#!/bin/bash

#######################################
# RISC-V Compiler Package, Spike, and PK Installer
# For KryptoNyte RISC-V Processor Family
# Uses Ubuntu's prebuilt RISC-V compiler and builds Spike/PK locally
#######################################

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
source "$SCRIPT_DIR/common_install.sh"

# Script configuration
VERBOSE=true
UPGRADE_MODE=false
INSTALL_PREFIX="$KRYPTONYTE_TOOLS_DIR/riscv"
BUILD_DIR="$KRYPTONYTE_VENV/build/riscv"
JOBS=$(nproc)

# Component versions
SPIKE_VERSION="master"
PK_VERSION="master"

# Installation/build configuration
BUILD_TOOLCHAIN=true
BUILD_SPIKE=true
BUILD_PK=true
CLEAN_BUILD=false

# Installation status tracking
TOOLCHAIN_AVAILABLE=false
SPIKE_BUILT=false
PK_BUILT=false

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --quiet)
            VERBOSE=false
            shift
            ;;
        --upgrade)
            UPGRADE_MODE=true
            shift
            ;;
        --clean)
            CLEAN_BUILD=true
            shift
            ;;
        --prefix)
            INSTALL_PREFIX="$2"
            shift 2
            ;;
        --build-dir)
            BUILD_DIR="$2"
            shift 2
            ;;
        --jobs)
            JOBS="$2"
            shift 2
            ;;
        --toolchain-version)
            echo "Warning: --toolchain-version is ignored; the compiler is installed from Ubuntu packages." >&2
            shift 2
            ;;
        --spike-version)
            SPIKE_VERSION="$2"
            shift 2
            ;;
        --pk-version)
            PK_VERSION="$2"
            shift 2
            ;;
        --no-toolchain)
            BUILD_TOOLCHAIN=false
            shift
            ;;
        --no-spike)
            BUILD_SPIKE=false
            shift
            ;;
        --no-pk)
            BUILD_PK=false
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "RISC-V Compiler Package, Spike, and PK Installer for KryptoNyte"
            echo ""
            echo "Options:"
            echo "  --quiet                  Reduce output verbosity"
            echo "  --upgrade                Force rebuild of existing components"
            echo "  --clean                  Clean build directories before building"
            echo "  --prefix DIR             Installation prefix (default: $KRYPTONYTE_TOOLS_DIR/riscv)"
            echo "  --build-dir DIR          Build directory (default: $KRYPTONYTE_VENV/build/riscv)"
            echo "  --jobs N                 Number of parallel jobs (default: $(nproc))"
            echo "  --toolchain-version V    Ignored; compiler is installed from Ubuntu packages"
            echo "  --spike-version V        Spike simulator version (default: master)"
            echo "  --pk-version V           Proxy kernel version (default: master)"
            echo "  --no-toolchain           Skip compiler package installation/check"
            echo "  --no-spike               Skip Spike build"
            echo "  --no-pk                  Skip PK build"
            echo "  --help, -h               Show this help message"
            echo ""
            echo "This script installs/builds:"
            echo "  - Ubuntu RISC-V compiler packages (GCC, Binutils)"
            echo "  - Spike RISC-V ISA Simulator"
            echo "  - RISC-V Proxy Kernel (pk)"
            echo ""
            echo "Build time: usually 5-15 minutes depending on system performance"
            echo "Disk space required: compiler packages plus Spike/PK build output"
            echo ""
            echo "Examples:"
            echo "  Install compiler packages and build Spike/PK:"
            echo "    $0"
            echo ""
            echo "  Install Spike/PK with custom prefix:"
            echo "    $0 --prefix \$PWD/.venv/tools/riscv-custom"
            echo ""
            echo "  Rebuild Spike/PK:"
            echo "    $0 --upgrade --clean"
            echo ""
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Function to execute commands
run_cmd() {
    "$@"
}

# Function to print large banner messages
print_banner() {
    local message="$1"
    local color="$2"
    
    if [ "$VERBOSE" = true ]; then
        echo -e "\n${color}"
        echo "=================================================================="
        echo "  $message"
        echo "=================================================================="
        echo -e "${NC}"
    fi
}

# Function to print step messages
print_step() {
    local message="$1"
    local color="${2:-$CYAN}"
    
    if [ "$VERBOSE" = true ]; then
        echo -e "\n${color}▶ $message${NC}"
    fi
}

# Function to print success messages
print_success() {
    local message="$1"
    echo -e "${GREEN}✓ $message${NC}"
}

# Function to print error messages
print_error() {
    local message="$1"
    echo -e "${RED}✗ Error: $message${NC}" >&2
}

# Function to print warning messages
print_warning() {
    local message="$1"
    echo -e "${YELLOW}⚠ Warning: $message${NC}"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check system requirements
check_requirements() {
    print_step "Checking system requirements for RISC-V tools"
    
    # Verify critical build tools
    print_step "Verifying build environment"
    
    local missing_tools=()
    
    for tool in git make gcc g++ autoconf cmake python3; do
        if ! command_exists "$tool"; then
            missing_tools+=("$tool")
        fi
    done

    if [ "$BUILD_TOOLCHAIN" = true ] && ! command_exists apt-get; then
        missing_tools+=("apt-get")
    fi
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        print_error "Missing required tools: ${missing_tools[*]}"
        print_error "Install OS prerequisites with: sudo .devcontainer/00_install_ubuntu_packages.sh"
        exit 1
    fi
    
    # Check disk space (need ~5GB for build)
    local available_space
    available_space=$(df "$KRYPTONYTE_REPO_ROOT" 2>/dev/null | awk 'NR==2 {print $4}' || echo "0")
    if [ "$available_space" -lt 5000000 ]; then  # 5GB in KB
        print_warning "Low disk space detected. Build may fail if space runs out."
        print_warning "Recommended: At least 5GB free space in $BUILD_DIR"
    fi
    
    print_success "Tool environment verified"
}

apt_install_packages() {
    local packages=("$@")
    local apt_cmd=()

    if [ "${EUID:-$(id -u)}" -eq 0 ]; then
        apt_cmd=(apt-get)
    elif command_exists sudo; then
        apt_cmd=(sudo apt-get)
    else
        print_error "Installing compiler packages requires root or sudo."
        print_error "Run this script as root, or install manually: apt-get install ${packages[*]}"
        return 1
    fi

    print_step "Updating apt package lists"
    DEBIAN_FRONTEND=noninteractive "${apt_cmd[@]}" update -y

    print_step "Installing apt packages: ${packages[*]}"
    DEBIAN_FRONTEND=noninteractive "${apt_cmd[@]}" install -y "${packages[@]}"
}

find_riscv_gcc() {
    command -v riscv64-unknown-elf-gcc 2>/dev/null || true
}

find_riscv_tool() {
    local tool="$1"
    command -v "riscv64-unknown-elf-$tool" 2>/dev/null || true
}

riscv_toolchain_complete() {
    [ -n "$(find_riscv_gcc)" ] &&
        [ -n "$(find_riscv_tool g++)" ] &&
        [ -n "$(find_riscv_tool ar)" ] &&
        [ -n "$(find_riscv_tool ranlib)" ] &&
        [ -n "$(find_riscv_tool strip)" ]
}

# Function to setup build environment
setup_build_env() {
    print_step "Setting up build environment"
    ensure_local_venv
    
    # Create build directory
    if [ "$CLEAN_BUILD" = true ] || [ "$UPGRADE_MODE" = true ]; then
        print_step "Cleaning build directory"
        rm -rf "$BUILD_DIR"
    fi
    
    mkdir -p "$BUILD_DIR"
    cd "$BUILD_DIR"
    
    # Create install directory
    if [ "$UPGRADE_MODE" = true ]; then
        print_step "Upgrade mode: Cleaning installation directory"
        run_cmd rm -rf "$INSTALL_PREFIX"
    fi
    
    run_cmd mkdir -p "$INSTALL_PREFIX"
    
    # Set environment variables for build
    export PATH="$INSTALL_PREFIX/bin:$PATH"
    export RISCV="$INSTALL_PREFIX"
    
    print_success "Build environment ready"
    print_step "Build directory: $BUILD_DIR"
    print_step "Install prefix: $INSTALL_PREFIX"
    print_step "Parallel jobs: $JOBS"
}

# Function to install/check RISC-V compiler packages
install_toolchain() {
    if [ "$BUILD_TOOLCHAIN" = false ]; then
        print_step "Skipping RISC-V compiler package installation/check"
        return 0
    fi
    
    print_banner "Installing RISC-V Compiler Packages" "$BLUE"

    if riscv_toolchain_complete; then
        local version
        version=$(riscv64-unknown-elf-gcc --version | head -1)
        print_success "RISC-V compiler tools already available: $version"
        TOOLCHAIN_AVAILABLE=true
        return 0
    fi

    apt_install_packages gcc-riscv64-unknown-elf binutils-riscv64-unknown-elf

    if riscv_toolchain_complete; then
        local version
        version=$(riscv64-unknown-elf-gcc --version | head -1)
        print_success "RISC-V compiler tools installed: $version"
        TOOLCHAIN_AVAILABLE=true
    else
        print_error "RISC-V compiler package installation completed, but the expected tools are not in PATH"
        print_error "Expected riscv64-unknown-elf-{gcc,g++,ar,ranlib,strip}."
        return 1
    fi
}

# Function to build Spike simulator
build_spike() {
    if [ "$BUILD_SPIKE" = false ]; then
        print_step "Skipping Spike simulator build"
        return 0
    fi
    
    print_banner "Building Spike RISC-V ISA Simulator" "$YELLOW"
    
    local spike_dir="$BUILD_DIR/riscv-isa-sim"
    
    # Check if already built
    if [ "$UPGRADE_MODE" = false ] && [ -f "$INSTALL_PREFIX/bin/spike" ]; then
        print_success "Spike simulator already built - skipping"
        SPIKE_BUILT=true
        return 0
    fi
    
    print_step "Cloning Spike repository"
    if [ -d "$spike_dir" ]; then
        cd "$spike_dir"
        git fetch origin
        git checkout "$SPIKE_VERSION"
        git pull origin "$SPIKE_VERSION"
    else
        git clone --depth 1 --branch "$SPIKE_VERSION" \
            https://github.com/riscv-software-src/riscv-isa-sim.git "$spike_dir"
        cd "$spike_dir"
    fi
    
    print_step "Building Spike simulator"
    rm -rf build
    mkdir -p build
    cd build
    
    ../configure --prefix="$INSTALL_PREFIX"
    if make -j"$JOBS" && run_cmd make install; then
        SPIKE_BUILT=true
        print_success "Spike simulator built successfully"
        
        # Verify installation
        if [ -f "$INSTALL_PREFIX/bin/spike" ]; then
            print_success "Spike installed at: $INSTALL_PREFIX/bin/spike"
        fi
    else
        print_error "Spike simulator build failed"
        return 1
    fi
}

# Function to build proxy kernel
build_pk() {
    if [ "$BUILD_PK" = false ]; then
        print_step "Skipping proxy kernel build"
        return 0
    fi
    
    print_banner "Building RISC-V Proxy Kernel" "$GREEN"
    
    local pk_dir="$BUILD_DIR/riscv-pk"
    
    # Check if already built
    if [ "$UPGRADE_MODE" = false ] && [ -f "$INSTALL_PREFIX/bin/pk" ]; then
        print_success "Proxy kernel already built - skipping"
        PK_BUILT=true
        return 0
    fi
    
    # Ensure toolchain is available
    local riscv_gcc
    riscv_gcc="$(find_riscv_gcc)"
    if [ -z "$riscv_gcc" ]; then
        print_error "RISC-V compiler not found. Install gcc-riscv64-unknown-elf first."
        return 1
    fi
    
    print_step "Cloning proxy kernel repository"
    if [ -d "$pk_dir" ]; then
        cd "$pk_dir"
        git fetch origin
        git checkout "$PK_VERSION"
        git pull origin "$PK_VERSION"
    else
        git clone --depth 1 --branch "$PK_VERSION" \
            https://github.com/riscv-software-src/riscv-pk.git "$pk_dir"
        cd "$pk_dir"
    fi
    
    print_step "Building proxy kernel"
    
    # Clean any previous build attempts
    if [ "$UPGRADE_MODE" = true ] || [ -d "build" ]; then
        print_step "Cleaning previous PK build"
        rm -rf build
        make clean 2>/dev/null || true
        make distclean 2>/dev/null || true
    fi
    
    mkdir -p build
    cd build
    
    # Set up cross-compilation environment
    local riscv_gxx riscv_ar riscv_ranlib riscv_strip
    riscv_gxx="$(find_riscv_tool g++)"
    riscv_ar="$(find_riscv_tool ar)"
    riscv_ranlib="$(find_riscv_tool ranlib)"
    riscv_strip="$(find_riscv_tool strip)"

    if [ -z "$riscv_gxx" ] || [ -z "$riscv_ar" ] || [ -z "$riscv_ranlib" ] || [ -z "$riscv_strip" ]; then
        print_error "Incomplete RISC-V compiler tools in PATH."
        print_error "Expected riscv64-unknown-elf-{gcc,g++,ar,ranlib,strip}."
        return 1
    fi

    export CC="$riscv_gcc"
    export CXX="$riscv_gxx"
    export AR="$riscv_ar"
    export RANLIB="$riscv_ranlib"
    export STRIP="$riscv_strip"
    
    print_step "Using toolchain: $CC"
    
    # Configure and build with proper ISA extensions
    # Install directly into the selected repo-local RISC-V prefix.
    export CFLAGS="-march=rv64imac_zicsr_zifencei -mabi=lp64"
    export CXXFLAGS="-march=rv64imac_zicsr_zifencei -mabi=lp64"
    ../configure --prefix="$INSTALL_PREFIX" --host=riscv64-unknown-elf --with-arch=rv64imac_zicsr_zifencei
    if make -j"$JOBS" && run_cmd make install; then
        # Copy pk binary to main bin directory for consistency with Spike
        if [ -f "$INSTALL_PREFIX/riscv64-unknown-elf/bin/pk" ]; then
            print_step "Copying PK to main bin directory"
            run_cmd cp "$INSTALL_PREFIX/riscv64-unknown-elf/bin/pk" "$INSTALL_PREFIX/bin/pk"
            run_cmd cp "$INSTALL_PREFIX/riscv64-unknown-elf/bin/bbl" "$INSTALL_PREFIX/bin/bbl" 2>/dev/null || true
        fi
        
        PK_BUILT=true
        print_success "Proxy kernel built successfully"
        
        # Verify installation
        if [ -f "$INSTALL_PREFIX/bin/pk" ]; then
            print_success "Proxy kernel installed at: $INSTALL_PREFIX/bin/pk"
        else
            print_warning "PK built but not found at expected location"
        fi
    else
        print_error "Proxy kernel build failed"
        return 1
    fi
    
    # Reset environment variables
    unset CC CXX AR RANLIB STRIP
}

# Function to setup environment
setup_environment() {
    print_banner "Setting up environment" "$PURPLE"
    
    local env_file="$KRYPTONYTE_VENV/riscv_native_env"
    local toolchain_root="$INSTALL_PREFIX"
    if [ -n "$(find_riscv_gcc)" ]; then
        toolchain_root="$(dirname "$(dirname "$(find_riscv_gcc)")")"
    fi
    
    print_step "Creating environment configuration file"
    cat > "$env_file" << EOF
# RISC-V Compiler, Spike, and PK Environment Variables
# Source this file or add to your shell profile (.bashrc, .zshrc, etc.)

# KryptoNyte repo-local environment
source "$KRYPTONYTE_REPO_ROOT/.devcontainer/dev_env.sh"

# RISC-V Installation
export RISCV="$INSTALL_PREFIX"
export RISCV_TOOLCHAIN_ROOT="$toolchain_root"

# Add repo-local Spike/PK and packaged compiler tools to PATH
export PATH="$INSTALL_PREFIX/bin:\$RISCV_TOOLCHAIN_ROOT/bin:\$PATH"

# RISC-V specific environment
export RISCV_PREFIX="riscv64-unknown-elf-"

# Tool locations
export SPIKE_ROOT="$INSTALL_PREFIX"
export PK_ROOT="$INSTALL_PREFIX"

echo "RISC-V compiler, Spike, and PK environment loaded"
echo "Compiler root: \$RISCV_TOOLCHAIN_ROOT"
echo "Spike/PK root: $INSTALL_PREFIX"
EOF

    print_step "Environment file created at: $env_file"
    
    # Add to shell profile if possible
    local shell_profile=""
    if [ -n "${BASH_VERSION:-}" ]; then
        shell_profile="$HOME/.bashrc"
    elif [ -n "${ZSH_VERSION:-}" ]; then
        shell_profile="$HOME/.zshrc"
    fi
    
    if [ -n "$shell_profile" ] && [ -w "$shell_profile" ]; then
        if ! grep -q "riscv_native_env" "$shell_profile"; then
            print_step "Adding environment setup to $shell_profile"
            echo "" >> "$shell_profile"
            echo "# RISC-V Compiler, Spike, and PK Environment" >> "$shell_profile"
            echo "source $env_file" >> "$shell_profile"
            print_success "Environment setup added to shell profile"
        fi
    fi

    add_dev_env_to_shell_profile
    
    print_success "Environment configuration complete"
    
    echo -e "\n${CYAN}To use the RISC-V tools in your current session, run:${NC}"
    echo -e "${WHITE}source $env_file${NC}"
}

# Function to verify installation
verify_installation() {
    print_banner "Verifying installation" "$GREEN"
    
    local errors=0
    local warnings=0
    
    # Check toolchain
    if [ "$BUILD_TOOLCHAIN" = true ]; then
        if [ "$TOOLCHAIN_AVAILABLE" = true ] && [ -n "$(find_riscv_gcc)" ]; then
            print_success "RISC-V compiler package installed and available"
            local version
            version=$(riscv64-unknown-elf-gcc --version | head -1)
            print_step "Compiler: $version"
        else
            print_error "RISC-V compiler package installation/check failed"
            ((errors++))
        fi
    fi
    
    # Check Spike
    if [ "$BUILD_SPIKE" = true ]; then
        if [ "$SPIKE_BUILT" = true ] && [ -f "$INSTALL_PREFIX/bin/spike" ]; then
            print_success "Spike simulator built and installed successfully"
        else
            print_error "Spike simulator build failed"
            ((errors++))
        fi
    fi
    
    # Check PK
    if [ "$BUILD_PK" = true ]; then
        if [ "$PK_BUILT" = true ] && [ -f "$INSTALL_PREFIX/bin/pk" ]; then
            print_success "Proxy kernel built and installed successfully"
        else
            print_error "Proxy kernel build failed"
            ((errors++))
        fi
    fi
    
    if [ $errors -eq 0 ]; then
        print_banner "Installation/build completed successfully!" "$GREEN"
        echo -e "\n${GREEN}✅ All components installed or built successfully!${NC}"
        
        echo -e "\n${CYAN}📋 Installation Summary:${NC}"
        [ "$BUILD_TOOLCHAIN" = true ] && [ "$TOOLCHAIN_AVAILABLE" = true ] && echo -e "  🛠️  RISC-V Compiler: ${GREEN}✅ Available from apt${NC}"
        [ "$BUILD_SPIKE" = true ] && [ "$SPIKE_BUILT" = true ] && echo -e "  🔧 Spike Simulator: ${GREEN}✅ Built${NC}"
        [ "$BUILD_PK" = true ] && [ "$PK_BUILT" = true ] && echo -e "  ⚙️  Proxy Kernel: ${GREEN}✅ Built${NC}"
        
        echo -e "\n${CYAN}📁 Installation Location:${NC}"
        echo -e "  📂 Install Prefix: ${WHITE}$INSTALL_PREFIX${NC}"
        echo -e "  🌍 Environment File: ${WHITE}$KRYPTONYTE_VENV/riscv_native_env${NC}"
        
        echo -e "\n${CYAN}🚀 Next Steps:${NC}"
        echo -e "  1. Load environment: ${WHITE}source $KRYPTONYTE_VENV/riscv_native_env${NC}"
        echo -e "  2. Test toolchain: ${WHITE}riscv64-unknown-elf-gcc --version${NC}"
        echo -e "  3. Test Spike: ${WHITE}spike --help${NC}"
        echo -e "  4. Use with KryptoNyte conformance tests"
        
        # Clean up build directory if successful
        if [ "$CLEAN_BUILD" = true ]; then
            print_step "Cleaning up build directory"
            rm -rf "$BUILD_DIR"
            print_success "Build directory cleaned"
        fi
        
    else
        print_banner "Build failed" "$RED"
        echo -e "\n${RED}❌ Build failed with $errors component failures${NC}"
        echo -e "\n${CYAN}🔧 Troubleshooting:${NC}"
        echo -e "  1. Check build logs above for specific errors"
        echo -e "  2. Ensure sufficient disk space (~5GB)"
        echo -e "  3. Verify all dependencies are installed"
        echo -e "  4. Try with --clean flag to force clean build"
        echo -e "  5. Check network connectivity for repository access"
        exit 1
    fi
}

# Main build flow
main() {
    print_banner "RISC-V Compiler, Spike, and PK Installer for KryptoNyte" "$BLUE"
    
    echo -e "${CYAN}Build Configuration:${NC}"
    echo -e "  Install Prefix: ${WHITE}$INSTALL_PREFIX${NC}"
    echo -e "  Build Directory: ${WHITE}$BUILD_DIR${NC}"
    echo -e "  Parallel Jobs: ${WHITE}$JOBS${NC}"
    echo -e "  Install/Check Compiler Packages: ${WHITE}$BUILD_TOOLCHAIN${NC}"
    echo -e "  Build Spike: ${WHITE}$BUILD_SPIKE${NC}"
    echo -e "  Build PK: ${WHITE}$BUILD_PK${NC}"
    echo -e "  Upgrade Mode: ${WHITE}$UPGRADE_MODE${NC}"
    echo -e "  Clean Build: ${WHITE}$CLEAN_BUILD${NC}"
    
    # Estimate build time
    local estimated_time="5-15 minutes"
    
    echo -e "\n${YELLOW}⏱️  Estimated build time: $estimated_time${NC}"
    echo -e "${YELLOW}💾 Disk space required: compiler packages plus Spike/PK build output${NC}"
    
    # Confirm build
    if [ "$VERBOSE" = true ]; then
        echo ""
        if ! confirm_continue "Continue with installation/build? (Y/n): "; then
            print_error "Installation cancelled by user"
            exit 1
        fi
    fi
    
    check_requirements
    setup_build_env
    install_toolchain
    build_spike
    build_pk
    setup_environment
    verify_installation
    
    print_banner "RISC-V Tools Installation Complete!" "$GREEN"
}

# Ensure terminal is reset even if script is interrupted
trap 'echo -e "\033[0m"; stty echo 2>/dev/null || true' EXIT INT TERM

# Run main function
main "$@"
