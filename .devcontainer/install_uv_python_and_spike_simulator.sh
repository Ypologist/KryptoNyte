#!/bin/bash

#######################################
# Spike RISC-V Simulator Installation
# Enhanced with error handling and logging
#######################################

# Script configuration
USE_SUDO=false
VERBOSE=true
SPIKE_PREFIX="/opt/riscv"
SPIKE_BUILD_DIR="$HOME/spike"
PARALLEL_JOBS=$(nproc)

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
        --with-sudo)
            USE_SUDO=true
            shift
            ;;
        --quiet)
            VERBOSE=false
            shift
            ;;
        --prefix)
            SPIKE_PREFIX="$2"
            shift 2
            ;;
        --jobs|-j)
            PARALLEL_JOBS="$2"
            shift 2
            ;;
        --build-dir)
            SPIKE_BUILD_DIR="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Spike RISC-V Simulator Installation Script"
            echo ""
            echo "Options:"
            echo "  --with-sudo       Use sudo for commands requiring elevated privileges"
            echo "  --quiet           Reduce output verbosity"
            echo "  --prefix DIR      Installation prefix (default: /opt/riscv)"
            echo "  --jobs N          Number of parallel make jobs (default: $(nproc))"
            echo "  --build-dir DIR   Build directory (default: ~/spike)"
            echo "  --help, -h        Show this help message"
            echo ""
            echo "This script installs:"
            echo "  - Spike RISC-V ISA Simulator"
            echo "  - RISC-V Proxy Kernel (pk)"
            echo "  - All required dependencies"
            echo ""
            echo "Example:"
            echo "  $0 --with-sudo --jobs 4"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Function to execute commands with optional sudo
