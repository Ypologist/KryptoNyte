import odb
import time
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
ODB_PATH = REPO_ROOT / ".venv/physical_design/runs/TetraNyteRV32ICore/runs/RUN_2026-03-18_20-41-08/20-openroad-ioplacement/TetraNyteRV32ICore.odb"

try:
    print("Loading DB...")
    db = odb.dbDatabase.create()
    odb.read_db(db, str(ODB_PATH))
    block = db.getChip().getBlock()
    
    match_regFile = 0
    match_fetch = 0
    match_decode = 0
    match_alu = 0
    
    sample_names = []
    
    for inst in block.getInsts():
        name = inst.getName()
        if len(sample_names) < 20:
            sample_names.append(name)
            
        if "regFile" in name:
            match_regFile += 1
        if "pcRegs" in name or "if_id" in name:
            match_fetch += 1
        if "id_ex" in name:
            match_decode += 1
        if "alu" in name:
            match_alu += 1
            
    print(f"Matched regFile: {match_regFile}")
    print(f"Matched fetch (pcRegs/if_id): {match_fetch}")
    print(f"Matched decode (id_ex): {match_decode}")
    print(f"Matched exec (alu): {match_alu}")
    print("Sample instance names:")
    for n in sample_names:
        print(" ", n)
except Exception as e:
    import traceback
    traceback.print_exc()
