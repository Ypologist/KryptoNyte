#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)

OUT_DIR="$REPO_ROOT/tests/output/functional_tests/dot_product/zeronyte"
MAX_CYCLES=1000000
KEEP_OUTPUT=0

RISCV_GCC="${RISCV_GCC:-/opt/riscv/bin/riscv64-unknown-elf-gcc}"
SPIKE_BIN="${SPIKE_BIN:-/opt/riscv/bin/spike}"
ISA="${ISA:-rv32i}"

usage() {
  cat <<EOF
Usage: $(basename "$0") [--out-dir <path>] [--max-cycles <count>] [--keep-output]

Builds and runs tests/functional_tests/dot_product.c on:
1) Spike (reference signature)
2) ZeroNyte RTL simulator (DUT signature)

Then compares signatures and fails on mismatch.

Environment overrides:
  RISCV_GCC  Cross compiler (default: /opt/riscv/bin/riscv64-unknown-elf-gcc)
  SPIKE_BIN  Spike executable (default: /opt/riscv/bin/spike)
  ISA        ISA string for compile + spike (default: rv32i)
EOF
}

require_cmd() {
  local tool="$1"
  if [[ "$tool" == */* ]]; then
    if [[ ! -x "$tool" ]]; then
      echo "Required executable not found: $tool" >&2
      exit 1
    fi
    return
  fi
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Required executable not found in PATH: $tool" >&2
    exit 1
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --out-dir)
      if [[ $# -lt 2 ]]; then
        echo "Error: --out-dir requires a path" >&2
        exit 1
      fi
      OUT_DIR="$2"
      shift 2
      ;;
    --max-cycles)
      if [[ $# -lt 2 ]]; then
        echo "Error: --max-cycles requires an integer argument" >&2
        exit 1
      fi
      MAX_CYCLES="$2"
      shift 2
      ;;
    --keep-output)
      KEEP_OUTPUT=1
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

require_cmd "$RISCV_GCC"
require_cmd "$SPIKE_BIN"
require_cmd cmp
require_cmd diff

if [[ "$KEEP_OUTPUT" -eq 0 ]]; then
  rm -rf "$OUT_DIR"
fi
mkdir -p "$OUT_DIR"

ELF="$OUT_DIR/dot_product.elf"
MAP="$OUT_DIR/dot_product.map"
SPIKE_SIG="$OUT_DIR/spike.signature"
SPIKE_LOG="$OUT_DIR/spike.log"
RTL_SIG="$OUT_DIR/zeronyte.signature"
RTL_LOG="$OUT_DIR/zeronyte.log"

echo "[1/4] Building RV32 test ELF..."
"$RISCV_GCC" \
  -march="$ISA" \
  -mabi=ilp32 \
  -mcmodel=medany \
  -static \
  -O2 \
  -ffreestanding \
  -fno-builtin \
  -fno-stack-protector \
  -nostdlib \
  -nostartfiles \
  -Wl,--build-id=none \
  -Wl,-Map,"$MAP" \
  -T "$SCRIPT_DIR/link.ld" \
  "$SCRIPT_DIR/crt0.S" \
  "$SCRIPT_DIR/signature.S" \
  "$SCRIPT_DIR/dot_product.c" \
  -o "$ELF"

echo "[2/4] Running Spike reference..."
"$SPIKE_BIN" \
  -m8796093022208 \
  --isa="$ISA" \
  +signature="$SPIKE_SIG" \
  +signature-granularity=4 \
  "$ELF" \
  >"$SPIKE_LOG" 2>&1

echo "[3/4] Building and running ZeroNyte RTL simulator..."
"$REPO_ROOT/tests/sim/build_zeronyte_sim.sh"

ZERONYTE_SIM="$REPO_ROOT/tests/sim/build/zeronyte_sim"
if [[ ! -x "$ZERONYTE_SIM" ]]; then
  echo "Expected simulator at $ZERONYTE_SIM after build." >&2
  exit 1
fi

"$ZERONYTE_SIM" \
  --elf "$ELF" \
  --signature "$RTL_SIG" \
  --log "$RTL_LOG" \
  --max-cycles "$MAX_CYCLES"

echo "[4/4] Comparing signatures..."
if cmp -s "$SPIKE_SIG" "$RTL_SIG"; then
  echo "PASS: ZeroNyte signature matches Spike reference."
  echo "Artifacts: $OUT_DIR"
  exit 0
fi

echo "FAIL: signature mismatch between Spike and ZeroNyte." >&2
echo "Diff:" >&2
diff -u "$SPIKE_SIG" "$RTL_SIG" || true
echo "Artifacts: $OUT_DIR" >&2
exit 1
