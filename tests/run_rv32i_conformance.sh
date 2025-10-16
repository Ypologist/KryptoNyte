#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(dirname "$SCRIPT_DIR")

RISCV_ARCH_TEST_ROOT=${RISCV_ARCH_TEST_ROOT:-/opt/riscv-conformance/riscv-arch-test}
PLUGIN_ROOT="$RISCV_ARCH_TEST_ROOT/riscof-plugins/rv32"
SUITE_ROOT="$RISCV_ARCH_TEST_ROOT/riscv-test-suite/rv32i_m/I"
ENV_ROOT="$RISCV_ARCH_TEST_ROOT/riscv-test-suite/env"

print_usage() {
  cat <<EOF
Usage: $(basename "$0") [--processor <zeronyte|tetranyte>]

Runs RISCOF RV32I conformance for the requested processor. Defaults to ZeroNyte.
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
    ISA_FILE="zeronyte/zeronyte_isa.yaml"
    PLATFORM_FILE="zeronyte/zeronyte_platform.yaml"
    ;;
  tetranyte)
    DUT_NAME="tetranyte"
    SIM_BUILD_SCRIPT="$SCRIPT_DIR/sim/build_tetranyte_sim.sh"
    SIM_BINARY="tetranyte_sim"
    ISA_FILE="tetranyte/tetranyte_isa.yaml"
    PLATFORM_FILE="tetranyte/tetranyte_platform.yaml"
    ;;
  *)
    echo "Unsupported processor: $PROCESSOR" >&2
    exit 1
    ;;
esac

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

"$SIM_BUILD_SCRIPT"

PLUGIN_DIR="$SCRIPT_DIR/riscof/$DUT_NAME"
if [[ ! -d "$PLUGIN_DIR" ]]; then
  echo "RISCOF plugin directory not found for $PROCESSOR: $PLUGIN_DIR" >&2
  exit 1
fi

CONFIG_GENERATED="$SCRIPT_DIR/riscof/.config.rv32i.${PROCESSOR}.ini"
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
PATH=/opt/riscv/bin
jobs=1
EOF

OUTPUT_DIR="$SCRIPT_DIR/output/rv32i/$PROCESSOR"
mkdir -p "$OUTPUT_DIR"

VENV_BIN="$REPO_ROOT/.venv/bin"
if [[ ! -d "$VENV_BIN" ]]; then
  echo "Warning: expected virtual environment bin directory at $VENV_BIN" >&2
fi

TOOLCHAIN_DIR="$SCRIPT_DIR/toolchain"
mkdir -p "$TOOLCHAIN_DIR"
create_wrapper() {
  local tool="$1"
  local suffix=${tool#riscv32-unknown-elf-}
  cat >"$TOOLCHAIN_DIR/$tool" <<EOF
#!/usr/bin/env bash
exec riscv64-unknown-elf-$suffix "\$@"
EOF
  chmod +x "$TOOLCHAIN_DIR/$tool"
}
for tool in gcc g++ objcopy objdump readelf; do
  create_wrapper "riscv32-unknown-elf-$tool"
done

export PATH="$TOOLCHAIN_DIR:$PATH"
export PYTHONPATH="$VENV_BIN:${PYTHONPATH:-}"
export PYTHONPATH="$SCRIPT_DIR/riscof:$PLUGIN_ROOT:$PYTHONPATH"

pushd "$SCRIPT_DIR/riscof" >/dev/null
riscof run \
  --config "$CONFIG_GENERATED" \
  --work-dir "$OUTPUT_DIR" \
  --suite "$SUITE_ROOT" \
  --env "$ENV_ROOT"
popd >/dev/null

echo "RISCV RV32I conformance results for $PROCESSOR available under $OUTPUT_DIR"
