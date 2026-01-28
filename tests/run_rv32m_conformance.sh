#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(dirname "$SCRIPT_DIR")

RISCV_ARCH_TEST_ROOT=${RISCV_ARCH_TEST_ROOT:-/opt/riscv-conformance/riscv-arch-test}
PLUGIN_ROOT="$RISCV_ARCH_TEST_ROOT/riscof-plugins/rv32"
SUITE_ROOT="$RISCV_ARCH_TEST_ROOT/riscv-test-suite/rv32i_m/M"
ENV_ROOT="$RISCV_ARCH_TEST_ROOT/riscv-test-suite/env"

print_usage() {
  cat <<EOF
Usage: $(basename "$0") [--processor zeronyte]

Runs RISCOF RV32M conformance for ZeroNyte.
EOF
}

PROCESSOR="zeronyte"
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
    *)
      echo "Unknown argument: $1" >&2
      print_usage >&2
      exit 1
      ;;
  esac
done

case "$PROCESSOR" in
  zeronyte)
    DUT_NAME="zeronyte"
    SIM_BUILD_SCRIPT="$SCRIPT_DIR/sim/build_zeronyte_sim.sh"
    SIM_BINARY="zeronyte_sim"
    ISA_FILE="zeronyte/zeronyte_isa_m.yaml"
    PLATFORM_FILE="zeronyte/zeronyte_platform.yaml"
    RTL_TOP="$REPO_ROOT/rtl/generators/generated/verilog_hierarchical_timed/ZeroNyteRV32ICore.v"
    RTL_GEN_TASK="generators/generateZeroNyteRTL"
    ;;
  *)
    echo "Unsupported processor: $PROCESSOR" >&2
    exit 1
    ;;
esac

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

if ! command -v riscof >/dev/null 2>&1; then
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

"$SIM_BUILD_SCRIPT"

PLUGIN_DIR="$SCRIPT_DIR/riscof/$DUT_NAME"
if [[ ! -d "$PLUGIN_DIR" ]]; then
  echo "RISCOF plugin directory not found for $PROCESSOR: $PLUGIN_DIR" >&2
  exit 1
fi

OUTPUT_DIR="$SCRIPT_DIR/output/rv32m/$PROCESSOR"
mkdir -p "$OUTPUT_DIR"

CONFIG_GENERATED="$SCRIPT_DIR/riscof/.config.rv32m.${PROCESSOR}.ini"
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

pushd "$SCRIPT_DIR/riscof" >/dev/null
riscof run --config "$CONFIG_GENERATED" --suite "$SUITE_ROOT" --env "$ENV_ROOT" --work-dir "$OUTPUT_DIR"
popd >/dev/null

echo "RISCV RV32M conformance results for $PROCESSOR available under $OUTPUT_DIR"
