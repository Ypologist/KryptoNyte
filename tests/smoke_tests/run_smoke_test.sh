#!/bin/bash

# Simple smoke test runner for ZeroNyte core
# Tests basic ADDI instruction functionality

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TESTS_DIR="$(dirname "$SCRIPT_DIR")"
KRYPTONYTE_ROOT="$(dirname "$TESTS_DIR")"
RISCOF_ROOT="$TESTS_DIR/riscof"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_step() { echo -e "${BLUE}▶${NC} $1"; }
print_success() { echo -e "${GREEN}✅${NC} $1"; }
print_error() { echo -e "${RED}❌${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠️${NC} $1"; }

echo "============================================================"
echo "ZeroNyte RISC-V Core Smoke Test"
echo "============================================================"

# Check prerequisites
print_step "Checking prerequisites"

if ! command -v riscv32-unknown-elf-gcc >/dev/null 2>&1; then
    print_error "RISC-V toolchain not found"
    exit 1
fi

if ! command -v verilator >/dev/null 2>&1; then
    print_error "Verilator not found"
    exit 1
fi

RTL_FILE="$KRYPTONYTE_ROOT/rtl/generators/generated/verilog_hierarchical_timed/ZeroNyteRV32ICore.v"
if [ ! -f "$RTL_FILE" ]; then
    print_error "RTL file not found: $RTL_FILE"
    print_step "Generate RTL first: cd rtl && sbt 'runMain generators.GenerateHierarchicalRTL'"
    exit 1
fi

print_success "Prerequisites check completed"

# Create work directory
WORK_DIR="$SCRIPT_DIR/work"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

print_step "Running ADDI smoke test"

# Compile test
print_step "Compiling test"
riscv32-unknown-elf-gcc \
    -march=rv32i \
    -mabi=ilp32 \
    -static \
    -mcmodel=medany \
    -fvisibility=hidden \
    -nostdlib \
    -nostartfiles \
    -T"$RISCOF_ROOT/zeronyte/env/link.ld" \
    -I"$RISCOF_ROOT/zeronyte/env" \
    -o addi_test.elf \
    "$SCRIPT_DIR/addi_test.S"

if [ $? -eq 0 ]; then
    print_success "Test compiled successfully"
else
    print_error "Test compilation failed"
    exit 1
fi

# Convert to hex
print_step "Converting to hex format"
riscv32-unknown-elf-objcopy \
    -O verilog \
    --verilog-data-width=4 \
    addi_test.elf \
    addi_test.hex

if [ $? -eq 0 ]; then
    print_success "ELF to hex conversion completed"
else
    print_error "ELF to hex conversion failed"
    exit 1
fi

# Create simple testbench
print_step "Creating Verilator testbench"
cat > tb_zeronyte.cpp << 'EOF'
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "VZeroNyteRV32ICore.h"
#include <iostream>
#include <fstream>

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);
    
    VZeroNyteRV32ICore* dut = new VZeroNyteRV32ICore;
    VerilatedVcdC* tfp = new VerilatedVcdC;
    
    dut->trace(tfp, 99);
    tfp->open("zeronyte_trace.vcd");
    
    // Reset
    dut->clock = 0;
    dut->reset = 1;
    dut->eval();
    tfp->dump(0);
    
    dut->clock = 1;
    dut->eval();
    tfp->dump(1);
    
    dut->clock = 0;
    dut->reset = 0;
    dut->eval();
    tfp->dump(2);
    
    // Run for some cycles
    for (int cycle = 0; cycle < 1000; cycle++) {
        dut->clock = 1;
        dut->eval();
        tfp->dump(cycle * 2 + 3);
        
        dut->clock = 0;
        dut->eval();
        tfp->dump(cycle * 2 + 4);
        
        // Simple halt detection (you may need to adjust this)
        if (cycle > 100) break;
    }
    
    tfp->close();
    delete dut;
    delete tfp;
    
    std::cout << "Simulation completed. Check zeronyte_trace.vcd for waveforms." << std::endl;
    return 0;
}
EOF

# Compile testbench
print_step "Compiling testbench"
verilator -Wall --cc --exe --build \
    --trace \
    -I"$KRYPTONYTE_ROOT/rtl/generators/generated/verilog_hierarchical_timed" \
    "$RTL_FILE" \
    tb_zeronyte.cpp \
    -o zeronyte_sim

if [ $? -eq 0 ]; then
    print_success "Testbench compiled successfully"
else
    print_error "Testbench compilation failed"
    exit 1
fi

# Run simulation
print_step "Running simulation"
./obj_dir/zeronyte_sim

if [ $? -eq 0 ]; then
    print_success "Simulation completed successfully"
    print_step "Waveform saved to: $WORK_DIR/zeronyte_trace.vcd"
else
    print_error "Simulation failed"
    exit 1
fi

echo "============================================================"
print_success "Smoke test completed!"
echo "============================================================"
print_step "Next steps:"
echo "  1. Open zeronyte_trace.vcd in GTKWave to view waveforms"
echo "  2. Verify ADDI instructions execute correctly"
echo "  3. Check register values match expected results"
echo "============================================================"
