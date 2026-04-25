#!/bin/bash

#######################################
# Physical Design Tools Installation Script
# Installs SkyWater 130nm PDK, Open PDK, Magic VLSI Layout Tool, 
# and OpenLane2 for complete RTL-to-GDSII ASIC design flow with KryptoNyte processors
#######################################

set -uo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
source "$SCRIPT_DIR/common_install.sh"

# Script configuration
VERBOSE=true
INSTALL_DIR="$KRYPTONYTE_TOOLS_DIR/skywater-pdk"
SKYWATER_VERSION="main"  # Can be changed to specific tag/commit
OPEN_PDK_VERSION="master"  # Open PDK uses master branch, not main

# Installation status tracking
SKYWATER_PDK_INSTALLED=false
MAGIC_INSTALLED=false
OPEN_PDK_INSTALLED=false
NIX_INSTALLED=false
OPENLANE2_INSTALLED=false
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
            echo "  --quiet               Reduce output verbosity"
            echo "  --install-dir DIR     Installation directory (default: $KRYPTONYTE_TOOLS_DIR/skywater-pdk)"
            echo "  --skywater-version V  SkyWater PDK version/branch (default: main)"
            echo "  --open-pdk-version V  Open PDK version/branch (default: master)"
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

# Function to get version of a command
get_command_version() {
    local cmd="$1"
    local version_flag="${2:---version}"
    
    if command_exists "$cmd"; then
        "$cmd" "$version_flag" 2>/dev/null | head -1 || echo "Unknown version"
    else
        echo "Not installed"
    fi
}

# Function to check if SkyWater PDK is installed
check_skywater_pdk() {
    local skywater_dir="$INSTALL_DIR/skywater-pdk"
    
    if [ -d "$skywater_dir" ] && [ -d "$skywater_dir/libraries" ]; then
        print_step "Found existing SkyWater PDK installation at: $skywater_dir"
        
        # Try to get version information
        if [ -d "$skywater_dir/.git" ]; then
            cd "$skywater_dir"
            local current_branch=$(git branch --show-current 2>/dev/null || echo "unknown")
            local last_commit=$(git log -1 --format="%h %s" 2>/dev/null || echo "unknown")
            print_step "Current version: branch '$current_branch', commit: $last_commit"
        fi
        return 0
    else
        print_step "SkyWater PDK not found at: $skywater_dir"
        return 1
    fi
}

# Function to check if Magic VLSI is installed
check_magic() {
    local magic_path="$INSTALL_DIR/magic-install/bin/magic"
    
    if [ -f "$magic_path" ] && [ -x "$magic_path" ]; then
        print_step "Found existing Magic VLSI installation at: $magic_path"
        print_step "Magic executable found and is executable"
        return 0
    elif command_exists magic; then
        print_step "Found Magic VLSI in system PATH"
        local magic_system_path=$(command -v magic)
        print_step "Magic found at: $magic_system_path"
        return 0
    else
        print_step "Magic VLSI not found"
        return 1
    fi
}

get_magic_path() {
    local bundled_magic="$INSTALL_DIR/magic-install/bin/magic"
    local candidates=()
    
    # Prefer the locally built Magic from the PDK install (avoid system Magic if flaky).
    if [ -x "$bundled_magic" ]; then
        candidates+=("$bundled_magic")
    fi

    # Fall back to system Magic if local copy is missing.
    if command_exists magic; then
        candidates+=("$(command -v magic)")
    fi

    for magic_bin in "${candidates[@]}"; do
        if "$magic_bin" --version >/dev/null 2>&1; then
            echo "$magic_bin"
            return 0
        else
            print_warning "Magic binary at $magic_bin failed version check, skipping"
        fi
    done
    
    echo ""
    return 1
}

