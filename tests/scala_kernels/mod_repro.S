    .section .text
    .globl _start
_start:
    li sp, 0x80004000
    jal ra, InitSeed
    li t1, 512
loop_random:
    jal ra, RandomInteger
    addi t1, t1, -1
    bnez t1, loop_random
    lui t0, 0x80002
    lw a0, 0(t0)
    li t2, 0x80003000
    sw a0, 0(t2)
halt:
    jal zero, halt

InitSeed:
    lui t0, 0x80002
    sw zero, 0(t0)
    ret

RandomInteger:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    addi s0, sp, 16
    lui a5, 0x80002
    lw a4, 0(a5)
    mv a5, a4
    slli a5, a5, 5
    add a5, a5, a4
    slli a5, a5, 2
    add a5, a5, a4
    addi a4, a5, 81
    lui a5, 0x2
    addi a1, a5, -97
    mv a0, a4
    jal ra, __modsi3
    mv a5, a0
    mv a4, a5
    lui a5, 0x80002
    sw a4, 0(a5)
    lui a5, 0x80002
    lw a5, 0(a5)
    mv a0, a5
    lw ra, 12(sp)
    lw s0, 8(sp)
    addi sp, sp, 16
    ret

    .globl __hidden___udivsi3
__hidden___udivsi3:
    mv a2, a1
    mv a1, a0
    li a0, -1
    beqz a2, 2f
    li a3, 1
1:
    bgeu a2, a1, 0f
    blez a2, 0f
    slli a2, a2, 1
    slli a3, a3, 1
    bltu a2, a1, 1b
0:
    li a0, 0
2:
    bltu a1, a2, 3f
    sub a1, a1, a2
    or a0, a0, a3
3:
    srli a3, a3, 1
    srli a2, a2, 1
    bnez a3, 2b
    ret

    .globl __modsi3
__modsi3:
    mv t0, ra
    bltz a1, 4f
    bltz a0, 5f
    jal ra, __hidden___udivsi3
    mv a0, a1
    jr t0
4:
    neg a1, a1
    bgez a0, 6f
5:
    neg a0, a0
    jal ra, __hidden___udivsi3
    neg a0, a1
    jr t0
6:
    jal ra, __hidden___udivsi3
    mv a0, a1
    jr t0

    .section .bss
    .align 2
Seed:
    .word 0
