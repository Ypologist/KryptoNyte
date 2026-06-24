#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)

cd "$REPO_ROOT"

SIM_DIR="$REPO_ROOT/tests/sim"
BUILD_DIR="$SIM_DIR/build"
OBJ_DIR="$BUILD_DIR/zeronyte_ifrvv_obj"

mkdir -p "$BUILD_DIR"
rm -rf "$OBJ_DIR"
mkdir -p "$OBJ_DIR"

VERILOG_TOP="rtl/generators/generated_sim/verilog_hierarchical_timed/ZeroNyteRV32IFRVVCore.v"
RTL_SRC_DIRS=("rtl/ZeroNyte/rv32if_rvv/src" "rtl/library/src")

regen_rtl=0
if [[ "${ZERONYTE_IFRVV_REGEN_RTL:-0}" == "1" ]]; then
  regen_rtl=1
elif [[ ! -f "$VERILOG_TOP" ]]; then
  regen_rtl=1
elif [[ -n "$(find "${RTL_SRC_DIRS[@]}" -type f -name '*.scala' -newer "$VERILOG_TOP" -print -quit)" ]]; then
  regen_rtl=1
fi

if [[ "$regen_rtl" -eq 1 ]]; then
  echo "Regenerating ZeroNyte RV32IF+RVV RTL..."
  (cd "rtl" && sbt "generators/runMain generators.GenerateHierarchicalRTL --core-family ZeroNyte --core-variant rv32if_rvv --cosimulate")
fi

if [[ ! -f "$VERILOG_TOP" ]]; then
  echo "Expected RTL at $VERILOG_TOP. Regenerate with 'sbt \"generators/runMain generators.GenerateHierarchicalRTL --core-family ZeroNyte --core-variant rv32if_rvv --cosimulate\"' from rtl/." >&2
  exit 1
fi

verilator -cc "$VERILOG_TOP" \
  --top-module ZeroNyteRV32IFRVVCore \
  --Mdir "$OBJ_DIR" \
  --timescale-override 1ns/1ns \
  --trace \
  --Wno-UNOPTFLAT \
  --Wno-PINMISSING \
  --Wno-WIDTH \
  --Wno-UNUSED \
  --build \
  -CFLAGS "-O2 -std=c++17" \
  -LDFLAGS "-O2" \
  --exe \
    "$SIM_DIR/zeronyte_ifrvv_sim.cpp" \
    "$SIM_DIR/elf_loader.cpp" \
    "$SIM_DIR/memory.cpp"

cp "$OBJ_DIR/VZeroNyteRV32IFRVVCore" "$BUILD_DIR/zeronyte_ifrvv_sim"
chmod +x "$BUILD_DIR/zeronyte_ifrvv_sim"

echo "Built simulator at $BUILD_DIR/zeronyte_ifrvv_sim"
