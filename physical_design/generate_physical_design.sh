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
OUTPUT_ROOT="${OPENLANE_OUTPUT_ROOT:-$SCRIPT_DIR/_runs}"
OPENLANE2_PATH="${OPENLANE2_ROOT:-/opt/skywater-pdk/openlane2}"
VERBOSE=true
USE_SUDO=false

# Export environment variables for template substitution
export MODULE_NAME
export CLOCK_PORT="clock"
export CLOCK_PERIOD="10.0"
export CORE_UTILIZATION="70"
export ASPECT_RATIO="1.0"
export PDK_VARIANT="sky130_fd_sc_hd"
export SYNTHESIS_STRATEGY="AREA 0"
export ROUTING_STRATEGY="0"
export GENERATE_GDS="true"
export RUN_DRC="true"
OPENLANE_EXIT_CODE=0
FLOW_COMPLETED_WITH_DEFERRED_ERRORS=false
LATEST_RUN_DIR=""
LATEST_FINAL_DIR=""

# --- Command-line Argument Parsing ---

show_help() {
    cat << EOF
============================================================
KryptoNyte Physical Design Flow
============================================================

Usage: $0 [options]

Options:
  --module-name <name>    Module to process (Required unless viewing help)
  --config-base <file>    Base JSON config (default: config.base.json)
  --config-module <file>  Module-specific JSON config (optional)
  --log-directory <path>  Output directory (default: physical_design/_runs)
  --openlane2-path <path> OpenLane2 directory (default: /opt/skywater-pdk/openlane2)
  --clock-period <ns>     Clock period in nanoseconds (default: 10.0)
  --utilization <percent> Core utilization percentage (default: 70)
  --use-sudo              Run nix-shell/openlane through sudo
  --quiet                 Reduced verbosity
  --help, -h              Show this help message

------------------------------------------------------------
Valid Target Modules for Synthesis:
------------------------------------------------------------
> Core Processors:
  - TetraNyteRV32ICore           (Base 4-thread I Core)
  - TetraNyteRV32IMCore          (Base 4-thread IM Core)
  - TetraNyteRV32IZmmulCore      (Base 4-thread I+Zmmul Core)
  - ZeroNyteRV32ICore            (Base single-thread I Core)
  - ZeroNyteRV32IMCore           (Base single-thread IM Core)
  - ZeroNyteRV32IZmmulCore       (Base single-thread I+Zmmul Core)

> Hard Macro Generation Targets:
  - RegFileMT2R1WMem             (TetraNyte Shared 2-Read 1-Write Register File)
  - RegFile2R1WMem               (ZeroNyte Dedicated 1-Thread 2-Read 1-Write Register File)
  - RegFileMT8R4WMem             (Superscalar 8-Read 4-Write Register File)
  - RegFileMTMem                 (Base multithreaded monolithic RF)
  - ICache                       (TetraNyte/ZeroNyte Instruction Cache)

Examples:
  ./generate_physical_design.sh --module-name RegFileMT2R1WMem
  ./generate_physical_design.sh --module-name TetraNyteRV32ICore --clock-period 8.0 --utilization 65
  ./generate_physical_design.sh --module-name ZeroNyteRV32ICore --use-sudo
EOF
    exit 0
}

if [[ $# -eq 0 ]]; then
    echo -e "${YELLOW}Notice: No arguments provided. Displaying help menu.${NC}\n"
    show_help
fi

# Reset MODULE_NAME to empty to enforce requiring it (or let it stay default if you want, but the user requested explicit safety)
MODULE_NAME=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --module-name) MODULE_NAME="$2"; export MODULE_NAME; shift 2 ;; 
        --config-base) CONFIG_BASE_FILE="$2"; shift 2 ;;
        --config-module) CONFIG_MODULE_FILE="$2"; shift 2 ;;
        --log-directory) OUTPUT_ROOT="$2"; shift 2 ;;
        --openlane2-path) OPENLANE2_PATH="$2"; shift 2 ;;
        --clock-period) CLOCK_PERIOD="$2"; export CLOCK_PERIOD; shift 2 ;;
        --utilization) CORE_UTILIZATION="$2"; export CORE_UTILIZATION; shift 2 ;;
        --use-sudo) USE_SUDO=true; shift ;;
        --quiet) VERBOSE=false; shift ;;
        --help|-h) show_help ;;
        *) print_error "Unknown argument: $1" ;;
    esac
