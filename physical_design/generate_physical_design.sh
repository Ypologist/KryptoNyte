#!/bin/bash

# KryptoNyte Physical Design Flow with OpenLane2
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
MODULE_NAME="TetraNyteRV32ICore"
CONFIG_BASE_FILE="config.base.json"
CONFIG_MODULE_FILE=""
OUTPUT_ROOT="${OPENLANE_OUTPUT_ROOT:-/tmp/kryptonyte_openlane_${USER}}"
OPENLANE2_PATH="${OPENLANE2_ROOT:-/opt/skywater-pdk/openlane2}"
VERBOSE=true
USE_SUDO=false

# Export environment variables for template substitution
export MODULE_NAME
export CLOCK_PORT="clock"
export CLOCK_PERIOD="10.0"
export CORE_UTILIZATION="0.7"
export ASPECT_RATIO="1.0"
export PDK_VARIANT="sky130_fd_sc_hd"
export SYNTHESIS_STRATEGY="AREA 0"
export ROUTING_STRATEGY="0"
export GENERATE_GDS="true"
export RUN_DRC="true"

# --- Command-line Argument Parsing ---
while [[ $# -gt 0 ]]; do
    case $1 in
        --module-name) MODULE_NAME="$2"; export MODULE_NAME; shift 2 ;; 
        --config-base) CONFIG_BASE_FILE="$2"; shift 2 ;;
        --config-module) CONFIG_MODULE_FILE="$2"; shift 2 ;;
        --output-root) OUTPUT_ROOT="$2"; shift 2 ;;
        --openlane2-path) OPENLANE2_PATH="$2"; shift 2 ;;
        --clock-period) CLOCK_PERIOD="$2"; export CLOCK_PERIOD; shift 2 ;;
        --utilization) CORE_UTILIZATION="$2"; export CORE_UTILIZATION; shift 2 ;;
        --use-sudo) USE_SUDO=true; shift ;;
        --quiet) VERBOSE=false; shift ;;
        --help|-h) cat << EOF
KryptoNyte Physical Design Flow

Usage: $0 [options]

Options:
  --module-name <name>    Module to process (default: TetraNyteRV32ICore)
  --config-base <file>    Base JSON config (default: config.base.json)
  --config-module <file>  Module-specific JSON config (optional)
  --output-root <path>    Output directory (default: /tmp/kryptonyte_openlane_\$USER)
  --openlane2-path <path> OpenLane2 directory (default: /opt/skywater-pdk/openlane2)
  --clock-period <ns>     Clock period in nanoseconds (default: 10.0)
  --utilization <ratio>   Core utilization ratio (default: 0.7)
  --use-sudo              Run nix-shell/openlane through sudo
  --quiet                 Reduced verbosity
  --help, -h              Show this help message

Examples:
  ./generate_physical_design.sh
  ./generate_physical_design.sh --module-name TetraNyteRV32ICore --clock-period 8.0
  ./generate_physical_design.sh --use-sudo
EOF
            exit 0 ;;
        *) print_error "Unknown argument: $1" ;;
    esac
done

