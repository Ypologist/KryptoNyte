# KryptoNyte RISC-V Conformance Testing

This directory contains a production-quality RISC-V Conformance Framework (RISCOF) setup for testing KryptoNyte's ZeroNyte RV32I core against the official RISC-V architecture tests.

## Overview

The conformance testing framework validates that the ZeroNyte core correctly implements the RISC-V ISA specification by running standardized test suites and comparing results against a reference implementation (Spike simulator).

## Directory Structure

```
tests/riscof/
├── config.ini                    # Main RISCOF configuration
├── run_conformance_tests.sh      # Test runner script
├── README.md                     # This documentation
├── configs/                      # Additional configuration files
├── plugins/                      # Shared plugin implementations
│   └── zeronyte_plugin.py        # ZeroNyte core plugin
├── zeronyte/                     # ZeroNyte-specific configuration
│   ├── riscof_zeronyte.py        # Plugin entry point
│   ├── zeronyte_isa.yaml         # ISA specification
│   └── zeronyte_platform.yaml   # Platform specification
├── spike/                        # Spike reference plugin
│   └── riscof_spike.py           # Spike plugin implementation
└── work/                         # Test execution workspace (created at runtime)
```

## Prerequisites

### Required Tools

1. **RISCOF Framework**
   ```bash
   pip install riscof
   ```

2. **RISC-V Toolchain**
   - Install using the provided script: `.devcontainer/install_riscv_conformance_tests.sh --with-sudo`
   - Or manually install RISC-V GNU toolchain

3. **Spike Simulator**
   - Installed automatically by the conformance test script
   - Located at: `/opt/riscv-conformance/spike/bin/spike`

4. **Verilator**
   - For RTL simulation of ZeroNyte core
   - Install: `sudo apt-get install verilator`

5. **ZeroNyte RTL**
   - Generate RTL using: `cd rtl && sbt "runMain generators.GenerateHierarchicalRTL"`

### Environment Setup

Load the RISC-V conformance environment:
```bash
source ~/.riscv_conformance_env
```

Or set up manually:
```bash
export RISCV_CONFORMANCE_ROOT="/opt/riscv-conformance"
export RISCV_ARCH_TEST_ROOT="/opt/riscv-conformance/riscv-arch-test"
export PATH="/opt/riscv-conformance/spike/bin:$PATH"
```

## Configuration Files

### ISA Specification (`zeronyte_isa.yaml`)

Defines the ZeroNyte core's ISA implementation:
- **ISA**: RV32IMCZicsr_Zifencei
- **Extensions**: Integer (I), Multiplication (M), Compressed (C), CSR access, Fence instructions
- **Physical Address Size**: 32 bits
- **PMP**: 16 entries with 4-byte granularity
- **CSRs**: Standard machine-level control and status registers

### Platform Specification (`zeronyte_platform.yaml`)

Defines platform-specific features:
- **Memory Map**: Instruction memory (64KB), Data memory (64KB), Stack (4KB)
- **Timer**: MTIME/MTIMECMP at standard CLINT addresses
- **Interrupts**: Machine software interrupt (MSIP)
- **Test Signature**: Dedicated region for test result output

### RISCOF Configuration (`config.ini`)

Main configuration file specifying:
- **DUT Plugin**: ZeroNyte core simulation
- **Reference Plugin**: Spike simulator
- **File Paths**: RTL files, toolchain prefix, plugin locations
- **Test Parameters**: Timeout, target runs, parallel execution

## Usage

### Basic Test Execution

Run all RV32I machine-mode tests:
```bash
./run_conformance_tests.sh --suite rv32i_m
```

### Advanced Usage

Run specific tests with custom configuration:
```bash
./run_conformance_tests.sh \
    --suite rv32i_m \
    --tests "add-01,sub-01,and-01" \
    --jobs 8 \
    --timeout 600 \
    --clean
```

Run tests excluding problematic ones:
```bash
./run_conformance_tests.sh \
    --suite rv32i_m \
    --exclude "fence-01,ecall-01" \
    --verbose
```

### Available Test Suites

- `rv32i_m`: RV32I machine mode tests (basic integer instructions)
- `rv32im_m`: RV32IM machine mode tests (integer + multiplication)
- `rv32imc_m`: RV32IMC machine mode tests (integer + multiplication + compressed)
- `rv32i_p`: RV32I privilege tests (CSR and exception handling)

### Command Line Options