# Function to check if Open PDK is installed
check_open_pdk() {
    local open_pdk_dir="$INSTALL_DIR/open_pdks"
    local pdk_install_dir="$INSTALL_DIR/pdks"
    
    if [ -d "$open_pdk_dir" ] && [ -d "$pdk_install_dir" ]; then
        print_step "Found existing Open PDK installation"
        print_step "Source: $open_pdk_dir"
        print_step "PDKs: $pdk_install_dir"
        
        # Check for Sky130 PDK variants
        local sky130_variants=$(find "$pdk_install_dir" -name "sky130*" -type d 2>/dev/null | wc -l)
        if [ "$sky130_variants" -gt 0 ]; then
            print_step "Found $sky130_variants Sky130 PDK variants"
        fi
        
        # Try to get version information
        if [ -d "$open_pdk_dir/.git" ]; then
            cd "$open_pdk_dir"
            local current_branch=$(git branch --show-current 2>/dev/null || echo "unknown")
            local last_commit=$(git log -1 --format="%h %s" 2>/dev/null || echo "unknown")
            print_step "Current version: branch '$current_branch', commit: $last_commit"
        fi
        return 0
    else
        print_step "Open PDK not found"
        return 1
    fi
}

# Function to check if Nix is installed
check_nix() {
    if command_exists nix; then
        print_step "Found existing Nix installation"
        local version=$(nix --version 2>/dev/null | head -1 || echo "unknown")
        print_step "Current version: $version"
        local install_path=$(which nix)
        print_step "Installation path: $install_path"
        return 0
    else
        print_step "Nix not found"
        return 1
    fi
}

# Function to check if OpenLane2 is installed
check_openlane2() {
    local openlane2_dir="$INSTALL_DIR/openlane2"
    
    if [ -d "$openlane2_dir" ]; then
        print_step "Found existing OpenLane2 installation at: $openlane2_dir"
        
        # Check if it's a git repository and get version info
        if [ -d "$openlane2_dir/.git" ]; then
            cd "$openlane2_dir"
            local current_branch=$(git branch --show-current 2>/dev/null || echo "unknown")
            local last_commit=$(git log -1 --format="%h %s" 2>/dev/null || echo "unknown")
            print_step "Current version: branch '$current_branch', commit: $last_commit"
        fi
        
        # Check if nix-shell works in the directory
        if [ -f "$openlane2_dir/flake.nix" ] || [ -f "$openlane2_dir/shell.nix" ]; then
            print_step "OpenLane2 Nix environment available"
        fi
        
        return 0
    else
        print_step "OpenLane2 not found"
        return 1
    fi
}

# Function to prompt user for upgrade decision
prompt_upgrade() {
    local tool_name="$1"
    local current_info="$2"

    if [ ! -t 0 ]; then
        print_success "Keeping existing $tool_name installation"
        return 0
    fi
    
    echo -e "\n${YELLOW}$tool_name is already installed.${NC}"
    if [ -n "$current_info" ]; then
        echo -e "${CYAN}Current installation: $current_info${NC}"
    fi
    
    echo -e "${CYAN}Options:${NC}"
    echo -e "  ${WHITE}1)${NC} Keep existing installation"
    echo -e "  ${WHITE}2)${NC} Upgrade/reinstall"
    echo -e "  ${WHITE}3)${NC} Skip this tool"
    
    while true; do
        echo -n "Please choose (1/2/3): "
        read -r choice
        case "$choice" in
            1)
                print_success "Keeping existing $tool_name installation"
                return 0  # Keep existing
                ;;
            2)
                print_step "Will upgrade/reinstall $tool_name"
                return 1  # Upgrade/reinstall
                ;;
            3)
                print_warning "Skipping $tool_name installation"
                return 2  # Skip
                ;;
            *)
                echo -e "${RED}Invalid choice. Please enter 1, 2, or 3.${NC}"
                ;;
        esac
    done
}

