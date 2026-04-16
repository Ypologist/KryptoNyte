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
tests/external_kernels/run_beebs.sh --benchmark cnt --processor tetranyte --thread-mask 0x1
```

The script applies the Zeronyte signature patch if needed, configures BEEBS for
riscv32 (ri5cy chip, generic board), builds the requested benchmark, and runs
Spike and the selected RTL core back-to-back (ZeroNyte by default). For the
barrel-threaded TetraNyte core the runner automatically relaxes the max-cycle
limit (4x the ZeroNyte default) and you can optionally pass `--thread-mask`
to experiment with different thread enables. Artifacts land under
`tests/output/external/beebs/<benchmark>` with individual logs and signatures
per processor.

### CoreMark workflow

- Clone CoreMark via `tests/external_kernels/clone_all.sh` which places the
  repository under `../external-kernels/coremark`.
- Run `tests/external_kernels/run_coremark.sh` to build and execute the bare
  metal port for Spike and the RTL cores. Example invocations:

```bash
# Single-threaded TetraNyte run (default thread 0)
tests/external_kernels/run_coremark.sh --iterations 1 --processor tetranyte

# Sweep all four hardware threads sequentially
tests/external_kernels/run_coremark.sh --iterations 1 --processor tetranyte --all-threads

# Run on ZeroNyte instead of TetraNyte
tests/external_kernels/run_coremark.sh --processor zeronyte --max-cycles 5000000
```

The script copies the maintained `coremark_port` into the external clone,
builds with the RV32 bare-metal toolchain, captures a Spike reference
signature, and then runs the requested RTL simulator(s). Each TetraNyte run is
rebuilt with a `COREMARK_THREAD_LABEL` tag so the four hardware contexts
produce four distinct signatures. You can either pick a specific
`--thread-mask` (e.g. `0x2` for thread 1) or pass `--all-threads` to iterate
over masks `0x1`, `0x2`, `0x4`, and `0x8` sequentially; each iteration stores
its own Spike and RTL logs/signatures under
`tests/output/external/coremark/<label>/`.

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
