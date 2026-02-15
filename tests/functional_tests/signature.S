.section .signature, "aw", @progbits
.align 4
.globl begin_signature
begin_signature:
.globl signature_buffer
signature_buffer:
  .word 0
  .word 0
  .word 0
  .word 0
.globl end_signature
end_signature:
