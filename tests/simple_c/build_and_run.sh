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
HTML_OUT="$BUILD_DIR/simple_report.html"
REF_SIG="$BUILD_DIR/simple.reference.signature"
REF_LOG="$BUILD_DIR/simple.reference.log"

CFLAGS=(
  -march=rv32i
  -mabi=ilp32
  -mcmodel=medany
  -static
  -nostdlib
  -nostartfiles
  -ffreestanding
  -fno-builtin
  -g
  -DXLEN=32
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

USE_REF=0
if command -v spike >/dev/null 2>&1; then
  if spike -m8796093022208 --isa=rv32i \
      +signature="$REF_SIG" +signature-granularity=4 \
      "$ELF" >"$REF_LOG" 2>&1; then
    USE_REF=1
  else
    echo "Warning: spike reference run failed; falling back to static expected.signature." >&2
  fi
fi

"$SIM_BIN" --elf "$ELF" --signature "$SIG_OUT" --log "$LOG_OUT" --max-cycles 200000

if [[ "$USE_REF" -eq 1 && -f "$REF_SIG" ]]; then
  if diff -u "$REF_SIG" "$SIG_OUT"; then
    echo "Signature matches reference (spike) output."
  else
    echo "Signature mismatch vs reference. See $SIG_OUT and $REF_SIG." >&2
    exit 2
  fi
else
  if [[ -f "$SIG_EXPECTED" ]]; then
    if diff -u "$SIG_EXPECTED" "$SIG_OUT"; then
      echo "Signature matches expected output."
    else
      echo "Signature mismatch. See $SIG_OUT and $SIG_EXPECTED." >&2
      exit 2
    fi
  fi
fi

EXPECTED_PATH="$SIG_EXPECTED"
if [[ "$USE_REF" -eq 1 && -f "$REF_SIG" ]]; then
  EXPECTED_PATH="$REF_SIG"
fi

python3 "$SCRIPT_DIR/generate_report.py" \
  --expected "$EXPECTED_PATH" \
  --actual "$SIG_OUT" \
  --log "$LOG_OUT" \
  --out "$HTML_OUT"
echo "HTML report: $HTML_OUT"

# Auto-open report on Ubuntu desktop if a GUI session is available.
if command -v xdg-open >/dev/null 2>&1; then
  if [[ -n "${DISPLAY:-}" || -n "${WAYLAND_DISPLAY:-}" ]]; then
    xdg-open "$HTML_OUT" >/dev/null 2>&1 &
  fi
fi
