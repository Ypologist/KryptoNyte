RISCV_PREFIX ?= /opt/riscv/bin/riscv64-unknown-elf-
CC := $(RISCV_PREFIX)gcc
AR := $(RISCV_PREFIX)ar
LD := $(CC)

OUTFLAG = -o
EXE =
OEXT = .o
MKDIR = mkdir -p

PORT_SRCS = $(PORT_DIR)/core_portme.c $(PORT_DIR)/crt0.S
PORT_CFLAGS = \
  -march=rv32i_zicsr \
  -mabi=ilp32 \
  -mcmodel=medany \
  -O2 \
  -ffreestanding \
  -fno-builtin \
  -fdata-sections \
  -ffunction-sections \
  -g \
  -static \
  -nostdlib \
  -nostartfiles \
  -Wall \
  -Wextra \
  -I$(PORT_DIR)
FLAGS_STR = "-march=rv32i_zicsr -O2 -ffreestanding"
CFLAGS = $(PORT_CFLAGS) -I. -DFLAGS_STR=\"$(FLAGS_STR)\"
LFLAGS_END = \
  -Wl,-T,$(PORT_DIR)/link.ld \
  -Wl,-Map=$(OPATH)coremark.map \
  -Wl,--gc-sections \
  -nostdlib \
  -nostartfiles \
  -static \
  -lgcc

LOAD = @:
RUN = @:
PORT_CLEAN = $(OPATH)coremark.map
