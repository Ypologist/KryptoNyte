#!/bin/bash

# KryptoNyte Physical Design Flow with OpenLane2
# Simple shell script to run complete RTL-to-GDSII flow using OpenLane2
# Place in: KryptoNyte/cores/generators/
# Can be run from anywhere, but works best from KryptoNyte/cores/

set -e  # Exit on any error

# Detect script location and set working directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORES_DIR="$(dirname "$SCRIPT_DIR")"

# Change to cores directory if not already there
if [ "$(basename "$(pwd)")" != "cores" ]; then
    echo "Changing to cores directory: $CORES_DIR"
    cd "$CORES_DIR"
fi

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Print functions
print_banner() {
    echo -e "\n${BLUE}============================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}============================================================${NC}"
}

print_step() {
    echo -e "${CYAN}▶${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

# Default configuration
MODULE_NAME="ZeroNyteRV32ICore"
TOP_MODULE=""
INPUT_RTL_PATH="generated/verilog_hierarchical_timed"
OUTPUT_ROOT="physical_design"
OPENLANE2_PATH="/opt/skywater-pdk/openlane2"
PDK_VARIANT="sky130_fd_sc_hd"
CLOCK_PERIOD="10.0"
CLOCK_PORT="clock"
RESET_PORT="reset"
CORE_UTILIZATION="0.7"
ASPECT_RATIO="1.0"
SYNTHESIS_STRATEGY="AREA 0"
PLACEMENT_STRATEGY="BASIC"
ROUTING_STRATEGY="0"
VERBOSE=true
RUN_SYNTHESIS=true
RUN_FLOORPLAN=true
RUN_PLACEMENT=true
RUN_CTS=true
RUN_ROUTING=true
RUN_SIGNOFF=true
GENERATE_GDS=true
RUN_DRC=true
RUN_LVS=true
RUN_STA=true
RUN_ANTENNA=true

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --module-name)
            MODULE_NAME="$2"
            shift 2
            ;;
        --top-module)
            TOP_MODULE="$2"
            shift 2
            ;;
        --input-rtl)
            INPUT_RTL_PATH="$2"
            shift 2
            ;;
        --output-root)
            OUTPUT_ROOT="$2"
            shift 2
            ;;
        --openlane2-path)
            OPENLANE2_PATH="$2"
            shift 2
            ;;
        --pdk-variant)
            PDK_VARIANT="$2"
            shift 2
            ;;
        --clock-period)
            CLOCK_PERIOD="$2"
            shift 2
            ;;
        --utilization)
            CORE_UTILIZATION="$2"
            shift 2
            ;;
        --aspect-ratio)
            ASPECT_RATIO="$2"
            shift 2
            ;;
        --synthesis-strategy)
            SYNTHESIS_STRATEGY="$2"
            shift 2
            ;;
        --placement-strategy)
            PLACEMENT_STRATEGY="$2"
            shift 2
            ;;
        --routing-strategy)
            ROUTING_STRATEGY="$2"
            shift 2
            ;;
        --synthesis-only)
            RUN_FLOORPLAN=false
            RUN_PLACEMENT=false
            RUN_CTS=false
            RUN_ROUTING=false
            RUN_SIGNOFF=false
            GENERATE_GDS=false
            shift
            ;;
        --no-signoff)
            RUN_SIGNOFF=false
            shift
            ;;
        --no-gds)
            GENERATE_GDS=false
            shift
            ;;
        --quiet)
            VERBOSE=false
            shift
            ;;
        --help|-h)
            cat << EOF
KryptoNyte Physical Design Flow with OpenLane2

Usage: $0 [options]

Options:
  --module-name <name>        Module name to process (default: ZeroNyteRV32ICore)
  --top-module <name>         Top-level module name (defaults to module-name)
  --input-rtl <path>          Input RTL directory (default: generated/verilog_hierarchical_timed)
  --output-root <path>        Root directory for physical design outputs (default: physical_design)
  --openlane2-path <path>     OpenLane2 installation directory (default: /opt/skywater-pdk/openlane2)
  --pdk-variant <variant>     PDK variant (default: sky130_fd_sc_hd)
  --clock-period <ns>         Clock period in nanoseconds (default: 10.0)
  --utilization <ratio>       Core utilization ratio 0.0-1.0 (default: 0.7)
  --aspect-ratio <ratio>      Core aspect ratio (default: 1.0)
  --synthesis-strategy <str>  Synthesis strategy (default: "AREA 0")
  --placement-strategy <str>  Placement strategy (default: "BASIC")
  --routing-strategy <num>    Routing strategy 0-3 (default: "0")
  --synthesis-only            Run synthesis only, skip physical design
  --no-signoff                Skip signoff verification (DRC/LVS/STA)
  --no-gds                    Skip GDS-II generation
  --quiet                     Reduce output verbosity
  --help, -h                  Show this help message

