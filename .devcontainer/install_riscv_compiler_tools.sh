#!/bin/bash

#######################################
# RISC-V Prebuilt Toolchain Installation Script
# For KryptoNyte RISC-V Processor Family
# Enhanced with tool detection and upgrade functionality
#######################################

# Script configuration
RISCV_TOOLS_VERSION="2025.08.08"
RISCV_TOOLS_INSTALL_DIR="/opt/riscv/collab"
USE_SUDO=false
VERBOSE=true
UPGRADE_MODE=false

# Installation status tracking
RISCV32_INSTALLED=false
RISCV64_INSTALLED=false

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
        --upgrade)
            UPGRADE_MODE=true
            shift
            ;;
        --install-dir)
            RISCV_TOOLS_INSTALL_DIR="$2"
            shift 2
            ;;
        --version)
            RISCV_TOOLS_VERSION="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "RISC-V Prebuilt Toolchain Installation Script for KryptoNyte"
            echo ""
            echo "Options:"
            echo "  --with-sudo              Use sudo for commands requiring elevated privileges"
            echo "  --quiet                  Reduce output verbosity"
            echo "  --upgrade                Force upgrade/reinstall of existing toolchain"
            echo "  --install-dir DIR        Installation directory (default: $RISCV_TOOLS_INSTALL_DIR)"
            echo "  --version VER            Toolchain version (default: $RISCV_TOOLS_VERSION)"
            echo "  --help, -h               Show this help message"
            echo ""
            echo "This script installs prebuilt RISC-V toolchain from riscv-collab:"
            echo "  - RISC-V 32-bit cross-compiler (riscv32-unknown-elf-gcc)"
            echo "  - RISC-V 64-bit cross-compiler (riscv64-unknown-elf-gcc)"
            echo "  - Complete toolchain with binutils, gdb, and libraries"
            echo ""
            echo "Tools are automatically detected and skipped if already installed"
            echo "unless --upgrade flag is used."
            echo ""
            echo "Environment variables set after installation:"
            echo "  PATH updated to include toolchain binaries"
            echo ""
            echo "Examples:"
            echo "  Install with default settings:"
            echo "    $0 --with-sudo"
            echo ""
            echo "  Install to custom directory:"
            echo "    $0 --with-sudo --install-dir /home/user/riscv-tools"
            echo ""
            echo "  Force upgrade existing installation:"
            echo "    $0 --with-sudo --upgrade"
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

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if running in Codespace
is_codespace() {
    [ -n "$CODESPACES" ] || [ -n "$GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN" ]
}

# Function to check if RISC-V 32-bit toolchain is installed
check_riscv32_toolchain() {
    if command_exists riscv32-unknown-elf-gcc; then
        local version=$(riscv32-unknown-elf-gcc --version 2>/dev/null | head -1)
        print_step "Found RISC-V 32-bit toolchain: $version"
        return 0
    else
        print_step "RISC-V 32-bit toolchain not found"
        return 1
    fi
}

# Function to check if RISC-V 64-bit toolchain is installed
check_riscv64_toolchain() {
    if command_exists riscv64-unknown-elf-gcc; then
        local version=$(riscv64-unknown-elf-gcc --version 2>/dev/null | head -1)
        print_step "Found RISC-V 64-bit toolchain: $version"
        return 0
    else
        print_step "RISC-V 64-bit toolchain not found"
        return 1
    fi
}

# Function to check if directory requires sudo access
check_sudo_needed() {
    local dir="$1"
    local parent_dir=$(dirname "$dir")
    
    # Check if we can write to the parent directory
    if [ ! -w "$parent_dir" ] 2>/dev/null; then
        return 0  # sudo needed
    fi
    
    # Check if directory exists and we can write to it
    if [ -d "$dir" ] && [ ! -w "$dir" ]; then
        return 0  # sudo needed
    fi
    
    return 1  # sudo not needed
}

