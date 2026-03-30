# External Kernel Suites

This directory tracks metadata, scripts, and documentation for open-source
kernel/benchmark suites that live outside of the KryptoNyte repository. The
current workflow is:

1. Clone the suites under a sibling directory (default:
   `../external-kernels`) so the large third-party projects are not checked
   into this repo.
2. Point the simulation runners at those clones when building/running kernels
   against Spike and the RTL simulators.

## Cloned suites

| Name | Repository | Notes |
| --- | --- | --- |
| `beebs` | https://github.com/mageec/beebs | Bare-metal kernels for embedded energy/perf measurements. Good source of integer-heavy workloads. |
| `embench-iot` | https://github.com/embench/embench-iot | Successor to BEEBS that bundles Python harnesses and consistent scoring. |
| `coremark` | https://github.com/eembc/coremark | Industry-standard MCU benchmark; requires a `core_portme` port but otherwise self-contained. |
| `riscv-tests` | https://github.com/riscv-software-src/riscv-tests | Assembly ISA tests; complements our RISCOF suite for quick spot checks. |
| `riscv-torture` | https://github.com/ucb-bar/riscv-torture | Random instruction generator that already emits Spike-compatible signatures. |

Feel free to extend the list as we onboard more suites (PolyBench, CHStone,
MiBench, etc.). Each suite should eventually get a runner script here that
translates the upstream build artifacts into our Spike/ZeroNyte signature flow.

### BEEBS workflow

- Clone via `tests/external_kernels/clone_all.sh` (places the repo under
  `../external-kernels/beebs`).
- Patch/build/run a benchmark:

```bash
tests/external_kernels/run_beebs.sh --benchmark cnt
```

The script applies the Zeronyte signature patch if needed, configures BEEBS for
riscv32 (ri5cy chip, generic board), builds the requested benchmark, and runs
Spike and ZeroNyte back-to-back. Artifacts land under
`tests/output/external/beebs/<benchmark>`.

## Cloning helper

Use `clone_all.sh` to create or update the suite clones. By default the script
creates `../external-kernels` relative to the repo root, but you can override
the destination with `EXTERNAL_KERNELS_DIR=/path/to/dir`.

```bash
tests/external_kernels/clone_all.sh
EXTERNAL_KERNELS_DIR=/opt/kernels tests/external_kernels/clone_all.sh
```

The script is idempotent: existing clones are fetched and fast-forwarded; new
directories are cloned fresh. After cloning, refer to the suite-specific README
files under the destination directory.