# --- Configuration Loading and Processing ---
load_and_process_config() {
    print_step "Loading and processing configurations..."
    local module_config_is_default=false

    # Determine module config file if not provided
    if [ -z "$CONFIG_MODULE_FILE" ]; then
        CONFIG_MODULE_FILE="config.${MODULE_NAME}.json"
        module_config_is_default=true
    fi

    # Check for jq
    if ! command -v jq >/dev/null 2>&1; then
        print_error "jq is not installed. Please install it to process JSON configurations."
    fi

    # Check for config files
    [ ! -f "$CONFIG_BASE_FILE" ] && print_error "Base config file not found: $CONFIG_BASE_FILE"

    if [ -f "$CONFIG_MODULE_FILE" ]; then
        # Merge configurations (module config overrides base config)
        MERGED_CONFIG=$(jq -s '.[0] * .[1]' "$CONFIG_BASE_FILE" "$CONFIG_MODULE_FILE")
        print_success "Configurations loaded and merged."
        return
    fi

    if [ "$module_config_is_default" != true ]; then
        print_error "Module config file not found: $CONFIG_MODULE_FILE"
    fi

    local pnr_sdc_exists=false
    local signoff_sdc_exists=false
    [ -f "constraints/${MODULE_NAME}.sdc" ] && pnr_sdc_exists=true
    [ -f "constraints/${MODULE_NAME}_signoff.sdc" ] && signoff_sdc_exists=true

    local generated_module_config
    generated_module_config=$(jq -n \
        --arg module_name "$MODULE_NAME" \
        --arg verilog_file "dir::src/${MODULE_NAME}.v" \
        --arg clock_port "$CLOCK_PORT" \
        --arg clock_period "$CLOCK_PERIOD" \
        --arg core_utilization "$CORE_UTILIZATION" \
        --arg aspect_ratio "$ASPECT_RATIO" \
        --arg pdk_variant "$PDK_VARIANT" \
        --arg pnr_sdc_file "dir::constraints/${MODULE_NAME}.sdc" \
        --arg signoff_sdc_file "dir::constraints/${MODULE_NAME}_signoff.sdc" \
        --argjson include_pnr_sdc "$pnr_sdc_exists" \
        --argjson include_signoff_sdc "$signoff_sdc_exists" '
        {
          DESIGN_NAME: $module_name,
          VERILOG_FILES: [$verilog_file],
          CLOCK_PORT: $clock_port,
          CLOCK_PERIOD: ($clock_period | tonumber),
          FP_CORE_UTIL: ($core_utilization | tonumber),
          FP_ASPECT_RATIO: ($aspect_ratio | tonumber),
          STD_CELL_LIBRARY: $pdk_variant
        }
        + (if $include_pnr_sdc then {PNR_SDC_FILE: $pnr_sdc_file} else {} end)
        + (if $include_signoff_sdc then {SIGNOFF_SDC_FILE: $signoff_sdc_file} else {} end)
    ')

    MERGED_CONFIG=$(jq -s --argjson module_config "$generated_module_config" '.[0] * $module_config' "$CONFIG_BASE_FILE")

    print_warning "Module config file not found: $CONFIG_MODULE_FILE. Generated a default module config for $MODULE_NAME."
    if [ "$pnr_sdc_exists" != true ] || [ "$signoff_sdc_exists" != true ]; then
        print_warning "Module-specific SDC files were not found for $MODULE_NAME; the flow will use JSON clock settings only."
    fi
    print_success "Base configuration loaded with generated module defaults."
}

# --- Main Flow Functions ---
prepare_design_config() {
    print_step "Preparing OpenLane2 design configuration..."
    
    local design_dir="$RUNS_PATH/$MODULE_NAME"
    local src_dir="$design_dir/src"
    mkdir -p "$src_dir"

    # Copy RTL file to design source directory
    local input_rtl="../rtl/generators/generated/verilog_hierarchical_timed/${MODULE_NAME}.v"
    local target_rtl="$src_dir/${MODULE_NAME}.v"
    
    if [ -f "$input_rtl" ]; then
        cp "$input_rtl" "$target_rtl"
        print_success "RTL file copied: $input_rtl -> $target_rtl"
    else
        print_error "RTL file not found: $input_rtl. Please generate RTL first."
    fi

    # Copy constraint files if they exist
    if [ -d "constraints" ]; then
        cp -r constraints "$design_dir/"
        print_success "Constraint files copied to design directory"
    fi

    # Write the merged config to the design directory
    echo "$MERGED_CONFIG" > "$design_dir/config.json"

    print_success "Design configuration prepared at: $design_dir"
    
    # Debug: Show the final config
    if [ "$VERBOSE" = true ]; then
        print_step "Final configuration:"
        echo "$MERGED_CONFIG" | jq '.'
    fi
}

validate_configuration() {
    print_step "Validating configuration..."
    
    # Check OpenLane2 installation
    if [ -d "$OPENLANE2_PATH" ]; then
        OPENLANE2_SHELL_NIX="$OPENLANE2_PATH/shell.nix"
        if [ ! -f "$OPENLANE2_SHELL_NIX" ]; then
            print_error "OpenLane2 shell.nix not found at: $OPENLANE2_SHELL_NIX"
        fi
    elif [ -f "$OPENLANE2_PATH" ]; then
        case "$OPENLANE2_PATH" in
            */shell.nix|shell.nix)
                OPENLANE2_SHELL_NIX="$OPENLANE2_PATH"
                ;;
            *)
                print_error "OpenLane2 path points to a file, but it is not shell.nix: $OPENLANE2_PATH"
                ;;
        esac
    else
        print_error "OpenLane2 path does not exist: $OPENLANE2_PATH"
    fi
    
    # Check nix-shell availability
    if ! command -v nix-shell >/dev/null 2>&1; then
        print_error "nix-shell not found - required for OpenLane2"
    fi

    # Warn when daemon socket likely needs elevated privileges
    if [ "$USE_SUDO" != true ] && [ -d "/nix/var/nix/daemon-socket" ] && ! id -nG | grep -qw "nix-users"; then
        print_warning "User '$USER' is not in nix-users; nix-shell may fail. Retry with --use-sudo or add your user to nix-users."
    fi
    
    # Check RTL file exists
    local input_rtl="../rtl/generators/generated/verilog_hierarchical_timed/${MODULE_NAME}.v"
    if [ ! -f "$input_rtl" ]; then
        print_error "RTL file not found: $input_rtl. Please generate RTL first using the RTL generation scripts."
    fi
    
    print_success "Configuration validated"
}

