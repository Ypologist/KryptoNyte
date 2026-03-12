# BEEBS `cnt` Mismatch (Spike vs ZeroNyte)

## Run context
- Script: `tests/external_kernels/run_beebs.sh --benchmark cnt --force-configure`
- Artifacts: `tests/output/external/beebs/cnt/`
- Spike/ZeroNyte share the same ELF built from `../external-kernels/beebs/src/cnt/cnt.c` with the zeronyte instrumentation patch applied.

## Signature comparison
| Slot | Meaning | Spike (`spike.signature`) | ZeroNyte (`zeronyte.signature`) |
| --- | --- | --- | --- |
| `[0]` | `Negtotal` result | `0x00060d83` | `0x9bfb329c` |
| `[1]` | `verify_benchmark` flag | `0x00000001` (pass) | `0x00000000` (fail) |
| `[2]` | Repeat count | `0x00000020` | `0x00000020` |
| `[3]` | Tag | `0xbeeb500d` | `0xbeeb500d` |
| `[4]` | `Seed` (final RNG state) | `0x00001a3b` | `0x03e3effc` |
| `[5]` | `Postotal` | `0x00000000` | `0x88e886b6` |
| `[6]` | `Negtotal` copy | `0x00060d83` | `0x9bfb329c` |
| `[7]` | `Poscnt` | `0x00000000` | `0x00000032` |
| `[8]` | `Negcnt` | `0x00000064` | `0x00000032` |

The counts show ZeroNyte sees 50 positive / 50 negative entries, while Spike sees all 100 values as negative. Seed divergence indicates the pseudo-random sequence itself is wrong, likely due to an arithmetic helper discrepancy (`RandomInteger` uses software `__modsi3`).

## Logs
`tests/output/external/beebs/cnt/zeronyte.log` confirms the core runs through `record_signature` and writes to `tohost`. Control flow is fine; data path diverges.

## Next actions
1. RTL team to inspect arithmetic helper behavior (focus on `__modsi3/__udivsi3` path in the synthesized C library) under ZeroNyte.
2. Once fixed, rerun `tests/external_kernels/run_beebs.sh --benchmark cnt --force-configure` and expect the signature table to match Spike’s reference.
