#!/bin/bash

# KryptoNyte Physical Design Flow with OpenLane2 (v2)
# Enhanced script with flexible JSON configuration system

set -e  # Exit on any error

# --- Path and Environment Setup ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
export RTL_DIR="$PROJECT_ROOT/rtl"
export PHYSICAL_DESIGN_DIR="$SCRIPT_DIR"

# --- Color Codes for Output ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# --- Print Functions ---
print_banner() { echo -e "\n${BLUE}============================================================\n${BLUE}$1\n${BLUE}============================================================${NC}"; }
print_step() { echo -e "${CYAN}▶${NC} $1"; }
print_success() { echo -e "${GREEN}✅${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠️${NC} $1"; }
print_error() { echo -e "${RED}❌${NC} $1"; exit 1; }

# --- Default Configuration ---
MODULE_NAME="ZeroNyteRV32ICore"
CONFIG_BASE_FILE="config.base.json"
CONFIG_MODULE_FILE=""
OUTPUT_ROOT="physical_design_v2"
OPENLANE2_PATH="${OPENLANE2_ROOT:-/opt/skywater-pdk/openlane2}"
VERBOSE=true

# --- Command-line Argument Parsing ---
while [[ $# -gt 0 ]]; do
    case $1 in
        --module-name) MODULE_NAME="$2"; shift 2 ;; 
        --config-base) CONFIG_BASE_FILE="$2"; shift 2 ;;
        --config-module) CONFIG_MODULE_FILE="$2"; shift 2 ;;
        --output-root) OUTPUT_ROOT="$2"; shift 2 ;;
        --openlane2-path) OPENLANE2_PATH="$2"; shift 2 ;;
        --quiet) VERBOSE=false; shift ;;
        --help|-h) cat << EOF
KryptoNyte Physical Design Flow v2

Usage: $0 [options]

Options:
  --module-name <name>    Module to process (default: ZeroNyteRV32ICore)
  --config-base <file>    Base JSON config (default: config.base.json)
  --config-module <file>  Module-specific JSON config (optional)
  --output-root <path>    Output directory (default: physical_design_v2)
  --openlane2-path <path> OpenLane2 directory (default: /opt/skywater-pdk/openlane2)
  --quiet                 Reduced verbosity
  --help, -h              Show this help message
EOF
            exit 0 ;;
        *) print_error "Unknown argument: $1" ;;
    esac
done

# --- Configuration Loading and Processing ---
load_config() {
    print_step "Loading and merging configurations..."

    # Determine module config file if not provided
    if [ -z "$CONFIG_MODULE_FILE" ]; then
        CONFIG_MODULE_FILE="config.${MODULE_NAME}.json"
    fi

    # Check for jq
    if ! command -v jq >/dev/null 2>&1; then
        print_error "jq is not installed. Please install it to process JSON configurations."
    fi

    # Check for config files
    [ ! -f "$CONFIG_BASE_FILE" ] && print_error "Base config file not found: $CONFIG_BASE_FILE"
    [ ! -f "$CONFIG_MODULE_FILE" ] && print_error "Module config file not found: $CONFIG_MODULE_FILE"

    # Merge configurations
    MERGED_CONFIG=$(jq -s '.[0] * .[1]' "$CONFIG_BASE_FILE" "$CONFIG_MODULE_FILE")
    export MERGED_CONFIG
    print_success "Configurations loaded and merged."
}

process_template() {
    print_step "Processing configuration template..."
    local template_file="config.template.json"
    [ ! -f "$template_file" ] && print_error "Template file not found: $template_file"

    # Export all variables from the merged config
    eval "$(echo "$MERGED_CONFIG" | jq -r 'paths(scalars) as $p | "export \($p | join("_") | ascii_upcase)=\"\(getpath($p))\""')"
    
    # Substitute environment variables in the template
    PROCESSED_CONFIG=$(envsubst < "$template_file")
    export PROCESSED_CONFIG
    print_success "Configuration template processed."
}

# --- Main Flow Functions ---
prepare_design_config() {
    print_step "Preparing OpenLane2 design configuration..."
    
    local design_dir="$RUNS_PATH/$MODULE_NAME"
    mkdir -p "$design_dir/src"

    # Write the final, processed config to the design directory
    echo "$PROCESSED_CONFIG" > "$design_dir/config.json"

    print_success "Design configuration prepared at: $design_dir"
}

run_openlane2_flow() {
    print_step "Running OpenLane2 flow..."
    local design_dir="$RUNS_PATH/$MODULE_NAME"
    local log_file="$REPORTS_PATH/openlane2_run.log"

    cd "$OPENLANE2_PATH"
    if [ "$VERBOSE" = true ]; then
        nix-shell --run "openlane $design_dir/config.json" 2>&1 | tee "$log_file"
    else
        nix-shell --run "openlane $design_dir/config.json" > "$log_file" 2>&1
    fi

    [ ${PIPESTATUS[0]} -ne 0 ] && print_error "OpenLane2 flow failed. Check log: $log_file"
    print_success "OpenLane2 flow completed successfully."
}

# --- Main Execution ---
main() {
    print_banner "Starting KryptoNyte OpenLane2 Physical Design Flow (v2) for $MODULE_NAME"

    # Setup paths
    export FULL_OUTPUT_ROOT="$(pwd)/$OUTPUT_ROOT"
    export RUNS_PATH="$FULL_OUTPUT_ROOT/runs"
    export REPORTS_PATH="$FULL_OUTPUT_ROOT/reports"
    mkdir -p "$RUNS_PATH" "$REPORTS_PATH"

    load_config
    process_template
    prepare_design_config
    run_openlane2_flow

    print_banner "Physical design flow completed successfully!"
}

main "$@"
