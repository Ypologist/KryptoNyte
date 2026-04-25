#!/usr/bin/env bash
set -euo pipefail

#######################################
# KryptoNyte RTL Development Tools Installation
# Installs repo-owned RTL tools into .venv and verifies OS prerequisites
#######################################

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
source "$SCRIPT_DIR/common_install.sh"

VERBOSE=true
UPGRADE_MODE=false

FIRTOOL_BIN="$KRYPTONYTE_VENV/bin/firtool"
SV2V_BIN="$KRYPTONYTE_VENV/bin/sv2v"
OSS_CAD_DIR="$KRYPTONYTE_TOOLS_DIR/oss-cad-suite"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

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
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "KryptoNyte RTL Development Tools Installation"
            echo ""
            echo "Options:"
            echo "  --quiet        Reduce output verbosity"
            echo "  --upgrade      Force reinstall of repo-owned tools"
            echo "  --help, -h     Show this help message"
            echo ""
            echo "Installs into the repo-local virtual environment:"
            echo "  - firtool:        .venv/bin/firtool"
            echo "  - sv2v:           .venv/bin/sv2v"
            echo "  - OSS-CAD Suite:  .venv/tools/oss-cad-suite"
            echo "  - netlistsvg:     npm global prefix .venv"
            echo ""
            echo "Verilator, Node.js/npm, rsvg-convert, and Inkscape are OS prerequisites"
            echo "supplied by the Dockerfile or .devcontainer/00_install_ubuntu_packages.sh."
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

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

print_step() {
    local message="$1"
    local color="${2:-$CYAN}"

    if [ "$VERBOSE" = true ]; then
        echo -e "\n${color}▶ $message${NC}"
    fi
}

print_success() {
    local message="$1"
    echo -e "${GREEN}✓ $message${NC}"
}

print_error() {
    local message="$1"
    echo -e "${RED}✗ Error: $message${NC}" >&2
}

check_verilator() {
    if command -v verilator >/dev/null 2>&1; then
        print_step "Found Verilator: $(verilator --version 2>/dev/null | head -1)"
        return 0
    fi

    print_step "Verilator not found"
    return 1
}

check_firtool() {
    if [ -x "$FIRTOOL_BIN" ]; then
        print_step "Found firtool: $($FIRTOOL_BIN --version 2>/dev/null | head -1)"
        return 0
    fi

    print_step "firtool not found in $KRYPTONYTE_VENV/bin"
    return 1
}

check_oss_cad_suite() {
    if [ -x "$OSS_CAD_DIR/bin/yosys" ]; then
        print_step "Found OSS-CAD Suite: $("$OSS_CAD_DIR/bin/yosys" -V 2>/dev/null | head -1)"
        return 0
    fi

    print_step "OSS-CAD Suite not found in $OSS_CAD_DIR"
    return 1
}

check_nodejs_tools() {
    if command -v node >/dev/null 2>&1 && command -v npm >/dev/null 2>&1 && command -v netlistsvg >/dev/null 2>&1; then
        print_step "Found Node.js: $(node --version 2>/dev/null) (npm: $(npm --version 2>/dev/null))"
        print_step "Found netlistsvg"
        return 0
    fi

    print_step "Node.js tools not found or incomplete"
    return 1
}

check_sv2v() {
    if [ -x "$SV2V_BIN" ]; then
        print_step "Found sv2v: $($SV2V_BIN --version 2>/dev/null | head -1)"
        return 0
    fi

    print_step "sv2v not found in $KRYPTONYTE_VENV/bin"
    return 1
}

check_graphics_tools() {
    if command -v rsvg-convert >/dev/null 2>&1 && command -v inkscape >/dev/null 2>&1; then
        print_step "Found graphics tools"
        return 0
    fi

    print_step "Graphics tools not found or incomplete"
    return 1
}

install_firtool() {
    print_banner "INSTALLING FIRRTL TOOLS (FIRTOOL)" "$PURPLE"
    require_commands curl jq wget tar find chmod || return 1
    ensure_local_venv

    print_step "Fetching latest FIRRTL tools release"
    local firtool_url
    firtool_url=$(curl -s https://api.github.com/repos/llvm/circt/releases/latest | \
        jq -r '.assets[] | select(.name == "firrtl-bin-linux-x64.tar.gz") | .browser_download_url')

    if [ -z "$firtool_url" ] || [ "$firtool_url" = "null" ]; then
        print_error "Failed to fetch FIRRTL tools release information"
        return 1
    fi

    rm -rf /tmp/kryptonyte-firtool /tmp/kryptonyte-firtool.tar.gz
    mkdir -p /tmp/kryptonyte-firtool

    print_step "Downloading FIRRTL tools"
    wget --no-check-certificate "$firtool_url" -O /tmp/kryptonyte-firtool.tar.gz

    print_step "Extracting FIRRTL tools"
    tar -xzf /tmp/kryptonyte-firtool.tar.gz -C /tmp/kryptonyte-firtool

    local firtool_path
    firtool_path=$(find /tmp/kryptonyte-firtool -type f -name firtool -executable 2>/dev/null | head -1)
    if [ -z "$firtool_path" ]; then
        print_error "firtool binary not found in extracted archive"
        rm -rf /tmp/kryptonyte-firtool /tmp/kryptonyte-firtool.tar.gz
        return 1
    fi

    print_step "Installing firtool to $FIRTOOL_BIN"
    mv "$firtool_path" "$FIRTOOL_BIN"
    chmod +x "$FIRTOOL_BIN"
    rm -rf /tmp/kryptonyte-firtool /tmp/kryptonyte-firtool.tar.gz

    print_success "FIRRTL tools installed"
    "$FIRTOOL_BIN" --version | head -1
}

