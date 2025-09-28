# ZeroNyte RISC-V Core Smoke Tests

This directory contains simple smoke tests for the ZeroNyte RV32I core, designed to quickly verify basic functionality without the complexity of the full RISCOF conformance test suite.

## Quick Start

```bash
cd tests/smoke_tests
./run_smoke_test.sh
```

## Test Description

### ADDI Test (`addi_test.S`)

Tests the ADDI (Add Immediate) instruction with various scenarios:

1. **Simple Addition**: `addi x1, x0, 42` → x1 = 42
2. **Chained Operations**: `addi x2, x1, 8` → x2 = 50
3. **Negative Immediate**: `addi x3, x2, -10` → x3 = 40
4. **Maximum Positive**: `addi x4, x0, 2047` → x4 = 2047
5. **Maximum Negative**: `addi x5, x0, -2048` → x5 = -2048
6. **Zero Addition**: `addi x6, x0, 0` → x6 = 0
7. **Chain Operations**: Multiple sequential ADDI instructions

## Expected Results

The test stores results in memory starting at address 0x80000000:
- Address 0x80000000: 42 (0x2A)
- Address 0x80000004: 50 (0x32)
- Address 0x80000008: 40 (0x28)
- Address 0x8000000C: 2047 (0x7FF)
- Address 0x80000010: -2048 (0xFFFFF800)
- Address 0x80000014: 0 (0x00)
- Address 0x80000018: 100 (0x64)
- Address 0x8000001C: 300 (0x12C)
- Address 0x80000020: 600 (0x258)

## Output Files

- `addi_test.elf`: Compiled test executable
- `addi_test.hex`: Verilog memory format for simulation
- `zeronyte_trace.vcd`: Waveform file for GTKWave analysis
- `tb_zeronyte.cpp`: Verilator testbench source

## Debugging

1. **View Waveforms**: Open `zeronyte_trace.vcd` in GTKWave
2. **Check Assembly**: `riscv32-unknown-elf-objdump -d addi_test.elf`
3. **Memory Contents**: Look for store operations in the waveform
4. **Register Values**: Monitor x1-x9 registers during execution

## Prerequisites

- RISC-V toolchain (`riscv32-unknown-elf-gcc`)
- Verilator simulator
- ZeroNyte RTL generated in `rtl/generators/generated/verilog_hierarchical_timed/`

## Troubleshooting

### RTL Not Found
```bash
cd ../../rtl
sbt "runMain generators.GenerateHierarchicalRTL"
```

### Toolchain Issues
```bash
# Check toolchain installation
which riscv32-unknown-elf-gcc
riscv32-unknown-elf-gcc --version
```

### Verilator Issues
```bash
# Check Verilator installation
which verilator
verilator --version
```

## Integration with RISCOF

This smoke test uses the same environment files as the RISCOF framework:
- Linker script: `../riscof/zeronyte/env/link.ld`
- Model header: `../riscof/zeronyte/env/model_test.h`

Success with this smoke test indicates the basic infrastructure is working and RISCOF should be able to run more complex tests.