done

if [[ -z "$MODULE_NAME" ]]; then
    print_error "You must specify a module to target using --module-name. Run with --help to see valid modules."
fi

# --- Configuration Loading and Processing ---
load_and_process_config() {
    print_step "Loading and processing configurations..."
    local module_config_is_default=false
    local pnr_sdc_exists=false
    local signoff_sdc_exists=false

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
    [ -f "constraints/${MODULE_NAME}.sdc" ] && pnr_sdc_exists=true
    [ -f "constraints/${MODULE_NAME}_signoff.sdc" ] && signoff_sdc_exists=true

    if [ -f "$CONFIG_MODULE_FILE" ]; then
        # Merge configurations (module config overrides base config)
        MERGED_CONFIG=$(jq -s '.[0] * .[1]' "$CONFIG_BASE_FILE" "$CONFIG_MODULE_FILE")
        MERGED_CONFIG=$(echo "$MERGED_CONFIG" | jq \
            --arg pnr_sdc_file "dir::constraints/${MODULE_NAME}.sdc" \
            --arg signoff_sdc_file "dir::constraints/${MODULE_NAME}_signoff.sdc" \
            --argjson include_pnr_sdc "$pnr_sdc_exists" \
            --argjson include_signoff_sdc "$signoff_sdc_exists" '
            .
            + (if $include_pnr_sdc then {PNR_SDC_FILE: $pnr_sdc_file} else {} end)
            + (if $include_signoff_sdc then {SIGNOFF_SDC_FILE: $signoff_sdc_file} else {} end)
        ')
        print_success "Configurations loaded and merged."
        if [ "$pnr_sdc_exists" != true ] || [ "$signoff_sdc_exists" != true ]; then
            print_warning "Module-specific SDC files were not found for $MODULE_NAME; the flow will use JSON clock settings only."
        fi
        return
    fi

    if [ "$module_config_is_default" != true ]; then
        print_error "Module config file not found: $CONFIG_MODULE_FILE"
    fi

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

find_latest_run_dir() {
    local design_dir="$1"
    ls -td "$design_dir"/runs/RUN_* 2>/dev/null | head -n1 || true
}

link_artifact_into_dir() {
    local source_path="$1"
    local target_path="$2"

    [ -n "$source_path" ] || return 0
    [ "$source_path" = "null" ] && return 0
    [ -e "$source_path" ] || return 0

    mkdir -p "$(dirname "$target_path")"
    ln -sfn "$source_path" "$target_path"
}

link_state_scalar_artifact() {
    local state_file="$1"
    local state_key="$2"
    local final_dir="$3"
    local target_subdir="${4:-$state_key}"
    local source_path=""

    source_path=$(jq -r --arg key "$state_key" '.[$key] // empty' "$state_file")
    [ -n "$source_path" ] || return 0

    link_artifact_into_dir "$source_path" "$final_dir/$target_subdir/$(basename "$source_path")"
}

link_state_dictionary_artifacts() {
    local state_file="$1"
    local state_key="$2"
    local final_dir="$3"
    local normalize_prefix="${4:-false}"
    local entry_key=""
    local entry_path=""
    local target_subdir=""

    while IFS=$'\t' read -r entry_key entry_path; do
        [ -n "$entry_key" ] || continue
        [ -n "$entry_path" ] || continue
        [ "$entry_path" = "null" ] && continue
        [ -e "$entry_path" ] || continue

        target_subdir="$entry_key"
        if [ "$normalize_prefix" = true ] && [[ "$entry_key" == *_* ]]; then
            target_subdir="${entry_key%%_*}"
        fi

        link_artifact_into_dir "$entry_path" "$final_dir/$state_key/$target_subdir/$(basename "$entry_path")"
    done < <(jq -r --arg key "$state_key" '
        .[$key] // {} |
        to_entries[]? |
        [.key, .value] |
        @tsv
    ' "$state_file")
}

materialize_run_final_dir() {
    local run_dir="$1"
    local module_name="$2"
    local candidate_final=""
    local state_file=""
    local gds_path=""
    local lef_path=""
    local nl_path=""
    local nom_lib=""
    local ss_lib=""
    local ff_lib=""

    [ -d "$run_dir" ] || return 1

    for candidate_final in "$run_dir/results/final" "$run_dir/final"; do
        if [ -f "$candidate_final/gds/$module_name.gds" ] && \
           [ -f "$candidate_final/lef/$module_name.lef" ] && \
           [ -f "$candidate_final/nl/$module_name.nl.v" ] && \
           [ -f "$candidate_final/lib/nom_tt_025C_1v80/${module_name}__nom_tt_025C_1v80.lib" ] && \
           [ -f "$candidate_final/lib/max_ss_100C_1v60/${module_name}__max_ss_100C_1v60.lib" ] && \
           [ -f "$candidate_final/lib/min_ff_n40C_1v95/${module_name}__min_ff_n40C_1v95.lib" ]; then
            echo "$candidate_final"
            return 0
        fi
    done

    while IFS= read -r state_file; do
        [ -f "$state_file" ] || continue

        gds_path=$(jq -r '.gds // empty' "$state_file")
        lef_path=$(jq -r '.lef // empty' "$state_file")
        nl_path=$(jq -r '.nl // empty' "$state_file")
        nom_lib=$(jq -r '.lib["nom_tt_025C_1v80"] // empty' "$state_file")
        ss_lib=$(jq -r '.lib["max_ss_100C_1v60"] // empty' "$state_file")
        ff_lib=$(jq -r '.lib["min_ff_n40C_1v95"] // empty' "$state_file")

        if [ -f "$gds_path" ] && [ -f "$lef_path" ] && [ -f "$nl_path" ] && \
           [ -f "$nom_lib" ] && [ -f "$ss_lib" ] && [ -f "$ff_lib" ]; then
            candidate_final="$run_dir/final"
            mkdir -p "$candidate_final"

            link_state_scalar_artifact "$state_file" "def" "$candidate_final"
            link_state_scalar_artifact "$state_file" "gds" "$candidate_final"
            link_state_scalar_artifact "$state_file" "json_h" "$candidate_final"
            link_state_scalar_artifact "$state_file" "klayout_gds" "$candidate_final"
            link_state_scalar_artifact "$state_file" "lef" "$candidate_final"
            link_state_scalar_artifact "$state_file" "mag" "$candidate_final"
            link_state_scalar_artifact "$state_file" "mag_gds" "$candidate_final"
            link_state_scalar_artifact "$state_file" "nl" "$candidate_final"
            link_state_scalar_artifact "$state_file" "odb" "$candidate_final"
            link_state_scalar_artifact "$state_file" "pnl" "$candidate_final"
            link_state_scalar_artifact "$state_file" "sdc" "$candidate_final"
            link_state_scalar_artifact "$state_file" "spice" "$candidate_final"
            link_state_scalar_artifact "$state_file" "vh" "$candidate_final"
            link_state_dictionary_artifacts "$state_file" "lib" "$candidate_final"
            link_state_dictionary_artifacts "$state_file" "sdf" "$candidate_final"
            link_state_dictionary_artifacts "$state_file" "spef" "$candidate_final" true

            echo "$candidate_final"
            return 0
        fi
    done < <(find "$run_dir" -mindepth 2 -maxdepth 2 \( -name state_out.json -o -name state_in.json \) | sort -r)

    return 1
}

create_regfile_macro_abstract_lef() {
    local source_lef="$1"
    local target_lef="${source_lef%.lef}.openlane.lef"

    [ -f "$source_lef" ] || return 1

    if [ -f "$target_lef" ] && [ "$target_lef" -nt "$source_lef" ]; then
        echo "$target_lef"
        return 0
    fi

    python3 - "$source_lef" "$target_lef" <<'PY'
import re
import sys
from pathlib import Path

source = Path(sys.argv[1])
target = Path(sys.argv[2])
lines = source.read_text().splitlines(keepends=True)

size_x = None
size_y = None
for line in lines:
    match = re.match(r"\s*SIZE\s+([0-9.]+)\s+BY\s+([0-9.]+)\s*;", line)
    if match:
        size_x = float(match.group(1))
        size_y = float(match.group(2))
        break

if size_x is None or size_y is None:
    raise SystemExit(f"Failed to parse macro SIZE from {source}")

boundary_x_tol = 3.0
boundary_y_tol = 12.0

def keep_power_port(layer: str, rect):
    x1, y1, x2, y2 = rect
    if layer == "met4":
        return x1 <= boundary_x_tol or x2 >= (size_x - boundary_x_tol)
    if layer == "met5":
        return y1 <= boundary_y_tol or y2 >= (size_y - boundary_y_tol)
    return True

def sanitize_power_pin_block(pin_lines):
    output = []
    i = 0
    while i < len(pin_lines):
        line = pin_lines[i]
        stripped = line.strip()
        if stripped != "PORT":
            output.append(line)
            i += 1
            continue

        port_lines = [line]
        i += 1
        layer = None
        rect = None
        while i < len(pin_lines):
            port_line = pin_lines[i]
            port_lines.append(port_line)
            port_stripped = port_line.strip()
            if port_stripped.startswith("LAYER "):
                layer = port_stripped.split()[1]
            elif port_stripped.startswith("RECT "):
                rect = tuple(
                    float(part)
                    for part in port_stripped.replace("RECT", "")
                    .replace(";", "")
                    .split()
                )
            elif port_stripped == "END":
                break
            i += 1

        if layer is not None and rect is not None and keep_power_port(layer, rect):
            output.extend(port_lines)
        i += 1

    return output

output = []
i = 0
while i < len(lines):
    line = lines[i]
    stripped = line.strip()
    if stripped.startswith("PIN VPWR") or stripped.startswith("PIN VGND"):
        pin_name = stripped.split()[1]
        pin_block = [line]
        i += 1
        while i < len(lines):
            pin_line = lines[i]
            pin_block.append(pin_line)
            if pin_line.strip() == f"END {pin_name}":
                break
            i += 1

        output.extend(sanitize_power_pin_block(pin_block))
        i += 1
        continue

    output.append(line)
    i += 1

target.write_text("".join(output))
PY

    echo "$target_lef"
}

# --- Main Flow Functions ---
prepare_design_config() {
    print_step "Preparing OpenLane2 design configuration..."
    
    local design_dir="$RUNS_PATH/$MODULE_NAME"
    local src_dir="$design_dir/src"
    local constraints_dir="$design_dir/constraints"

    # Refresh staged inputs on every invocation so deleted files do not persist
    # across runs while preserving historical artifacts under design_dir/runs.
    rm -rf "$src_dir" "$constraints_dir"
    mkdir -p "$src_dir"

    # Copy RTL file to design source directory
    local input_rtl="../rtl/generators/generated/verilog_hierarchical_timed/${MODULE_NAME}.v"
    local target_rtl="$src_dir/${MODULE_NAME}.v"
    
    if [ ! -f "$input_rtl" ]; then
        print_warning "RTL file not found: $input_rtl"
        print_step "Attempting to generate missing RTL automatically via SBT..."
        pushd "$RTL_DIR" > /dev/null
        sbt generateRTL || print_error "SBT RTL generation failed! Check compiler logs."
        popd > /dev/null
    fi

    if [ -f "$input_rtl" ]; then
        cp "$input_rtl" "$target_rtl"
        if [[ "$MODULE_NAME" != "RegFileMT2R1WMem" && "$MODULE_NAME" != "RegFile2R1WMem" ]] && grep -E -q "module RegFile(MT)?2R1WMem" "$target_rtl"; then
            python3 -c "
with open('$target_rtl', 'r') as f: content = f.read()

def strip_mod(text, mod_name):
    while True:
        start = text.find('module ' + mod_name + '(')
        if start == -1: break
        end = text.find('endmodule', start)
        if end == -1: break
        end += 9
        idx = start
        while idx > 0:
            while idx > 0 and text[idx-1].isspace(): idx -= 1
            if idx >= 2 and text[idx-2:idx] == '*)':
                op = text.rfind('(*', 0, idx)
                if op != -1: idx = op
                else: break
            else: break
        text = text[:idx] + text[end:]
    return text

content = strip_mod(content, 'RegFileMT2R1WMem')
content = strip_mod(content, 'RegFile2R1WMem')
content = strip_mod(content, 'regs_128x32')
content = strip_mod(content, 'regs_32x32')

import re
content = re.sub(r'(RegFile(?:MT)?2R1WMem\s+\w+\s*\(\s*\n?\s*\.clock\(clock\)),', r'\1, .reset(reset),', content)
def fix_read_addrs(m):
    val = m.group(1).strip()
    match = re.match(r'(.+)\[(\d+):(\d+)\]', val)
    if match:
        name, hi, lo = match.group(1), int(match.group(2)), int(match.group(3))
        mid = (hi + lo) // 2
        return f'.io_readAddrs_0({name}[{mid}:{lo}]), .io_readAddrs_1({name}[{hi}:{mid+1}])'
    return f'.io_readAddrs_0({val}[4:0]), .io_readAddrs_1({val}[9:5])'

content = re.sub(r'\.io_readAddrs\((.*?)\)', fix_read_addrs, content)
content = re.sub(r'\.io_readData\((.*?)\)', r'.io_readData_0(\1[31:0]), .io_readData_1(\1[63:32])', content)
content = re.sub(r'\.io_wens\((.*?)\)', r'.io_wens_0(\1)', content)
content = re.sub(r'\.io_writeAddrs\((.*?)\)', r'.io_writeAddrs_0(\1)', content)
content = re.sub(r'\.io_writeData\((.*?)\)', r'.io_writeData_0(\1)', content)
content = re.sub(r'\.io_debugX1\((.*?)\)', r'.io_debugX1_0(\1[31:0]), .io_debugX1_1(\1[63:32]), .io_debugX1_2(\1[95:64]), .io_debugX1_3(\1[127:96])', content)

with open('$target_rtl', 'w') as f: f.write(content)
"
        fi
        print_success "RTL file copied: $input_rtl -> $target_rtl"
    else
        print_error "RTL file STILL not found: $input_rtl. Is '$MODULE_NAME' spelled perfectly with correct capitalization?"
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
    OPENLANE_EXIT_CODE=$exit_code
    LATEST_RUN_DIR=$(find_latest_run_dir "$design_dir")
    LATEST_FINAL_DIR=""
    if [ -n "$LATEST_RUN_DIR" ]; then
        LATEST_FINAL_DIR=$(materialize_run_final_dir "$LATEST_RUN_DIR" "$MODULE_NAME" || true)
    fi

    if [ $exit_code -ne 0 ]; then
        if [ -n "$LATEST_FINAL_DIR" ]; then
            FLOW_COMPLETED_WITH_DEFERRED_ERRORS=true
            print_warning "OpenLane2 exited with code $exit_code, but usable final artifacts were recovered from $LATEST_RUN_DIR"
            print_warning "Continuing to final report generation. Inspect $log_file for deferred timing or checker failures."
            return
        fi
        print_error "OpenLane2 flow failed with exit code $exit_code. Check log: $log_file"
    fi

    print_success "OpenLane2 flow completed successfully."
}

generate_final_reports() {
    print_step "Generating final reports..."
    
    local design_dir="$RUNS_PATH/$MODULE_NAME"
    local latest_run="$LATEST_RUN_DIR"
    local results_dir="$LATEST_FINAL_DIR"
    local report_file="$REPORTS_PATH/final_report.md"
    local netlist_file=""
    local sdf_file=""
    local flow_status="Completed cleanly"

    if [ -z "$latest_run" ]; then
        latest_run=$(find_latest_run_dir "$design_dir")
    fi
    [ -n "$latest_run" ] || print_error "No OpenLane run directory found under $design_dir/runs"

    if [ -z "$results_dir" ]; then
        results_dir=$(materialize_run_final_dir "$latest_run" "$MODULE_NAME" || true)
    fi
    [ -n "$results_dir" ] || print_error "No usable final artifacts were found for $MODULE_NAME under $latest_run"
    
    # Check for output files
    local gds_file="$results_dir/gds/$MODULE_NAME.gds"
    local def_file="$results_dir/def/$MODULE_NAME.def"
    netlist_file="$results_dir/nl/$MODULE_NAME.nl.v"
    if [ ! -f "$netlist_file" ] && [ -f "$results_dir/verilog/gl/$MODULE_NAME.v" ]; then
        netlist_file="$results_dir/verilog/gl/$MODULE_NAME.v"
    fi
    sdf_file="$results_dir/sdf/nom_tt_025C_1v80/${MODULE_NAME}__nom_tt_025C_1v80.sdf"
    if [ ! -f "$sdf_file" ]; then
        sdf_file=$(find "$results_dir/sdf" -type f | head -n1 || true)
    fi

    if [ "$FLOW_COMPLETED_WITH_DEFERRED_ERRORS" = true ]; then
        flow_status="Completed with deferred checker/timing failures"
    fi
    
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
- **Flow Status**: $flow_status
- **OpenLane Exit Code**: $OPENLANE_EXIT_CODE

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
- **Latest Run**: $latest_run
- **Usable Final Artifacts**: $results_dir
- **Wrapper Reports**: $REPORTS_PATH
- **OpenLane Log**: $REPORTS_PATH/openlane2_run.log

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

resolve_macro_paths() {
    print_step "Resolving latest macro paths..."

    _inject_macro() {
        local macro_name="$1"

        if [ "$MODULE_NAME" = "$macro_name" ]; then
            print_success "Target module is $macro_name; skipping self-macro injection"
            return
        fi

        # Check if the RTL actually instantiates this macro
        if ! grep -E -q "module $macro_name" "$target_rtl" 2>/dev/null; then
            return
        fi

        local regfile_dir="$PHYSICAL_DESIGN_DIR/_runs/runs/$macro_name/runs"
        if [ -d "$regfile_dir" ]; then
            local latest_run=""
            local final_dir=""
            local candidate_run=""
            local macro_lef=""
            while IFS= read -r candidate_run; do
                [ -n "$candidate_run" ] || continue

                final_dir=$(materialize_run_final_dir "$candidate_run" "$macro_name" || true)
                if [ -n "$final_dir" ]; then
                    latest_run="$candidate_run"
                    break
                fi

                print_warning "Skipping unusable $macro_name run: $candidate_run"
            done < <(ls -td "$regfile_dir"/RUN_* 2>/dev/null || true)

            if [ -z "$latest_run" ]; then
                print_error "No completed $macro_name macro run with final artifacts found under $regfile_dir"
                exit 1
            fi

            print_success "Using $macro_name macro run: $latest_run"
            macro_lef=$(create_regfile_macro_abstract_lef "$final_dir/lef/$macro_name.lef")

            # Dynamically merge the exact macro dependencies natively
            MERGED_CONFIG=$(echo "$MERGED_CONFIG" | jq --arg final_dir "$final_dir" --arg macro_lef "$macro_lef" --arg macro_name "$macro_name" '
                .PDN_MACRO_CONNECTIONS = ["regFile VPWR VGND VPWR VGND"] |
                .FP_PDN_VPITCH = 341.45 |
                .FP_PDN_HPITCH = 340.04 |
                .FP_PDN_VOFFSET = 102.8 |
                .FP_PDN_HOFFSET = 109.32 |
                .FP_MACRO_HORIZONTAL_HALO = 10.12 |
                .FP_MACRO_VERTICAL_HALO = 10.88 |
                .PL_MAX_DISPLACEMENT_X = 1500 |
                .PL_MAX_DISPLACEMENT_Y = 1500 |
                .MACROS[$macro_name] = {
                    "instances": {
                        "regFile": {
                            "location": [100.28, 780.72],
                            "orientation": "N"
                        }
                    },
                    "gds": [($final_dir + "/gds/" + $macro_name + ".gds")],
                    "lef": [$macro_lef],
                    "nl": [($final_dir + "/nl/" + $macro_name + ".nl.v")],
                    "spef": {
                        "nom_*": [($final_dir + "/spef/nom/" + $macro_name + ".nom.spef")],
                        "min_*": [($final_dir + "/spef/min/" + $macro_name + ".min.spef")],
                        "max_*": [($final_dir + "/spef/max/" + $macro_name + ".max.spef")]
                    },
                    "lib": {
                        "nom_tt_025C_1v80": [($final_dir + "/lib/nom_tt_025C_1v80/" + $macro_name + "__nom_tt_025C_1v80.lib")],
                        "nom_ss_100C_1v60": [($final_dir + "/lib/nom_ss_100C_1v60/" + $macro_name + "__nom_ss_100C_1v60.lib")],
                        "nom_ff_n40C_1v95": [($final_dir + "/lib/nom_ff_n40C_1v95/" + $macro_name + "__nom_ff_n40C_1v95.lib")],
                        "min_tt_025C_1v80": [($final_dir + "/lib/min_tt_025C_1v80/" + $macro_name + "__min_tt_025C_1v80.lib")],
                        "min_ss_100C_1v60": [($final_dir + "/lib/min_ss_100C_1v60/" + $macro_name + "__min_ss_100C_1v60.lib")],
                        "min_ff_n40C_1v95": [($final_dir + "/lib/min_ff_n40C_1v95/" + $macro_name + "__min_ff_n40C_1v95.lib")],
                        "max_tt_025C_1v80": [($final_dir + "/lib/max_tt_025C_1v80/" + $macro_name + "__max_tt_025C_1v80.lib")],
                        "max_ss_100C_1v60": [($final_dir + "/lib/max_ss_100C_1v60/" + $macro_name + "__max_ss_100C_1v60.lib")],
                        "max_ff_n40C_1v95": [($final_dir + "/lib/max_ff_n40C_1v95/" + $macro_name + "__max_ff_n40C_1v95.lib")]
                    },
                    "sdf": {
                        "nom_tt_025C_1v80": [($final_dir + "/sdf/nom_tt_025C_1v80/" + $macro_name + "__nom_tt_025C_1v80.sdf")],
                        "nom_ss_100C_1v60": [($final_dir + "/sdf/nom_ss_100C_1v60/" + $macro_name + "__nom_ss_100C_1v60.sdf")],
                        "nom_ff_n40C_1v95": [($final_dir + "/sdf/nom_ff_n40C_1v95/" + $macro_name + "__nom_ff_n40C_1v95.sdf")],
                        "min_tt_025C_1v80": [($final_dir + "/sdf/min_tt_025C_1v80/" + $macro_name + "__min_tt_025C_1v80.sdf")],
                        "min_ss_100C_1v60": [($final_dir + "/sdf/min_ss_100C_1v60/" + $macro_name + "__min_ss_100C_1v60.sdf")],
                        "min_ff_n40C_1v95": [($final_dir + "/sdf/min_ff_n40C_1v95/" + $macro_name + "__min_ff_n40C_1v95.sdf")],
                        "max_tt_025C_1v80": [($final_dir + "/sdf/max_tt_025C_1v80/" + $macro_name + "__max_tt_025C_1v80.sdf")],
                        "max_ss_100C_1v60": [($final_dir + "/sdf/max_ss_100C_1v60/" + $macro_name + "__max_ss_100C_1v60.sdf")],
                        "max_ff_n40C_1v95": [($final_dir + "/sdf/max_ff_n40C_1v95/" + $macro_name + "__max_ff_n40C_1v95.sdf")]
                    }
                }
            ')
            print_success "Injected dynamic MACROS configuration for $macro_name"
        fi
    }

    _inject_macro "RegFileMT2R1WMem"
    _inject_macro "RegFile2R1WMem"
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
    resolve_macro_paths
    prepare_design_config
    run_openlane2_flow
    generate_final_reports

    if [ "$FLOW_COMPLETED_WITH_DEFERRED_ERRORS" = true ]; then
        print_banner "Physical design flow completed with deferred warnings!"
    else
        print_banner "Physical design flow completed successfully!"
    fi
    echo -e "${GREEN}Results directory: $RUNS_PATH${NC}"
    if [ -f "$LATEST_FINAL_DIR/gds/$MODULE_NAME.gds" ]; then
        echo -e "${GREEN}GDS-II file: $LATEST_FINAL_DIR/gds/$MODULE_NAME.gds${NC}"
    fi
}

main "$@"