install_oss_cad_suite() {
    print_banner "INSTALLING OSS-CAD SUITE (YOSYS, NEXTPNR, ETC.)" "$CYAN"
    require_commands curl jq wget tar || return 1
    ensure_local_venv

    print_step "Fetching latest OSS-CAD Suite release"
    local oss_cad_url
    oss_cad_url=$(curl -s https://api.github.com/repos/YosysHQ/oss-cad-suite-build/releases/latest | \
        jq -r '.assets[] | select(.name | contains("linux-x64")) | .browser_download_url' | head -1)

    if [ -z "$oss_cad_url" ] || [ "$oss_cad_url" = "null" ]; then
        print_error "Failed to fetch OSS-CAD Suite release information"
        return 1
    fi

    rm -rf "$OSS_CAD_DIR" /tmp/kryptonyte-oss-cad-suite.tar.xz
    mkdir -p "$OSS_CAD_DIR"

    print_step "Downloading OSS-CAD Suite"
    wget --no-check-certificate "$oss_cad_url" -O /tmp/kryptonyte-oss-cad-suite.tar.xz

    print_step "Installing OSS-CAD Suite to $OSS_CAD_DIR"
    tar -xf /tmp/kryptonyte-oss-cad-suite.tar.xz -C "$OSS_CAD_DIR" --strip-components=1
    rm -f /tmp/kryptonyte-oss-cad-suite.tar.xz

    export PATH="$OSS_CAD_DIR/bin:$PATH"
    print_success "OSS-CAD Suite installed"
    "$OSS_CAD_DIR/bin/yosys" -V | head -1
}

install_nodejs_tools() {
    print_banner "INSTALLING NODE.JS TOOLS" "$GREEN"
    require_commands node npm || return 1
    ensure_local_venv

    export NPM_CONFIG_PREFIX="$KRYPTONYTE_VENV"
    export npm_config_prefix="$KRYPTONYTE_VENV"
    export PATH="$KRYPTONYTE_VENV/bin:$PATH"

    print_step "Installing netlistsvg into $KRYPTONYTE_VENV"
    npm install -g netlistsvg

    print_success "Node.js tools installed"
    node --version
    npm --version
}

install_sv2v() {
    print_banner "INSTALLING SV2V SYSTEMVERILOG CONVERTER" "$BLUE"
    require_commands curl jq wget unzip find chmod || return 1
    ensure_local_venv

    print_step "Fetching latest sv2v release"
    local sv2v_url
    sv2v_url=$(curl -s https://api.github.com/repos/zachjs/sv2v/releases/latest | \
        jq -r '.assets[] | select(.name == "sv2v-Linux.zip") | .browser_download_url')

    if [ -z "$sv2v_url" ] || [ "$sv2v_url" = "null" ]; then
        print_error "Failed to fetch sv2v release information"
        return 1
    fi

    rm -rf /tmp/kryptonyte-sv2v /tmp/kryptonyte-sv2v.zip
    mkdir -p /tmp/kryptonyte-sv2v

    print_step "Downloading sv2v"
    wget "$sv2v_url" -O /tmp/kryptonyte-sv2v.zip

    print_step "Extracting sv2v"
    unzip /tmp/kryptonyte-sv2v.zip -d /tmp/kryptonyte-sv2v

    local sv2v_path
    sv2v_path=$(find /tmp/kryptonyte-sv2v -type f -name sv2v -executable 2>/dev/null | head -1)
    if [ -z "$sv2v_path" ]; then
        print_error "sv2v binary not found in extracted archive"
        rm -rf /tmp/kryptonyte-sv2v /tmp/kryptonyte-sv2v.zip
        return 1
    fi

    print_step "Installing sv2v to $SV2V_BIN"
    mv "$sv2v_path" "$SV2V_BIN"
    chmod +x "$SV2V_BIN"
    rm -rf /tmp/kryptonyte-sv2v /tmp/kryptonyte-sv2v.zip

    print_success "sv2v installed"
    "$SV2V_BIN" --version | head -1
}

