#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(dirname "$SCRIPT_DIR")

RISCV_ARCH_TEST_ROOT=${RISCV_ARCH_TEST_ROOT:-/opt/riscv-conformance/riscv-arch-test}
PLUGIN_ROOT="$RISCV_ARCH_TEST_ROOT/riscof-plugins/rv32"
SUITE_ROOT="$RISCV_ARCH_TEST_ROOT/riscv-test-suite/rv32i_m/I"
ENV_ROOT="$RISCV_ARCH_TEST_ROOT/riscv-test-suite/env"

if [[ ! -d "$RISCV_ARCH_TEST_ROOT" ]]; then
  echo "RISCV_ARCH_TEST_ROOT not found at $RISCV_ARCH_TEST_ROOT" >&2
  exit 1
fi

if ! command -v riscof >/dev/null 2>&1; then
  echo "riscof CLI not found. Install riscof in your Python environment." >&2
  exit 1
fi

"$SCRIPT_DIR/sim/build_zeronyte_sim.sh"

CONFIG_TEMPLATE="$SCRIPT_DIR/riscof/config.ini"
CONFIG_GENERATED="$SCRIPT_DIR/riscof/.config.rv32i.ini"
sed "s|@RISCV_PLUGIN_ROOT@|$PLUGIN_ROOT|g" "$CONFIG_TEMPLATE" > "$CONFIG_GENERATED"

OUTPUT_DIR="$SCRIPT_DIR/output/rv32i"
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

echo "RISCV RV32I conformance results available under $OUTPUT_DIR"
