# Functional Tests

This directory contains bare-metal C tests that can be co-simulated between a
reference RISC-V ISA simulator and KryptoNyte RTL simulators.

## Dot Product (ZeroNyte)

Run:

```bash
tests/functional_tests/run_dot_product_zeronyte.sh
```

The script will:

1. Build `dot_product.c` into a RV32 ELF.
2. Run Spike and dump a signature file.
3. Run `zeronyte_sim` and dump a signature file.
4. Compare the two signatures and fail on mismatch.

Artifacts are written under:

```text
tests/output/functional_tests/dot_product/zeronyte
```
