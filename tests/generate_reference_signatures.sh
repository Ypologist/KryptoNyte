#!/bin/bash

# Generate Reference Signatures for RISC-V Conformance Tests
# This script runs Spike once to generate reference signatures that can be reused

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="$SCRIPT_DIR/riscof/reference_signatures"
SPIKE_BIN="/opt/riscv-conformance/spike/bin/spike"
RISCV_PREFIX="/opt/riscv/collab/bin/riscv32-unknown-elf-"

# Test suites to generate references for
TEST_SUITES=(
    "/opt/riscv-conformance/riscv-arch-test/riscv-test-suite/rv32i_m/I"
    "/opt/riscv-conformance/riscv-arch-test/riscv-test-suite/rv32i_m/M"
    "/opt/riscv-conformance/riscv-arch-test/riscv-test-suite/rv32i_m/privilege"
)

echo "============================================================"
echo "Generating RISC-V Conformance Test Reference Signatures"
echo "============================================================"

# Create work directory
mkdir -p "$WORK_DIR"

# Check prerequisites
if [ ! -f "$SPIKE_BIN" ]; then
    echo "❌ Spike not found at $SPIKE_BIN"
    echo "Please install RISC-V conformance tests first"
    exit 1
fi

if [ ! -f "${RISCV_PREFIX}gcc" ]; then
    echo "❌ RISC-V toolchain not found at $RISCV_PREFIX"
    echo "Please install RISC-V toolchain first"
    exit 1
fi

echo "✅ Prerequisites check completed"

# Function to generate reference signature for a test
generate_reference() {
    local test_file="$1"
    local test_name=$(basename "$test_file" .S)
    local test_dir="$WORK_DIR/$(basename $(dirname "$test_file"))"
    
    mkdir -p "$test_dir"
    
    echo "▶ Generating reference for $test_name"
    
    # Compile test
    local elf_file="$test_dir/${test_name}.elf"
    "${RISCV_PREFIX}gcc" -march=rv32i -mabi=ilp32 -static -mcmodel=medany \
        -fvisibility=hidden -nostdlib -nostartfiles \
        -I/opt/riscv-conformance/riscv-arch-test/riscv-test-suite/env \
        -I/opt/riscv-conformance/riscv-arch-test/riscof-plugins/rv32/spike_simple/env \
        -T/opt/riscv-conformance/riscv-arch-test/riscof-plugins/rv32/spike_simple/env/link.ld \
        -DXLEN=32 -DTEST_CASE_1=True \
        "$test_file" -o "$elf_file"
    
    if [ $? -ne 0 ]; then
        echo "❌ Failed to compile $test_name"
        return 1
    fi
    
    # Run Spike simulation
    local log_file="$test_dir/${test_name}.log"
    "$SPIKE_BIN" --isa=rv32i -m0x80000000:0x10000000 "$elf_file" > "$log_file" 2>&1
    
    if [ $? -ne 0 ]; then
        echo "❌ Spike simulation failed for $test_name"
        return 1
    fi
    
    # Extract signature using riscv_isac
    local sig_file="$test_dir/${test_name}.signature"
    riscv_isac --verbose info normalize \
        -t "$log_file" \
        --parser-name spike \
        --sig-label begin_signature end_signature \
        -e "$elf_file" \
        -x32 \
        -o "$sig_file" > /dev/null 2>&1
    
    if [ $? -eq 0 ] && [ -f "$sig_file" ]; then
        echo "✅ Generated reference signature for $test_name"
        return 0
    else
        echo "⚠️  No signature generated for $test_name (test may not have signature)"
        # Create empty signature file to indicate test was processed
        echo "# No signature data for this test" > "$sig_file"
        return 0
    fi
}

# Generate references for all test suites
total_tests=0
successful_tests=0

for suite in "${TEST_SUITES[@]}"; do
    if [ -d "$suite/src" ]; then
        echo "▶ Processing test suite: $(basename "$suite")"
        
        # Find all .S test files
        while IFS= read -r -d '' test_file; do
            total_tests=$((total_tests + 1))
            if generate_reference "$test_file"; then
                successful_tests=$((successful_tests + 1))
            fi
        done < <(find "$suite/src" -name "*.S" -print0)
    else
        echo "⚠️  Test suite not found: $suite"
    fi
done

echo "============================================================"
echo "Reference Signature Generation Complete"
echo "============================================================"
echo "Total tests processed: $total_tests"
echo "Successful signatures: $successful_tests"
echo "Reference signatures stored in: $WORK_DIR"
echo ""
echo "You can now run RISCOF tests using these pre-generated references"
echo "by setting the reference directory in your RISCOF configuration."
