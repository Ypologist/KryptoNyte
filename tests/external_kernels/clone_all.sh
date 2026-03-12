#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)
DEST_DIR=${EXTERNAL_KERNELS_DIR:-"$REPO_ROOT/../external-kernels"}

mkdir -p "$DEST_DIR"

declare -A REPOS=(
  [beebs]=https://github.com/mageec/beebs.git
  [embench-iot]=https://github.com/embench/embench-iot.git
  [coremark]=https://github.com/eembc/coremark.git
  [riscv-tests]=https://github.com/riscv-software-src/riscv-tests.git
  [riscv-torture]=https://github.com/ucb-bar/riscv-torture.git
)

clone_or_update() {
  local name=$1
  local url=$2
  local target="$DEST_DIR/$name"

  if [[ -d "$target/.git" ]]; then
    echo "[update] $name -> $target"
    git -C "$target" remote set-url origin "$url"
    git -C "$target" fetch origin --tags
    upstream=$(git -C "$target" rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true)
    if [[ -n "$upstream" ]]; then
      git -C "$target" merge --ff-only "$upstream"
    else
      echo "  (no upstream tracking branch; skipped fast-forward)" >&2
    fi
  else
    echo "[clone] $name -> $target"
    git clone "$url" "$target"
  fi
}

echo "Destination: $DEST_DIR"
for name in "${!REPOS[@]}"; do
  clone_or_update "$name" "${REPOS[$name]}"
done

echo "Done."
