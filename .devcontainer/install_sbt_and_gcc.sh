#!/usr/bin/env bash
set -euo pipefail

#######################################
# KryptoNyte Basic Tools Installation
# Verifies GCC/build tools and installs SDKMAN with Java/SBT/Scala under .venv
#######################################

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
source "$SCRIPT_DIR/common_install.sh"

VERBOSE=true
UPGRADE_MODE=false
JAVA_VERSION="${JAVA_VERSION:-23.0.1-oracle}"
SCALA_VERSION="${SCALA_VERSION:-2.13.15}"

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
            echo "KryptoNyte Basic Tools Installation"
            echo ""
            echo "Options:"
            echo "  --quiet        Reduce output verbosity"
            echo "  --upgrade      Reinstall SDKMAN-managed tools"
            echo "  --help, -h     Show this help message"
            echo ""
            echo "Installs into the repo-local virtual environment:"
            echo "  - .venv/sdkman with Java $JAVA_VERSION, SBT, and Scala $SCALA_VERSION"
            echo ""
            echo "GCC/build tools are OS prerequisites supplied by the Dockerfile or"
            echo ".devcontainer/00_install_ubuntu_packages.sh."
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

print_warning() {
    local message="$1"
    echo -e "${YELLOW}⚠ Warning: $message${NC}"
}

check_build_tools() {
    print_step "Checking OS build prerequisites"
    require_commands gcc g++ make curl unzip zip || return 1

    local gcc_version
    gcc_version=$(gcc --version 2>/dev/null | head -1 || echo "gcc installed")
    print_success "Build tools available: $gcc_version"
}

check_sdkman_tools() {
    if [ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
        if SDKMAN_DIR="$SDKMAN_DIR" bash +u -c 'source "$SDKMAN_DIR/bin/sdkman-init.sh" && command -v java >/dev/null 2>&1 && command -v sbt >/dev/null 2>&1 && command -v scala >/dev/null 2>&1'; then
            print_step "Found SDKMAN tools in $SDKMAN_DIR"
            return 0
        fi

        print_step "Found SDKMAN in $SDKMAN_DIR, but Java/SBT/Scala are incomplete"
        return 1
    fi

    print_step "SDKMAN not found in $SDKMAN_DIR"
    return 1
}

install_sdkman_tools() {
    print_banner "INSTALLING SDKMAN WITH JAVA, SBT, AND SCALA" "$GREEN"

    ensure_local_venv

    if [ "$UPGRADE_MODE" = true ] && [ -d "$SDKMAN_DIR" ]; then
        print_step "Upgrade mode: removing existing SDKMAN directory"
        rm -rf "$SDKMAN_DIR"
    fi

    if ! check_sdkman_tools >/dev/null 2>&1; then
        print_step "Downloading SDKMAN into $SDKMAN_DIR"
        mkdir -p "$(dirname "$SDKMAN_DIR")"
        SDKMAN_DIR="$SDKMAN_DIR" bash +u -c 'curl -s "https://get.sdkman.io" | bash +u' || {
            print_error "Failed to install SDKMAN"
            return 1
        }
    fi

    print_step "Installing Java, SBT, and Scala via SDKMAN"
    SDKMAN_DIR="$SDKMAN_DIR" JAVA_VERSION="$JAVA_VERSION" SCALA_VERSION="$SCALA_VERSION" bash +u -c 'set -eo pipefail
        export SDKMAN_AUTO_ANSWER=true
        export SDKMAN_SELFUPDATE_FEATURE=false
        source "$SDKMAN_DIR/bin/sdkman-init.sh"
        command -v java >/dev/null 2>&1 || sdk install java "$JAVA_VERSION"
        command -v sbt >/dev/null 2>&1 || sdk install sbt
        command -v scala >/dev/null 2>&1 || sdk install scala "$SCALA_VERSION"
    ' || {
        print_error "Failed to install Java/Scala tools via SDKMAN"
        return 1
    }

    add_dev_env_to_shell_profile
    print_success "SDKMAN and Java/Scala tools installed under $SDKMAN_DIR"
}

verify_tools() {
    print_banner "INSTALLATION COMPLETE - VERIFYING TOOLS" "$WHITE"

    # shellcheck disable=SC1091
    source "$SCRIPT_DIR/dev_env.sh"

    echo ""
    echo -e "${GREEN}KryptoNyte Basic Tools Installation Complete${NC}"
    echo ""
    echo "Install locations:"
    echo "  Virtual environment: $KRYPTONYTE_VENV"
    echo "  SDKMAN:              $SDKMAN_DIR"
    echo ""
    echo "Installed tools:"

    if command -v gcc >/dev/null 2>&1; then
        local gcc_version
        gcc_version=$(gcc --version 2>/dev/null | head -1 || echo "gcc installed")
        echo "  ✓ GCC:    $gcc_version"
    else
        echo "  ⚠ GCC:    Not found"
    fi

    if command -v java >/dev/null 2>&1; then
        local java_version
        java_version=$(java --version 2>/dev/null | head -1 || echo "java installed")
        echo "  ✓ Java:   $java_version"
    else
        echo "  ⚠ Java:   Not found"
    fi

    if command -v scala >/dev/null 2>&1; then
        local scala_version
        scala_version=$(timeout 5 scala --version 2>&1 | head -1 || echo "scala installed")
        echo "  ✓ Scala:  $scala_version"
    else
        echo "  ⚠ Scala:  Not found"
    fi

    if command -v sbt >/dev/null 2>&1; then
        local sbt_version
        sbt_version=$(timeout 10 sbt --version 2>/dev/null | grep "sbt runner version" | head -1 || echo "sbt installed")
        echo "  ✓ SBT:    $sbt_version"
    else
        echo "  ⚠ SBT:    Not found"
    fi

    echo ""
    echo "To load this environment in the current shell:"
    echo "  source .devcontainer/dev_env.sh"
}

main() {
    print_banner "KRYPTONYTE BASIC TOOLS INSTALLATION" "$WHITE"
    echo -e "${CYAN}Installation Configuration:${NC}"
    echo "  Virtual environment: $KRYPTONYTE_VENV"
    echo "  SDKMAN directory:    $SDKMAN_DIR"
    echo "  Verbose output:      $VERBOSE"
    echo "  Upgrade mode:        $UPGRADE_MODE"

    if [ "$VERBOSE" = true ]; then
        echo ""
        if ! confirm_continue "Continue with installation? (Y/n): "; then
            print_error "Installation cancelled by user"
            exit 1
        fi
    fi

    check_build_tools
    ensure_local_venv

    if [ "$UPGRADE_MODE" = true ] || ! check_sdkman_tools >/dev/null 2>&1; then
        install_sdkman_tools
    else
        print_success "SDKMAN tools already installed in $SDKMAN_DIR - skipping"
        add_dev_env_to_shell_profile
    fi

    verify_tools
    print_success "Basic tools successfully installed and configured"
}

main "$@"