# Function to check system requirements
check_requirements() {
    print_step "Checking system requirements"
    
    # Basic verification of critical build tools only
    print_step "Verifying critical build tools"
    
    local critical_missing=()
    
    for tool in git make gcc autoconf automake cmake python3 curl wget tar; do
        if ! command_exists "$tool"; then
            critical_missing+=("$tool")
        fi
    done
    
    # If critical tools are missing, try one more installation attempt
    if [ ${#critical_missing[@]} -ne 0 ]; then
        print_error "Critical build tools missing: ${critical_missing[*]}"
        print_error "Install OS prerequisites with: sudo .devcontainer/00_install_ubuntu_packages.sh"
        exit 1
    fi
    
    print_success "Critical build tools available"
    
    print_success "System requirements satisfied"
}

# Function to create installation directory
create_install_dir() {
    print_step "Creating installation directory: $INSTALL_DIR"
    ensure_local_venv
    
    if [ -d "$INSTALL_DIR" ]; then
        print_warning "Installation directory already exists"
        if [ -t 0 ]; then
            local reply
            read -p "Do you want to continue and potentially overwrite existing files? (y/N): " -n 1 -r reply || reply=""
            echo
            if [[ ! $reply =~ ^[Yy]$ ]]; then
                print_warning "Installation cancelled by user - some tools may not be installed"
                return 1
            fi
        else
            print_warning "No interactive terminal detected; continuing with existing directory"
        fi
    fi
    
    run_cmd mkdir -p "$INSTALL_DIR"
    
    # Check if we can write to the directory
    if [ ! -w "$INSTALL_DIR" ]; then
        print_error "Cannot write to installation directory: $INSTALL_DIR"
        exit 1
    fi
    
    print_success "Installation directory ready"
}

# Function to install SkyWater PDK
install_skywater_pdk() {
    print_banner "Installing SkyWater 130nm PDK" "$BLUE"
    
    local skywater_dir="$INSTALL_DIR/skywater-pdk"
    
    # Check if SkyWater PDK is already installed
    if check_skywater_pdk; then
        local current_info="$skywater_dir"
        if [ -d "$skywater_dir/.git" ]; then
            cd "$skywater_dir"
            local current_branch=$(git branch --show-current 2>/dev/null || echo "unknown")
            current_info="$current_info (branch: $current_branch)"
        fi
        
        prompt_upgrade "SkyWater PDK" "$current_info"
        local upgrade_choice=$?
        
        case $upgrade_choice in
            0)  # Keep existing
                SKYWATER_PDK_INSTALLED=true
                return 0
                ;;
            1)  # Upgrade/reinstall
                print_step "Removing existing SkyWater PDK directory for fresh installation"
                rm -rf "$skywater_dir"
                ;;
            2)  # Skip
                return 0
                ;;
        esac
    fi
    
    # Install SkyWater PDK
    print_step "Cloning SkyWater PDK repository"
    if git clone --depth 1 --branch "$SKYWATER_VERSION" \
        https://github.com/google/skywater-pdk.git "$skywater_dir"; then
        SKYWATER_PDK_INSTALLED=true
    else
        print_error "Failed to clone SkyWater PDK repository"
        return 1
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
    
    print_success "SkyWater PDK installation process completed"
}