# Function to install RISC-V toolchain
install_riscv_toolchain() {
    print_banner "Installing RISC-V Prebuilt Toolchain" "$BLUE"
    
    # Check if toolchains are already installed
    local riscv32_found=false
    local riscv64_found=false
    
    if [ "$UPGRADE_MODE" = false ]; then
        if check_riscv32_toolchain >/dev/null 2>&1; then
            print_success "RISC-V 32-bit toolchain already installed - skipping"
            riscv32_found=true
            RISCV32_INSTALLED=true
        fi
        
        if check_riscv64_toolchain >/dev/null 2>&1; then
            print_success "RISC-V 64-bit toolchain already installed - skipping"
            riscv64_found=true
            RISCV64_INSTALLED=true
        fi
        
        if [ "$riscv32_found" = true ] && [ "$riscv64_found" = true ]; then
            print_success "Both RISC-V toolchains already installed - skipping installation"
            return 0
        fi
    fi
    
    if [ "$UPGRADE_MODE" = true ]; then
        print_step "Upgrade mode: Reinstalling RISC-V toolchain"
        if [ -d "$RISCV_TOOLS_INSTALL_DIR" ]; then
            print_step "Removing existing installation"
            run_cmd rm -rf "$RISCV_TOOLS_INSTALL_DIR"
        fi
    fi
    
    # Auto-detect if sudo is needed for installation directory
    if [ "$USE_SUDO" = false ] && check_sudo_needed "$RISCV_TOOLS_INSTALL_DIR"; then
        print_warning "Installation directory ${RISCV_TOOLS_INSTALL_DIR} requires elevated privileges"
        print_warning "Consider running with --with-sudo option"
        print_warning "Continuing anyway - commands may fail..."
    fi
    
    print_step "Installing RISC-V Toolchain v${RISCV_TOOLS_VERSION}"
    print_step "Installation directory: ${RISCV_TOOLS_INSTALL_DIR}"
    
    # Change to temporary directory
    cd /tmp || {
        print_error "Failed to change to /tmp directory"
        return 1
    }
    
    # Create installation directory
    print_step "Creating installation directory"
    run_cmd mkdir -p "${RISCV_TOOLS_INSTALL_DIR}" || {
        print_error "Failed to create installation directory"
        return 1
    }
    
    # Download and install 32-bit tools
    if [ "$riscv32_found" = false ]; then
        print_step "Downloading 32-bit RISC-V toolchain"
        wget -q --show-progress https://github.com/riscv-collab/riscv-gnu-toolchain/releases/download/${RISCV_TOOLS_VERSION}/riscv32-elf-ubuntu-24.04-gcc-nightly-${RISCV_TOOLS_VERSION}-nightly.tar.xz || {
            print_error "Failed to download 32-bit toolchain"
            return 1
        }
        
        print_step "Extracting 32-bit toolchain"
        run_cmd tar -xf riscv32-elf-ubuntu-24.04-gcc-nightly-${RISCV_TOOLS_VERSION}-nightly.tar.xz -C "${RISCV_TOOLS_INSTALL_DIR}" --strip-components=1 || {
            print_error "Failed to extract 32-bit toolchain"
            return 1
        }
        
        RISCV32_INSTALLED=true
        print_success "32-bit RISC-V toolchain installed"
    fi
    
    # Download and install 64-bit tools
    if [ "$riscv64_found" = false ]; then
        print_step "Downloading 64-bit RISC-V toolchain"
        wget -q --show-progress https://github.com/riscv-collab/riscv-gnu-toolchain/releases/download/${RISCV_TOOLS_VERSION}/riscv64-elf-ubuntu-24.04-gcc-nightly-${RISCV_TOOLS_VERSION}-nightly.tar.xz || {
            print_error "Failed to download 64-bit toolchain"
            return 1
        }
        
        print_step "Extracting 64-bit toolchain"
        run_cmd tar -xf riscv64-elf-ubuntu-24.04-gcc-nightly-${RISCV_TOOLS_VERSION}-nightly.tar.xz -C "${RISCV_TOOLS_INSTALL_DIR}" --strip-components=1 || {
            print_error "Failed to extract 64-bit toolchain"
            return 1
        }
        
        RISCV64_INSTALLED=true
        print_success "64-bit RISC-V toolchain installed"
    fi
    
    # Update PATH in ~/.bashrc (always runs as current user, never needs sudo)
    print_step "Updating PATH in ~/.bashrc"
    if ! grep -q "KryptoNyte RISC-V Tools" ~/.bashrc 2>/dev/null; then
        cat >> ~/.bashrc << EOF
# KryptoNyte RISC-V Tools
if [[ ":\$PATH:" != *":${RISCV_TOOLS_INSTALL_DIR}/bin:"* ]]; then
    export PATH="${RISCV_TOOLS_INSTALL_DIR}/bin:\$PATH"
fi
EOF
        print_success "PATH updated in ~/.bashrc"
    else
        print_step "PATH already configured in ~/.bashrc"
    fi
    
    # Set PATH for current session
    export PATH="${RISCV_TOOLS_INSTALL_DIR}/bin:$PATH"
    
    # Cleanup temporary files
    print_step "Cleaning up temporary files"
    rm -f riscv32-elf-ubuntu-24.04-gcc-nightly-${RISCV_TOOLS_VERSION}-nightly.tar.xz 2>/dev/null
    rm -f riscv64-elf-ubuntu-24.04-gcc-nightly-${RISCV_TOOLS_VERSION}-nightly.tar.xz 2>/dev/null
    
    print_success "RISC-V toolchain installation completed"
}

