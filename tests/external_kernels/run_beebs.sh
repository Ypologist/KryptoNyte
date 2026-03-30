#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)
BEEBS_ROOT=${BEEBS_ROOT:-"$REPO_ROOT/../external-kernels/beebs"}
PATCH_FILE="$SCRIPT_DIR/beebs_signature.patch"
BEEBS_CONFIG_LOG="$BEEBS_ROOT/config.status"
LINKER_SCRIPT="$REPO_ROOT/tests/functional_tests/link.ld"

RISCV_PREFIX=${RISCV_PREFIX:-/opt/riscv/bin/riscv64-unknown-elf-}
RISCV_GCC=${RISCV_GCC:-${RISCV_PREFIX}gcc}
RISCV_AR=${RISCV_AR:-${RISCV_PREFIX}ar}
RISCV_RANLIB=${RISCV_RANLIB:-${RISCV_PREFIX}ranlib}
RISCV_OBJDUMP=${RISCV_OBJDUMP:-${RISCV_PREFIX}objdump}
RISCV_OBJCOPY=${RISCV_OBJCOPY:-${RISCV_PREFIX}objcopy}

SPIKE_BIN=${SPIKE_BIN:-/opt/riscv/bin/spike}
ISA=${ISA:-rv32i}

usage() {
  cat <<USAGE
Usage: $(basename "$0") --benchmark <name> [--out-dir <path>] [--max-cycles <count>] [--force-configure]

Builds and runs the requested BEEBS benchmark using Spike (reference) and ZeroNyte RTL.
Requires the BEEBS repository at $BEEBS_ROOT (clone via tests/external_kernels/clone_all.sh).

Options:
  --benchmark <name>   Benchmark directory under beebs/src (e.g. cnt, fir, qsort).
  --out-dir <path>     Output directory for artifacts (defaults to tests/output/external/beebs/<name>).
  --max-cycles <n>     Cycle limit for zeronyte_sim (default: 1000000).
  --force-configure    Re-run ./configure even if config.status exists.
USAGE
}

BENCH=""
OUT_DIR=""
MAX_CYCLES=1000000
FORCE_CONFIGURE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --benchmark)
      BENCH="$2"
      shift 2
      ;;
    --out-dir)
      OUT_DIR="$2"
      shift 2
      ;;
    --max-cycles)
      MAX_CYCLES="$2"
      shift 2
      ;;
    --force-configure)
      FORCE_CONFIGURE=1
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

if [[ -z "$BENCH" ]]; then
  echo "Error: --benchmark is required." >&2
  usage >&2
  exit 1
fi

if [[ ! -d "$BEEBS_ROOT" ]]; then
  echo "BEEBS repository not found at $BEEBS_ROOT. Run tests/external_kernels/clone_all.sh first." >&2
  exit 1
fi

if [[ ! -f "$PATCH_FILE" ]]; then
  echo "Missing patch file: $PATCH_FILE" >&2
  exit 1
fi

ensure_patch_applied() {
  if grep -q "zeronyte_signature_buffer" "$BEEBS_ROOT/support/main.c" && \
     [[ -f "$BEEBS_ROOT/config/riscv32/chips/ri5cy/link.ld" ]]; then
    return
  fi
  echo "[beebs] Applying Zeronyte signature patch..."
  (cd "$BEEBS_ROOT" && git apply "$PATCH_FILE")
}

configure_beebs() {
  if [[ "$FORCE_CONFIGURE" -eq 0 && -f "$BEEBS_CONFIG_LOG" ]]; then
    return
  fi
  echo "[beebs] Configuring for riscv32-unknown-elf (chip=ri5cy, board=generic)..."
  pushd "$BEEBS_ROOT" >/dev/null
  CC="$RISCV_GCC -mabi=ilp32 -march=rv32i" \
  AR="$RISCV_AR" \
  RANLIB="$RISCV_RANLIB" \
  OBJDUMP="$RISCV_OBJDUMP" \
  OBJCOPY="$RISCV_OBJCOPY" \
    ./configure \
      --host=riscv32-unknown-elf \
      --with-arch=riscv32 \
      --with-chip=ri5cy \
      --with-board=generic
  popd >/dev/null
}

build_common_libs() {
  echo "[beebs] Building support libraries..."
  make -C "$BEEBS_ROOT/support" \
    libsupport.la \
    libdummycrt0.la \
    libdummyc.la \
    libdummygcc.la \
    libdummym.la >/dev/null
}

build_benchmark() {
  echo "[beebs] Building benchmark '$BENCH'..."
  make -C "$BEEBS_ROOT/src/$BENCH" "$BENCH"
}

clean_benchmark() {
  if [[ -d "$BEEBS_ROOT/src/$BENCH" ]]; then
    make -C "$BEEBS_ROOT/src/$BENCH" clean >/dev/null || true
  fi
}
find_elf() {
  local elf_path
  elf_path=$(find "$BEEBS_ROOT/src/$BENCH" -maxdepth 2 -type f -perm -111 -name "$BENCH" | head -n1 || true)
  if [[ -z "$elf_path" ]]; then
    elf_path=$(find "$BEEBS_ROOT/src/$BENCH/.libs" -type f -name "$BENCH" | head -n1 || true)
  fi
  if [[ -z "$elf_path" ]]; then
    echo "Failed to locate ELF for benchmark '$BENCH' under $BEEBS_ROOT/src/$BENCH" >&2
    exit 1
  fi
  echo "$elf_path"
}

ensure_patch_applied
configure_beebs
build_common_libs
clean_benchmark
build_benchmark

ELF_PATH=$(find_elf)
echo "[beebs] ELF: $ELF_PATH"

if [[ -z "$OUT_DIR" ]]; then
  OUT_DIR="$REPO_ROOT/tests/output/external/beebs/$BENCH"
fi
mkdir -p "$OUT_DIR"

SPIKE_SIG="$OUT_DIR/spike.signature"
SPIKE_LOG="$OUT_DIR/spike.log"
RTL_SIG="$OUT_DIR/zeronyte.signature"
RTL_LOG="$OUT_DIR/zeronyte.log"

echo "[beebs] Running Spike reference..."
"$SPIKE_BIN" \
  --isa="$ISA" \
  +signature="$SPIKE_SIG" \
  +signature-granularity=4 \
  "$ELF_PATH" \
  >"$SPIKE_LOG" 2>&1

ZERONYTE_SIM="$REPO_ROOT/tests/sim/build/zeronyte_sim"
if [[ ! -x "$ZERONYTE_SIM" ]]; then
  "$REPO_ROOT/tests/sim/build_zeronyte_sim.sh"
fi

echo "[beebs] Running ZeroNyte RTL..."
"$ZERONYTE_SIM" \
  --elf "$ELF_PATH" \
  --signature "$RTL_SIG" \
  --log "$RTL_LOG" \
  --max-cycles "$MAX_CYCLES"

echo "[beebs] Comparing signatures..."
if cmp -s "$SPIKE_SIG" "$RTL_SIG"; then
  echo "[beebs] PASS: signatures match for $BENCH (artifacts in $OUT_DIR)"
else
  echo "[beebs] FAIL: signature mismatch for $BENCH" >&2
  diff -u "$SPIKE_SIG" "$RTL_SIG" || true
  exit 1
fi
