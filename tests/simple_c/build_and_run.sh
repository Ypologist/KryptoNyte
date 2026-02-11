#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)

CORE=${CORE:-tetranyte}
SIG_EXPECTED="$SCRIPT_DIR/expected.signature"

case "$CORE" in
  zeronyte)
    SIM_BUILD="$REPO_ROOT/tests/sim/build_zeronyte_sim.sh"
    SIM_BIN="$REPO_ROOT/tests/sim/build/zeronyte_sim"
    ;;
  zeronyte-cache)
    SIM_BUILD="$REPO_ROOT/tests/sim/build_zeronyte_cache_sim.sh"
    SIM_BIN="$REPO_ROOT/tests/sim/build/zeronyte_cache_sim"
    ;;
  tetranyte)
    SIM_BUILD="$REPO_ROOT/tests/sim/build_tetranyte_sim.sh"
    SIM_BIN="$REPO_ROOT/tests/sim/build/tetranyte_sim"
    ;;
  octonyte)
    SIM_BUILD="$REPO_ROOT/tests/sim/build_octonyte_sim.sh"
    SIM_BIN="$REPO_ROOT/tests/sim/build/octonyte_sim"
    ;;
  *)
    echo "Unsupported CORE: $CORE" >&2
    exit 1
    ;;
esac

RISCV_PREFIX=${RISCV_PREFIX:-riscv64-unknown-elf-}
CC="${RISCV_PREFIX}gcc"
OBJDUMP="${RISCV_PREFIX}objdump"

BUILD_DIR="$SCRIPT_DIR/build"
mkdir -p "$BUILD_DIR"

ELF="$BUILD_DIR/simple_signature.elf"
SIG_OUT="$BUILD_DIR/simple.signature"
LOG_OUT="$BUILD_DIR/simple.log"

CFLAGS=(
  -march=rv32i
  -mabi=ilp32
  -mcmodel=medany
  -static
  -nostdlib
  -nostartfiles
  -g
)

"$CC" "${CFLAGS[@]}" \
  -T "$SCRIPT_DIR/link.ld" \
  "$SCRIPT_DIR/start.S" \
  "$SCRIPT_DIR/platform.S" \
  "$SCRIPT_DIR/simple_signature.c" \
  -o "$ELF"

if [[ -x "$OBJDUMP" ]]; then
  "$OBJDUMP" -d "$ELF" >"$BUILD_DIR/simple_signature.disasm"
fi

if [[ ! -x "$SIM_BIN" ]]; then
  "$SIM_BUILD"
fi

"$SIM_BIN" --elf "$ELF" --signature "$SIG_OUT" --log "$LOG_OUT" --max-cycles 200000

if [[ -f "$SIG_EXPECTED" ]]; then
  if diff -u "$SIG_EXPECTED" "$SIG_OUT"; then
    echo "Signature matches expected output."
  else
    echo "Signature mismatch. See $SIG_OUT and $SIG_EXPECTED." >&2
    exit 2
  fi
fi