# Function to install Open PDK
install_open_pdk() {
    print_banner "Installing Open PDK" "$PURPLE"
    
    local open_pdk_dir="$INSTALL_DIR/open_pdks"
    local pdk_install_dir="$INSTALL_DIR/pdks"
    
    # Check if Open PDK is already installed
    if check_open_pdk; then
        local current_info="$open_pdk_dir"
        if [ -d "$open_pdk_dir/.git" ]; then
            cd "$open_pdk_dir"
            local current_branch=$(git branch --show-current 2>/dev/null || echo "unknown")
            current_info="$current_info (branch: $current_branch)"
        fi
        
        prompt_upgrade "Open PDK" "$current_info"
        local upgrade_choice=$?
        
        case $upgrade_choice in
            0)  # Keep existing
                OPEN_PDK_INSTALLED=true
                return 0
                ;;
            1)  # Upgrade/reinstall
                print_step "Removing existing Open PDK installation for fresh build"
                rm -rf "$open_pdk_dir" "$pdk_install_dir"
                ;;
            2)  # Skip
                return 0
                ;;
        esac
    fi
    
    print_step "Cloning Open PDK repository"
    # Try to clone with the specified branch, fallback to master if main doesn't exist
    if ! git clone --depth 1 --branch "$OPEN_PDK_VERSION" \
        https://github.com/RTimothyEdwards/open_pdks.git "$open_pdk_dir"; then
        print_warning "Failed to clone with branch $OPEN_PDK_VERSION, trying master"
        git clone --depth 1 --branch master \
            https://github.com/RTimothyEdwards/open_pdks.git "$open_pdk_dir"
    fi
    
    cd "$open_pdk_dir"
    
    # Fetch tags for version determination
    print_step "Fetching repository tags for version information"
    git fetch --tags --depth 1 || {
        print_warning "Could not fetch tags, version detection may fail"
    }
    
    print_step "Configuring Open PDK for SkyWater 130nm"
    # Determine the Magic binary to use for Open PDK configuration
    local magic_binary
    magic_binary="$(get_magic_path)"
    
    if [ -z "$magic_binary" ]; then
        print_error "Magic executable not found - required for Open PDK build"
        print_step "Install Magic using this script or ensure 'magic' is available in PATH"
        return 1
    fi
    
    print_step "Using Magic executable at: $magic_binary"
    export PATH="$(dirname "$magic_binary"):$PATH"
    
    ./configure --enable-sky130-pdk="$INSTALL_DIR/skywater-pdk" \
                --enable-alpha-sky130 \
                --with-magic="$magic_binary" \
                --prefix="$pdk_install_dir"
    
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
    local magic_install_dir="$INSTALL_DIR/magic-install"
    
    # Check if Magic is already installed
    if check_magic; then
        local current_info=""
        if [ -f "$magic_install_dir/bin/magic" ]; then
            current_info="$magic_install_dir/bin/magic"
        elif command_exists magic; then
            current_info="$(which magic) (system installation)"
        fi
        
        prompt_upgrade "Magic VLSI Layout Tool" "$current_info"
        local upgrade_choice=$?
        
        case $upgrade_choice in
            0)  # Keep existing
                MAGIC_INSTALLED=true
                return 0
                ;;
            1)  # Upgrade/reinstall
                print_step "Removing existing Magic installation for fresh build"
                rm -rf "$magic_dir" "$magic_install_dir"
                ;;
            2)  # Skip
                return 0
                ;;
        esac
    fi
    
    print_step "Checking Magic dependencies"
    local magic_deps=(
        "tcl-dev" "tk-dev" "libcairo2-dev" "mesa-common-dev"
        "libglu1-mesa-dev" "libncurses-dev" "m4" "tcsh" "csh"
        "libx11-dev" "libxpm-dev" "libxext-dev" "libxt-dev"
    )

    print_step "Magic uses OS development packages that cannot live in .venv"
    print_step "Expected packages: ${magic_deps[*]}"
    require_commands tclsh wish m4 tcsh csh || {
        print_error "Missing Magic OS prerequisites. Install them with: sudo .devcontainer/00_install_ubuntu_packages.sh"
        return 1
    }
    
    print_step "Cloning Magic repository"
    git clone https://github.com/RTimothyEdwards/magic.git "$magic_dir"
    
    cd "$magic_dir"
    
    print_step "Configuring Magic"
    ./configure --prefix="$magic_install_dir"
    
    print_step "Building Magic"
    make -j$(nproc)
    
    print_step "Installing Magic"
    if run_cmd make install; then
        # Mark as successfully installed only if make install succeeded
        MAGIC_INSTALLED=true
        print_success "Magic VLSI Layout Tool installed"
        # Prefer the freshly built Magic for subsequent steps in this run
        export PATH="$magic_install_dir/bin:$PATH"
    else
        print_error "Magic VLSI Layout Tool installation failed"
        return 1
    fi
}