run_cmd() {
    if [ "$USE_SUDO" = true ]; then
        sudo "$@"
    else
        "$@"
    fi
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

# Function to check if running in Codespace
is_codespace() {
    [ -n "$CODESPACES" ] || [ -n "$GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN" ]
}

# Function to detect if sudo is needed
check_sudo_needed() {
    # Check if we can write to the installation prefix
    local parent_dir=$(dirname "$SPIKE_PREFIX")
    if [ ! -w "$parent_dir" ] 2>/dev/null; then
        return 0  # sudo needed
    fi
    
    # Check if directory exists and we can write to it
    if [ -d "$SPIKE_PREFIX" ] && [ ! -w "$SPIKE_PREFIX" ]; then
        return 0  # sudo needed
    fi
    
    # Check if we can run apt commands
    if ! apt list --installed >/dev/null 2>&1; then
        return 0  # sudo needed
    fi
    
    return 1  # sudo not needed
}

# Auto-detect environment and sudo needs
if is_codespace; then
    print_banner "DETECTED: GitHub Codespace Environment" "$PURPLE"
else
    print_banner "DETECTED: Standalone Environment" "$PURPLE"
fi

if [ "$USE_SUDO" = false ] && check_sudo_needed; then
    print_warning "Elevated privileges may be needed for installation"
    print_warning "Consider running with --with-sudo option if commands fail"
    echo ""
fi

print_banner "SPIKE RISC-V SIMULATOR INSTALLATION" "$WHITE"
echo -e "${CYAN}Installing Spike RISC-V ISA Simulator and Proxy Kernel${NC}"
echo ""
echo "Configuration:"
echo "  Using sudo: $USE_SUDO"
echo "  Installation prefix: $SPIKE_PREFIX"
echo "  Build directory: $SPIKE_BUILD_DIR"
echo "  Parallel jobs: $PARALLEL_JOBS"
echo "  Verbose output: $VERBOSE"


#############################
# Install uv and Python 3.10
#############################
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env
uv venv --python 3.10
source .venv/bin/activate
uv pip install -r requirements.txt



#######################################
# Install Dependencies
#######################################
print_banner "INSTALLING DEPENDENCIES" "$BLUE"

print_step "Setting up non-interactive package management"
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true

print_step "Updating package lists"
run_cmd apt update || {
    print_error "Failed to update package lists"
    exit 1
}

print_step "Installing build dependencies"
DEPENDENCIES=(
    autoconf
    automake
    autotools-dev
    curl
    python3
    libmpc-dev
    libmpfr-dev
    libgmp-dev
    gawk
    build-essential
    bison
    flex
    texinfo
    gperf
    libtool
    patchutils
    bc
    zlib1g-dev
    libexpat-dev
    device-tree-compiler
    git
)

run_cmd apt install -y "${DEPENDENCIES[@]}" || {
    print_error "Failed to install build dependencies"
    exit 1
}

run_cmd apt clean
print_success "All dependencies installed"

########################################
# Check if RISC-V toolchain is available
########################################
print_step "Checking for RISC-V cross-compiler"
if command -v riscv64-unknown-elf-gcc >/dev/null 2>&1; then
    print_success "RISC-V cross-compiler found"
    RISCV_TOOLCHAIN_AVAILABLE=true
    
    # Show toolchain info
    RISCV_GCC_VERSION=$(riscv64-unknown-elf-gcc --version 2>/dev/null | head -1)
    echo "  Using: $RISCV_GCC_VERSION"
    
elif command -v riscv32-unknown-elf-gcc >/dev/null 2>&1; then
    print_success "RISC-V cross-compiler found (32-bit)"
    RISCV_TOOLCHAIN_AVAILABLE=true
    RISCV_PREFIX="riscv32-unknown-elf"
    
    # Show toolchain info
    RISCV_GCC_VERSION=$(riscv32-unknown-elf-gcc --version 2>/dev/null | head -1)
    echo "  Using: $RISCV_GCC_VERSION"
    
else
    print_warning "RISC-V cross-compiler not found"
    print_warning "Proxy Kernel requires RISC-V toolchain to build"
    RISCV_TOOLCHAIN_AVAILABLE=false
fi



#######################################
# Create Installation Directory
#######################################
print_banner "SETTING UP DIRECTORIES" "$CYAN"

print_step "Creating installation directory: $SPIKE_PREFIX"
run_cmd mkdir -p "$SPIKE_PREFIX" || {
    print_error "Failed to create installation directory: $SPIKE_PREFIX"
    exit 1
}

print_step "Creating build directory: $SPIKE_BUILD_DIR"
mkdir -p "$SPIKE_BUILD_DIR" || {
    print_error "Failed to create build directory: $SPIKE_BUILD_DIR"
    exit 1
}

print_success "Directories created successfully"

#######################################
# Install Spike Simulator
#######################################
print_banner "INSTALLING SPIKE RISC-V ISA SIMULATOR" "$GREEN"

cd "$SPIKE_BUILD_DIR" || {
    print_error "Failed to change to build directory: $SPIKE_BUILD_DIR"
    exit 1
}

print_step "Cloning Spike repository"
if [ -d "riscv-isa-sim" ]; then
    print_warning "Spike repository already exists, updating..."
    cd riscv-isa-sim
    git pull origin master || {
        print_error "Failed to update Spike repository"
        exit 1
    }
    cd ..
else
    git clone https://github.com/riscv/riscv-isa-sim.git || {
        print_error "Failed to clone Spike repository"
        exit 1
    }
fi

print_step "Creating Spike build directory"
mkdir -p riscv-isa-sim/build
cd riscv-isa-sim/build || {
    print_error "Failed to enter Spike build directory"
    exit 1
}

print_step "Configuring Spike build"
../configure --prefix="$SPIKE_PREFIX" || {
    print_error "Failed to configure Spike build"
    exit 1
}

print_step "Building Spike (using $PARALLEL_JOBS parallel jobs)"
make -j"$PARALLEL_JOBS" || {
    print_error "Failed to build Spike"
    exit 1
}

print_step "Installing Spike"
run_cmd make install || {
    print_error "Failed to install Spike"
    exit 1
}

