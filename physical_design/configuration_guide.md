# Physical Design Config Basics

## Files
- `config.base.json` – shared defaults for Sky130A/`sky130_fd_sc_hd`.
- `config.ZeroNyteRV32ICore.json` – full-timing settings for the core.
- `config.ZeroNyteRV32ICore_relaxed.json` – looser timing/area to converge faster.
- `config.template.json` – optional starting point when creating new modules.
- `/tmp/kryptonyte_openlane_$USER/` – default generated output from the OpenLane2 flow.

## Running the Flow
```bash
cd physical_design
./generate_physical_design.sh               # Uses config.ZeroNyteRV32ICore.json
./generate_physical_design.sh --config-module config.ZeroNyteRV32ICore_relaxed.json
./generate_physical_design.sh --output-root _runs  # Keep artifacts in repo instead of /tmp
./generate_physical_design.sh --use-sudo   # Useful if nix daemon socket needs root/group access
```
The script copies RTL from `../rtl/generators/generated/verilog_hierarchical_timed/` and writes the merged `config.json` under `/tmp/kryptonyte_openlane_$USER/runs/<module>/` by default before launching OpenLane2 via `nix-shell <openlane2>/shell.nix`.

## Fast Debug Profile
Use `config.ZeroNyteRV32ICore_relaxed.json` for a full-stage run with relaxed physical/timing targets. It intentionally:
- explicitly enables the previously skipped Classic flow stages (routing, extraction, streamout, DRC, LVS, and final checkers),
- increases clock period and lowers utilization/density,
- increases routing closure effort (`DRT_OPT_ITERS=64`) and enables stronger antenna mitigation (`RUN_HEURISTIC_DIODE_INSERTION=true`, `DIODE_ON_PORTS=both`).

This profile is for bring-up and integration debugging only; do not use it for final tapeout-quality closure.

## How Configs Merge
`generate_physical_design.sh` loads `config.base.json` and the chosen module config, merges them with `jq`, then passes the merged JSON directly to OpenLane2. Module settings win on conflicts. You can point to a different base or module JSON with `--config-base` and `--config-module`.

## Useful Command-Line Overrides
`--module-name`, `--clock-period <ns>`, `--utilization <ratio>`, `--output-root <dir>`, and `--openlane2-path <path>` adjust the environment before the merge. Provide a custom JSON if you need additional fields.

## Requirements & Tips
- `jq`, `nix-shell`, and an OpenLane2 checkout (default `/opt/skywater-pdk/openlane2`).
- Ensure the target RTL exists; otherwise the script aborts.
- Place SDC files under `physical_design/constraints/`; they are copied into each run directory automatically.
- The script exports `NIX_BUILD_SHELL` to avoid `<nixpkgs>.bashInteractive` lookup warnings when channels/NIX_PATH are not configured.