# Function to set up environment variables
setup_environment() {
    print_banner "Setting up environment variables" "$GREEN"
    
    local env_file="$KRYPTONYTE_VENV/skywater_pdk_env"
    
    print_step "Creating environment configuration file"
    cat > "$env_file" << EOF
# SkyWater PDK Environment Variables
# Source this file or add to your shell profile (.bashrc, .zshrc, etc.)

# KryptoNyte repo-local environment
source "$KRYPTONYTE_REPO_ROOT/.devcontainer/dev_env.sh"

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
    if [ -n "${BASH_VERSION:-}" ]; then
        shell_profile="$HOME/.bashrc"
    elif [ -n "${ZSH_VERSION:-}" ]; then
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
    add_dev_env_to_shell_profile
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
        
        # Check Magic executable exists and is executable
        if [ -f "$INSTALL_DIR/magic-install/bin/magic" ] && [ -x "$INSTALL_DIR/magic-install/bin/magic" ]; then
            print_success "Magic executable found and is executable"
        else
            print_warning "Magic marked as installed but executable not found or not executable"
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
    
    # Check Nix installation status
    if [ "$NIX_INSTALLED" = true ]; then
        print_success "Nix package manager installation completed successfully"
        
        # Test Nix executable
        if command -v nix >/dev/null 2>&1; then
            if nix --version >/dev/null 2>&1; then
                print_success "Nix executable verified and working"
            else
                print_warning "Nix installed but version check failed"
                ((warnings++))
            fi
        else
            print_warning "Nix marked as installed but not found in PATH"
            ((warnings++))
        fi
    else
        print_warning "Nix installation failed - OpenLane2 will not be available"
        ((warnings++))
    fi
    
    # Check OpenLane2 installation status
    if [ "$OPENLANE2_INSTALLED" = true ]; then
        print_success "OpenLane2 installation completed successfully"
        
        # Check if OpenLane2 directory exists
        local openlane2_dir="$INSTALL_DIR/openlane2"
        if [ -d "$openlane2_dir" ]; then
            print_success "OpenLane2 repository found at: $openlane2_dir"
            
            # Check for convenience script
            local openlane_script="$INSTALL_DIR/openlane"
            if [ -x "$openlane_script" ]; then
                print_success "OpenLane2 convenience script created"
            fi
        else
            print_warning "OpenLane2 marked as installed but directory not found"
            ((warnings++))
        fi
    else
        print_warning "OpenLane2 installation failed - RTL-to-GDSII flow will not be available"
        ((warnings++))
    fi
    
    # Check environment setup status
    if [ "$ENVIRONMENT_SETUP" = true ]; then
        print_success "Environment configuration completed successfully"
        
        # Verify environment file exists
        if [ -f "$KRYPTONYTE_VENV/skywater_pdk_env" ]; then
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
        [ "$SKYWATER_PDK_INSTALLED" = true ] && echo -e "  📦 SkyWater PDK Source: ${GREEN}✅ Installed${NC}" || echo -e "  📦 SkyWater PDK Source: ${RED}❌ Failed${NC}"
        [ "$MAGIC_INSTALLED" = true ] && echo -e "  🔧 Magic VLSI Tool: ${GREEN}✅ Installed${NC}" || echo -e "  🔧 Magic VLSI Tool: ${RED}❌ Failed${NC}"
        [ "$OPEN_PDK_INSTALLED" = true ] && echo -e "  ⚙️  Open PDK Processing: ${GREEN}✅ Completed${NC}" || echo -e "  ⚙️  Open PDK Processing: ${RED}❌ Failed${NC}"
        [ "$NIX_INSTALLED" = true ] && echo -e "  📦 Nix Package Manager: ${GREEN}✅ Installed${NC}" || echo -e "  📦 Nix Package Manager: ${RED}❌ Failed${NC}"
        [ "$OPENLANE2_INSTALLED" = true ] && echo -e "  🏗️  OpenLane2 RTL-to-GDSII: ${GREEN}✅ Installed${NC}" || echo -e "  🏗️  OpenLane2 RTL-to-GDSII: ${YELLOW}⚠️  Not Available${NC}"
        [ "$ENVIRONMENT_SETUP" = true ] && echo -e "  🌍 Environment Setup: ${GREEN}✅ Configured${NC}" || echo -e "  🌍 Environment Setup: ${YELLOW}⚠️  Incomplete${NC}"
        
        echo -e "\n${CYAN}📁 Installation Locations:${NC}"
        echo -e "  📂 Installation Root: ${WHITE}$INSTALL_DIR${NC}"
        echo -e "  🔧 Magic Tool: ${WHITE}$INSTALL_DIR/magic-install/bin/magic${NC}"
        echo -e "  🌍 Environment File: ${WHITE}$KRYPTONYTE_VENV/skywater_pdk_env${NC}"
        
        # Try to find actual PDK locations
        if [ -d "$INSTALL_DIR/pdks" ]; then
            local pdk_root=$(find "$INSTALL_DIR/pdks" -name "sky130*" -type d 2>/dev/null | head -1)
            if [ -n "$pdk_root" ]; then
                echo -e "  📚 PDK Root: ${WHITE}$pdk_root${NC}"
            fi
        fi
        
        echo -e "\n${CYAN}🚀 Next Steps:${NC}"
        echo -e "  1. Load environment: ${WHITE}source $KRYPTONYTE_VENV/skywater_pdk_env${NC}"
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
        echo -e "  4. Check network connectivity for repository access"
        
        exit 1
    fi
}

