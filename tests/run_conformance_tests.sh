#!/bin/bash

#######################################
# KryptoNyte RISC-V Conformance Test Runner
# Production-quality script for running RISCOF conformance tests
#######################################

set -e  # Exit on any error

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KRYPTONYTE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RISCOF_ROOT="$SCRIPT_DIR/riscof"

# Default configuration
TEST_SUITE="rv32i_m"
ARCHITECTURE="rv32i"
WORK_DIR="$RISCOF_ROOT/work"
CONFIG_FILE="$RISCOF_ROOT/config.ini"
VERBOSE=true
CLEAN_WORK=false
PARALLEL_JOBS=4
TIMEOUT=300

# Test selection
RUN_ALL_TESTS=true
SPECIFIC_TESTS=""
EXCLUDE_TESTS=""

# Environment paths - check for system installation first
CONFORMANCE_ROOT="/opt/riscv-conformance"
if [ -d "$CONFORMANCE_ROOT/riscv-arch-test" ]; then
    ARCH_TEST_ROOT="$CONFORMANCE_ROOT/riscv-arch-test"
else
    ARCH_TEST_ROOT="$RISCOF_ROOT/riscv-arch-test"
fi

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Print functions
print_banner() {
    echo -e "\n${BLUE}============================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}============================================================${NC}"
}

print_step() {
    echo -e "${CYAN}▶${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --suite)
            TEST_SUITE="$2"
            shift 2
            ;;
        --arch)
            ARCHITECTURE="$2"
            shift 2
            ;;
        --work-dir)
            WORK_DIR="$2"
            shift 2
            ;;
        --config)
            CONFIG_FILE="$2"
            shift 2
            ;;
        --jobs)
            PARALLEL_JOBS="$2"
            shift 2
            ;;
        --timeout)
            TIMEOUT="$2"
            shift 2
            ;;
        --tests)
            SPECIFIC_TESTS="$2"
            RUN_ALL_TESTS=false
            shift 2
            ;;
        --exclude)
            EXCLUDE_TESTS="$2"
            shift 2
            ;;
        --clean)
            CLEAN_WORK=true
            shift
            ;;
        --quiet)
            VERBOSE=false
            shift
            ;;
        --help|-h)
            cat << EOF
KryptoNyte RISC-V Conformance Test Runner

Usage: $0 [options]

Options:
  --suite <suite>       Test suite to run (default: rv32i_m)
  --arch <arch>         Architecture (default: rv32i)
  --work-dir <dir>      Working directory (default: ./riscof/work)
  --config <file>       RISCOF config file (default: ./riscof/config.ini)
  --jobs <n>            Parallel jobs (default: 4)
  --timeout <sec>       Test timeout in seconds (default: 300)
  --tests <list>        Run specific tests (comma-separated)
  --exclude <list>      Exclude specific tests (comma-separated)
  --clean               Clean work directory before running
  --quiet               Reduce output verbosity
  --help, -h            Show this help message

Test Suites:
  rv32i_m               RV32I Machine mode tests
  rv32i_p               RV32I Privilege tests
  rv32im_m              RV32IM Machine mode tests
  rv32imc_m             RV32IMC Machine mode tests

Examples:
  # Run all RV32I machine mode tests
  $0 --suite rv32i_m

  # Run specific tests with verbose output
  $0 --suite rv32i_m --tests "add-01,sub-01" --clean

  # Run tests with custom configuration
  $0 --config custom_config.ini --arch rv32i --jobs 8

Environment Variables:
  RISCV_CONFORMANCE_ROOT    Path to conformance test installation
  RISCV_ARCH_TEST_ROOT      Path to architecture tests
  SPIKE_ROOT                Path to Spike simulator
EOF
            exit 0
            ;;
        *)
            print_error "Unknown argument: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Function to check prerequisites