run_openlane2_flow() {
    print_step "Running OpenLane2 flow..."
    local design_dir="$RUNS_PATH/$MODULE_NAME"
    local log_file="$REPORTS_PATH/openlane2_run.log"

    # Unset PDK environment variables to avoid conflicts
    unset PDK_ROOT 2>/dev/null || true
    unset SKYWATER_PDK_ROOT 2>/dev/null || true
    unset STD_CELL_LIBRARY 2>/dev/null || true

    print_step "Running OpenLane2 (this may take 30+ minutes)..."
    print_step "Design directory: $design_dir"
    print_step "Log file: $log_file"

    # Avoid nix-shell fallback lookup of <nixpkgs>.bashInteractive on systems
    # without configured channels/NIX_PATH.
    local nix_build_shell="${NIX_BUILD_SHELL:-$(command -v bash)}"
    local openlane_run_cmd="cd \"$design_dir\" && python3 \"$PHYSICAL_DESIGN_DIR/run_custom_floorplan.py\" config.json"
    local nix_cmd=(env "NIX_BUILD_SHELL=$nix_build_shell" nix-shell --pure "$OPENLANE2_SHELL_NIX" --run "$openlane_run_cmd")
    if [ "$USE_SUDO" = true ]; then
        nix_cmd=(sudo env "NIX_BUILD_SHELL=$nix_build_shell" nix-shell --pure "$OPENLANE2_SHELL_NIX" --run "$openlane_run_cmd")
    fi
    local exit_code=0
    if [ "$VERBOSE" = true ]; then
        "${nix_cmd[@]}" 2>&1 | tee "$log_file"
        exit_code=${PIPESTATUS[0]}
    else
        "${nix_cmd[@]}" > "$log_file" 2>&1
        exit_code=$?
    fi
    if [ $exit_code -ne 0 ]; then
        print_error "OpenLane2 flow failed with exit code $exit_code. Check log: $log_file"
    fi
    print_success "OpenLane2 flow completed successfully."
    
}

