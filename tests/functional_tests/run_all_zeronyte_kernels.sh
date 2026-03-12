#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

KERNELS=(
  dot_product
  alu_signature
  memory_stride
  branch_stress
  checksum32
)

PASSTHROUGH=("$@")
FAILURES=()
FORCE_SIM_BUILD=0

PASSTHROUGH=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --force-sim-build)
      FORCE_SIM_BUILD=1
      shift
      ;;
    *)
      PASSTHROUGH+=("$1")
      shift
      ;;
  esac
done

for idx in "${!KERNELS[@]}"; do
  kernel="${KERNELS[$idx]}"
  echo
  echo "===== Kernel: $kernel ====="

  cmd=("$SCRIPT_DIR/run_kernel_zeronyte.sh" --kernel "$kernel")
  if [[ "$FORCE_SIM_BUILD" -eq 1 && "$idx" -eq 0 ]]; then
    cmd+=(--force-sim-build)
  fi
  cmd+=("${PASSTHROUGH[@]}")

  if ! "${cmd[@]}"; then
    FAILURES+=("$kernel")
  fi
done

echo
if [[ "${#FAILURES[@]}" -eq 0 ]]; then
  echo "PASS: all ZeroNyte kernels matched Spike signatures."
  exit 0
fi

echo "FAIL: kernel mismatches detected: ${FAILURES[*]}" >&2
exit 1
