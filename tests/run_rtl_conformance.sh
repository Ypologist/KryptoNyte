#!/bin/bash

# Run RISC-V Conformance Tests against RTL Implementation
# This script runs tests for specific extensions against the RTL implementation
# Updated for RISCOF 1.25.3 with database approach and parallel execution

set -e

# Signal handling for clean exit
cleanup() {
    echo ""
    echo "🛑 Script interrupted. Cleaning up..."
    # Kill any running processes and their children
    pkill -f riscof 2>/dev/null || true
    # Kill any background jobs
    jobs -p | xargs -r kill 2>/dev/null || true
    # Wait a moment for processes to terminate
    sleep 1
    echo "✅ Cleanup completed"
    exit 1
}

trap cleanup SIGINT SIGTERM

# Parse command line arguments
RUN_I=true
RUN_M=false
RUN_PRIVILEGE=false
SMOKE_TEST=false
PARALLEL_JOBS=""

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
        --jobs)
            PARALLEL_JOBS="$2"
            shift 2
            ;;
        --help)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --with-m           Include M extension tests (multiply/divide)"
            echo "  --with-privilege   Include privilege tests"
            echo "  --all              Include all test suites"
            echo "  --smoke-test       Run only a single test as a smoke test"
            echo "  --jobs N           Number of parallel jobs (default: half of available cores)"
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

# Detect available processors and set parallel jobs
TOTAL_CORES=$(nproc)
if [ -z "$PARALLEL_JOBS" ]; then
    PARALLEL_JOBS=$(( TOTAL_CORES / 2 ))
    # Ensure at least 1 job
    if [ $PARALLEL_JOBS -eq 0 ]; then
        PARALLEL_JOBS=1
    fi
fi

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

# Print selected test suites
echo "============================================================"
echo "Running RISC-V Conformance Tests against RTL Implementation"
echo "============================================================"
echo "System Configuration:"
echo "  - Total CPU cores: $TOTAL_CORES"
echo "  - Parallel jobs: $PARALLEL_JOBS"
echo ""
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

# Generate database if it doesn't exist or if we want to refresh it
DATABASE_FILE="$WORK_DIR/database.yaml"
if [ ! -f "$DATABASE_FILE" ] || [ "$1" = "--refresh-db" ]; then
    echo "▶ Generating test database"
    riscof testlist \
        --suite="$CONFORMANCE_SUITE" \
        --env="zeronyte/env" \
        --config="config.ini" \
        --work-dir="$WORK_DIR"
fi

# Create a filtered test list if smoke test is requested
if [ "$SMOKE_TEST" = true ]; then
    echo "▶ Creating smoke test filter"
    
    # Create a simple test list with just one I extension test
    cat > "$WORK_DIR/smoke_test_list.yaml" << EOF
# Smoke test - single test for quick validation
/opt/riscv-conformance/riscv-arch-test/riscv-test-suite/rv32i_m/I/src/addi-01.S:
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
    
    TEST_ARG="--testfile=$WORK_DIR/smoke_test_list.yaml"
else
    TEST_ARG="--dbfile=$DATABASE_FILE"
fi

# Function to run a subset of tests
run_test_subset() {
    local subset_id="$1"
    local test_file="$2"
    local subset_work_dir="$WORK_DIR/parallel_$subset_id"
    
    echo "▶ [Job $subset_id] Starting parallel test execution"
    
    # Create separate work directory for this subset
    mkdir -p "$subset_work_dir"
    
    # Run RISCOF for this subset
    riscof run \
        --suite="$CONFORMANCE_SUITE" \
        --env="zeronyte/env" \
        --config="config.ini" \
        --work-dir="$subset_work_dir" \
        --testfile="$test_file" \
        --no-browser \
        > "$subset_work_dir/riscof_$subset_id.log" 2>&1
    
    local exit_code=$?
    if [ $exit_code -eq 0 ]; then
        echo "✅ [Job $subset_id] Completed successfully"
    else
        echo "❌ [Job $subset_id] Failed with exit code $exit_code"
    fi
    
    return $exit_code
}

# Run RISCOF with parallel execution
echo "▶ Running RISCOF with parallel execution ($PARALLEL_JOBS jobs)"
echo "  Using work directory: $WORK_DIR"
echo "  Using database: $DATABASE_FILE"
echo ""

