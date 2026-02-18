.section .text.init
.globl rvtest_entry_point
rvtest_entry_point:
  la sp, _stack_top
  call main
  call rvmodel_halt

.globl rvmodel_halt
rvmodel_halt:
  li t0, 1
  la t1, tohost
1:
  sw t0, 0(t1)
  j 1b
