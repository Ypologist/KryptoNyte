# Physical Design

This directory contains tools and scripts for the physical design flow (RTL-to-GDSII) using OpenLane2.

## Contents

- `generate_physical_design.sh` - Main physical design flow script
- `runs/` - OpenLane2 run directories (created during execution)
- `reports/` - Design reports and logs (created during execution)

## Usage

```bash
cd physical_design
./generate_physical_design.sh --module-name ZeroNyteRV32ICore
```

## Requirements

- OpenLane2 installed at `/opt/skywater-pdk/openlane2`
- Nix package manager with nixpkgs channel
- Generated RTL files in `../rtl/generators/generated/verilog_hierarchical_timed/`

See the main project documentation for installation instructions.
