#include <stdint.h>

#define DOT_PRODUCT_LEN 8u

extern volatile uint32_t signature_buffer[4];

static const int32_t kVecA[DOT_PRODUCT_LEN] = {2, -3, 4, -5, 6, -7, 8, -9};
static const int32_t kVecB[DOT_PRODUCT_LEN] = {1, 2, 3, 4, 5, 6, 7, 8};

static int32_t mul_i32(int32_t lhs, int32_t rhs) {
  uint32_t a = (lhs < 0) ? (uint32_t)(-lhs) : (uint32_t)lhs;
  uint32_t b = (rhs < 0) ? (uint32_t)(-rhs) : (uint32_t)rhs;
  uint32_t product = 0;

  while (b != 0u) {
    if ((b & 1u) != 0u) {
      product += a;
    }
    a <<= 1;
    b >>= 1;
  }

  if ((lhs < 0) ^ (rhs < 0)) {
    return -(int32_t)product;
  }
  return (int32_t)product;
}

int main(void) {
  int32_t dot = 0;
  for (uint32_t i = 0; i < DOT_PRODUCT_LEN; ++i) {
    dot += mul_i32(kVecA[i], kVecB[i]);
  }

  const int32_t expected = -40;

  signature_buffer[0] = (uint32_t)dot;
  signature_buffer[1] = (uint32_t)expected;
  signature_buffer[2] = (dot == expected) ? 0x600D600Du : 0xDEADBEEFu;
  signature_buffer[3] = 0x13579BDFu;

  return (dot == expected) ? 0 : 2;
}
