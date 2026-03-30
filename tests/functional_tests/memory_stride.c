#include <stdint.h>

extern volatile uint32_t signature_buffer[32];

#define MEM_WORDS 32u

volatile uint32_t g_mem[MEM_WORDS];

int main(void) {
  uint32_t sum_init = 0;
  uint32_t sum_stride3 = 0;
  uint32_t sum_even = 0;
  uint32_t xor_mix = 0;

  for (uint32_t i = 0; i < MEM_WORDS; ++i) {
    uint32_t v = (i * 0x10203u) ^ 0xA5A5A5A5u;
    g_mem[i] = v;
    sum_init += v;
  }

  for (uint32_t i = 0; i < MEM_WORDS; i += 3) {
    sum_stride3 += g_mem[i];
  }

  for (uint32_t i = 0; i < MEM_WORDS; i += 2) {
    g_mem[i] ^= 0x01020304u;
  }

  for (uint32_t i = 0; i < MEM_WORDS; ++i) {
    uint32_t v = g_mem[i];
    xor_mix ^= (v >> (i & 7u));
    if ((i & 1u) == 0u) {
      sum_even += v;
    }
  }

  signature_buffer[0] = sum_init;
  signature_buffer[1] = sum_stride3;
  signature_buffer[2] = sum_even;
  signature_buffer[3] = xor_mix;
  signature_buffer[4] = g_mem[0];
  signature_buffer[5] = g_mem[MEM_WORDS - 1u];
  signature_buffer[6] = 0x4D535452u;  // 'MSTR'
  signature_buffer[7] = 0x00000001u;

  return 0;
}
