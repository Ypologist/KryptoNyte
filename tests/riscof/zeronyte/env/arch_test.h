/*
 * RISC-V Architecture Test Framework - Simplified arch_test.h
 * Compatible with KryptoNyte's compilation flags
 */

#ifndef _ARCH_TEST_H
#define _ARCH_TEST_H

// Basic test macros
#define RVTEST_ISA(isa_str)
#define RVTEST_CODE_BEGIN
#define RVTEST_CODE_END
#define RVTEST_DATA_BEGIN
#define RVTEST_DATA_END

// Signature macros
#define RVTEST_SIGBASE(base_reg, base_addr) \
    la base_reg, base_addr

#define RVTEST_SIGUPD(base_reg, offset_reg, offset) \
    addi offset_reg, base_reg, offset

// Test result macros
#define TEST_CASE(test_num, testreg, correctval, code...) \
    code; \
    li x29, correctval; \
    bne testreg, x29, fail

// Pass/fail handling
#define TEST_PASSFAIL \
    j pass; \
fail: \
    li x28, 1; \
    j end; \
pass: \
    li x28, 0; \
end: \
    nop

// Memory load/store macros with simple implementations
#define RVMODEL_IO_WRITE_STR(str)
#define RVMODEL_IO_CHECK()
#define RVMODEL_IO_ASSERT_GPR_EQ(reg, val)
#define RVMODEL_IO_ASSERT_SFPR_EQ(reg, val)
#define RVMODEL_IO_ASSERT_DFPR_EQ(reg, val)

// Halt macro
#define RVMODEL_HALT \
    li x28, 0; \
    ecall

// Data section macros
#define RVMODEL_DATA_BEGIN \
    .section .data; \
    .align 4; \
    .global begin_signature; \
begin_signature:

#define RVMODEL_DATA_END \
    .global end_signature; \
end_signature:

// Boot macro
#define RVMODEL_BOOT

#endif /* _ARCH_TEST_H */
