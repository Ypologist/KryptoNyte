#!/bin/bash

# Create dummy reference signatures for testing signature comparison
# This allows us to test the signature comparison functionality

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REF_SIG_DIR="$SCRIPT_DIR/reference_signatures/src"

echo "Creating dummy reference signatures for testing..."

# Create the reference signatures directory
mkdir -p "$REF_SIG_DIR"

# Create a dummy reference signature for addi-01 test
# This should match what a working ZeroNyte core would produce
cat > "$REF_SIG_DIR/addi-01.signature" << 'EOF'
feedc0b7
00f16133
0071d213
01925793
00f36333
0073d413
01945793
00f56533
0075d613
01965793
18012303
fe64ae23
bfe5f413
00130000
babecafe
00000080
00000004
EOF

echo "✅ Created dummy reference signature for addi-01"
echo "Reference signatures directory: $REF_SIG_DIR"
echo ""
echo "To use your prebuilt signatures:"
echo "1. Copy your prebuilt .signature files to: $REF_SIG_DIR"
echo "2. Make sure filenames match the test names (e.g., addi-01.signature)"
echo "3. Run: ./run_rtl_conformance.sh --smoke-test"
