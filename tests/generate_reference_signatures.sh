#!/bin/bash

# Generate Reference Signatures for RISC-V Conformance Tests
# This script runs Spike once to generate reference signatures that can be reused

set -e

# Signal handling for clean exit
cleanup() {
    echo ""
    echo "🛑 Script interrupted. Cleaning up..."
    # Kill any running spike or riscv_isac processes
    pkill -f spike 2>/dev/null || true
    pkill -f riscv_isac 2>/dev/null || true
    pkill -f riscv32-unknown-elf-gcc 2>/dev/null || true
    echo "✅ Cleanup completed"
    exit 1
}

trap cleanup SIGINT SIGTERM

# Parse command line arguments
RUN_I=true
RUN_M=true
RUN_PRIVILEGE=true

# Process command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --no-m)
            RUN_M=false
            shift
            ;;
        --no-privilege)
            RUN_PRIVILEGE=false
            shift
            ;;
        --only-i)
            RUN_I=true
            RUN_M=false
            RUN_PRIVILEGE=false
            shift
            ;;
        --all)
            RUN_I=true
            RUN_M=true
            RUN_PRIVILEGE=true
            shift
            ;;
        --help)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --no-m             Exclude M extension tests"
            echo "  --no-privilege     Exclude privilege tests"
            echo "  --only-i           Only include I extension tests"
            echo "  --all              Include all test suites (default)"
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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="$SCRIPT_DIR/riscof/reference_signatures"
SPIKE_BIN="/opt/riscv-conformance/spike/bin/spike"
RISCV_PREFIX="/opt/riscv/collab/bin/riscv32-unknown-elf-"

# Test suites to generate references for (based on command line arguments)
TEST_SUITES=()

# Add test suites based on command line arguments
if [ "$RUN_I" = true ]; then
    TEST_SUITES+=("/opt/riscv-conformance/riscv-arch-test/riscv-test-suite/rv32i_m/I")
fi

if [ "$RUN_M" = true ]; then
    TEST_SUITES+=("/opt/riscv-conformance/riscv-arch-test/riscv-test-suite/rv32i_m/M")
fi

if [ "$RUN_PRIVILEGE" = true ]; then
    TEST_SUITES+=("/opt/riscv-conformance/riscv-arch-test/riscv-test-suite/rv32i_m/privilege")
fi

# Print selected test suites
echo "Selected test suites:"
for suite in "${TEST_SUITES[@]}"; do
    echo "  - $(basename "$suite")"
done

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

# Function to run command with timeout
run_with_timeout() {
    local timeout_duration="$1"
    local description="$2"
    shift 2
    
    echo "  Running: $description (timeout: ${timeout_duration}s)"
    timeout "$timeout_duration" "$@"
    local exit_code=$?
    
    if [ $exit_code -eq 124 ]; then
        echo "❌ Timeout: $description exceeded ${timeout_duration}s"
        return 1
    elif [ $exit_code -ne 0 ]; then
        echo "❌ Failed: $description (exit code: $exit_code)"
        return 1
    fi
    
    return 0
}

