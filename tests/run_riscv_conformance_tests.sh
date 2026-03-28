#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(dirname "$SCRIPT_DIR")

RISCV_ARCH_TEST_ROOT=${RISCV_ARCH_TEST_ROOT:-/opt/riscv-conformance/riscv-arch-test}
PLUGIN_ROOT="$RISCV_ARCH_TEST_ROOT/riscof-plugins/rv32"
BASE_SUITE_I="$RISCV_ARCH_TEST_ROOT/riscv-test-suite/rv32i_m/I"
BASE_SUITE_M="$RISCV_ARCH_TEST_ROOT/riscv-test-suite/rv32i_m/M"
ENV_ROOT="$RISCV_ARCH_TEST_ROOT/riscv-test-suite/env"

# Define supported configurations.
# Format: <processor_name>|<dut_name>|<sim_build_script>|<sim_binary>|<isa_yaml>|<platform_yaml>|<rtl_top>|<rtl_task>|<feature_set>
# feature_set can be: 'i', 'zmmul', 'im'

AVAILABLE_PROCESSORS=(
  "octonyte|octonyte|sim/build_octonyte_sim.sh|octonyte_sim|octonyte/octonyte_isa.yaml|octonyte/octonyte_platform.yaml|rtl/generators/generated/verilog_hierarchical_timed/OctoNyteRV32ICore.v|generators/generateOctoNyteRTL|i"
  "tetranyte|tetranyte|sim/build_tetranyte_sim.sh|tetranyte_sim|tetranyte/tetranyte_isa.yaml|tetranyte/tetranyte_platform.yaml|rtl/generators/generated/verilog_hierarchical_timed/TetraNyteRV32ICore.v|generators/generateTetraNyteRTL|i"
  "tetranyte-mrf|tetranyte|sim/build_tetranyte_mrf_sim.sh|tetranyte_mrf_sim|tetranyte/tetranyte_isa.yaml|tetranyte/tetranyte_platform.yaml|rtl/generators/generated/verilog_hierarchical_timed/TetraNyteRV32ICoreMRF.v|generators/generateTetraNyteRTL|i"
  "zeronyte|zeronyte|sim/build_zeronyte_sim.sh|zeronyte_sim|zeronyte/zeronyte_isa.yaml|zeronyte/zeronyte_platform.yaml|rtl/generators/generated/verilog_hierarchical_timed/ZeroNyteRV32ICore.v|generators/generateZeroNyteRTL|i"
  "zeronyte-cache|zeronyte|sim/build_zeronyte_cache_sim.sh|zeronyte_cache_sim|zeronyte/zeronyte_isa.yaml|zeronyte/zeronyte_platform.yaml|rtl/generators/generated/verilog_hierarchical_timed/ZeroNyteRV32ICoreWithCache.v|generators/generateZeroNyteRTL|i"
  "zeronyte-im|zeronyte_im|sim/build_zeronyte_im_sim.sh|zeronyte_im_sim|zeronyte_im/zeronyte_im_isa.yaml|zeronyte_im/zeronyte_im_platform.yaml|rtl/generators/generated/verilog_hierarchical_timed/ZeroNyteRV32IMCore.v|generators/generateZeroNyteIMRTL|im"
  "zeronyte-zmmul|zeronyte_zmmul|sim/build_zeronyte_zmmul_sim.sh|zeronyte_zmmul_sim|zeronyte_zmmul/zeronyte_zmmul_isa.yaml|zeronyte_zmmul/zeronyte_zmmul_platform.yaml|rtl/generators/generated/verilog_hierarchical_timed/ZeroNyteRV32IZmmulCore.v|generators/generateZeroNyteZmmulRTL|zmmul"
)

print_usage() {
  echo "Usage: $(basename "$0") --processor <name> [--smoke-test] [--timeout <seconds>]"
  echo ""
  echo "Available Processors and Feature Sets:"
  for config in "${AVAILABLE_PROCESSORS[@]}"; do
    IFS="|" read -r proc_name _ _ _ _ _ _ _ feat <<< "$config"
    display_feat="$feat"
    if [[ "$feat" == "zmmul" || "$feat" == "im" ]]; then
      display_feat="i, $feat"
    fi
    echo "  $proc_name (Features: $display_feat)"
  done
  echo ""
  echo "RV32i processors only do the base tests."
  echo "Zmmul adds just multiplier tests."
  echo "RV32IM executes integer, multiplier, and divider tests."
  echo ""
}