verify_prerequisites() {
    print_banner "CHECKING OS PREREQUISITES" "$CYAN"
    require_commands curl jq wget tar unzip find chmod || return 1

    if ! check_verilator >/dev/null 2>&1; then
        print_error "Verilator is an OS prerequisite. Install it with .devcontainer/00_install_ubuntu_packages.sh."
        return 1
    fi

    if ! check_graphics_tools >/dev/null 2>&1; then
        print_error "rsvg-convert and Inkscape are OS prerequisites. Install them with .devcontainer/00_install_ubuntu_packages.sh."
        return 1
    fi

    require_commands node npm || return 1
    print_success "OS prerequisites available"
}

print_detection_summary() {
    print_banner "Checking Existing Tools" "$CYAN"
    echo -e "${CYAN}Tool Detection Summary:${NC}"

    check_verilator >/dev/null 2>&1 && echo -e "  Verilator:      ${GREEN}Found${NC}" || echo -e "  Verilator:      ${RED}Not Found${NC}"
    check_firtool >/dev/null 2>&1 && echo -e "  firtool:        ${GREEN}Found${NC}" || echo -e "  firtool:        ${RED}Not Found${NC}"
    check_oss_cad_suite >/dev/null 2>&1 && echo -e "  OSS-CAD Suite:  ${GREEN}Found${NC}" || echo -e "  OSS-CAD Suite:  ${RED}Not Found${NC}"
    check_nodejs_tools >/dev/null 2>&1 && echo -e "  netlistsvg:     ${GREEN}Found${NC}" || echo -e "  netlistsvg:     ${RED}Not Found${NC}"
    check_sv2v >/dev/null 2>&1 && echo -e "  sv2v:           ${GREEN}Found${NC}" || echo -e "  sv2v:           ${RED}Not Found${NC}"
    check_graphics_tools >/dev/null 2>&1 && echo -e "  Graphics tools: ${GREEN}Found${NC}" || echo -e "  Graphics tools: ${RED}Not Found${NC}"
}

main() {
    print_banner "KRYPTONYTE RTL DEVELOPMENT TOOLS INSTALLATION" "$WHITE"
    echo -e "${CYAN}Installation Configuration:${NC}"
    echo "  Virtual environment: $KRYPTONYTE_VENV"
    echo "  Tools directory:      $KRYPTONYTE_TOOLS_DIR"
    echo "  Verbose output:       $VERBOSE"
    echo "  Upgrade mode:         $UPGRADE_MODE"

    print_detection_summary

    if [ "$VERBOSE" = true ]; then
        echo ""
        if ! confirm_continue "Continue with installation? (Y/n): "; then
            print_error "Installation cancelled by user"
            exit 1
        fi
    fi

    ensure_local_venv
    add_dev_env_to_shell_profile
    verify_prerequisites

    local install_count=0
    local skip_count=0

    if [ "$UPGRADE_MODE" = true ] || ! check_firtool >/dev/null 2>&1; then
        [ "$UPGRADE_MODE" = true ] && rm -f "$FIRTOOL_BIN"
        install_firtool
        install_count=$((install_count + 1))
    else
        print_success "firtool already installed - skipping"
        skip_count=$((skip_count + 1))
    fi

    if [ "$UPGRADE_MODE" = true ] || ! check_oss_cad_suite >/dev/null 2>&1; then
        install_oss_cad_suite
        install_count=$((install_count + 1))
    else
        print_success "OSS-CAD Suite already installed - skipping"
        skip_count=$((skip_count + 1))
    fi

    if [ "$UPGRADE_MODE" = true ] || ! check_nodejs_tools >/dev/null 2>&1; then
        install_nodejs_tools
        install_count=$((install_count + 1))
    else
        print_success "Node.js tools already installed - skipping"
        skip_count=$((skip_count + 1))
    fi

    if [ "$UPGRADE_MODE" = true ] || ! check_sv2v >/dev/null 2>&1; then
        [ "$UPGRADE_MODE" = true ] && rm -f "$SV2V_BIN"
        install_sv2v
        install_count=$((install_count + 1))
    else
        print_success "sv2v already installed - skipping"
        skip_count=$((skip_count + 1))
    fi

    print_banner "INSTALLATION COMPLETE - VERIFYING TOOLS" "$WHITE"
    echo ""
    echo -e "${GREEN}KryptoNyte RTL Development Tools Installation Complete${NC}"
    echo ""
    echo "Installation Summary:"
    echo "  Tools installed: $install_count"
    echo "  Tools skipped:   $skip_count"
    echo ""
    echo "Install locations:"
    echo "  firtool:       $FIRTOOL_BIN"
    echo "  sv2v:          $SV2V_BIN"
    echo "  OSS-CAD Suite: $OSS_CAD_DIR"
    echo "  npm prefix:    $KRYPTONYTE_VENV"
    echo ""
    echo "To load this environment in the current shell:"
    echo "  source .devcontainer/dev_env.sh"

    print_success "RTL development tools successfully installed and configured"
}

main "$@"
