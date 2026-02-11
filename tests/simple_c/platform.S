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
.align 4
.globl begin_signature
begin_signature:
  .space 32
.globl end_signature
end_signature:
