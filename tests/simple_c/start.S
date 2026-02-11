.section .text.init
.globl rvtest_entry_point
rvtest_entry_point:
  la sp, _stack_top
  call main
1:
  j 1b
