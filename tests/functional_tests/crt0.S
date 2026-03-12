.section .text.init
.globl _start
_start:
  la sp, _stack_top
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

.align 8
.globl fromhost
fromhost:
  .dword 0
