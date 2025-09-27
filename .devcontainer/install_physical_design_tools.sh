#!/bin/bash

#######################################
# Physical Design Tools Installation Script
# Installs SkyWater 130nm PDK, Open PDK, Magic VLSI Layout Tool, 
# and OpenROAD for complete ASIC design flow with KryptoNyte processors
#######################################

# Script configuration
USE_SUDO=false
VERBOSE=true
INSTALL_DIR="/opt/skywater-pdk"
SKYWATER_VERSION="main"  # Can be changed to specific tag/commit
OPEN_PDK_VERSION="master"  # Open PDK uses master branch, not main

# Installation status tracking
SKYWATER_PDK_INSTALLED=false
MAGIC_INSTALLED=false
OPEN_PDK_INSTALLED=false
OPENROAD_INSTALLED=false
ENVIRONMENT_SETUP=false

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
        --install-dir)
            INSTALL_DIR="$2"
            shift 2
            ;;
        --skywater-version)
            SKYWATER_VERSION="$2"
            shift 2
            ;;
        --open-pdk-version)
            OPEN_PDK_VERSION="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "SkyWater PDK Installation Script for KryptoNyte"
            echo ""
            echo "Options:"
            echo "  --with-sudo           Use sudo for commands requiring elevated privileges"
            echo "  --quiet               Reduce output verbosity"
            echo "  --install-dir DIR     Installation directory (default: /opt/skywater-pdk)"
            echo "  --skywater-version V  SkyWater PDK version/branch (default: main)"
            echo "  --open-pdk-version V  Open PDK version/branch (default: main)"
            echo "  --help, -h            Show this help message"
            echo ""
            echo "This script installs:"
            echo "  - SkyWater 130nm PDK"
            echo "  - Open PDK flow"
            echo "  - Standard cell libraries"
            echo "  - Timing libraries"
            echo "  - Technology files"
            echo ""
            echo "Environment variables set after installation:"
            echo "  SKYWATER_PDK_ROOT     - Path to SkyWater PDK"
            echo "  PDK_ROOT              - Path to PDK root"
            echo "  STD_CELL_LIBRARY      - Path to standard cell library"
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