PROCESSOR=""
SMOKE_TEST=false
TIMEOUT_SECS=3600
TIMEOUT_SPECIFIED=false

if [[ $# -eq 0 ]]; then
  print_usage
  exit 0
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --processor|-p)
      if [[ $# -lt 2 ]]; then
        echo "Error: --processor requires an argument" >&2
        exit 1
      fi
      PROCESSOR="$2"
      shift 2
      ;;
    --help|-h)
      print_usage
      exit 0
      ;;
    --smoke-test)
      SMOKE_TEST=true
      shift
      ;;
    --timeout)
      if [[ $# -lt 2 ]]; then
        echo "Error: --timeout requires a value in seconds" >&2
        exit 1
      fi
      TIMEOUT_SECS="$2"
      TIMEOUT_SPECIFIED=true
      shift 2
      ;;
    *)
      echo "Unknown argument: $1" >&2
      print_usage >&2
      exit 1
      ;;
  esac
done

if [[ -z "$PROCESSOR" ]]; then
  echo "Error: You must specify a --processor." >&2
  print_usage
  exit 1
fi

FOUND=0
for config in "${AVAILABLE_PROCESSORS[@]}"; do
  IFS="|" read -r proc_name dut_name sim_build sim_bin isa_yaml platform_yaml rtl_top rtl_task feat <<< "$config"
  if [[ "$PROCESSOR" == "$proc_name" ]]; then
    DUT_NAME="$dut_name"
    SIM_BUILD_SCRIPT="$SCRIPT_DIR/$sim_build"
    SIM_BINARY="$sim_bin"
    ISA_FILE="$isa_yaml"
    PLATFORM_FILE="$platform_yaml"
    RTL_TOP="$REPO_ROOT/$rtl_top"
    RTL_GEN_TASK="$rtl_task"
    FEATURE_SET="$feat"
    FOUND=1
    break
  fi
done

if [[ $FOUND -eq 0 ]]; then
  echo "Unsupported processor: $PROCESSOR" >&2
  echo ""
  print_usage
  exit 1
fi

if [[ "$PROCESSOR" == "octonyte" && "$TIMEOUT_SPECIFIED" == "false" ]]; then
  TIMEOUT_SECS=120
fi

# Prefer local virtualenv bins early so riscof check succeeds
VENV_BIN="$REPO_ROOT/.venv/bin"
if [[ -d "$VENV_BIN" ]]; then
  export PATH="$VENV_BIN:$PATH"
else
  echo "Warning: expected virtual environment bin directory at $VENV_BIN" >&2
fi

# Toolchain prefix (riscv32 toolchains often installed as riscv64-unknown-elf-)
export RISCV_PREFIX="${RISCV_TOOLCHAIN_PREFIX:-riscv64-unknown-elf-}"

# Provide riscv32 aliases to the riscv64 toolchain if needed
ALIAS_BIN="$SCRIPT_DIR/toolchain_alias/bin"
mkdir -p "$ALIAS_BIN"
TOOLS=(gcc g++ as ld objcopy objdump ar ranlib readelf)
for t in "${TOOLS[@]}"; do
  if [[ ! -x "$ALIAS_BIN/riscv32-unknown-elf-$t" ]]; then
    ln -sf "/opt/riscv/bin/riscv64-unknown-elf-$t" "$ALIAS_BIN/riscv32-unknown-elf-$t" || true
  fi
done
export PATH="$ALIAS_BIN:$PATH"

if [[ ! -d "$RISCV_ARCH_TEST_ROOT" ]]; then
  echo "RISCV_ARCH_TEST_ROOT not found at $RISCV_ARCH_TEST_ROOT" >&2
  exit 1
fi

RISCOF_CMD=()
if [[ -x "$VENV_BIN/python3" ]] && "$VENV_BIN/python3" -c "import riscof.cli" >/dev/null 2>&1; then
  RISCOF_CMD=("$VENV_BIN/python3" -m riscof.cli)
elif command -v riscof >/dev/null 2>&1; then
  RISCOF_CMD=(riscof)
else
  echo "riscof CLI not found. Install riscof in your Python environment." >&2
  exit 1
fi

if [[ ! -x "$SIM_BUILD_SCRIPT" ]]; then
  echo "Simulation build script not found for $PROCESSOR: $SIM_BUILD_SCRIPT" >&2
  exit 1
fi

# Ensure timed hierarchical RTL exists; generate via sbt if missing
if [[ ! -f "$RTL_TOP" ]]; then
  echo "Timed RTL not found at $RTL_TOP. Attempting to generate via sbt $RTL_GEN_TASK ..."
  pushd "$REPO_ROOT/rtl" >/dev/null
  sbt "$RTL_GEN_TASK"
  popd >/dev/null
  if [[ ! -f "$RTL_TOP" ]]; then
    echo "Failed to generate RTL for $PROCESSOR at $RTL_TOP" >&2
    exit 1
  fi
fi

# Dynamic suite builder based on feature set
DYN_SUITE="$SCRIPT_DIR/output/dyn_suite_$PROCESSOR"
rm -rf "$DYN_SUITE"
mkdir -p "$DYN_SUITE/I/src"
mkdir -p "$DYN_SUITE/I/references"

cp "$BASE_SUITE_I/src/"*.S "$DYN_SUITE/I/src/" 2>/dev/null || true
cp "$BASE_SUITE_I/references/"* "$DYN_SUITE/I/references/" 2>/dev/null || true

if [[ "$FEATURE_SET" == "zmmul" ]]; then
  cp "$BASE_SUITE_M/src/mul"*.S "$DYN_SUITE/I/src/" 2>/dev/null || true
  cp "$BASE_SUITE_M/references/mul"* "$DYN_SUITE/I/references/" 2>/dev/null || true
elif [[ "$FEATURE_SET" == "im" ]]; then
  cp "$BASE_SUITE_M/src/"*.S "$DYN_SUITE/I/src/" 2>/dev/null || true
  cp "$BASE_SUITE_M/references/"* "$DYN_SUITE/I/references/" 2>/dev/null || true
fi

SUITE_ROOT="$DYN_SUITE"

"$SIM_BUILD_SCRIPT"

PLUGIN_DIR="$SCRIPT_DIR/riscof/$DUT_NAME"
if [[ ! -d "$PLUGIN_DIR" ]]; then
  echo "RISCOF plugin directory not found for $PROCESSOR: $PLUGIN_DIR" >&2
  exit 1
fi

OUTPUT_DIR="$SCRIPT_DIR/output/conformance/$PROCESSOR"
mkdir -p "$OUTPUT_DIR"

CONFIG_GENERATED="$SCRIPT_DIR/riscof/.config.${PROCESSOR}.ini"
cat >"$CONFIG_GENERATED" <<EOF
[RISCOF]
ReferencePlugin=spike_simple
ReferencePluginPath=$PLUGIN_ROOT/spike_simple
DUTPlugin=$DUT_NAME
DUTPluginPath=$DUT_NAME

[$DUT_NAME]
pluginpath=$DUT_NAME
ispec=$ISA_FILE
pspec=$PLATFORM_FILE
PATH=../sim/build
sim=$SIM_BINARY
jobs=1

[spike_simple]
pluginpath=$PLUGIN_ROOT/spike_simple
ispec=$PLUGIN_ROOT/spike_simple/spike_simple_isa.yaml
pspec=$PLUGIN_ROOT/spike_simple/spike_simple_platform.yaml
PATH=
EOF

# Workaround for Spike signature dumps failing on multi-threaded concurrent simulators
# Because spike outputs into a single flat directory namespace, SMOKE TEST checks are isolated
if $SMOKE_TEST; then
  # In smoke test we just run the first ADD test manually via the bash script bypassing riscof suite runner
  echo ""
  echo "=============================="
  echo "[SMOKE] Starting add-01.S for $PROCESSOR"
  
  SMOKE_WORK_DIR="$OUTPUT_DIR/add-01"
  mkdir -p "$SMOKE_WORK_DIR"
  
  SMOKE_SUITE_DIR="$SCRIPT_DIR/output/smoke_suite_$PROCESSOR/add-01_suite"
  rm -rf "$SMOKE_SUITE_DIR"
  mkdir -p "$SMOKE_SUITE_DIR/src"
  mkdir -p "$SMOKE_SUITE_DIR/references"
  
  cp "$BASE_SUITE_I/src/add-01.S" "$SMOKE_SUITE_DIR/src/"
  cp "$BASE_SUITE_I/references/add-01.reference_output" "$SMOKE_SUITE_DIR/references/" 2>/dev/null || true
  
  pushd "$SCRIPT_DIR/riscof" >/dev/null
  "${RISCOF_CMD[@]}" run --config "$CONFIG_GENERATED" --suite "$SMOKE_SUITE_DIR" --env "$ENV_ROOT" --work-dir "$SMOKE_WORK_DIR"
  popd >/dev/null

  # Evaluate Multi-threading coherence identically for all targets
  COPIED=("add-01")
  
  if [[ "$PROCESSOR" == "tetranyte" || "$PROCESSOR" == "tetranyte-mrf" || "$PROCESSOR" == "octonyte" ]]; then
    for test_name in "${COPIED[@]}"; do
      ELF_PATH=$(find "$SMOKE_WORK_DIR" -path "*${test_name}/dut/*.elf" | head -n1 || true)
      REF_SIG=$(find "$SMOKE_WORK_DIR" -path "*${test_name}/ref/Reference-spike.signature" | head -n1 || true)
      
      if [[ -z "$ELF_PATH" || ! -f "$ELF_PATH" ]]; then
        echo "Could not locate ELF for $test_name under $SMOKE_WORK_DIR" >&2
        continue
      fi
      
      echo "Running per-thread smoke comparisons using $ELF_PATH"
      declare -a THREAD_SIGS=()
      
      NUM_THREADS=4
      if [[ "$PROCESSOR" == "octonyte" ]]; then
        NUM_THREADS=8
      fi
      
      for ((tid=0; tid<NUM_THREADS; tid++)); do
        SIG_PATH="$SMOKE_WORK_DIR/${test_name}/dut/DUT-${DUT_NAME}.thread${tid}.signature"
        LOG_PATH="$SMOKE_WORK_DIR/${test_name}/dut/DUT-${DUT_NAME}.thread${tid}.log"
        THREAD_MASK=$((1 << tid))
        
        VL_TOP="VTetraNyteRV32ICore"
        OBJ_DIR="tetranyte_obj"
        if [[ "$PROCESSOR" == "tetranyte-mrf" ]]; then
          VL_TOP="VTetraNyteRV32ICoreMRF"
          OBJ_DIR="tetranyte_mrf_obj"
        elif [[ "$PROCESSOR" == "octonyte" ]]; then
          VL_TOP="VOctoNyteRV32ICore"
          OBJ_DIR="octonyte_obj"
        fi
        
        "$SCRIPT_DIR/sim/build/${OBJ_DIR}/${VL_TOP}" \
          --elf "$ELF_PATH" \
          --signature "$SIG_PATH" \
          --log "$LOG_PATH" \
          --max-cycles 200000 \
          --thread-mask "$THREAD_MASK" \
          --trace-stage || { echo "Thread $tid simulation failed for $test_name" >&2; exit 1; }
          
        echo "[INFO] Thread $tid simulation done for $test_name. Signature: $SIG_PATH"
        THREAD_SIGS+=("$SIG_PATH")
      done
      
      BASE_SIG="${THREAD_SIGS[0]}"
      for sig in "${THREAD_SIGS[@]:1}"; do
        if ! cmp -s "$BASE_SIG" "$sig"; then
          echo "Thread signature mismatch for $test_name: $BASE_SIG vs $sig" >&2
          exit 1
        fi
      done
      echo "[INFO] All thread signatures match each other for $test_name."
      if [[ -n "$REF_SIG" && -f "$REF_SIG" ]]; then
        if cmp -s "$BASE_SIG" "$REF_SIG"; then
          echo "[INFO] Thread signatures match spike reference for $test_name."
        else
          echo "[FAIL] Thread signatures do not match spike reference for $test_name."
          exit 1
        fi
      fi
    done
  fi
  
  echo "[SMOKE] add-01.S PASSED (artifacts under $SMOKE_WORK_DIR)"
  exit 0
fi

# Standard full run
pushd "$SCRIPT_DIR/riscof" >/dev/null
"${RISCOF_CMD[@]}" run --config "$CONFIG_GENERATED" --suite "$SUITE_ROOT" --env "$ENV_ROOT" --work-dir "$OUTPUT_DIR"
popd >/dev/null

echo "RISCV RV32 conformance results for $PROCESSOR available under $OUTPUT_DIR"