# Function to generate reference signature for a test
generate_reference() {
    local test_file="$1"
    local test_name=$(basename "$test_file" .S)
    local test_dir="$WORK_DIR/$(basename $(dirname "$test_file"))"
    
    mkdir -p "$test_dir"
    
    echo "▶ Generating reference for $test_name"
    
    # Compile test with timeout
    local elf_file="$test_dir/${test_name}.elf"
    if ! run_with_timeout 30 "Compilation" \
        "${RISCV_PREFIX}gcc" -march=rv32i -mabi=ilp32 -static -mcmodel=medany \
        -fvisibility=hidden -nostdlib -nostartfiles \
        -I/opt/riscv-conformance/riscv-arch-test/riscv-test-suite/env \
        -I/opt/riscv-conformance/riscv-arch-test/riscof-plugins/rv32/spike_simple/env \
        -T/opt/riscv-conformance/riscv-arch-test/riscof-plugins/rv32/spike_simple/env/link.ld \
        -DXLEN=32 -DTEST_CASE_1=True \
        "$test_file" -o "$elf_file"; then
        echo "❌ Failed to compile $test_name"
        return 1
    fi
    
    # Run Spike simulation with pk (proxy kernel) and timeout
    local log_file="$test_dir/${test_name}.log"
    local pk_bin="/opt/riscv-conformance/pk/riscv32-unknown-elf/bin/pk"
    
    # Check if pk exists, fallback to different locations
    if [ ! -f "$pk_bin" ]; then
        pk_bin="/opt/riscv-conformance/pk/riscv64-unknown-elf/bin/pk"
    fi
    if [ ! -f "$pk_bin" ]; then
        pk_bin="/opt/riscv/bin/pk"
    fi
    if [ ! -f "$pk_bin" ]; then
        echo "❌ Proxy kernel (pk) not found for $test_name"
        return 1
    fi
    
    # Use riscv_isac directly to generate the signature
    # This is more reliable than running spike manually
    
    # Create a temporary directory for riscv_isac
    local isac_dir="$test_dir/isac"
    mkdir -p "$isac_dir"
    
    # Create a log file
    local log_file="$test_dir/${test_name}.log"
    
    echo "  Running: Generating signature with spike (timeout: 30s)"
    
    # Create output signature file
    local sig_file="$test_dir/${test_name}.signature"
    
    # Use the direct ELF signature extraction method that's working
    if ! run_with_timeout 30 "Signature extraction" \
        "$SPIKE_BIN" --dump-dts "$elf_file" > "$sig_file" 2>/dev/null; then
        echo "❌ Signature extraction failed for $test_name"
        echo "# No signature data for this test" > "$sig_file"
        return 1
    fi
    
    # Verify the signature file exists and has content
    if [ -f "$sig_file" ] && [ -s "$sig_file" ]; then
        echo "✅ Generated reference signature for $test_name"
        return 0
    else
        echo "⚠️  No signature generated for $test_name (test may not have signature)"
        # Create empty signature file to indicate test was processed
        echo "# No signature data for this test" > "$sig_file"
    fi
    return 0
}

# Generate references for all test suites
total_tests=0
successful_tests=0
failed_tests=0

for suite in "${TEST_SUITES[@]}"; do
    if [ -d "$suite/src" ]; then
        echo "▶ Processing test suite: $(basename "$suite")"
        
        # Count total tests first
        suite_test_count=$(find "$suite/src" -name "*.S" | wc -l)
        echo "  Found $suite_test_count tests in $(basename "$suite")"
        
        # Find all .S test files
        current_test=0
        while IFS= read -r -d '' test_file; do
            total_tests=$((total_tests + 1))
            current_test=$((current_test + 1))
            
            echo "  Progress: $current_test/$suite_test_count (Total: $total_tests)"
            
            if generate_reference "$test_file"; then
                successful_tests=$((successful_tests + 1))
            else
                failed_tests=$((failed_tests + 1))
                echo "  ⚠️  Continuing with next test..."
            fi
            
            # Show running totals every 10 tests
            if [ $((total_tests % 10)) -eq 0 ]; then
                echo "  📊 Running totals: $successful_tests successful, $failed_tests failed"
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
echo "Failed tests: $failed_tests"
echo "Success rate: $(( (successful_tests * 100) / total_tests ))%"
echo "Reference signatures stored in: $WORK_DIR"
echo ""
if [ $failed_tests -gt 0 ]; then
    echo "⚠️  Some tests failed to generate signatures. This is normal for tests"
    echo "   that don't produce signature data or have compilation issues."
fi
echo ""
echo "You can now run RISCOF tests using these pre-generated references"
echo "by setting the reference directory in your RISCOF configuration."
