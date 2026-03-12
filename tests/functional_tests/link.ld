OUTPUT_ARCH("riscv")
ENTRY(_start)

SECTIONS
{
  . = 0x80000000;
  .text.init : { *(.text.init) }
  . = ALIGN(0x1000);
  .tohost : { *(.tohost) }
  . = ALIGN(0x1000);
  .text : { *(.text .text.*) }
  .rodata : { *(.rodata .rodata.*) }
  . = ALIGN(0x1000);
  .data : { *(.data .data.*) }
  .sdata : { *(.sdata .sdata.*) }
  .bss : {
    *(.sbss .sbss.*)
    *(.bss .bss.*)
    *(COMMON)
  }

  . = ALIGN(16);
  .signature : { *(.signature) }

  . = ALIGN(16);
  .stack (NOLOAD) : {
    . = . + 0x1000;
    _stack_top = .;
  }

  _end = .;
}
