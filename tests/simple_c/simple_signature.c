#include <stdint.h>

extern volatile uint32_t tohost;
extern volatile uint32_t fromhost;
extern volatile uint32_t begin_signature[];
extern volatile uint32_t end_signature;

static inline void write_signature(uint32_t index, uint32_t value) {
  begin_signature[index] = value;
}

volatile uint32_t data_words[4] = {
    0xdeadbeefu,
    0xa5a5a5a5u,
    0x0000ffffu,
    0x80000001u,
};

int main(void) {
  uint32_t a = 0x12345678u;
  uint32_t b = 0x01020304u;

  write_signature(0, a);
  write_signature(1, b);
  write_signature(2, a + b);
  write_signature(3, a ^ b);
  write_signature(4, a | b);
  write_signature(5, a & b);
  write_signature(6, data_words[2]);
  write_signature(7, data_words[0] + data_words[3]);

  (void)fromhost;
  (void)end_signature;

  tohost = 1;
  return 0;
}
