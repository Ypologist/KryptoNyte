#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
TESTS_DIR=$(dirname "$SCRIPT_DIR")
REPO_ROOT=$(dirname "$TESTS_DIR")
BUILD_DIR="$SCRIPT_DIR/build"
OBJ_DIR="$BUILD_DIR/obj_dir"

mkdir -p "$BUILD_DIR"

VERILOG_TOP="$REPO_ROOT/rtl/generators/generated/verilog_hierarchical_timed/ZeroNyteRV32ICore.v"
if [[ ! -f "$VERILOG_TOP" ]]; then
  echo "Expected RTL at $VERILOG_TOP. Regenerate with 'sbt generateRTL' from rtl/." >&2
  exit 1
fi

verilator -cc "$VERILOG_TOP" \
  --top-module ZeroNyteRV32ICore \
  --Mdir "$OBJ_DIR" \
  --timescale-override 1ns/1ns \
  --trace \
  --build \
  -CFLAGS "-O2 -std=c++17" \
  -LDFLAGS "-O2" \
  --exe \
    "$SCRIPT_DIR/zeronyte_sim.cpp" \
    "$SCRIPT_DIR/elf_loader.cpp" \
    "$SCRIPT_DIR/memory.cpp"

cp "$OBJ_DIR/VZeroNyteRV32ICore" "$BUILD_DIR/zeronyte_sim"
chmod +x "$BUILD_DIR/zeronyte_sim"

echo "Built simulator at $BUILD_DIR/zeronyte_sim"