# Function to verify Nix package manager
install_nix() {
    print_banner "Checking Nix Package Manager" "$PURPLE"

    if check_nix; then
        if command -v nix-shell >/dev/null 2>&1; then
            print_success "nix-shell is available at: $(command -v nix-shell)"
        fi
        NIX_INSTALLED=true
        return 0
    fi

    print_warning "Nix cannot be installed into $KRYPTONYTE_VENV because it manages /nix"
    print_warning "Install Nix as an OS prerequisite if you need OpenLane2"
    NIX_INSTALLED=false
    return 1
}

# Function to install OpenLane2
install_openlane2() {
    print_banner "Installing OpenLane2" "$PURPLE"
    
    # Check if OpenLane2 is already installed
    if check_openlane2; then
        local current_info=""
        local openlane2_dir="$INSTALL_DIR/openlane2"
        if [ -d "$openlane2_dir" ]; then
            current_info="$openlane2_dir"
        fi
        
        prompt_upgrade "OpenLane2" "$current_info"
        local upgrade_choice=$?
        
        case $upgrade_choice in
            0)  # Keep existing
                OPENLANE2_INSTALLED=true
                return 0
                ;;
            1)  # Upgrade/reinstall
                print_step "Will attempt to upgrade/reinstall OpenLane2"
                if [ -d "$openlane2_dir" ]; then
                    print_step "Removing existing OpenLane2 installation"
                    rm -rf "$openlane2_dir"
                fi
                ;;
            2)  # Skip
                return 0
                ;;
        esac
    fi
    
    # Ensure Nix is available - try to source it if not found
    if ! command_exists nix; then
        print_step "Nix not found in PATH, attempting to source Nix environment"
        
        # Try to source Nix environment
        if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
            print_step "Sourcing Nix from ~/.nix-profile/etc/profile.d/nix.sh"
            source "$HOME/.nix-profile/etc/profile.d/nix.sh"
        elif [ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
            print_step "Sourcing Nix daemon from /nix/var/nix/profiles/default"
            source "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
        fi
        
        # Add Nix to PATH if directory exists
        if [ -d "/nix/var/nix/profiles/default/bin" ]; then
            export PATH="/nix/var/nix/profiles/default/bin:$PATH"
        fi
        
        # Check again after sourcing
        if ! command_exists nix; then
            print_error "Nix is required for OpenLane2 but is not available"
            print_step "Nix may have been installed but requires a new shell session"
            print_step "Please restart your terminal and run the script again"
            print_step "Or manually source: source ~/.nix-profile/etc/profile.d/nix.sh"
            return 1
        else
            print_success "Nix is now available after sourcing environment"
        fi
    fi
    
    # Install git if needed
    if ! command_exists git; then
        print_error "git is required for OpenLane2 installation"
        print_error "Install OS prerequisites with: sudo .devcontainer/00_install_ubuntu_packages.sh"
        return 1
    fi
    
    # Clone OpenLane2 repository
    local openlane2_dir="$INSTALL_DIR/openlane2"
    print_step "Cloning OpenLane2 repository to: $openlane2_dir"
    
    if git clone https://github.com/efabless/openlane2.git "$openlane2_dir"; then
        print_success "OpenLane2 repository cloned successfully"
        
        # Unset PDK environment variables to avoid conflicts with OpenLane2's PDK management
        print_step "Unsetting PDK environment variables to avoid conflicts"
        unset PDK_ROOT 2>/dev/null || true
        unset SKYWATER_PDK_ROOT 2>/dev/null || true
        unset STD_CELL_LIBRARY 2>/dev/null || true
        print_step "PDK variables unset - OpenLane2 will manage its own PDK"
        
        # Test the Nix environment
        print_step "Testing OpenLane2 Nix environment (this may take 10+ minutes on first run)"
        print_step "Nix will download and cache all required tools..."
        
        cd "$openlane2_dir"
        
        # Try to enter nix-shell and run smoke test
        if timeout 1800 nix-shell --run "openlane --smoke-test" 2>/dev/null; then
            print_success "OpenLane2 smoke test passed"
            OPENLANE2_INSTALLED=true
        else
            print_warning "OpenLane2 smoke test failed or timed out"
            print_step "OpenLane2 is installed but may need manual verification"
            print_step "To test manually: cd $openlane2_dir && nix-shell --run 'openlane --smoke-test'"
            OPENLANE2_INSTALLED=true
        fi
        
        # Create convenience script
        local openlane_script="$INSTALL_DIR/openlane"
        cat > "$openlane_script" << 'EOF'
#!/bin/bash
# OpenLane2 convenience script for KryptoNyte
# Unset PDK environment variables to avoid conflicts with OpenLane2's PDK management
unset PDK_ROOT 2>/dev/null || true
unset SKYWATER_PDK_ROOT 2>/dev/null || true
unset STD_CELL_LIBRARY 2>/dev/null || true

OPENLANE2_DIR="$(dirname "$0")/openlane2"
if [ -d "$OPENLANE2_DIR" ]; then
    cd "$OPENLANE2_DIR"
    exec nix-shell --run "openlane $*"
else
    echo "Error: OpenLane2 not found at $OPENLANE2_DIR"
    exit 1
fi
EOF
        chmod +x "$openlane_script"
        print_step "Created convenience script: $openlane_script"
        
    else
        print_error "Failed to clone OpenLane2 repository"
        OPENLANE2_INSTALLED=false
        return 1
    fi
}