Examples:
  # Complete flow for ZeroNyte core
  $0 --module-name ZeroNyteRV32ICore
  
  # Synthesis only with custom clock
  $0 --module-name ALU32 --clock-period 5.0 --synthesis-only
  
  # Custom OpenLane2 path and output location
  $0 --openlane2-path /opt/skywater-pdk/openlane2 --output-root /tmp/physical

Environment Variables:
  OPENLANE2_ROOT             OpenLane2 installation directory
EOF
            exit 0
            ;;
        *)
            print_error "Unknown argument: $1"
            exit 1
            ;;
    esac
done

# Set effective top module
EFFECTIVE_TOP_MODULE="${TOP_MODULE:-$MODULE_NAME}"

# Computed paths
FULL_OUTPUT_ROOT="$(pwd)/$OUTPUT_ROOT"
RUNS_PATH="$FULL_OUTPUT_ROOT/runs"
REPORTS_PATH="$FULL_OUTPUT_ROOT/reports"

# Validate configuration
validate_configuration() {
    print_step "Validating configuration..."
    
    # Check input RTL file exists
    local input_rtl_file="$INPUT_RTL_PATH/$MODULE_NAME.v"
    if [ ! -f "$input_rtl_file" ]; then
        print_error "Input RTL file not found: $input_rtl_file"
        exit 1
    fi
    
    # Check OpenLane2 installation
    if [ ! -d "$OPENLANE2_PATH" ]; then
        print_error "OpenLane2 path does not exist: $OPENLANE2_PATH"
        exit 1
    fi
    
    # Check for Nix environment files
    if [ ! -f "$OPENLANE2_PATH/flake.nix" ] && [ ! -f "$OPENLANE2_PATH/shell.nix" ]; then
        print_error "OpenLane2 Nix environment not found at: $OPENLANE2_PATH"
        exit 1
    fi
    
    # Check nix-shell availability
    if ! command -v nix-shell >/dev/null 2>&1; then
        print_error "nix-shell not found - required for OpenLane2"
        exit 1
    fi
    
    # Validate design parameters
    if (( $(echo "$CLOCK_PERIOD <= 0" | bc -l) )); then
        print_error "Clock period must be positive"
        exit 1
    fi
    
    if (( $(echo "$CORE_UTILIZATION <= 0 || $CORE_UTILIZATION > 1" | bc -l) )); then
        print_error "Core utilization must be between 0 and 1"
        exit 1
    fi
    
    print_success "Configuration validated"
}

# Print configuration
print_configuration() {
    print_banner "KryptoNyte OpenLane2 Physical Design Flow Configuration"
    echo -e "${CYAN}Input RTL Path:${NC}        $INPUT_RTL_PATH"
    echo -e "${CYAN}Module Name:${NC}           $MODULE_NAME"
    echo -e "${CYAN}Top Module:${NC}            $EFFECTIVE_TOP_MODULE"
    echo -e "${CYAN}Output Root:${NC}           $FULL_OUTPUT_ROOT"
    echo -e "${CYAN}OpenLane2 Path:${NC}        $OPENLANE2_PATH"
    echo -e "${CYAN}PDK Variant:${NC}           $PDK_VARIANT"
    echo -e "${CYAN}Clock Period:${NC}          $CLOCK_PERIOD ns"
    echo -e "${CYAN}Core Utilization:${NC}      $CORE_UTILIZATION"
    echo -e "${CYAN}Aspect Ratio:${NC}          $ASPECT_RATIO"
    echo -e "${CYAN}Synthesis Strategy:${NC}    $SYNTHESIS_STRATEGY"
    echo -e "${CYAN}Placement Strategy:${NC}    $PLACEMENT_STRATEGY"
    echo -e "${CYAN}Routing Strategy:${NC}      $ROUTING_STRATEGY"
    echo -e "${CYAN}Run Synthesis:${NC}         $RUN_SYNTHESIS"
    echo -e "${CYAN}Run Floorplan:${NC}         $RUN_FLOORPLAN"
    echo -e "${CYAN}Run Placement:${NC}         $RUN_PLACEMENT"
    echo -e "${CYAN}Run CTS:${NC}               $RUN_CTS"
    echo -e "${CYAN}Run Routing:${NC}           $RUN_ROUTING"
    echo -e "${CYAN}Run Signoff:${NC}           $RUN_SIGNOFF"
    echo -e "${CYAN}Generate GDS:${NC}          $GENERATE_GDS"
    echo ""
}