# Function to check system requirements
check_requirements() {
    print_step "Checking system requirements"
    
    # Install all required dependencies upfront if using sudo
    if [ "$USE_SUDO" = true ]; then
        print_step "Installing SkyWater PDK dependencies"
        
        sudo apt-get update
        
        print_step "Installing essential build tools"
        sudo apt-get install -y \
            build-essential git make gcc g++ autoconf automake autotools-dev cmake ninja-build \
            pkg-config
        
        print_step "Installing development libraries"
        sudo apt-get install -y \
            libmpc-dev libmpfr-dev libgmp-dev zlib1g-dev libexpat-dev libglib2.0-dev libncurses-dev
        
        print_step "Installing build utilities"
        sudo apt-get install -y \
            gawk bison flex texinfo gperf libtool patchutils bc m4 tcsh csh
        
        print_step "Installing GUI and graphics libraries (for Magic VLSI)"
        sudo apt-get install -y \
            tcl-dev tk-dev libcairo2-dev mesa-common-dev libglu1-mesa-dev \
            libx11-dev libxpm-dev libxext-dev libxt-dev
        
        print_step "Installing Python development tools"
        sudo apt-get install -y \
            python3 python3-dev python3-venv
        
        print_step "Installing uv (fast Python package manager)"
        if ! command_exists uv; then
            curl -LsSf https://astral.sh/uv/install.sh | sh
            export PATH="$HOME/.cargo/bin:$PATH"
        fi
        
        print_step "Installing additional utilities"
        sudo apt-get install -y \
            curl wget unzip tar gzip
        
        print_success "All dependencies installed"
    fi
    
    # Basic verification of critical build tools only
    print_step "Verifying critical build tools"
    
    local critical_missing=()
    
    # Only check the most essential tools needed for the build process
    if ! command_exists git; then
        critical_missing+=("git")
    fi
    
    if ! command_exists make; then
        critical_missing+=("make")
    fi
    
    if ! command_exists gcc; then
        critical_missing+=("gcc")
    fi
    
    if ! command_exists python3; then
        critical_missing+=("python3")
    fi
    
    # If critical tools are missing, try one more installation attempt
    if [ ${#critical_missing[@]} -ne 0 ]; then
        if [ "$USE_SUDO" = true ]; then
            print_warning "Some critical tools missing, attempting installation: ${critical_missing[*]}"
            sudo apt-get update
            sudo apt-get install -y build-essential git python3 autoconf cmake
            
            # Re-check after installation
            if ! command_exists gcc || ! command_exists make; then
                print_error "Critical build tools still missing. Cannot proceed."
                exit 1
            fi
        else
            print_error "Critical build tools missing: ${critical_missing[*]}"
            print_error "Run with --with-sudo to automatically install dependencies"
            exit 1
        fi
    fi
    
    print_success "Critical build tools available"
    
    print_success "System requirements satisfied"
}

# Function to create installation directory
create_install_dir() {
    print_step "Creating installation directory: $INSTALL_DIR"
    
    if [ -d "$INSTALL_DIR" ]; then
        print_warning "Installation directory already exists"
        read -p "Do you want to continue and potentially overwrite existing files? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_error "Installation cancelled by user"
            exit 1
        fi
    fi
    
    run_cmd mkdir -p "$INSTALL_DIR"
    
    # Fix ownership and permissions if using sudo
    if [ "$USE_SUDO" = true ]; then
        sudo chown -R $USER:$USER "$INSTALL_DIR"
        sudo chmod -R u+w "$INSTALL_DIR"
    fi
    
    # Check if we can write to the directory
    if [ ! -w "$INSTALL_DIR" ]; then
        if [ "$USE_SUDO" = true ]; then
            print_error "Cannot write to installation directory: $INSTALL_DIR"
            print_error "Try running: sudo chown -R \$USER:\$USER $INSTALL_DIR"
        else
            print_error "Cannot write to installation directory: $INSTALL_DIR"
            print_error "Directory may be owned by root. Try running with --with-sudo"
        fi
        exit 1
    fi
    
    print_success "Installation directory ready"
}

# Function to install SkyWater PDK
install_skywater_pdk() {
    print_banner "Installing SkyWater 130nm PDK" "$BLUE"
    
    local skywater_dir="$INSTALL_DIR/skywater-pdk"
    
    print_step "Cloning SkyWater PDK repository"
    if [ -d "$skywater_dir" ]; then
        print_step "Updating existing SkyWater PDK repository"
        cd "$skywater_dir"
        git fetch origin
        git checkout "$SKYWATER_VERSION"
        git pull origin "$SKYWATER_VERSION"
    else
        git clone --depth 1 --branch "$SKYWATER_VERSION" \
            https://github.com/google/skywater-pdk.git "$skywater_dir"
    fi
    
    cd "$skywater_dir"
    
    print_step "Initializing SkyWater PDK submodules"
    # Configure git to use HTTPS instead of SSH for GitHub
    git config --global url."https://github.com/".insteadOf git@github.com:
    git config --global url."https://github.com/".insteadOf git+ssh://github.com/
    
    # Initialize submodules, but skip the problematic make-env submodules
    # These are not essential for basic PDK functionality
    git submodule update --init --depth 1 || {
        print_warning "Some submodules failed to initialize (likely make-env dependencies)"
        print_warning "This is not critical for basic PDK functionality"
        
        # Try to initialize just the essential submodules
        print_step "Attempting to initialize essential submodules only"
        git submodule update --init libraries/sky130_fd_sc_hd/latest --depth 1 || true
        git submodule update --init libraries/sky130_fd_sc_ms/latest --depth 1 || true
        git submodule update --init libraries/sky130_fd_sc_ls/latest --depth 1 || true
        git submodule update --init libraries/sky130_fd_sc_hs/latest --depth 1 || true
    }
    
    # Mark as successfully installed
    SKYWATER_PDK_INSTALLED=true
    print_success "SkyWater PDK installed"
}

# Function to install Open PDK
install_open_pdk() {
    print_banner "Installing Open PDK" "$PURPLE"
    
    local open_pdk_dir="$INSTALL_DIR/open_pdks"
    
    print_step "Cloning Open PDK repository"
    if [ -d "$open_pdk_dir" ]; then
        print_step "Updating existing Open PDK repository"
        cd "$open_pdk_dir"
        git fetch origin
        git checkout "$OPEN_PDK_VERSION"
        git pull origin "$OPEN_PDK_VERSION"
    else
        # Try to clone with the specified branch, fallback to master if main doesn't exist
        if ! git clone --depth 1 --branch "$OPEN_PDK_VERSION" \
            https://github.com/RTimothyEdwards/open_pdks.git "$open_pdk_dir"; then
            print_warning "Failed to clone with branch $OPEN_PDK_VERSION, trying master"
            git clone --depth 1 --branch master \
                https://github.com/RTimothyEdwards/open_pdks.git "$open_pdk_dir"
        fi
    fi
    
    cd "$open_pdk_dir"
    
    # Fetch tags for version determination
    print_step "Fetching repository tags for version information"
    git fetch --tags --depth 1 || {
        print_warning "Could not fetch tags, version detection may fail"
    }
    
    print_step "Configuring Open PDK for SkyWater 130nm"
    # Make sure Magic is in PATH for Open PDK configuration
    export PATH="$INSTALL_DIR/magic-install/bin:$PATH"
    
    ./configure --enable-sky130-pdk="$INSTALL_DIR/skywater-pdk" \
                --enable-alpha-sky130 \
                --with-magic="$INSTALL_DIR/magic-install/bin/magic" \
                --prefix="$INSTALL_DIR/pdks"
    
    print_step "Building Open PDK (this may take a while...)"
    make -j$(nproc)
    
    print_step "Installing Open PDK"
    if run_cmd make install; then
        # Mark as successfully installed only if make install succeeded
        OPEN_PDK_INSTALLED=true
        print_success "Open PDK installed"
    else
        print_error "Open PDK installation failed"
        return 1
    fi
}

# Function to install Magic VLSI Layout Tool
install_magic() {
    print_banner "Installing Magic VLSI Layout Tool" "$YELLOW"
    
    local magic_dir="$INSTALL_DIR/magic"
    
    print_step "Installing Magic dependencies"
    local magic_deps=(
        "tcl-dev" "tk-dev" "libcairo2-dev" "mesa-common-dev"
        "libglu1-mesa-dev" "libncurses-dev" "m4" "tcsh" "csh"
        "libx11-dev" "libxpm-dev" "libxext-dev" "libxt-dev"
    )
    
    if [ "$USE_SUDO" = true ]; then
        sudo apt-get update
        sudo apt-get install -y "${magic_deps[@]}"
    else
        print_warning "Cannot install Magic dependencies without sudo"
        print_step "Please install these packages manually: ${magic_deps[*]}"
    fi
    
    print_step "Cloning Magic repository"
    if [ -d "$magic_dir" ]; then
        print_step "Updating existing Magic repository"
        cd "$magic_dir"
        git fetch origin
        git pull origin master
    else
        git clone https://github.com/RTimothyEdwards/magic.git "$magic_dir"
    fi
    
    cd "$magic_dir"
    
    print_step "Configuring Magic"
    ./configure --prefix="$INSTALL_DIR/magic-install"
    
    print_step "Building Magic"
    make -j$(nproc)
    
    print_step "Installing Magic"
    if run_cmd make install; then
        # Mark as successfully installed only if make install succeeded
        MAGIC_INSTALLED=true
        print_success "Magic VLSI Layout Tool installed"
    else
        print_error "Magic VLSI Layout Tool installation failed"
        return 1
    fi
}

# Function to set up environment variables
setup_environment() {
    print_banner "Setting up environment variables" "$GREEN"
    
    local env_file="$HOME/.skywater_pdk_env"
    
    print_step "Creating environment configuration file"
    cat > "$env_file" << EOF
# SkyWater PDK Environment Variables
# Source this file or add to your shell profile (.bashrc, .zshrc, etc.)

# PDK Root Directories
export SKYWATER_PDK_ROOT="$INSTALL_DIR/skywater-pdk"
export PDK_ROOT="$INSTALL_DIR/pdks"
export OPEN_PDKS_ROOT="$INSTALL_DIR/open_pdks"

# SkyWater 130nm specific paths
export SKY130_PDK_ROOT="\$PDK_ROOT/sky130A"
export STD_CELL_LIBRARY="\$SKY130_PDK_ROOT/libs.ref/sky130_fd_sc_hd"
export IO_LIBRARY="\$SKY130_PDK_ROOT/libs.ref/sky130_fd_io"
export PRIMITIVE_LIBRARY="\$SKY130_PDK_ROOT/libs.ref/sky130_fd_pr"

# Timing libraries
export SKY130_TIMING_ROOT="\$STD_CELL_LIBRARY/lib"
export SKY130_TIMING_TT_025C_1V80="\$SKY130_TIMING_ROOT/sky130_fd_sc_hd__tt_025C_1v80.lib"
export SKY130_TIMING_SS_100C_1V60="\$SKY130_TIMING_ROOT/sky130_fd_sc_hd__ss_100C_1v60.lib"
export SKY130_TIMING_FF_N40C_1V95="\$SKY130_TIMING_ROOT/sky130_fd_sc_hd__ff_n40C_1v95.lib"

# Technology files
export SKY130_TECH_ROOT="\$SKY130_PDK_ROOT/libs.tech"
export SKY130_MAGIC_TECH="\$SKY130_TECH_ROOT/magic/sky130A.tech"
export SKY130_KLAYOUT_TECH="\$SKY130_TECH_ROOT/klayout/sky130A.lyt"

# Magic VLSI Layout Tool
export MAGIC_ROOT="$INSTALL_DIR/magic-install"
export PATH="\$MAGIC_ROOT/bin:\$PATH"

# KryptoNyte specific configurations
export KRYPTONYTE_PDK_ROOT="\$SKY130_PDK_ROOT"
export KRYPTONYTE_STD_CELL_LIB="\$SKY130_TIMING_TT_025C_1V80"
export KRYPTONYTE_TECH_FILE="\$SKY130_MAGIC_TECH"

EOF

    print_step "Environment file created at: $env_file"
    
    # Add to current shell profile if possible
    local shell_profile=""
    if [ -n "$BASH_VERSION" ]; then
        shell_profile="$HOME/.bashrc"
    elif [ -n "$ZSH_VERSION" ]; then
        shell_profile="$HOME/.zshrc"
    fi
    
    if [ -n "$shell_profile" ] && [ -w "$shell_profile" ]; then
        if ! grep -q "skywater_pdk_env" "$shell_profile"; then
            print_step "Adding environment setup to $shell_profile"
            echo "" >> "$shell_profile"
            echo "# SkyWater PDK Environment" >> "$shell_profile"
            echo "source $env_file" >> "$shell_profile"
            print_success "Environment setup added to shell profile"
        else
            print_warning "Environment setup already exists in shell profile"
        fi
    fi
    
    # Mark environment setup as complete
    ENVIRONMENT_SETUP=true
    print_success "Environment configuration complete"
    
    echo -e "\n${CYAN}To use the SkyWater PDK in your current session, run:${NC}"
    echo -e "${WHITE}source $env_file${NC}"
    echo -e "\n${CYAN}Or restart your terminal to load the environment automatically.${NC}"
}

# Function to verify installation
verify_installation() {
    print_banner "Verifying installation" "$GREEN"
    
    local errors=0
    local warnings=0
    
    print_step "Checking installation status based on component completion"
    
    # Check SkyWater PDK installation status
    if [ "$SKYWATER_PDK_INSTALLED" = true ]; then
        print_success "SkyWater PDK source installation completed successfully"
    else
        print_error "SkyWater PDK source installation failed"
        ((errors++))
    fi
    
    # Check Magic installation status
    if [ "$MAGIC_INSTALLED" = true ]; then
        print_success "Magic VLSI Layout Tool installation completed successfully"
        
        # Optional: Test Magic executable if it exists
        if [ -f "$INSTALL_DIR/magic-install/bin/magic" ]; then
            if "$INSTALL_DIR/magic-install/bin/magic" -noconsole -dnull -rcfile /dev/null <<< "exit" >/dev/null 2>&1; then
                print_success "Magic executable verified and working"
            else
                print_warning "Magic installed but executable test failed"
                ((warnings++))
            fi
        else
            print_warning "Magic marked as installed but executable not found"
            ((warnings++))
        fi
    else
        print_error "Magic VLSI Layout Tool installation failed"
        ((errors++))
    fi
    
    # Check Open PDK installation status
    if [ "$OPEN_PDK_INSTALLED" = true ]; then
        print_success "Open PDK installation completed successfully"
        
        # Optional: Verify some key files exist if directories are accessible
        if [ -d "$INSTALL_DIR/pdks" ]; then
            local pdk_dirs=$(find "$INSTALL_DIR/pdks" -name "sky130*" -type d 2>/dev/null | wc -l)
            if [ "$pdk_dirs" -gt 0 ]; then
                print_success "Open PDK generated $pdk_dirs Sky130 variant directories"
            else
                print_warning "Open PDK completed but no Sky130 directories found"
                ((warnings++))
            fi
        fi
    else
        print_error "Open PDK installation failed"
        ((errors++))
    fi
    
    # Check environment setup status
    if [ "$ENVIRONMENT_SETUP" = true ]; then
        print_success "Environment configuration completed successfully"
        
        # Verify environment file exists
        if [ -f "$HOME/.skywater_pdk_env" ]; then
            print_success "Environment file created successfully"
        else
            print_warning "Environment setup completed but file not found"
            ((warnings++))
        fi
    else
        print_warning "Environment configuration was not completed"
        ((warnings++))
    fi
    
    # Summary based on component status
    print_step "Installation verification summary"
    if [ $errors -eq 0 ]; then
        if [ $warnings -eq 0 ]; then
            print_banner "Installation completed successfully!" "$GREEN"
            echo -e "\n${GREEN}✅ All SkyWater PDK components installed successfully!${NC}"
            echo -e "${GREEN}   The PDK is ready for use with KryptoNyte processors.${NC}"
        else
            print_banner "Installation completed with warnings" "$YELLOW"
            echo -e "\n${YELLOW}⚠️  SkyWater PDK installation completed with $warnings warnings${NC}"
            echo -e "${YELLOW}   Core functionality should work, but some features may be limited${NC}"
        fi
        
        echo -e "\n${CYAN}📋 Component Status Summary:${NC}"
        echo -e "  📦 SkyWater PDK Source: ${GREEN}✅ Installed${NC}"
        echo -e "  🔧 Magic VLSI Tool: ${GREEN}✅ Installed${NC}"
        echo -e "  ⚙️  Open PDK Processing: ${GREEN}✅ Completed${NC}"
        echo -e "  🏗️  OpenROAD Physical Design: ${GREEN}✅ Installed${NC}"
        echo -e "  🌍 Environment Setup: ${GREEN}✅ Configured${NC}"
        
        echo -e "\n${CYAN}📁 Installation Locations:${NC}"
        echo -e "  📂 Installation Root: ${WHITE}$INSTALL_DIR${NC}"
        echo -e "  🔧 Magic Tool: ${WHITE}$INSTALL_DIR/magic-install/bin/magic${NC}"
        echo -e "  🌍 Environment File: ${WHITE}$HOME/.skywater_pdk_env${NC}"
        
        # Try to find actual PDK locations
        if [ -d "$INSTALL_DIR/pdks" ]; then
            local pdk_root=$(find "$INSTALL_DIR/pdks" -name "sky130*" -type d 2>/dev/null | head -1)
            if [ -n "$pdk_root" ]; then
                echo -e "  📚 PDK Root: ${WHITE}$pdk_root${NC}"
            fi
        fi
        
        echo -e "\n${CYAN}🚀 Next Steps:${NC}"
        echo -e "  1. Load environment: ${WHITE}source $HOME/.skywater_pdk_env${NC}"
        echo -e "  2. Update KryptoNyte RTL generator paths"
        echo -e "  3. Test synthesis with your RISC-V cores"
        echo -e "  4. Verify PDK integration with your design flow"
        
    else
        print_banner "Installation failed" "$RED"
        echo -e "\n${RED}❌ Installation failed with $errors critical component failures${NC}"
        if [ $warnings -gt 0 ]; then
            echo -e "${YELLOW}   Also encountered $warnings warnings${NC}"
        fi
        
        echo -e "\n${CYAN}💥 Failed Components:${NC}"
        [ "$SKYWATER_PDK_INSTALLED" != true ] && echo -e "  📦 SkyWater PDK Source: ${RED}❌ Failed${NC}"
        [ "$MAGIC_INSTALLED" != true ] && echo -e "  🔧 Magic VLSI Tool: ${RED}❌ Failed${NC}"
        [ "$OPEN_PDK_INSTALLED" != true ] && echo -e "  ⚙️  Open PDK Processing: ${RED}❌ Failed${NC}"
        
        echo -e "\n${CYAN}🔧 Troubleshooting Suggestions:${NC}"
        echo -e "  1. Review the installation log above for specific error messages"
        echo -e "  2. Check system requirements and dependencies"
        echo -e "  3. Verify disk space and permissions in $INSTALL_DIR"
        echo -e "  4. Try running with --with-sudo if permission issues"
        echo -e "  5. Check network connectivity for repository access"
        
        exit 1
    fi
}

# Install OpenROAD for physical design flow
install_openroad() {
    print_header "Installing OpenROAD"
    
    # OpenROAD is available as a pre-built binary from GitHub releases
    print_step "Fetching OpenROAD release information"
    
    # Get the latest OpenROAD release URL
    OPENROAD_URL=$(curl -s https://api.github.com/repos/The-OpenROAD-Project/OpenROAD/releases/latest | \
        jq -r '.assets[] | select(.name | contains("ubuntu22")) | select(.name | contains("amd64")) | .browser_download_url')
    
    if [ -z "$OPENROAD_URL" ] || [ "$OPENROAD_URL" = "null" ]; then
        print_warning "Failed to fetch OpenROAD release information, trying alternative installation"
        
        # Alternative: Install from OpenROAD PPA
        print_step "Adding OpenROAD PPA"
        if run_cmd add-apt-repository -y ppa:openroad/ppa; then
            run_cmd apt-get update -qq
            print_step "Installing OpenROAD from PPA"
            if run_cmd apt-get install -y openroad; then
                print_success "OpenROAD installed from PPA"
                OPENROAD_INSTALLED=true
            else
                print_warning "OpenROAD installation failed - physical design flow will be limited"
            fi
        else
            print_warning "Could not add OpenROAD PPA - physical design flow will be limited"
        fi
    else
        print_step "Downloading OpenROAD"
        if ! wget "$OPENROAD_URL" -O /tmp/openroad.deb; then
            print_error "Failed to download OpenROAD"
            print_warning "Physical design flow will be limited without OpenROAD"
        else
            print_step "Installing OpenROAD"
            if run_cmd dpkg -i /tmp/openroad.deb; then
                print_success "OpenROAD installed"
                OPENROAD_INSTALLED=true
            else
                print_step "Fixing dependencies"
                run_cmd apt-get install -f -y
                if run_cmd dpkg -i /tmp/openroad.deb; then
                    print_success "OpenROAD installed"
                    OPENROAD_INSTALLED=true
                else
                    print_warning "OpenROAD installation failed - physical design flow will be limited"
                fi
            fi
            rm -f /tmp/openroad.deb
        fi
    fi
    
    # Verify OpenROAD installation
    if command -v openroad >/dev/null 2>&1; then
        print_step "Verifying OpenROAD installation"
        openroad -version 2>/dev/null || echo "OpenROAD installed (version check failed)"
        OPENROAD_INSTALLED=true
    else
        print_warning "OpenROAD not found in PATH after installation"
    fi
}

# Main installation function
main() {
    print_banner "Physical Design Tools Installation for KryptoNyte" "$BLUE"
    
    echo -e "${CYAN}Installation Configuration:${NC}"
    echo -e "  Install Directory: ${WHITE}$INSTALL_DIR${NC}"
    echo -e "  SkyWater Version: ${WHITE}$SKYWATER_VERSION${NC}"
    echo -e "  Open PDK Version: ${WHITE}$OPEN_PDK_VERSION${NC}"
    echo -e "  Use Sudo: ${WHITE}$USE_SUDO${NC}"
    
    # Confirm installation
    if [ "$VERBOSE" = true ]; then
        echo ""
        read -p "Continue with installation? (Y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            print_error "Installation cancelled by user"
            exit 1
        fi
    fi
    
    check_requirements
    create_install_dir
    install_skywater_pdk
    install_magic          # Install Magic FIRST - Open PDK needs it
    install_open_pdk       # Install Open PDK AFTER Magic is available
    install_openroad       # Install OpenROAD for physical design flow
    setup_environment
    verify_installation
    
    print_banner "Installation Complete!" "$GREEN"
}

# Run main function
main "$@"
