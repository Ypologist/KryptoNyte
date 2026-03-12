.section .tohost,"aw",@progbits
.align 8
.globl tohost
tohost:
  .dword 0
.align 8
.globl fromhost
fromhost:
  .dword 0

.section .data
.align 8
.globl begin_regstate
begin_regstate:
  .word 128
.align 8
.globl end_regstate
end_regstate:
  .word 4

.align 4
.globl begin_signature
begin_signature:
  .space 128
.globl end_signature
end_signature:
