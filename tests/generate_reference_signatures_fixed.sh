#!/bin/bash

# Generate Reference Signatures for RISC-V Conformance Tests
# This script generates reference signatures for all RISC-V extensions using Spike
# Updated for new directory structure

set -e

# Signal handling for clean exit
cleanup() {
    echo ""
    echo "🛑 Script interrupted. Cleaning up..."
    # Kill any running processes
    pkill -f spike 2>/dev/null || true
    echo "✅ Cleanup completed"
    exit 1
}

trap cleanup SIGINT SIGTERM

# Parse command line arguments
GENERATE_I=false
GENERATE_M=false
GENERATE_PRIVILEGE=false
GENERATE_ALL=false

# Process command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --i)
            GENERATE_I=true
            shift
            ;;
        --m)
            GENERATE_M=true
            shift
            ;;
        --privilege)
            GENERATE_PRIVILEGE=true
            shift
            ;;
        --all)
            GENERATE_ALL=true
            shift
            ;;
        --help)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --i                Generate I extension reference signatures"
            echo "  --m                Generate M extension reference signatures"
            echo "  --privilege        Generate privilege reference signatures"
            echo "  --all              Generate all reference signatures"
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

# If no specific extension is selected, default to all
if [ "$GENERATE_I" = false ] && [ "$GENERATE_M" = false ] && [ "$GENERATE_PRIVILEGE" = false ] && [ "$GENERATE_ALL" = false ]; then
    GENERATE_ALL=true
fi

# Set up paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RISCOF_DIR="$SCRIPT_DIR/riscof"
WORK_DIR="$SCRIPT_DIR/riscof_work"
REFERENCE_DIR="$WORK_DIR/reference_signatures"

# Create directories
mkdir -p "$REFERENCE_DIR"
mkdir -p "$WORK_DIR"

# Export KRYPTONYTE_ROOT for the plugins to use
export KRYPTONYTE_ROOT="$REPO_ROOT"

echo "============================================================"
echo "Generating RISC-V Reference Signatures using Spike"
echo "============================================================"

# Check if Spike is available
if ! command -v spike &> /dev/null; then
    echo "❌ Spike simulator not found"
    echo "Please install Spike or ensure it's in your PATH"
    exit 1
fi

# Check if RISC-V proxy kernel is available
if ! command -v pk &> /dev/null; then
    echo "⚠️  Warning: RISC-V proxy kernel (pk) not found"
    echo "Some tests may not work without pk"
fi

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
    echo "Please install RISC-V conformance tests"
    exit 1
fi

echo "Using conformance suite: $CONFORMANCE_SUITE"

# Check if RISC-V toolchain is available
RISCV_PREFIX=""
if command -v riscv64-linux-gnu-gcc &> /dev/null; then
    RISCV_PREFIX="riscv64-linux-gnu-"
elif command -v riscv32-unknown-elf-gcc &> /dev/null; then
    RISCV_PREFIX="riscv32-unknown-elf-"
else
    echo "❌ RISC-V toolchain not found"
    echo "Please install with: sudo apt install gcc-riscv64-linux-gnu"
    exit 1
fi

echo "Using RISC-V toolchain: ${RISCV_PREFIX}gcc"

# Function to generate reference signatures for a test suite
generate_reference_signatures() {
    local suite_name=$1
    local suite_path="$CONFORMANCE_SUITE/$suite_name"
    
    if [ ! -d "$suite_path" ]; then
        echo "⚠️  Warning: Test suite not found: $suite_path"
        return
    fi
    
    echo "▶ Generating reference signatures for $suite_name extension"
    
    # Find all test files
    local test_files=($(find "$suite_path" -name "*.S" | sort))
    
    if [ ${#test_files[@]} -eq 0 ]; then
        echo "⚠️  Warning: No test files found in $suite_path"
        return
    fi
    
    echo "Found ${#test_files[@]} test files"
    
    # Create suite-specific reference directory
    local suite_ref_dir="$REFERENCE_DIR/$suite_name"
    mkdir -p "$suite_ref_dir"
    
    # Process each test file
    local success_count=0
    local total_count=${#test_files[@]}
    
    for test_file in "${test_files[@]}"; do
        local test_name=$(basename "$test_file" .S)
        local ref_sig_file="$suite_ref_dir/${test_name}.reference_output"
        
        echo "  Processing: $test_name"
        
        # Create temporary work directory for this test
        local temp_dir="$WORK_DIR/temp_ref_$test_name"
        mkdir -p "$temp_dir"
        
        # Compile the test
        local elf_file="$temp_dir/${test_name}.elf"
        
        # Use the same compilation flags as the DUT plugin
        if ${RISCV_PREFIX}gcc \
            -march=rv32imc \
            -DXLEN=32 \
            -mabi=ilp32 \
            -static \
            -mcmodel=medany \
            -fvisibility=hidden \
            -nostdlib \
            -nostartfiles \
            -Wa,-march=rv32imc \
            -Wa,--no-warn \
            -Ttext=0x80000000 \
            -I"$RISCOF_DIR/zeronyte/env" \
            -DRVTEST_E=1 \
            -o "$elf_file" \
            "$test_file" 2>/dev/null; then
            
            # Run with Spike to generate reference signature
            if spike --isa=rv32imc "$elf_file" > "$ref_sig_file" 2>/dev/null; then
                echo "    ✅ Generated reference signature"
                ((success_count++))
            else
                echo "    ❌ Failed to run with Spike"
                echo "# Failed to generate reference signature with Spike" > "$ref_sig_file"
            fi
        else
            echo "    ❌ Failed to compile"
            echo "# Failed to compile test" > "$ref_sig_file"
        fi
        
        # Clean up temporary files
        rm -rf "$temp_dir"
    done
    
    echo "  Generated $success_count/$total_count reference signatures for $suite_name"
    echo ""
}

# Generate reference signatures based on command line arguments
if [ "$GENERATE_ALL" = true ] || [ "$GENERATE_I" = true ]; then
    generate_reference_signatures "I"
fi

if [ "$GENERATE_ALL" = true ] || [ "$GENERATE_M" = true ]; then
    generate_reference_signatures "M"
fi

if [ "$GENERATE_ALL" = true ] || [ "$GENERATE_PRIVILEGE" = true ]; then
    generate_reference_signatures "privilege"
fi

echo "✅ Reference signature generation completed"
echo "Reference signatures saved to: $REFERENCE_DIR"
echo ""
echo "You can now run conformance tests with:"
echo "  ./run_rtl_conformance_fixed.sh --smoke-test"