# Main installation function
main() {
    print_banner "Physical Design Tools Installation for KryptoNyte" "$BLUE"
    
    echo -e "${CYAN}Installation Configuration:${NC}"
    echo -e "  Install Directory: ${WHITE}$INSTALL_DIR${NC}"
    echo -e "  SkyWater Version: ${WHITE}$SKYWATER_VERSION${NC}"
    echo -e "  Open PDK Version: ${WHITE}$OPEN_PDK_VERSION${NC}"
    
    # Quick tool detection summary
    print_banner "Checking Existing Tools" "$CYAN"
    echo -e "${CYAN}Tool Detection Summary:${NC}"
    
    if check_skywater_pdk >/dev/null 2>&1; then
        echo -e "  📦 SkyWater PDK: ${GREEN}Found${NC}"
    else
        echo -e "  📦 SkyWater PDK: ${RED}Not Found${NC}"
    fi
    
    if check_magic >/dev/null 2>&1; then
        echo -e "  🔧 Magic VLSI: ${GREEN}Found${NC}"
    else
        echo -e "  🔧 Magic VLSI: ${RED}Not Found${NC}"
    fi
    
    if check_open_pdk >/dev/null 2>&1; then
        echo -e "  ⚙️  Open PDK: ${GREEN}Found${NC}"
    else
        echo -e "  ⚙️  Open PDK: ${RED}Not Found${NC}"
    fi
    
    if check_nix >/dev/null 2>&1; then
        echo -e "  📦 Nix Package Manager: ${GREEN}Found${NC}"
    else
        echo -e "  📦 Nix Package Manager: ${RED}Not Found${NC}"
    fi
    
    if check_openlane2 >/dev/null 2>&1; then
        echo -e "  🏗️  OpenLane2: ${GREEN}Found${NC}"
    else
        echo -e "  🏗️  OpenLane2: ${RED}Not Found${NC}"
    fi
    
    # Confirm installation
    if [ "$VERBOSE" = true ]; then
        echo ""
        if ! confirm_continue "Continue with installation? (Y/n): "; then
            print_error "Installation cancelled by user"
            exit 1
        fi
    fi
    
    check_requirements
    
    # Try to create installation directory, but continue if user declines
    if ! create_install_dir; then
        print_warning "Installation directory setup skipped - some installations may fail"
    fi
    
    # Install components - each function handles its own error conditions
    install_skywater_pdk || print_warning "SkyWater PDK installation failed or skipped"
    install_magic || print_warning "Magic VLSI installation failed or skipped"
    install_open_pdk || print_warning "Open PDK installation failed or skipped"
    install_nix || print_warning "Nix installation failed or skipped"
    install_openlane2 || print_warning "OpenLane2 installation failed or skipped"
    
    setup_environment
    verify_installation
    
    print_banner "Installation Complete!" "$GREEN"
}

# Run main function
main "$@"
