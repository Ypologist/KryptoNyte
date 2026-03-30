#include <stdint.h>

extern volatile uint32_t signature_buffer[32];

#define DATA_LEN 64u

static const uint8_t kData[DATA_LEN] = {
    0x10, 0x32, 0x54, 0x76, 0x98, 0xBA, 0xDC, 0xFE,
    0x01, 0x23, 0x45, 0x67, 0x89, 0xAB, 0xCD, 0xEF,
    0x55, 0xAA, 0x5A, 0xA5, 0x0F, 0xF0, 0x11, 0xEE,
    0x12, 0x21, 0x34, 0x43, 0x56, 0x65, 0x78, 0x87,
    0x9A, 0xA9, 0xBC, 0xCB, 0xDE, 0xED, 0xF1, 0x1F,
    0x24, 0x42, 0x36, 0x63, 0x48, 0x84, 0x5A, 0xA5,
    0x6C, 0xC6, 0x7E, 0xE7, 0x80, 0x08, 0x91, 0x19,
    0xA2, 0x2A, 0xB3, 0x3B, 0xC4, 0x4C, 0xD5, 0x5D,
};

int main(void) {
  uint32_t sum = 0;
  uint32_t xor_fold = 0;
  uint32_t fnv = 2166136261u;

  for (uint32_t i = 0; i < DATA_LEN; ++i) {
    uint32_t b = (uint32_t)kData[i];
    sum += b;
    xor_fold ^= (b << (i & 7u));
    fnv ^= b;
    fnv *= 16777619u;
  }

  uint32_t rolling = 0;
  for (uint32_t i = 0; i < DATA_LEN; i += 4u) {
    uint32_t w = ((uint32_t)kData[i + 0u] << 0u) |
                 ((uint32_t)kData[i + 1u] << 8u) |
                 ((uint32_t)kData[i + 2u] << 16u) |
                 ((uint32_t)kData[i + 3u] << 24u);
    rolling = (rolling << 5) | (rolling >> 27);
    rolling ^= w;
  }

  signature_buffer[0] = sum;
  signature_buffer[1] = xor_fold;
  signature_buffer[2] = fnv;
  signature_buffer[3] = rolling;
  signature_buffer[4] = DATA_LEN;
  signature_buffer[5] = 0x43534B33u;  // 'CSK3'
  signature_buffer[6] = 0x00000001u;

  return 0;
}