```
--suite <suite>       Test suite to run (default: rv32i_m)
--arch <arch>         Architecture (default: rv32i)
--work-dir <dir>      Working directory (default: ./work)
--config <file>       RISCOF config file (default: ./config.ini)
--jobs <n>            Parallel jobs (default: 4)
--timeout <sec>       Test timeout in seconds (default: 300)
--tests <list>        Run specific tests (comma-separated)
--exclude <list>      Exclude specific tests (comma-separated)
--clean               Clean work directory before running
--quiet               Reduce output verbosity
--help, -h            Show help message
```

## Test Results

### Output Locations

- **Work Directory**: `./work/` (configurable)
- **Test Logs**: `./work/logs/`
- **Test Reports**: `./work/reports/`
- **RISCOF Results**: `./work/riscof_work/`

### Result Analysis

1. **HTML Report**: Open `./work/riscof_work/report.html` in a browser
2. **Test Summary**: Check `./work/reports/conformance_report_*.md`
3. **Individual Logs**: Review specific test logs in `./work/logs/`
4. **Signature Comparison**: Compare DUT vs reference signatures

### Common Result Patterns

- ✅ **PASS**: Test executed successfully, signatures match
- ❌ **FAIL**: Test failed, signatures don't match or simulation error
- ⏱️ **TIMEOUT**: Test exceeded time limit
- 🔧 **BUILD_FAIL**: RTL compilation or simulation build failed

## Troubleshooting

### Common Issues

1. **RTL File Not Found**
   ```
   Solution: Generate RTL first
   cd rtl && sbt "runMain generators.GenerateHierarchicalRTL"
   ```

2. **Toolchain Not Found**
   ```
   Solution: Install RISC-V toolchain
   .devcontainer/install_riscv_conformance_tests.sh --with-sudo
   ```

3. **Spike Not Found**
   ```
   Solution: Check PATH and installation
   export PATH="/opt/riscv-conformance/spike/bin:$PATH"
   ```

4. **Verilator Build Fails**
   ```
   Solution: Check Verilator installation and RTL syntax
   sudo apt-get install verilator
   ```

5. **Test Timeouts**
   ```
   Solution: Increase timeout or optimize RTL
   ./run_conformance_tests.sh --timeout 600
   ```

### Debug Mode

Enable verbose output for debugging:
```bash
./run_conformance_tests.sh --suite rv32i_m --verbose --clean
```

Check individual test execution:
```bash
cd work/riscof_work
# Review specific test directories and logs
```

### Plugin Development

To modify the ZeroNyte plugin:

1. Edit `plugins/zeronyte_plugin.py`
2. Update testbench in `_create_basic_testbench()` method
3. Modify signature extraction in `parse_sig()` method
4. Test changes with a small test subset

## Integration with KryptoNyte

### RTL Generation Integration

The conformance tests automatically use RTL generated by:
```bash
cd rtl
sbt "runMain generators.GenerateHierarchicalRTL"
```

Expected RTL location:
```
rtl/generators/generated/verilog_hierarchical_timed/ZeroNyteRV32ICore.v
```

### CI/CD Integration

Add to your CI pipeline:
```yaml
- name: Run RISC-V Conformance Tests
  run: |
    cd tests/riscof
    ./run_conformance_tests.sh --suite rv32i_m --quiet
```

### Custom Test Development

1. Create custom test programs in RISC-V assembly
2. Add to the test suite configuration
3. Update ISA/platform specifications as needed
4. Run tests to validate implementation

## Performance Optimization

### Parallel Execution

Increase parallel jobs for faster execution:
```bash
./run_conformance_tests.sh --jobs $(nproc)
```

### Test Filtering

Run only essential tests during development:
```bash
./run_conformance_tests.sh --tests "add-01,sub-01,lw-01,sw-01"
```

### Simulation Optimization

1. **Verilator Optimization**: Use `-O3` flag (already enabled)
2. **RTL Optimization**: Minimize combinational logic depth
3. **Memory Initialization**: Optimize hex file loading
4. **Timeout Tuning**: Set appropriate timeouts per test complexity

## References

- [RISC-V Conformance Framework (RISCOF)](https://riscof.readthedocs.io/)
- [RISC-V Architecture Tests](https://github.com/riscv-non-isa/riscv-arch-test)
- [Spike RISC-V ISA Simulator](https://github.com/riscv-software-src/riscv-isa-sim)
- [RISC-V ISA Specification](https://riscv.org/technical/specifications/)
- [Verilator User Guide](https://verilator.org/guide/latest/)

## Support

For issues specific to KryptoNyte conformance testing:
1. Check the troubleshooting section above
2. Review test logs in `./work/logs/`
3. Verify RTL generation and toolchain installation
4. Compare with OctoNyte reference implementation if needed

For RISCOF framework issues:
- [RISCOF Documentation](https://riscof.readthedocs.io/)
- [RISCOF GitHub Issues](https://github.com/riscv-software-src/riscof/issues)
