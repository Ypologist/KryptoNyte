# RISCOF Quick Start Guide

## Prerequisites

Ensure all development tools are installed:
```bash
cd .devcontainer
./install_sbt_and_gcc.sh --with-sudo
./install_riscv_conformance_tests.sh --with-sudo  
./install_rtl_tools.sh --with-sudo
```

## Generate RTL

```bash
cd rtl
source ~/.sdkman/bin/sdkman-init.sh
export PATH="/opt/oss-cad-suite/bin:$PATH"
sbt genZeroNyte
```

## Run Smoke Test

```bash
cd tests
./run_conformance_tests.sh --smoke-test
```

## Run Full Conformance Suite

```bash
cd tests
./run_conformance_tests.sh
```

## Debug Failed Tests

Check simulation logs:
```bash
find tests/riscof/work -name "*.log" -exec cat {} \;
```

View VCD waveforms:
```bash
find tests/riscof/work -name "*.vcd"
```

## Key Files

- `tests/riscof/config.ini` - Main RISCOF configuration
- `tests/riscof/zeronyte/riscof_zeronyte.py` - ZeroNyte plugin
- `tests/riscof/zeronyte/env/` - Test environment headers
- `rtl/ZeroNyte/rv32i/src/main/scala/ZeroNyteRV32ICore.scala` - Core source

## Troubleshooting

**Compilation Errors:** Check toolchain installation and PATH
**Simulation Crashes:** Verify RTL generation and memory configuration  
**Missing Signatures:** Check test completion logic and file permissions
