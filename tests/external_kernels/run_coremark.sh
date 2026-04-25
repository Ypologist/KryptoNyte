#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)
COREMARK_ROOT=${COREMARK_ROOT:-"$REPO_ROOT/../external-kernels/coremark"}
PORT_NAME="kryptonnyte"
PORT_SRC="$SCRIPT_DIR/coremark_port"
PORT_DST="$COREMARK_ROOT/$PORT_NAME"
BUILD_DIR="$COREMARK_ROOT/build/$PORT_NAME"
DEFAULT_OUT_DIR="$REPO_ROOT/tests/output/external/coremark"

RISCV_PREFIX=${RISCV_PREFIX:-$REPO_ROOT/.venv/tools/riscv/bin/riscv64-unknown-elf-}
SPIKE_BIN=${SPIKE_BIN:-$REPO_ROOT/.venv/tools/riscv/bin/spike}
ISA=${ISA:-rv32i}

ITERATIONS=1
OUT_DIR=""
MAX_CYCLES=20000000
PROCESSOR="tetranyte"
THREAD_MASK=""
RUN_ALL_THREADS=0
SKIP_SPIKE=0
FORCE_REBUILD=0
COREMARK_XCFLAGS=${COREMARK_XCFLAGS:-"-DPERFORMANCE_RUN=1"}

usage() {
  cat <<USAGE
Usage: $(basename "$0") [options]

Builds CoreMark for the KryptoNyte cores and runs Spike + RTL to compare signatures.

Options:
  --iterations <n>     CoreMark iterations (default: $ITERATIONS)
  --processor <name>   zeronyte or tetranyte (default: tetranyte)
  --thread-mask <mask> Enable a specific TetraNyte thread mask (default: 0x1)
  --all-threads        Run TetraNyte 4 times (thread0..thread3)
  --max-cycles <n>     RTL max cycles (default: $MAX_CYCLES)
  --out-dir <path>     Output root (default: $DEFAULT_OUT_DIR)
  --skip-spike         Skip Spike reference run
  --force-rebuild      Delete the CoreMark build directory before compiling
  --xcflags <flags>    Extra CoreMark XCFLAGS string (default: "$COREMARK_XCFLAGS")
  --help               Show this help message
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --iterations)
      ITERATIONS="$2"; shift 2;;
    --processor)
      PROCESSOR="$2"; shift 2;;
    --thread-mask)
      THREAD_MASK="$2"; shift 2;;
    --all-threads)
      RUN_ALL_THREADS=1; shift;;
    --max-cycles)
      MAX_CYCLES="$2"; shift 2;;
    --out-dir)
      OUT_DIR="$2"; shift 2;;
    --skip-spike)
      SKIP_SPIKE=1; shift;;
    --force-rebuild)
      FORCE_REBUILD=1; shift;;
    --xcflags)
      COREMARK_XCFLAGS="$2"; shift 2;;
    --help|-h)
      usage; exit 0;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1;;
  esac
done

if [[ ! -d "$COREMARK_ROOT" ]]; then
  echo "CoreMark repo not found at $COREMARK_ROOT. Run tests/external_kernels/clone_all.sh first." >&2
  exit 1
fi

if [[ ! -d "$PORT_SRC" ]]; then
  echo "Missing port directory: $PORT_SRC" >&2
  exit 1
fi

if [[ "$RUN_ALL_THREADS" -eq 1 && -n "$THREAD_MASK" ]]; then
  echo "Cannot combine --all-threads with --thread-mask." >&2
  exit 1
fi

if [[ -z "$OUT_DIR" ]]; then
  OUT_DIR="$DEFAULT_OUT_DIR"
fi
mkdir -p "$OUT_DIR"

if command -v rsync >/dev/null 2>&1; then
  rsync -a --delete "$PORT_SRC/" "$PORT_DST/"
else
  rm -rf "$PORT_DST"
  mkdir -p "$PORT_DST"
  cp -a "$PORT_SRC/." "$PORT_DST/"
fi

declare -A SIM_BUILD
SIM_BUILD[zeronyte]="$REPO_ROOT/tests/sim/build_zeronyte_sim.sh"
SIM_BUILD[tetranyte]="$REPO_ROOT/tests/sim/build_tetranyte_sim.sh"

declare -A SIM_BIN
SIM_BIN[zeronyte]="$REPO_ROOT/tests/sim/build/zeronyte_sim"
SIM_BIN[tetranyte]="$REPO_ROOT/tests/sim/build/tetranyte_sim"

