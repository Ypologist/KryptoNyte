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
[--smoke-test]

Runs RISCOF RV32I conformance for the requested processor. Defaults to ZeroNyte.
Use --smoke-test to run a minimal ADD-only test for quicker turnaround.
EOF
}

PROCESSOR="zeronyte"
SMOKE_TEST=false
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
    RTL_TOP="$REPO_ROOT/rtl/generators/generated/verilog_hierarchical_timed/ZeroNyteRV32ICore.v"
    RTL_GEN_TASK="generators/generateZeroNyteRTL"
    ;;
  tetranyte)
    DUT_NAME="tetranyte"
    SIM_BUILD_SCRIPT="$SCRIPT_DIR/sim/build_tetranyte_sim.sh"
    SIM_BINARY="tetranyte_sim"
    ISA_FILE="tetranyte/tetranyte_isa.yaml"
    PLATFORM_FILE="tetranyte/tetranyte_platform.yaml"
    RTL_TOP="$REPO_ROOT/rtl/generators/generated/verilog_hierarchical_timed/TetraNyteRV32ICore.v"
    RTL_GEN_TASK="generators/generateTetraNyteRTL"
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

OUTPUT_DIR="$SCRIPT_DIR/output/rv32i/$PROCESSOR"
mkdir -p "$OUTPUT_DIR"

SUITE_PATH="$SUITE_ROOT"
if $SMOKE_TEST; then
  SMOKE_DIR="$SCRIPT_DIR/smoke_suite"
  mkdir -p "$SMOKE_DIR"
  if [[ ! -d "$SMOKE_DIR/.git" ]]; then
    git -C "$SMOKE_DIR" init -q
  fi
  if ! git -C "$SMOKE_DIR" rev-parse --verify HEAD >/dev/null 2>&1; then
    GIT_AUTHOR_NAME=smoke GIT_AUTHOR_EMAIL=smoke@example.com \
    GIT_COMMITTER_NAME=smoke GIT_COMMITTER_EMAIL=smoke@example.com \
      git -C "$SMOKE_DIR" commit --allow-empty -m "init" -q
  fi
  if ! git -C "$SMOKE_DIR" remote | grep -q "^origin$"; then
    git -C "$SMOKE_DIR" remote add origin "$SMOKE_DIR" >/dev/null
  fi
  rm -rf "$SMOKE_DIR/src"
  mkdir -p "$SMOKE_DIR/src"
  SMOKE_TEST_FILE="$SUITE_ROOT/src/add-01.S"
  if [[ ! -f "$SMOKE_TEST_FILE" ]]; then
    SMOKE_TEST_FILE="$SUITE_ROOT/src/ADD-01.S"
  fi
  if [[ ! -f "$SMOKE_TEST_FILE" ]]; then
    echo "Smoke test add-01.S not found under $SUITE_ROOT" >&2
    exit 1
  fi
  cp "$SMOKE_TEST_FILE" "$SMOKE_DIR/src/"
  SUITE_PATH="$SMOKE_DIR"
  echo "Smoke test enabled: running only $(basename "$SMOKE_TEST_FILE")"
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
RISCOF_TIMEOUT=${RISCOF_TIMEOUT:-1800} \
  riscof run \
  --config "$CONFIG_GENERATED" \
  --work-dir "$OUTPUT_DIR" \
  --suite "$SUITE_PATH" \
  --env "$ENV_ROOT"
popd >/dev/null

echo "RISCV RV32I conformance results for $PROCESSOR available under $OUTPUT_DIR"