generate_final_reports() {
    print_step "Generating final reports..."
    
    local design_dir="$RUNS_PATH/$MODULE_NAME"
    local results_dir="$design_dir/results/final"
    local report_file="$REPORTS_PATH/final_report.md"
    
    # Check for output files
    local gds_file="$results_dir/gds/$MODULE_NAME.gds"
    local def_file="$results_dir/def/$MODULE_NAME.def"
    local netlist_file="$results_dir/verilog/gl/$MODULE_NAME.v"
    local sdf_file="$results_dir/sdf/$MODULE_NAME.sdf"
    
    # Calculate frequency
    local frequency=$(echo "scale=2; 1000.0 / $CLOCK_PERIOD" | bc -l)
    
    cat > "$report_file" << EOF
# KryptoNyte OpenLane2 Physical Design Report

## Design Information
- **Module Name**: $MODULE_NAME
- **Clock Period**: $CLOCK_PERIOD ns ($frequency MHz)
- **Core Utilization**: $CORE_UTILIZATION
- **Aspect Ratio**: $ASPECT_RATIO
- **PDK Variant**: $PDK_VARIANT

## Flow Summary
- **Synthesis**: ✅ Completed
- **Floorplan**: ✅ Completed
- **Placement**: ✅ Completed
- **Clock Tree Synthesis**: ✅ Completed
- **Routing**: ✅ Completed
- **Signoff**: ✅ Completed
- **GDS Generation**: ✅ Completed

## Output Files
- **Gate-Level Netlist**: $([ -f "$netlist_file" ] && echo "✅ $netlist_file" || echo "❌ Not generated")
- **Standard Delay Format**: $([ -f "$sdf_file" ] && echo "✅ $sdf_file" || echo "❌ Not generated")
- **Final DEF Layout**: $([ -f "$def_file" ] && echo "✅ $def_file" || echo "❌ Not generated")
- **GDS-II Layout**: $([ -f "$gds_file" ] && echo "✅ $gds_file" || echo "❌ Not generated")

## OpenLane2 Results Directory
- **Full Results**: $results_dir
- **Reports**: $design_dir/reports
- **Logs**: $design_dir/logs

Generated on: $(date)
Generated by: KryptoNyte OpenLane2 Physical Design Flow
EOF
    
    print_success "Final report generated: $report_file"
    
    # Print summary of key files
    if [ -f "$gds_file" ]; then
        print_success "GDS-II layout: $gds_file"
    fi
    if [ -f "$netlist_file" ]; then
        print_success "Gate-level netlist: $netlist_file"
    fi
    if [ -f "$sdf_file" ]; then
        print_success "SDF timing file: $sdf_file"
    fi
}

# --- Main Execution ---
main() {
    print_banner "Starting KryptoNyte OpenLane2 Physical Design Flow for $MODULE_NAME"

    # Normalize execution location so run/report paths can stay relative.
    cd "$PHYSICAL_DESIGN_DIR"

    # Setup paths
    export FULL_OUTPUT_ROOT="$OUTPUT_ROOT"
    export RUNS_PATH="$FULL_OUTPUT_ROOT/runs"
    export REPORTS_PATH="$FULL_OUTPUT_ROOT/reports"
    mkdir -p "$RUNS_PATH" "$REPORTS_PATH"

    validate_configuration
    load_and_process_config
    prepare_design_config
    run_openlane2_flow
    generate_final_reports

    print_banner "Physical design flow completed successfully!"
    echo -e "${GREEN}Results directory: $RUNS_PATH${NC}"
    if [ -f "$RUNS_PATH/$MODULE_NAME/results/final/gds/$MODULE_NAME.gds" ]; then
        echo -e "${GREEN}GDS-II file: $RUNS_PATH/$MODULE_NAME/results/final/gds/$MODULE_NAME.gds${NC}"
    fi
}

main "$@"