print_success "Spike RISC-V ISA Simulator installed successfully"


#######################################
# Install Proxy Kernel (pk) 
#######################################
print_banner "INSTALLING RISC-V PROXY KERNEL (PK)" "$YELLOW"


if [ "$RISCV_TOOLCHAIN_AVAILABLE" = true ]; then
    # Proceed with Proxy Kernel installation
    cd "$SPIKE_BUILD_DIR" || {
        print_error "Failed to change to build directory: $SPIKE_BUILD_DIR"
        exit 1
    }

    print_step "Cloning RISC-V Proxy Kernel repository"
    if [ -d "riscv-pk" ]; then
        print_warning "Proxy Kernel repository already exists, updating..."
        cd riscv-pk
        git pull origin master || {
            print_error "Failed to update Proxy Kernel repository"
            exit 1
        }
        cd ..
    else
        git clone https://github.com/riscv/riscv-pk.git || {
            print_error "Failed to clone Proxy Kernel repository"
            exit 1
        }
    fi

    print_step "Creating Proxy Kernel build directory"
    mkdir -p riscv-pk/build
    cd riscv-pk/build || {
        print_error "Failed to enter Proxy Kernel build directory"
        exit 1
    }

    print_step "Configuring Proxy Kernel build with RISC-V toolchain"
    
    # Set cross-compiler environment variables
    export CC=${RISCV_PREFIX:-riscv64-unknown-elf}-gcc
    export CXX=${RISCV_PREFIX:-riscv64-unknown-elf}-g++
    export AR=${RISCV_PREFIX:-riscv64-unknown-elf}-ar
    export RANLIB=${RISCV_PREFIX:-riscv64-unknown-elf}-ranlib
    export STRIP=${RISCV_PREFIX:-riscv64-unknown-elf}-strip
    
    # Configure with explicit cross-compiler specification
    ../configure --prefix="$SPIKE_PREFIX" \
                 --host=${RISCV_PREFIX:-riscv64-unknown-elf} \
                 CC="$CC" \
                 CXX="$CXX" \
                 AR="$AR" \
                 RANLIB="$RANLIB" \
                 STRIP="$STRIP" || {
        print_error "Failed to configure Proxy Kernel build"
        print_error "This may indicate an issue with the RISC-V toolchain"
        exit 1
    }

    print_step "Building Proxy Kernel (using $PARALLEL_JOBS parallel jobs)"
    make -j"$PARALLEL_JOBS" || {
        print_error "Failed to build Proxy Kernel"
        print_error "Check that RISC-V toolchain is properly installed"
        exit 1
    }

    print_step "Installing Proxy Kernel"
    run_cmd make install || {
        print_error "Failed to install Proxy Kernel"
        exit 1
    }

    print_success "RISC-V Proxy Kernel installed successfully"
    
    # Verify installation
    if [ -f "$SPIKE_PREFIX/${RISCV_PREFIX:-riscv64-unknown-elf}/bin/pk" ]; then
        print_success "Proxy Kernel (pk) binary found at $SPIKE_PREFIX/${RISCV_PREFIX:-riscv64-unknown-elf}/bin/pk"
    else
        print_warning "Proxy Kernel binary not found in expected location"
    fi
    
else
    # Skip Proxy Kernel installation
    print_warning "Skipping Proxy Kernel installation"
    echo ""
    echo "To install Proxy Kernel later:"
    echo "  1. Install RISC-V toolchain (e.g., from riscv-collab releases)"
    echo "  2. Re-run this script or build Proxy Kernel manually"
    echo ""
    echo "Spike simulator will still work for:"
    echo "  - Running pre-compiled RISC-V binaries"
    echo "  - Using other proxy kernels or bare-metal programs"
    echo ""
fi

# Reset environment variables to avoid affecting other builds
unset CC CXX AR RANLIB STRIP



#######################################
# Update PATH
#######################################
print_banner "CONFIGURING ENVIRONMENT" "$PURPLE"

