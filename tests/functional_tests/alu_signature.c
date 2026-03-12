#include <stdint.h>

extern volatile uint32_t signature_buffer[32];

int main(void) {
  const uint32_t a = 0x12345678u;
  const uint32_t b = 0x01020304u;
  const int32_t neg = (int32_t)0x80000001u;

  volatile uint8_t mem[16] __attribute__((aligned(4))) = {
      0x11, 0x22, 0x33, 0x44,
      0x00, 0x80, 0xFF, 0x7F,
      0x55, 0xAA, 0x01, 0x02,
      0x10, 0x20, 0x30, 0x40,
  };

  signature_buffer[0] = a + b;
  signature_buffer[1] = a - b;
  signature_buffer[2] = a ^ b;
  signature_buffer[3] = a | b;
  signature_buffer[4] = a & b;
  signature_buffer[5] = a << 3;
  signature_buffer[6] = a >> 5;
  signature_buffer[7] = (uint32_t)(neg >> 3);

  signature_buffer[8] = *(volatile uint32_t*)&mem[0];
  signature_buffer[9] = (uint32_t)*(volatile int8_t*)&mem[6];
  signature_buffer[10] = (uint32_t)*(volatile uint8_t*)&mem[6];
  signature_buffer[11] = (uint32_t)*(volatile int16_t*)&mem[4];
  signature_buffer[12] = (uint32_t)*(volatile uint16_t*)&mem[4];
  signature_buffer[13] = *(volatile uint32_t*)&mem[8];

  *(volatile uint32_t*)&mem[12] = 0x0BADF00Du;
  signature_buffer[14] = *(volatile uint32_t*)&mem[12];

  uint32_t flags = 0;
  if (a == 0x12345678u) {
    flags |= 0x1u;
  }
  if (a != b) {
    flags |= 0x2u;
  }
  if (neg < 0) {
    flags |= 0x4u;
  }
  if (a > b) {
    flags |= 0x8u;
  }
  signature_buffer[15] = flags;

  return (flags == 0xFu) ? 0 : 3;
}
