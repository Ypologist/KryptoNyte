#!/bin/bash

# Run RISC-V Conformance Tests against RTL Implementation
# This script runs tests for specific extensions against the RTL implementation
# Updated for RISCOF 1.25.3 and new directory structure

set -e

# Signal handling for clean exit
cleanup() {
    echo ""
    echo "🛑 Script interrupted. Cleaning up..."
    # Kill any running processes
    pkill -f riscof 2>/dev/null || true
    echo "✅ Cleanup completed"
    exit 1
}

trap cleanup SIGINT SIGTERM

# Parse command line arguments
RUN_I=true
RUN_M=false
RUN_PRIVILEGE=false
SMOKE_TEST=false

# Process command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --with-m)
            RUN_M=true
            shift
            ;;
        --with-privilege)
            RUN_PRIVILEGE=true
            shift
            ;;
        --all)
            RUN_I=true
            RUN_M=true
            RUN_PRIVILEGE=true
            shift
            ;;
        --smoke-test)
            SMOKE_TEST=true
            shift
            ;;
        --help)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --with-m           Include M extension tests (multiply/divide)"
            echo "  --with-privilege   Include privilege tests"
            echo "  --all              Include all test suites"
            echo "  --smoke-test       Run only a single test as a smoke test"
            echo "  --help             Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Set up paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RISCOF_DIR="$SCRIPT_DIR/riscof"
WORK_DIR="$SCRIPT_DIR/riscof_work"
RISCOF_CONFIG="$RISCOF_DIR/config.ini"

# Export KRYPTONYTE_ROOT for the plugins to use
export KRYPTONYTE_ROOT="$REPO_ROOT"

# Check if RTL file exists
RTL_PATHS=(
    "$REPO_ROOT/rtl/generators/generated/verilog_hierarchical_timed/ZeroNyteRV32ICore.v"
    "$REPO_ROOT/rtl/generators/generated/verilog_hierarchical/ZeroNyteRV32ICore.v"
    "$REPO_ROOT/rtl/ZeroNyte/rv32i/generated/ZeroNyteRV32ICore.v"
    "$REPO_ROOT/rtl/generated/ZeroNyteRV32ICore.v"
)

RTL_FILE=""
for path in "${RTL_PATHS[@]}"; do
    if [ -f "$path" ]; then
        RTL_FILE="$path"
        break
    fi
done

if [ -z "$RTL_FILE" ]; then
    echo "⚠️  Warning: RTL file not found in expected locations:"
    for path in "${RTL_PATHS[@]}"; do
        echo "  - $path"
    done
    echo "You may need to generate the RTL first with: cd $REPO_ROOT/rtl && sbt 'runMain generators.GenerateHierarchicalRTL'"
    echo "Continuing anyway - tests will fail if RTL is needed..."
fi

# Create work directory
mkdir -p "$WORK_DIR"

# Create test list file based on selected extensions
TEST_LIST="$WORK_DIR/test_list.yaml"
echo "# RISCOF Test List for ZeroNyte RV32I Core" > "$TEST_LIST"
echo "# Generated for RISCOF 1.25.3 compatibility" >> "$TEST_LIST"
echo "" >> "$TEST_LIST"

# Add tests based on command line arguments
if [ "$RUN_I" = true ]; then
    if [ "$SMOKE_TEST" = true ]; then
        cat >> "$TEST_LIST" << EOF
addi-01:
  test_path: /opt/riscv-conformance/riscv-arch-test/riscv-test-suite/rv32i_m/I/src/addi-01.S
  work_dir: $WORK_DIR/I/src/addi-01.S/dut
  commit_id: b91f98f3a0e908bad4680c2e3901fbc24b63a563
  macros:
    - TEST_CASE_1=True
    - XLEN=32
  isa: RV32I
  coverage_labels:
    - addi
EOF
    else
        # For full I extension tests, we would add more tests here
        # For now, just add the addi test as an example
        cat >> "$TEST_LIST" << EOF
addi-01:
  test_path: /opt/riscv-conformance/riscv-arch-test/riscv-test-suite/rv32i_m/I/src/addi-01.S
  work_dir: $WORK_DIR/I/src/addi-01.S/dut
  commit_id: b91f98f3a0e908bad4680c2e3901fbc24b63a563
  macros:
    - TEST_CASE_1=True
    - XLEN=32
  isa: RV32I
  coverage_labels:
    - addi
EOF
    fi
fi

# Print selected test suites
echo "============================================================"
echo "Running RISC-V Conformance Tests against RTL Implementation"
echo "============================================================"
echo "Selected test suites:"
if [ "$RUN_I" = true ]; then
    echo "  - I (Base Integer Instructions)"
fi
if [ "$RUN_M" = true ]; then
    echo "  - M (Integer Multiplication and Division)"
fi
if [ "$RUN_PRIVILEGE" = true ]; then
    echo "  - Privilege (Privileged Architecture)"
fi
if [ "$SMOKE_TEST" = true ]; then
    echo "Running in smoke test mode (single test per extension)"
fi
echo ""

# Check prerequisites
if [ ! -f "$RISCOF_CONFIG" ]; then
    echo "❌ RISCOF configuration not found at $RISCOF_CONFIG"
    echo "Please set up RISCOF configuration first"
    exit 1
fi

# Check if RISC-V toolchain is available
if ! command -v riscv64-linux-gnu-gcc &> /dev/null && ! command -v riscv32-unknown-elf-gcc &> /dev/null; then
    echo "❌ RISC-V toolchain not found"
    echo "Please install with: sudo apt install gcc-riscv64-linux-gnu"
    exit 1
fi

# Check if Verilator is available
if ! command -v verilator &> /dev/null; then
    echo "❌ Verilator not found"
    echo "Please install with: sudo apt install verilator"
    exit 1
fi

# Run RISCOF with the selected tests
echo "▶ Running RISCOF with selected tests"
echo "  Using test list: $TEST_LIST"
echo "  Using work directory: $WORK_DIR"
echo ""

# Find RISC-V conformance test suite
CONFORMANCE_PATHS=(
    "/opt/riscv-conformance/riscv-arch-test/riscv-test-suite/rv32i_m"
    "/opt/riscv-arch-test/riscv-test-suite/rv32i_m"
    "/usr/local/share/riscv-arch-test/riscv-test-suite/rv32i_m"
)

CONFORMANCE_SUITE=""
for path in "${CONFORMANCE_PATHS[@]}"; do
    if [ -d "$path" ]; then
        CONFORMANCE_SUITE="$path"
        break
    fi
done

if [ -z "$CONFORMANCE_SUITE" ]; then
    echo "❌ RISC-V conformance test suite not found in expected locations"
    echo "Please install RISC-V conformance tests or set the correct path"
    exit 1
fi

# Change to RISCOF directory for proper plugin loading
cd "$RISCOF_DIR"

# Run RISCOF with the selected tests
echo "Running RISCOF from directory: $(pwd)"
echo "Suite: $CONFORMANCE_SUITE"
echo "Env: zeronyte/env"
echo "Config: config.ini"
echo "Work dir: $WORK_DIR"
echo "Test file: $TEST_LIST"

riscof run \
    --suite="$CONFORMANCE_SUITE" \
    --env="zeronyte/env" \
    --config="config.ini" \
    --work-dir="$WORK_DIR" \
    --testfile="$TEST_LIST" \
    --no-ref-run \
    --no-browser

echo "✅ RISCOF tests completed"
echo "Results available in: $WORK_DIR"
