import odb
import sys
import time
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
ODB_PATH = REPO_ROOT / ".venv/physical_design/runs/TetraNyteRV32ICore/runs/RUN_2026-03-18_20-41-08/20-openroad-ioplacement/TetraNyteRV32ICore.odb"

try:
    print("Loading DB...")
    t0 = time.time()
    db = odb.dbDatabase.create()
    odb.read_db(db, str(ODB_PATH))
    block = db.getChip().getBlock()
    print(f"DB loaded in {time.time()-t0:.2f}s")
    
    t0 = time.time()
    insts = block.getInsts()
    print(f"Got {len(insts)} insts in {time.time()-t0:.2f}s")
    
    match_count = 0
    t0 = time.time()
    for inst in insts:
        name = inst.getName()
        if "pcRegs" in name:
            match_count += 1
    print(f"Matched {match_count} insts in {time.time()-t0:.2f}s")
except Exception as e:
    import traceback
    traceback.print_exc()
