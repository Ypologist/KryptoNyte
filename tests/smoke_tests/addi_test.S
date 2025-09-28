#include "model_test.h"

.section .text.init
.globl rvtest_entry_point
rvtest_entry_point:

RVMODEL_BOOT

# Test ADDI instruction
# Test 1: Simple addition
addi x1, x0, 42      # x1 = 0 + 42 = 42
addi x2, x1, 8       # x2 = 42 + 8 = 50
addi x3, x2, -10     # x3 = 50 + (-10) = 40

# Test 2: Maximum positive immediate
addi x4, x0, 2047    # x4 = 0 + 2047 = 2047

# Test 3: Maximum negative immediate  
addi x5, x0, -2048   # x5 = 0 + (-2048) = -2048

# Test 4: Zero addition
addi x6, x0, 0       # x6 = 0 + 0 = 0

# Test 5: Chain operations
addi x7, x0, 100     # x7 = 100
addi x8, x7, 200     # x8 = 300
addi x9, x8, 300     # x9 = 600

RVMODEL_DATA_BEGIN
.align 4
begin_signature:

# Store test results
sw x1, 0(x0)        # Store 42
sw x2, 4(x0)        # Store 50  
sw x3, 8(x0)        # Store 40
sw x4, 12(x0)       # Store 2047
sw x5, 16(x0)       # Store -2048
sw x6, 20(x0)       # Store 0
sw x7, 24(x0)       # Store 100
sw x8, 28(x0)       # Store 300
sw x9, 32(x0)       # Store 600

end_signature:
RVMODEL_DATA_END

RVMODEL_HALT
