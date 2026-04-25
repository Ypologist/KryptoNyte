import re
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
NETLIST = REPO_ROOT / ".venv/physical_design/runs/TetraNyteRV32ICore/runs/RUN_2026-03-18_20-41-08/20-openroad-ioplacement/TetraNyteRV32ICore.nl.v"

with open(NETLIST) as f:
    count = 0
    for line in f:
        if "sky130_fd_sc_hd__df" in line:
            print(line.strip())
            count += 1
            if count >= 30:
                break