check_prerequisites() {
    print_step "Checking prerequisites"
    
    local missing_tools=()
    
    # Check for RISCOF
    if ! command -v riscof >/dev/null 2>&1; then
        missing_tools+=("riscof")
    fi
    
    # Check for RISC-V toolchain
    if ! command -v "${ARCHITECTURE/rv/riscv}-unknown-elf-gcc" >/dev/null 2>&1 && \
       ! command -v "riscv32-unknown-elf-gcc" >/dev/null 2>&1 && \
       ! command -v "riscv64-unknown-elf-gcc" >/dev/null 2>&1; then
        missing_tools+=("riscv-toolchain")
    fi
    
    # Check for Spike
    if ! command -v spike >/dev/null 2>&1; then
        missing_tools+=("spike")
    fi
    
    # Check for Verilator
    if ! command -v verilator >/dev/null 2>&1; then
        missing_tools+=("verilator")
    fi
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        print_error "Missing required tools: ${missing_tools[*]}"
        print_step "Please install missing tools or run the installation script:"
        print_step "  .devcontainer/install_riscv_conformance_tests.sh --with-sudo"
        exit 1
    fi
    
    # Check for configuration file
    if [ ! -f "$CONFIG_FILE" ]; then
        print_error "Configuration file not found: $CONFIG_FILE"
        exit 1
    fi
    
    # Check for RTL files
    local rtl_file="$KRYPTONYTE_ROOT/rtl/generators/generated/verilog_hierarchical_timed/ZeroNyteRV32ICore.v"
    if [ ! -f "$rtl_file" ]; then
        print_warning "RTL file not found: $rtl_file"
        print_step "You may need to generate RTL first using the RTL generation scripts"
    fi
    
    # Check for architecture test suite
    if [ ! -d "$ARCH_TEST_ROOT" ]; then
        print_error "RISC-V architecture test suite not found: $ARCH_TEST_ROOT"
        print_step "Downloading architecture test suite..."
        cd "$RISCOF_ROOT"
        riscof arch-test --clone --dir ./riscv-arch-test
        cd - >/dev/null
    fi
    
    print_success "Prerequisites check completed"
}

# Function to setup environment
setup_environment() {
    print_step "Setting up environment"
    
    # Load RISC-V conformance environment if available
    local env_file="$HOME/.riscv_conformance_env"
    if [ -f "$env_file" ]; then
        source "$env_file"
        print_success "Loaded RISC-V conformance environment"
        # Update ARCH_TEST_ROOT from environment if available
        if [ -n "$RISCV_ARCH_TEST_ROOT" ] && [ -d "$RISCV_ARCH_TEST_ROOT" ]; then
            ARCH_TEST_ROOT="$RISCV_ARCH_TEST_ROOT"
        fi
    fi
    
    # Set up Python environment
    if [ -f "$CONFORMANCE_ROOT/.venv/bin/activate" ]; then
        source "$CONFORMANCE_ROOT/.venv/bin/activate"
        print_success "Activated Python virtual environment"
    elif [ -f "$CONFORMANCE_ROOT/venv/bin/activate" ]; then
        source "$CONFORMANCE_ROOT/venv/bin/activate"
        print_success "Activated Python virtual environment"
    fi
    
    # Export environment variables
    export RISCV_CONFORMANCE_ROOT="$CONFORMANCE_ROOT"
    export RISCV_ARCH_TEST_ROOT="$ARCH_TEST_ROOT"
    export KRYPTONYTE_ROOT="$KRYPTONYTE_ROOT"
    
    # Add current directory to Python path for plugin imports
    export PYTHONPATH="$RISCOF_ROOT:$PYTHONPATH"
    
    print_success "Environment setup completed"
}

# Function to prepare work directory
prepare_work_directory() {
    print_step "Preparing work directory: $WORK_DIR"
    
    if [ "$CLEAN_WORK" = true ] && [ -d "$WORK_DIR" ]; then
        print_step "Cleaning existing work directory"
        rm -rf "$WORK_DIR"
    fi
    
    mkdir -p "$WORK_DIR"
    
    # Create subdirectories
    mkdir -p "$WORK_DIR/logs"
    mkdir -p "$WORK_DIR/reports"
    mkdir -p "$WORK_DIR/signatures"
    
    print_success "Work directory prepared"
}

# Function to validate configuration
validate_configuration() {
    print_step "Validating RISCOF configuration"
    
    # Change to tests directory for validation
    cd "$(dirname "$RISCOF_ROOT")"
    
    local validation_log="$WORK_DIR/logs/riscof_validation.log"
    mkdir -p "$(dirname "$validation_log")"
    
    if ! riscof validateyaml --config="riscof/config.ini" > "$validation_log" 2>&1; then
        print_warning "RISCOF configuration validation had issues"
        if [ "$VERBOSE" = true ]; then
            print_step "Running configuration validation for details:"
            riscof validateyaml --config="riscof/config.ini" || true
        fi
    else
        print_success "Configuration validation passed"
    fi
}