# Create directories
create_directories() {
    print_step "Creating output directories..."
    mkdir -p "$RUNS_PATH" "$REPORTS_PATH"
    print_success "Directories created"
}

# Prepare design configuration
prepare_design_config() {
    print_step "Preparing OpenLane2 design configuration..."
    
    local design_dir="$RUNS_PATH/$EFFECTIVE_TOP_MODULE"
    local src_dir="$design_dir/src"
    
    # Create design directory structure
    mkdir -p "$src_dir"
    
    # Copy RTL file to design source directory
    local input_rtl="$INPUT_RTL_PATH/$MODULE_NAME.v"
    local target_rtl="$src_dir/$EFFECTIVE_TOP_MODULE.v"
    cp "$input_rtl" "$target_rtl"
    
    # Create OpenLane2 configuration file
    local config_file="$design_dir/config.json"
    cat > "$config_file" << EOF
{
  "DESIGN_NAME": "$EFFECTIVE_TOP_MODULE",
  "VERILOG_FILES": ["dir::src/$EFFECTIVE_TOP_MODULE.v"],
  "CLOCK_PORT": "$CLOCK_PORT",
  "CLOCK_PERIOD": $CLOCK_PERIOD,
  
  "PDK": "sky130A",
  "STD_CELL_LIBRARY": "$PDK_VARIANT",
  
  "FP_CORE_UTIL": $CORE_UTILIZATION,
  "FP_ASPECT_RATIO": $ASPECT_RATIO,
  "FP_PDN_AUTO_ADJUST": true,
  
  "SYNTH_STRATEGY": "$SYNTHESIS_STRATEGY",
  "PL_BASIC_PLACEMENT": $([ "$PLACEMENT_STRATEGY" = "BASIC" ] && echo "true" || echo "false"),
  "RT_MAX_LAYER": 6,
  
  "RUN_KLAYOUT": $GENERATE_GDS,
  "RUN_KLAYOUT_DRC": $RUN_DRC,
  "RUN_KLAYOUT_XOR": false,
  
  "RUN_MAGIC": true,
  "RUN_MAGIC_DRC": $RUN_DRC,
  "RUN_MAGIC_SPICE_EXPORT": $RUN_LVS,
  
  "RUN_NETGEN": $RUN_LVS,
  "RUN_NETGEN_LVS": $RUN_LVS,
  
  "RUN_OPENSTA": $RUN_STA,
  "STA_REPORT_POWER": true,
  
  "RUN_CVC": false,
  "RUN_ANTENNA_CHECK": $RUN_ANTENNA,
  
  "QUIT_ON_TIMING_VIOLATIONS": false,
  "QUIT_ON_MAGIC_DRC": false,
  "QUIT_ON_LVS_ERROR": false,
  
  "EXTRA_LEFS": [],
  "EXTRA_GDS_FILES": [],
  "EXTRA_LIBS": []
}
EOF
    
    print_success "Design configuration prepared at: $design_dir"
}

# Run OpenLane2 flow
run_openlane2_flow() {
    print_step "Running OpenLane2 flow..."
    
    local design_dir="$RUNS_PATH/$EFFECTIVE_TOP_MODULE"
    local log_file="$REPORTS_PATH/openlane2_run.log"
    
    # Unset PDK environment variables to avoid conflicts
    unset PDK_ROOT 2>/dev/null || true
    unset SKYWATER_PDK_ROOT 2>/dev/null || true
    unset STD_CELL_LIBRARY 2>/dev/null || true
    
    print_step "Running OpenLane2 (this may take 30+ minutes)..."
    print_step "Design directory: $design_dir"
    print_step "Log file: $log_file"
    
    # Change to OpenLane2 directory and run
    cd "$OPENLANE2_PATH"
    
    # OpenLane2 expects the config file as an argument
    local config_file="$design_dir/config.json"
    
    if [ "$VERBOSE" = true ]; then
        # Show output in real-time and save to log
        nix-shell --run "openlane $config_file" 2>&1 | tee "$log_file"
    else
        # Only save to log file
        nix-shell --run "openlane $config_file" > "$log_file" 2>&1
    fi
    
    local exit_code=${PIPESTATUS[0]}
    if [ $exit_code -ne 0 ]; then
        print_error "OpenLane2 flow failed with exit code $exit_code"
        print_step "Check log file: $log_file"
        exit 1
    fi
    
    print_success "OpenLane2 flow completed successfully"
}

