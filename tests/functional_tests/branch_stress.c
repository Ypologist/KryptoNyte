#include <stdint.h>

extern volatile uint32_t signature_buffer[32];

int main(void) {
  int32_t acc = 0;
  uint32_t branch_a = 0;
  uint32_t branch_b = 0;
  uint32_t branch_c = 0;
  uint32_t loop_iters = 0;

  for (uint32_t i = 0; i < 512u; ++i) {
    if ((i & 1u) == 0u) {
      acc += (int32_t)i;
      branch_a++;
    } else {
      acc -= (int32_t)(i >> 1);
      branch_b++;
    }

    switch (i & 3u) {
      case 0u:
        acc ^= 0x13579BDF;
        break;
      case 1u:
        acc += 0x2468;
        break;
      case 2u:
        acc -= 0x369C;
        break;
      default:
        acc = (acc << 1) | ((uint32_t)acc >> 31);
        break;
    }

    if ((acc & 7) == 3) {
      branch_c++;
    }
  }

  uint32_t i = 0;
  uint32_t phase = 0;
  while (i < 300u) {
    if (phase == 0u) {
      acc += (int32_t)i;
    } else if (phase == 1u) {
      acc -= (int32_t)(i + 7u);
    } else {
      acc ^= (int32_t)(i * 17u);
    }
    i += 3u;
    loop_iters++;
    phase += 3u;
    if (phase >= 5u) {
      phase -= 5u;
    }
  }

  signature_buffer[0] = (uint32_t)acc;
  signature_buffer[1] = branch_a;
  signature_buffer[2] = branch_b;
  signature_buffer[3] = branch_c;
  signature_buffer[4] = loop_iters;
  signature_buffer[5] = 0x42525354u;  // 'BRST'
  signature_buffer[6] = (branch_a + branch_b == 512u) ? 0x1u : 0x0u;
  signature_buffer[7] = 0x00000001u;

  return 0;
}