# Function to run RISCOF tests
run_riscof_tests() {
    print_banner "Running RISCOF Conformance Tests"
    
    local start_time=$(date +%s)
    
    print_step "Test Configuration:"
    echo "  Suite: $TEST_SUITE"
    echo "  Architecture: $ARCHITECTURE"
    echo "  Work Directory: $WORK_DIR"
    echo "  Config File: $CONFIG_FILE"
    echo "  Parallel Jobs: $PARALLEL_JOBS"
    echo "  Timeout: ${TIMEOUT}s"
    
    # Change to tests directory for proper path resolution
    cd "$(dirname "$RISCOF_ROOT")"
    
    # Build RISCOF command
    local riscof_cmd="riscof run"
    riscof_cmd+=" --config=riscof/config.ini"
    riscof_cmd+=" --suite=$ARCH_TEST_ROOT/riscv-test-suite/$TEST_SUITE"
    riscof_cmd+=" --env=riscof/zeronyte/env"
    riscof_cmd+=" --work-dir=$WORK_DIR"
    
    if [ "$RUN_ALL_TESTS" = false ] && [ -n "$SPECIFIC_TESTS" ]; then
        riscof_cmd+=" --filter=$SPECIFIC_TESTS"
    fi
    
    if [ -n "$EXCLUDE_TESTS" ]; then
        riscof_cmd+=" --exclude=$EXCLUDE_TESTS"
    fi
    
    # Note: riscof run command doesn't support --verbose flag
    # Verbose output is controlled by the global -v flag
    
    print_step "Running RISCOF command: $riscof_cmd"
    
    # Run RISCOF tests
    local log_file="$WORK_DIR/logs/riscof_run_$(date +%Y%m%d_%H%M%S).log"
    
    if [ "$VERBOSE" = true ]; then
        # Show output in real-time and save to log
        $riscof_cmd 2>&1 | tee "$log_file"
        local exit_code=${PIPESTATUS[0]}
    else
        # Only save to log file
        $riscof_cmd > "$log_file" 2>&1
        local exit_code=$?
    fi
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    if [ $exit_code -eq 0 ]; then
        print_success "RISCOF tests completed successfully in ${duration}s"
    else
        print_error "RISCOF tests failed with exit code $exit_code"
        print_step "Check log file: $log_file"
        exit $exit_code
    fi
}

# Function to generate test report
generate_report() {
    print_step "Generating test report"
    
    local report_file="$WORK_DIR/reports/conformance_report_$(date +%Y%m%d_%H%M%S).md"
    
    cat > "$report_file" << EOF
# KryptoNyte RISC-V Conformance Test Report

## Test Configuration
- **Test Suite**: $TEST_SUITE
- **Architecture**: $ARCHITECTURE
- **Date**: $(date)
- **Duration**: ${duration}s

## Test Results
$(find "$WORK_DIR" -name "*.html" -o -name "*.xml" -o -name "*.json" | head -10 | while read file; do echo "- [$(basename "$file")]($file)"; done)

## Summary
- **Work Directory**: $WORK_DIR
- **Configuration**: $CONFIG_FILE
- **Log Files**: $WORK_DIR/logs/

## Next Steps
1. Review detailed test results in the work directory
2. Analyze any test failures
3. Update RTL or test configuration as needed
4. Re-run failed tests if necessary

Generated by: KryptoNyte RISCOF Test Runner
EOF
    
    print_success "Test report generated: $report_file"
}

# Function to cleanup
cleanup() {
    print_step "Cleaning up temporary files"
    
    # Remove temporary files but keep results
    find "$WORK_DIR" -name "*.tmp" -delete 2>/dev/null || true
    find "$WORK_DIR" -name "core.*" -delete 2>/dev/null || true
    
    print_success "Cleanup completed"
}

# Main execution
main() {
    print_banner "KryptoNyte RISC-V Conformance Test Runner"
    
    check_prerequisites
    setup_environment
    prepare_work_directory
    validate_configuration
    run_riscof_tests
    generate_report
    cleanup
    
    print_banner "Conformance Testing Complete!"
    echo -e "${GREEN}Results available in: $WORK_DIR${NC}"
    
    # Show summary of key files
    if [ -d "$WORK_DIR/riscof_work" ]; then
        echo -e "${GREEN}RISCOF results: $WORK_DIR/riscof_work${NC}"
    fi
    
    if [ -f "$WORK_DIR/reports/conformance_report_"*.md ]; then
        echo -e "${GREEN}Test report: $(ls -t "$WORK_DIR/reports/conformance_report_"*.md | head -1)${NC}"
    fi
}

# Run main function
main "$@"
