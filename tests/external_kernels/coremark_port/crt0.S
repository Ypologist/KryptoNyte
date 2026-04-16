.section .text.init
.globl _start
_start:
  la sp, _stack_top
  la t0, trap_vector
  csrw mtvec, t0
  call main

  li t1, 1
  beqz a0, 1f
  mv t1, a0
1:
  la t0, tohost
  sw t1, 0(t0)
2:
  j 2b

.section .tohost, "aw", @progbits
.align 8
.globl tohost
tohost:
  .dword 0

.align 4
trap_vector:
  csrr t2, mcause
  csrr t3, mepc
  la t4, coremark_signature_buffer
  li t5, 31
  slli t5, t5, 2
  add t4, t4, t5
  sw t2, 0(t4)
  addi t4, t4, -4
  sw t3, 0(t4)
  la t0, tohost
  li t1, 1
  sw t1, 0(t0)
1:
  j 1b

.align 8
.globl fromhost
fromhost:
  .dword 0