# Function to verify installation
verify_installation() {
    print_banner "Verifying Installation" "$GREEN"
    
    local errors=0
    
    # Test 32-bit toolchain
    if command_exists riscv32-unknown-elf-gcc; then
        local version32=$(riscv32-unknown-elf-gcc --version 2>/dev/null | head -1)
        print_success "32-bit toolchain: $version32"
    else
        print_error "32-bit toolchain not found in PATH"
        ((errors++))
    fi
    
    # Test 64-bit toolchain
    if command_exists riscv64-unknown-elf-gcc; then
        local version64=$(riscv64-unknown-elf-gcc --version 2>/dev/null | head -1)
        print_success "64-bit toolchain: $version64"
    else
        print_error "64-bit toolchain not found in PATH"
        ((errors++))
    fi
    
    # Summary
    if [ $errors -eq 0 ]; then
        print_banner "Installation Successful!" "$GREEN"
        echo -e "\n${GREEN}✅ RISC-V toolchain installation completed successfully!${NC}"
        echo -e "${GREEN}   Both 32-bit and 64-bit toolchains are ready for use.${NC}"
        
        echo -e "\n${CYAN}📋 Installation Summary:${NC}"
        echo -e "  🛠️  Installation Directory: ${WHITE}$RISCV_TOOLS_INSTALL_DIR${NC}"
        echo -e "  📦 Toolchain Version: ${WHITE}$RISCV_TOOLS_VERSION${NC}"
        echo -e "  🔧 32-bit Compiler: ${GREEN}✅ Available${NC}"
        echo -e "  🔧 64-bit Compiler: ${GREEN}✅ Available${NC}"
        echo -e "  🌍 PATH Configuration: ${GREEN}✅ Updated${NC}"
        
        echo -e "\n${CYAN}🚀 Next Steps:${NC}"
        if is_codespace; then
            echo -e "  1. Your Codespace is ready for RISC-V development!"
            echo -e "  2. Toolchain is automatically available in new terminals"
        else
            echo -e "  1. Start a new terminal session or run: ${WHITE}source ~/.bashrc${NC}"
            echo -e "  2. Verify installation: ${WHITE}riscv32-unknown-elf-gcc --version${NC}"
        fi
        echo -e "  3. Begin compiling KryptoNyte processor code!"
        
        echo -e "\n${CYAN}📝 Usage Examples:${NC}"
        echo -e "  # Compile for 32-bit RISC-V"
        echo -e "  ${WHITE}riscv32-unknown-elf-gcc -o program program.c${NC}"
        echo -e ""
        echo -e "  # Compile for 64-bit RISC-V"
        echo -e "  ${WHITE}riscv64-unknown-elf-gcc -o program program.c${NC}"
        
    else
        print_banner "Installation Failed" "$RED"
        echo -e "\n${RED}❌ Installation failed with $errors errors${NC}"
        echo -e "\n${CYAN}🔧 Troubleshooting Suggestions:${NC}"
        echo -e "  1. Check network connectivity for downloads"
        echo -e "  2. Verify disk space in $RISCV_TOOLS_INSTALL_DIR"
        echo -e "  3. Try running with --with-sudo if permission issues"
        echo -e "  4. Check that ~/.bashrc was updated correctly"
        exit 1
    fi
}

# Main installation flow
main() {
    print_banner "RISC-V Prebuilt Toolchain Installation for KryptoNyte" "$BLUE"
    
    # Auto-detect environment
    if is_codespace; then
        print_banner "DETECTED: GitHub Codespace Environment" "$PURPLE"
    else
        print_banner "DETECTED: Standalone Environment" "$PURPLE"
    fi
    
    echo -e "${CYAN}Installation Configuration:${NC}"
    echo -e "  Install Directory: ${WHITE}$RISCV_TOOLS_INSTALL_DIR${NC}"
    echo -e "  Toolchain Version: ${WHITE}$RISCV_TOOLS_VERSION${NC}"
    echo -e "  Use Sudo: ${WHITE}$USE_SUDO${NC}"
    echo -e "  Upgrade Mode: ${WHITE}$UPGRADE_MODE${NC}"
    
    # Tool detection summary
    print_banner "Checking Existing Tools" "$CYAN"
    echo -e "${CYAN}Tool Detection Summary:${NC}"
    
    if check_riscv32_toolchain >/dev/null 2>&1; then
        echo -e "  🔧 RISC-V 32-bit: ${GREEN}Found${NC}"
    else
        echo -e "  🔧 RISC-V 32-bit: ${RED}Not Found${NC}"
    fi
    
    if check_riscv64_toolchain >/dev/null 2>&1; then
        echo -e "  🔧 RISC-V 64-bit: ${GREEN}Found${NC}"
    else
        echo -e "  🔧 RISC-V 64-bit: ${RED}Not Found${NC}"
    fi
    
    # Confirm installation
    if [ "$VERBOSE" = true ]; then
        echo ""
        if [ "$UPGRADE_MODE" = true ]; then
            echo "Upgrade mode enabled - will reinstall toolchain"
        else
            echo "Normal mode - will skip existing tools"
        fi
        read -p "Continue with installation? (Y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            print_error "Installation cancelled by user"
            exit 1
        fi
    fi
    
    install_riscv_toolchain
    verify_installation
    
    print_banner "Installation Complete!" "$GREEN"
}

# Run main function
main "$@"
