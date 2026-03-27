import re
with open("/tmp/kryptonyte_openlane_jglossner/runs/TetraNyteRV32ICore/runs/RUN_2026-03-18_20-41-08/20-openroad-ioplacement/TetraNyteRV32ICore.nl.v") as f:
    named_count = 0
    numeric_count = 0
    matched_regfile = 0
    pattern = re.compile(r'sky130_fd_sc_hd__dfxtp[^ ]*\s+([^ ]+)\s*\(')
    for line in f:
        match = pattern.search(line)
        if match:
            name = match.group(1)
            if re.match(r'^_\d+_$', name):
                numeric_count += 1
            else:
                named_count += 1
                if "regFile" in name:
                    matched_regfile += 1
                if named_count <= 20:
                    print(name)
    print(f"Numeric flops: {numeric_count}")
    print(f"Named flops: {named_count}")
    print(f"Flops containing 'regFile': {matched_regfile}")