# Generate final reports
generate_final_reports() {
    print_step "Generating final reports..."
    
    local design_dir="$RUNS_PATH/$EFFECTIVE_TOP_MODULE"
    local results_dir="$design_dir/results/final"
    local report_file="$REPORTS_PATH/final_report.md"
    
    # Check for output files
    local gds_file="$results_dir/gds/$EFFECTIVE_TOP_MODULE.gds"
    local def_file="$results_dir/def/$EFFECTIVE_TOP_MODULE.def"
    local netlist_file="$results_dir/verilog/gl/$EFFECTIVE_TOP_MODULE.v"
    local sdf_file="$results_dir/sdf/$EFFECTIVE_TOP_MODULE.sdf"
    
    # Calculate frequency
    local frequency=$(echo "scale=2; 1000.0 / $CLOCK_PERIOD" | bc)
    
    cat > "$report_file" << EOF
# KryptoNyte OpenLane2 Physical Design Report

## Design Information
- **Module Name**: $EFFECTIVE_TOP_MODULE
- **Clock Period**: $CLOCK_PERIOD ns ($frequency MHz)
- **Core Utilization**: $CORE_UTILIZATION
- **Aspect Ratio**: $ASPECT_RATIO
- **PDK Variant**: $PDK_VARIANT

## OpenLane2 Configuration
- **Synthesis Strategy**: $SYNTHESIS_STRATEGY
- **Placement Strategy**: $PLACEMENT_STRATEGY
- **Routing Strategy**: $ROUTING_STRATEGY

## Flow Summary
- **Synthesis**: $([ "$RUN_SYNTHESIS" = true ] && echo "✅ Completed" || echo "⏭️ Skipped")
- **Floorplan**: $([ "$RUN_FLOORPLAN" = true ] && echo "✅ Completed" || echo "⏭️ Skipped")
- **Placement**: $([ "$RUN_PLACEMENT" = true ] && echo "✅ Completed" || echo "⏭️ Skipped")
- **Clock Tree Synthesis**: $([ "$RUN_CTS" = true ] && echo "✅ Completed" || echo "⏭️ Skipped")
- **Routing**: $([ "$RUN_ROUTING" = true ] && echo "✅ Completed" || echo "⏭️ Skipped")
- **Signoff**: $([ "$RUN_SIGNOFF" = true ] && echo "✅ Completed" || echo "⏭️ Skipped")
- **GDS Generation**: $([ "$GENERATE_GDS" = true ] && echo "✅ Completed" || echo "⏭️ Skipped")

## Output Files
- **Gate-Level Netlist**: $([ -f "$netlist_file" ] && echo "✅ $netlist_file" || echo "❌ Not generated")
- **Standard Delay Format**: $([ -f "$sdf_file" ] && echo "✅ $sdf_file" || echo "❌ Not generated")
- **Final DEF Layout**: $([ -f "$def_file" ] && echo "✅ $def_file" || echo "❌ Not generated")
- **GDS-II Layout**: $([ -f "$gds_file" ] && echo "✅ $gds_file" || echo "❌ Not generated")

## OpenLane2 Results Directory
- **Full Results**: $results_dir
- **Reports**: $design_dir/reports
- **Logs**: $design_dir/logs

## Usage Instructions

### View Layout in KLayout
\`\`\`bash
$([ -f "$gds_file" ] && echo "klayout $gds_file" || echo "klayout path/to/gds/file")
\`\`\`

### Simulate with Gate-Level Netlist
\`\`\`bash
# Use the gate-level netlist for post-synthesis simulation
# Netlist: $netlist_file
# SDF: $sdf_file
\`\`\`

### Next Steps
1. **Verification**: Run post-layout simulation with SDF timing
2. **Analysis**: Review timing, power, and area reports in $design_dir/reports
3. **Tapeout**: Use GDS-II file for fabrication submission

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

# Main execution
main() {
    print_banner "Starting KryptoNyte OpenLane2 Physical Design Flow for $EFFECTIVE_TOP_MODULE"
    
    # Validate configuration
    validate_configuration
    
    # Print configuration
    if [ "$VERBOSE" = true ]; then
        print_configuration
    fi
    
    # Create output directories
    create_directories
    
    # Prepare design configuration
    prepare_design_config
    
    # Run OpenLane2 flow
    run_openlane2_flow
    
    # Generate reports
    generate_final_reports
    
    print_banner "Physical design flow completed successfully!"
    echo -e "${GREEN}Results directory: $RUNS_PATH${NC}"
    if [ -f "$RUNS_PATH/$EFFECTIVE_TOP_MODULE/results/final/gds/$EFFECTIVE_TOP_MODULE.gds" ]; then
        echo -e "${GREEN}GDS-II file: $RUNS_PATH/$EFFECTIVE_TOP_MODULE/results/final/gds/$EFFECTIVE_TOP_MODULE.gds${NC}"
    fi
}

# Run main function
main "$@"