if [ "$SMOKE_TEST" = true ] || [ "$PARALLEL_JOBS" -eq 1 ]; then
    # Single job execution for smoke test or when only 1 job requested
    echo "Running single job execution"
    echo "Suite: $CONFORMANCE_SUITE"
    echo "Env: zeronyte/env"
    echo "Config: config.ini"
    echo "Work dir: $WORK_DIR"
    
    riscof run \
        --suite="$CONFORMANCE_SUITE" \
        --env="zeronyte/env" \
        --config="config.ini" \
        --work-dir="$WORK_DIR" \
        $TEST_ARG \
        --no-browser
    
    echo "✅ RISCOF tests completed"
else
    # Parallel execution
    echo "Splitting tests into $PARALLEL_JOBS parallel jobs..."
    
    # Split the database into chunks for parallel processing
    python3 << EOF
import yaml
import sys
import os
import math

# Load the database
with open('$DATABASE_FILE', 'r') as f:
    db = yaml.safe_load(f)

# Handle RISCOF's ordered map format (list of tuples)
tests = []
if isinstance(db, list):
    # RISCOF 1.25.3 uses ordered map format (list of tuples)
    for item in db:
        if isinstance(item, tuple) and len(item) == 2:
            test_path, test_data = item
            test_entry = {test_path: test_data}
            tests.append(test_entry)
        elif isinstance(item, dict):
            tests.append(item)
elif isinstance(db, dict):
    # Older format (dict)
    for test_path, test_data in db.items():
        test_entry = {test_path: test_data}
        tests.append(test_entry)
else:
    print(f"Unexpected database format: {type(db)}")
    sys.exit(1)

total_tests = len(tests)
jobs = $PARALLEL_JOBS
chunk_size = math.ceil(total_tests / jobs)

print(f"Total tests: {total_tests}")
print(f"Chunk size: {chunk_size}")

# Create test files for each job
for i in range(jobs):
    start_idx = i * chunk_size
    end_idx = min((i + 1) * chunk_size, total_tests)
    
    if start_idx >= total_tests:
        break
        
    chunk_tests = tests[start_idx:end_idx]
    
    # Create test file for this chunk
    chunk_dict = {}
    for test in chunk_tests:
        chunk_dict.update(test)
    
    chunk_file = f'$WORK_DIR/test_chunk_{i}.yaml'
    with open(chunk_file, 'w') as f:
        yaml.dump(chunk_dict, f, default_flow_style=False)
    
    print(f"Created chunk {i}: {len(chunk_tests)} tests -> {chunk_file}")
EOF
    
    # Start parallel jobs
    echo ""
    echo "Starting $PARALLEL_JOBS parallel RISCOF jobs..."
    
    job_pids=()
    for i in $(seq 0 $((PARALLEL_JOBS - 1))); do
        chunk_file="$WORK_DIR/test_chunk_$i.yaml"
        if [ -f "$chunk_file" ]; then
            run_test_subset "$i" "$chunk_file" &
            job_pids+=($!)
        fi
    done
    
    # Wait for all jobs to complete
    echo "Waiting for all parallel jobs to complete..."
    failed_jobs=0
    for i in "${!job_pids[@]}"; do
        pid=${job_pids[$i]}
        if wait $pid; then
            echo "✅ Job $i completed successfully"
        else
            echo "❌ Job $i failed"
            ((failed_jobs++))
        fi
    done
    
    # Merge results
    echo ""
    echo "▶ Merging results from parallel jobs..."
    
    # Copy all results to main work directory
    for i in $(seq 0 $((PARALLEL_JOBS - 1))); do
        subset_work_dir="$WORK_DIR/parallel_$i"
        if [ -d "$subset_work_dir" ]; then
            # Copy test results, avoiding conflicts
            find "$subset_work_dir" -name "*.signature" -exec cp {} "$WORK_DIR/" \; 2>/dev/null || true
            find "$subset_work_dir" -type d -name "*src*" -exec cp -r {} "$WORK_DIR/" \; 2>/dev/null || true
        fi
    done
    
    if [ $failed_jobs -eq 0 ]; then
        echo "✅ All parallel RISCOF jobs completed successfully"
    else
        echo "⚠️  $failed_jobs out of $PARALLEL_JOBS jobs failed"
    fi
fi

echo ""
echo "Results available in: $WORK_DIR"
echo "Individual job logs available in: $WORK_DIR/parallel_*/riscof_*.log"