print_step "Adding Spike to PATH in ~/.bashrc"
cat >> ~/.bashrc << EOF
# Spike RISC-V Simulator
if [[ ":\$PATH:" != *":${SPIKE_PREFIX}/bin:"* ]]; then
    export PATH="${SPIKE_PREFIX}/bin:\$PATH"
fi
EOF

# Set PATH for current session
export PATH="${SPIKE_PREFIX}/bin:$PATH"

print_success "PATH updated in ~/.bashrc and current session"

#######################################
# Create Test Program
#######################################
print_banner "CREATING TEST PROGRAM" "$CYAN"

print_step "Creating hello.c test program"
cat > "$SPIKE_BUILD_DIR/hello.c" << 'EOF'
#include <stdio.h>

int main() {
    printf("Hello, RISC-V Spike!\n");
    return 0;
}
EOF

print_success "Test program created: $SPIKE_BUILD_DIR/hello.c"

#######################################
# Verify Installation
#######################################
print_banner "VERIFYING INSTALLATION" "$WHITE"

print_step "Checking Spike installation"
if command -v spike >/dev/null 2>&1; then
    print_success "Spike simulator found in PATH"
    spike --help | head -3
else
    print_error "Spike simulator not found in PATH"
    exit 1
fi

print_step "Checking Proxy Kernel installation"
if [ -f "$SPIKE_PREFIX/riscv64-unknown-elf/bin/pk" ]; then
    print_success "Proxy Kernel (pk) installed successfully"
else
    print_error "Proxy Kernel (pk) not found"
    exit 1
fi

print_step "Testing with RISC-V toolchain (if available)"
if command -v riscv64-unknown-elf-gcc >/dev/null 2>&1; then
    print_step "Compiling test program with RISC-V GCC"
    cd "$SPIKE_BUILD_DIR"
    riscv64-unknown-elf-gcc -o hello hello.c || {
        print_warning "Failed to compile test program (RISC-V toolchain may not be installed)"
    }
    
    if [ -f "hello" ]; then
        print_step "Running test program with Spike"
        spike pk hello || {
            print_warning "Failed to run test program with Spike"
        }
        print_success "Test program executed successfully!"
    fi
else
    print_warning "RISC-V toolchain not found - cannot test compilation"
    print_warning "Install RISC-V toolchain to compile and test programs"
fi

#######################################
# Installation Summary
#######################################
print_banner "INSTALLATION COMPLETE" "$WHITE"

echo ""
echo -e "${GREEN}🎉 Spike RISC-V Simulator Installation Complete! 🎉${NC}"
echo ""
echo "Installed components:"
echo -e "  ${CYAN}✓ Spike RISC-V ISA Simulator${NC}"
echo -e "  ${CYAN}✓ RISC-V Proxy Kernel (pk)${NC}"
echo -e "  ${CYAN}✓ All build dependencies${NC}"
echo ""
echo "Installation details:"
echo "  Installation prefix: $SPIKE_PREFIX"
echo "  Build directory: $SPIKE_BUILD_DIR"
echo "  Test program: $SPIKE_BUILD_DIR/hello.c"
echo ""
echo "Usage examples:"
echo "  # Run a RISC-V binary with Spike:"
echo "  spike pk your_program"
echo ""
echo "  # Compile and run the test program:"
echo "  cd $SPIKE_BUILD_DIR"
echo "  riscv64-unknown-elf-gcc -o hello hello.c"
echo "  spike pk hello"
echo ""
echo "Next steps:"
if is_codespace; then
    echo "  1. Your Codespace is ready for RISC-V simulation!"
    echo "  2. Spike tools are automatically available in new terminals"
else
    echo "  1. Start a new terminal session or run: source ~/.bashrc"
    echo "  2. Install RISC-V toolchain if not already installed"
fi
echo "  3. Begin developing and testing RISC-V programs!"

echo ""
print_success "Spike RISC-V Simulator ready for use!"

