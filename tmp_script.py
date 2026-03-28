import os

def copy_and_replace(src_file, dst_file, replacements):
    with open(src_file, 'r') as f:
        text = f.read()
    for old, new in replacements.items():
        text = text.replace(old, new)
    with open(dst_file, 'w') as f:
        f.write(text)

# Set base paths
b_path = '/home/jglossner/KryptoNyte/tests/sim/'
r_path = '/home/jglossner/KryptoNyte/tests/riscof/'

# Create RISCOF dirs
os.makedirs(f'{r_path}tetranyte_im', exist_ok=True)
os.makedirs(f'{r_path}tetranyte_zmmul', exist_ok=True)


### TETRANYTE IM ###
# SIM
copy_and_replace(f'{b_path}tetranyte_sim.cpp', f'{b_path}tetranyte_im_sim.cpp', {'TetraNyteRV32ICore': 'TetraNyteRV32IMCore', 'tetranyte_sim': 'tetranyte_im_sim'})
copy_and_replace(f'{b_path}build_tetranyte_sim.sh', f'{b_path}build_tetranyte_im_sim.sh', {'TetraNyteRV32ICore': 'TetraNyteRV32IMCore', 'generateTetraNyteRTL': 'generateTetraNyteIMRTL', 'tetranyte_obj': 'tetranyte_im_obj', 'tetranyte_sim': 'tetranyte_im_sim'})
os.chmod(f'{b_path}build_tetranyte_im_sim.sh', 0o755)

# RISCOF
copy_and_replace(f'{r_path}tetranyte/riscof_tetranyte.py', f'{r_path}tetranyte_im/riscof_tetranyte_im.py', {'tetranyte': 'tetranyte_im', 'TetraNyte_Plugin': 'TetraNyte_Im_Plugin'})
# For the ISA yaml, just swap the target architecture natively
copy_and_replace(f'{r_path}tetranyte/tetranyte_isa.yaml', f'{r_path}tetranyte_im/tetranyte_im_isa.yaml', {'ISA: RV32I': 'ISA: RV32IM'})
copy_and_replace(f'{r_path}tetranyte/tetranyte_platform.yaml', f'{r_path}tetranyte_im/tetranyte_im_platform.yaml', {})


### TETRANYTE ZMMUL ###
# SIM
copy_and_replace(f'{b_path}tetranyte_sim.cpp', f'{b_path}tetranyte_zmmul_sim.cpp', {'TetraNyteRV32ICore': 'TetraNyteRV32IZmmulCore', 'tetranyte_sim': 'tetranyte_zmmul_sim'})
copy_and_replace(f'{b_path}build_tetranyte_sim.sh', f'{b_path}build_tetranyte_zmmul_sim.sh', {'TetraNyteRV32ICore': 'TetraNyteRV32IZmmulCore', 'generateTetraNyteRTL': 'generateTetraNyteZmmulRTL', 'tetranyte_obj': 'tetranyte_zmmul_obj', 'tetranyte_sim': 'tetranyte_zmmul_sim'})
os.chmod(f'{b_path}build_tetranyte_zmmul_sim.sh', 0o755)

# RISCOF
copy_and_replace(f'{r_path}tetranyte/riscof_tetranyte.py', f'{r_path}tetranyte_zmmul/riscof_tetranyte_zmmul.py', {'tetranyte': 'tetranyte_zmmul', 'TetraNyte_Plugin': 'TetraNyte_Zmmul_Plugin'})
copy_and_replace(f'{r_path}tetranyte/tetranyte_isa.yaml', f'{r_path}tetranyte_zmmul/tetranyte_zmmul_isa.yaml', {'ISA: RV32I': 'ISA: RV32IZmmul'})
copy_and_replace(f'{r_path}tetranyte/tetranyte_platform.yaml', f'{r_path}tetranyte_zmmul/tetranyte_zmmul_platform.yaml', {})