if [[ -z "${SIM_BUILD[$PROCESSOR]:-}" ]]; then
  echo "Unsupported processor: $PROCESSOR" >&2
  exit 1
fi

if [[ "$FORCE_REBUILD" -eq 1 ]]; then
  rm -rf "$BUILD_DIR"
fi

build_coremark() {
  local label="$1"
  local tag="$2"
  local build_subdir="$BUILD_DIR/$label"
  local xcflags="$COREMARK_XCFLAGS"
  if [[ -n "$tag" ]]; then
    xcflags+=" -DCOREMARK_THREAD_LABEL=$tag"
  fi
  rm -rf "$build_subdir"
  mkdir -p "$build_subdir"
  echo "[coremark] Building CoreMark for $label (xcflags=$xcflags)..." >&2
  make -C "$COREMARK_ROOT" \
    PORT_DIR="$PORT_NAME" \
    OPATH="$build_subdir/" \
    ITERATIONS="$ITERATIONS" \
    XCFLAGS="$xcflags" \
    RISCV_PREFIX="$RISCV_PREFIX" \
    REBUILD=1 \
    compile >/dev/null
  printf "%s" "$build_subdir/coremark"
}

run_label() {
  local label="$1"
  local mask="$2"
  local tag="$3"
  local elf_path
  elf_path=$(build_coremark "$label" "$tag")
  if [[ ! -f "$elf_path" ]]; then
    echo "Failed to build coremark ELF at $elf_path" >&2
    exit 1
  fi
  local run_dir="$OUT_DIR/$label"
  mkdir -p "$run_dir"
  local spike_sig="$run_dir/spike.signature"
  local spike_log="$run_dir/spike.log"
  if [[ "$SKIP_SPIKE" -eq 0 ]]; then
    echo "[coremark] Running Spike reference for $label..."
    "$SPIKE_BIN" --isa="$ISA" +signature="$spike_sig" +signature-granularity=4 "$elf_path" >"$spike_log" 2>&1
  else
    : >"$spike_sig"
  fi

  if [[ ! -x "${SIM_BIN[$PROCESSOR]}" ]]; then
    "${SIM_BUILD[$PROCESSOR]}"
  fi
  if [[ ! -x "${SIM_BIN[$PROCESSOR]}" ]]; then
    echo "Simulator binary missing: ${SIM_BIN[$PROCESSOR]}" >&2
    exit 1
  fi

  local rtl_sig="$run_dir/${PROCESSOR}.signature"
  local rtl_log="$run_dir/${PROCESSOR}.log"
  local cmd=("${SIM_BIN[$PROCESSOR]}" --elf "$elf_path" --signature "$rtl_sig" --log "$rtl_log" --max-cycles "$MAX_CYCLES")
  if [[ "$PROCESSOR" == "tetranyte" && -n "$mask" ]]; then
    cmd+=(--thread-mask "$mask")
  fi
  echo "[coremark] Running $PROCESSOR (label=$label mask=${mask:-n/a})..."
  "${cmd[@]}"

  if [[ "$SKIP_SPIKE" -eq 0 ]]; then
    if cmp -s "$spike_sig" "$rtl_sig"; then
      echo "[coremark] PASS: signatures match for $label"
    else
      echo "[coremark] FAIL: signature mismatch for $label" >&2
      diff -u "$spike_sig" "$rtl_sig" || true
      exit 1
    fi
  else
    echo "[coremark] Skipped signature comparison for $label"
  fi
}

declare -a RUN_LABELS
declare -a RUN_MASKS
declare -a RUN_TAGS

if [[ "$PROCESSOR" == "tetranyte" ]]; then
  if [[ "$RUN_ALL_THREADS" -eq 1 ]]; then
    RUN_LABELS=(thread0 thread1 thread2 thread3)
    RUN_MASKS=(0x1 0x2 0x4 0x8)
    RUN_TAGS=(1 2 4 8)
  else
    mask=${THREAD_MASK:-0x1}
    RUN_LABELS=("mask_${mask}")
    RUN_MASKS=("$mask")
    RUN_TAGS=($((mask)))
  fi
else
  RUN_LABELS=("${PROCESSOR}")
  RUN_MASKS=("")
  RUN_TAGS=("")
fi

for idx in "${!RUN_LABELS[@]}"; do
  run_label "${RUN_LABELS[$idx]}" "${RUN_MASKS[$idx]}" "${RUN_TAGS[$idx]}"
done

echo "[coremark] Done. Artifacts in $OUT_DIR"
