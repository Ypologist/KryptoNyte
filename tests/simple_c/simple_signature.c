#include <stdint.h>

extern volatile uint32_t tohost;
extern volatile uint32_t fromhost;
extern volatile uint32_t begin_signature[];
extern volatile uint32_t end_signature;

static inline void write_signature(uint32_t index, uint32_t value) {
  begin_signature[index] = value;
}

static inline uint32_t rv_sub(uint32_t a, uint32_t b) {
  uint32_t r;
  asm volatile("sub %0, %1, %2" : "=r"(r) : "r"(a), "r"(b));
  return r;
}

static inline uint32_t rv_sll(uint32_t a, uint32_t shamt) {
  uint32_t r;
  asm volatile("sll %0, %1, %2" : "=r"(r) : "r"(a), "r"(shamt));
  return r;
}

static inline uint32_t rv_srl(uint32_t a, uint32_t shamt) {
  uint32_t r;
  asm volatile("srl %0, %1, %2" : "=r"(r) : "r"(a), "r"(shamt));
  return r;
}

static inline uint32_t rv_sra(uint32_t a, uint32_t shamt) {
  uint32_t r;
  asm volatile("sra %0, %1, %2" : "=r"(r) : "r"(a), "r"(shamt));
  return r;
}

static inline uint32_t rv_slt(uint32_t a, uint32_t b) {
  uint32_t r;
  asm volatile("slt %0, %1, %2" : "=r"(r) : "r"(a), "r"(b));
  return r;
}

static inline uint32_t rv_sltu(uint32_t a, uint32_t b) {
  uint32_t r;
  asm volatile("sltu %0, %1, %2" : "=r"(r) : "r"(a), "r"(b));
  return r;
}

static inline uint32_t rv_addi(uint32_t a) {
  uint32_t r;
  asm volatile("addi %0, %1, 7" : "=r"(r) : "r"(a));
  return r;
}

static inline uint32_t rv_andi(uint32_t a) {
  uint32_t r;
  asm volatile("andi %0, %1, 0x0ff" : "=r"(r) : "r"(a));
  return r;
}

static inline uint32_t rv_ori(uint32_t a) {
  uint32_t r;
  asm volatile("ori %0, %1, 0x0f0" : "=r"(r) : "r"(a));
  return r;
}

static inline uint32_t rv_xori(uint32_t a) {
  uint32_t r;
  asm volatile("xori %0, %1, 0x0ff" : "=r"(r) : "r"(a));
  return r;
}

static inline uint32_t rv_slli(uint32_t a) {
  uint32_t r;
  asm volatile("slli %0, %1, 4" : "=r"(r) : "r"(a));
  return r;
}

static inline uint32_t rv_srli(uint32_t a) {
  uint32_t r;
  asm volatile("srli %0, %1, 2" : "=r"(r) : "r"(a));
  return r;
}

static inline uint32_t rv_srai(uint32_t a) {
  uint32_t r;
  asm volatile("srai %0, %1, 1" : "=r"(r) : "r"(a));
  return r;
}

static inline uint32_t rv_slti(uint32_t a) {
  uint32_t r;
  asm volatile("slti %0, %1, 10" : "=r"(r) : "r"(a));
  return r;
}

static inline uint32_t rv_sltiu(uint32_t a) {
  uint32_t r;
  asm volatile("sltiu %0, %1, 1" : "=r"(r) : "r"(a));
  return r;
}

static inline uint32_t rv_lw0(const volatile uint8_t* base) {
  uint32_t r;
  asm volatile("lw %0, 0(%1)" : "=r"(r) : "r"(base));
  return r;
}

static inline uint32_t rv_lw8(const volatile uint8_t* base) {
  uint32_t r;
  asm volatile("lw %0, 8(%1)" : "=r"(r) : "r"(base));
  return r;
}

static inline uint32_t rv_lw12(const volatile uint8_t* base) {
  uint32_t r;
  asm volatile("lw %0, 12(%1)" : "=r"(r) : "r"(base));
  return r;
}

