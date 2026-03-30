# Functional Tests

This directory contains bare-metal C kernels that can be co-simulated between a
reference RISC-V ISA simulator and KryptoNyte RTL simulators.

For now, kernels are run against ZeroNyte only.

## ZeroNyte Kernel Runs

Run:

```bash
tests/functional_tests/run_dot_product_zeronyte.sh
tests/functional_tests/run_alu_signature_zeronyte.sh
tests/functional_tests/run_memory_stride_zeronyte.sh
tests/functional_tests/run_branch_stress_zeronyte.sh
tests/functional_tests/run_checksum32_zeronyte.sh
```

Or use the generic runner:

```bash
tests/functional_tests/run_kernel_zeronyte.sh --kernel dot_product
tests/functional_tests/run_kernel_zeronyte.sh --kernel alu_signature
tests/functional_tests/run_kernel_zeronyte.sh --kernel memory_stride
tests/functional_tests/run_kernel_zeronyte.sh --kernel branch_stress
tests/functional_tests/run_kernel_zeronyte.sh --kernel checksum32
```

Batch run all kernels:

```bash
tests/functional_tests/run_all_zeronyte_kernels.sh
```

Each run will:

1. Build `<kernel>.c` into a RV32 ELF.
2. Run Spike and dump a signature file.
3. Run `zeronyte_sim` and dump a signature file.
4. Compare the two signatures and fail on mismatch.

Artifacts are written under:

```text
tests/output/functional_tests/<kernel>/zeronyte
```
