# ZeroNyte SBT Test Report – 2025‑11‑10

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

- SBT resolved dependencies using repo-local caches; build completed without warnings after the initial download.
- ZeroNyte RV32I top-level regressions all passed within the aggregated `sbt test` run.
- Coverage: core pipeline regression plus the focused AND/ANDI instruction sweep.

## ZeroNyte Suite Breakdown

| Suite/Test               | Status | Notes |
|--------------------------|--------|-------|
| `ZeroNyteRV32ICoreTest`  | ✅ | Instruction fetch/execute trace beginning at `0x8000_0000`. |
| `ZeroNyteRV32IAndTest`   | ✅ | Validates AND/ANDI logical behavior and register writes. |

> sbt reported “Run completed … All tests passed.” for both suites with no pending or ignored tests.

## Trace Excerpts

- `[Cycle 00] PC: 0x80000000, Instr: 0x13`
- `[Cycle 01] PC: 0x80000004, Instr: 0x100093`
- `[Cycle 02] PC: 0x80000008, Instr: 0x208133`

## Follow‑ups / Tips

1. Re-run ZeroNyte-only suites with: `sbt "zeroNyteRv32i/test"`.
2. Persist complete console logs via `sbt "zeroNyteRv32i/test" | tee tests/reports/zeronyte-test-$(date +%F-%H%M).log`.