static inline uint32_t rv_lb6(const volatile uint8_t* base) {
  int32_t r;
  asm volatile("lb %0, 6(%1)" : "=r"(r) : "r"(base));
  return (uint32_t)r;
}

static inline uint32_t rv_lbu6(const volatile uint8_t* base) {
  uint32_t r;
  asm volatile("lbu %0, 6(%1)" : "=r"(r) : "r"(base));
  return r;
}

static inline uint32_t rv_lh4(const volatile uint8_t* base) {
  int32_t r;
  asm volatile("lh %0, 4(%1)" : "=r"(r) : "r"(base));
  return (uint32_t)r;
}

static inline uint32_t rv_lhu4(const volatile uint8_t* base) {
  uint32_t r;
  asm volatile("lhu %0, 4(%1)" : "=r"(r) : "r"(base));
  return r;
}

static inline void rv_sw12(volatile uint8_t* base, uint32_t value) {
  asm volatile("sw %0, 12(%1)" :: "r"(value), "r"(base) : "memory");
}

volatile uint32_t data_words[4] = {
    0xdeadbeefu,
    0xa5a5a5a5u,
    0x0000ffffu,
    0x80000001u,
};

int main(void) {
  volatile uint32_t a = 0x12345678u;
  volatile uint32_t b = 0x01020304u;
  volatile uint32_t neg = 0x80000001u;

  volatile uint8_t mem[16] __attribute__((aligned(4))) = {
      0x11, 0x22, 0x33, 0x44,
      0x00, 0x80, 0xFF, 0x7F,
      0x55, 0xAA, 0x01, 0x02,
      0x10, 0x20, 0x30, 0x40,
  };
  volatile uint8_t* mem_base = mem;

  write_signature(0, a);
  write_signature(1, b);
  write_signature(2, a + b);
  write_signature(3, a ^ b);
  write_signature(4, a | b);
  write_signature(5, a & b);
  write_signature(6, data_words[2]);
  write_signature(7, data_words[0] + data_words[3]);

  write_signature(8, rv_sub(a, b));
  write_signature(9, rv_sll(a, 3));
  write_signature(10, rv_srl(a, 5));
  write_signature(11, rv_sra(neg, 3));
  write_signature(12, rv_slt(a, b));
  write_signature(13, rv_slt(b, a));
  write_signature(14, rv_sltu(0u, 0xffffffffu));
  write_signature(15, rv_addi(a));
  write_signature(16, rv_andi(a));
  write_signature(17, rv_ori(a));
  write_signature(18, rv_xori(a));
  write_signature(19, rv_slli(a));
  write_signature(20, rv_srli(a));
  write_signature(21, rv_srai(neg));
  write_signature(22, rv_slti(5u));
  write_signature(23, rv_sltiu(0u));

  write_signature(24, rv_lw0(mem_base));
  write_signature(25, rv_lb6(mem_base));
  write_signature(26, rv_lbu6(mem_base));
  write_signature(27, rv_lh4(mem_base));
  write_signature(28, rv_lhu4(mem_base));
  write_signature(29, rv_lw8(mem_base));
  rv_sw12(mem_base, 0x0badf00du);
  write_signature(30, rv_lw12(mem_base));

  uint32_t branch_flags = 0;
  if (a == 0x12345678u) {
    branch_flags |= 0x1;
  } else {
    branch_flags |= 0x2;
  }
  if (a != b) {
    branch_flags |= 0x4;
  } else {
    branch_flags |= 0x8;
  }
  if ((int32_t)neg < 0) {
    branch_flags |= 0x10;
  } else {
    branch_flags |= 0x20;
  }
  if (a < b) {
    branch_flags |= 0x40;
  } else {
    branch_flags |= 0x80;
  }
  write_signature(31, branch_flags);

  (void)fromhost;
  (void)end_signature;

  tohost = 1;
  return 0;
}
