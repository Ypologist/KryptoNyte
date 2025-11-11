# SBT Test Report – 2025‑11‑10

- **Command**
  ```
  XDG_RUNTIME_DIR=/home/kryptonyte/KryptoNyte/.xdg-runtime \
  TMPDIR=/home/kryptonyte/KryptoNyte/.tmp \
  sbt \
    -Dsbt.boot.directory=/home/kryptonyte/KryptoNyte/.sbtboot \
    -Dsbt.global.base=/home/kryptonyte/KryptoNyte/.sbt-global \
    -Dsbt.ivy.home=/home/kryptonyte/KryptoNyte/.ivy2 \
    -Dsbt.coursier.home=/home/kryptonyte/KryptoNyte/.coursier \
    test
  ```
- **Working directory:** `/home/kryptonyte/KryptoNyte/rtl`
- **Start time:** 2025‑11‑10 18:32 UTC (approx.)
- **Total duration:** ~2m13s (per sbt log)

## Outcome

- Build + dependency resolution succeeded after redirecting sbt caches into the repo (avoids sandboxed `$HOME`/`/run/user` paths).
- 8 unit-test suites from the shared library plus the ZeroNyte and TetraNyte core regressions all passed.
- No test failures, cancellations, or pending tests were reported.

## Suite Breakdown

| Module     | Suite/Test                              | Status | Notes |
|------------|-----------------------------------------|--------|-------|
| `library`  | `ALU32Test`                             | ✅ | Arithmetic/logical/shift ops across all opcodes. |
| `library`  | `ALU_LogicTest`                         | ✅ | AND/OR/XOR functional coverage. |
| `library`  | `ALU_CompareTest`                       | ✅ | Signed/unsigned compare ops. |
| `library`  | `ALU_ShiftTest`                         | ✅ | Logical + arithmetic shift behavior. |
| `library`  | `BranchUnitTest`                        | ✅ | Branch condition + target calc. |
| `library`  | `LoadUnitTester`                        | ✅ | Signed/unsigned load path. |
| `library`  | `StoreUnitTest`                         | ✅ | Store path data/address alignment. |
| `library`  | `RegFileMT2R1WVecTest`                  | ✅ | Multi-thread reg-file reads/writes. |
| `ZeroNyte` | `ZeroNyteRV32ICoreTest`                 | ✅ | Fetch/execute trace at 0x8000_0000. |
| `ZeroNyte` | `ZeroNyteRV32IAndTest`                  | ✅ | Focused AND/ANDI regression. |
| `TetraNyte`| `TetraNyteRV32ICoreTest`                | ✅ | 4-thread execution trace (cycles 00–11 shown). |

> sbt emitted multiple “Run completed … All tests passed.” lines while iterating through aggregated projects; no warnings or errors followed once dependency downloads finished.

## Trace Excerpts

- `TetraNyteRV32ICoreTest` logged representative cycles such as:
  - `[Cycle 00][Thread 0] PC: 0x00000014 instr: 0x00000013 …`
  - `[Cycle 05][Thread 1] PC: 0x00000028 instr: 0x00308133 …`
- `ZeroNyteRV32ICoreTest` trace:
  - `[Cycle 00] PC: 0x80000000, Instr: 0x13`
  - `[Cycle 02] PC: 0x80000008, Instr: 0x208133`

## Follow‑ups / Tips

1. Rerun quickly with `sbt "zeroNyteRv32i/test"` or `sbt "tetraNyteRv32i/test"` if you need per-core confirmation only.
2. Capture future logs with `sbt … test | tee tests/reports/sbt-test-$(date +%F-%H%M).log` for archival.

