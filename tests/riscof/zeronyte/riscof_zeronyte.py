"""
ZeroNyte RISC-V Core Plugin for RISCOF
Production-quality DUT plugin for KryptoNyte's ZeroNyte RV32I core
"""

import os
import re
import shutil
import subprocess
import shlex
import logging
import random
import string
from string import Template
import sys
from pathlib import Path

import riscof.utils as utils
import riscof.constants as constants
from riscof.pluginTemplate import pluginTemplate

logger = logging.getLogger()

class zeronyte(pluginTemplate):
    __model__ = "zeronyte"
    __version__ = "1.0.0"

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        config = kwargs.get('config')

        # If the config node for this DUT is missing or empty. Raise an error. At minimum we need
        # the paths to the ispec and pspec files
        if config is None:
            print("Please enter input file paths in configuration.")
            raise SystemExit(1)

        # Extract the paths to the ispec and pspec files
        self.isa_spec = os.path.abspath(config['ispec'])
        self.platform_spec = os.path.abspath(config['pspec'])

        # Collect the paths to the plugins
        self.pluginpath = os.path.abspath(config['pluginpath'])

        # Get RTL and toolchain paths
        self.kryptonyte_root = os.environ.get('KRYPTONYTE_ROOT', os.path.abspath('../..'))
        self.rtl_file = os.path.join(self.kryptonyte_root, 
                                   'rtl/generators/generated/verilog_hierarchical_timed/ZeroNyteRV32ICore.v')
        
        # RISC-V toolchain configuration - auto-detect
        try:
            self.prefix = self._find_riscv_prefix()
        except RuntimeError:
            # Fallback to default path
            self.prefix = "/opt/riscv/collab/bin/riscv32-unknown-elf-"
        
        # Verilator configuration
        self.verilator_cmd = 'verilator'
        self.verilator_args = [
            '--cc',
            '--exe',
            '--build',
            '--top-module', 'ZeroNyteRV32ICore',
            '-O3',
            '--x-assign', 'fast',
            '--x-initial', 'fast',
            '--noassert',
            '--trace',
            '-Wno-UNOPTFLAT'
        ]

        logger.info(f"ZeroNyte plugin initialized")
        logger.info(f"RTL file: {self.rtl_file}")
        logger.info(f"Toolchain prefix: {self.prefix}")
        logger.info(f"Expected GCC location: {self.prefix}gcc")

    def _find_riscv_prefix(self):
        """Find the appropriate RISC-V toolchain prefix"""
        # Check common installation paths
        common_paths = [
            "/opt/riscv/collab/bin/",
            "/opt/riscv/bin/", 
            "/usr/bin/",
            "/usr/local/bin/"
        ]
        
        prefixes = [
            'riscv32-unknown-elf-',
            'riscv64-unknown-elf-',
            'riscv32-unknown-linux-gnu-',
            'riscv64-unknown-linux-gnu-'
        ]
        
        # First try the paths with prefixes
        for path in common_paths:
            for prefix in prefixes:
                full_path = f"{path}{prefix}"
                if os.path.exists(f"{full_path}gcc"):
                    return full_path
        
        # Fallback to system PATH
        for prefix in prefixes:
            if shutil.which(f"{prefix}gcc"):
                return prefix
                
        raise RuntimeError("No RISC-V toolchain found. Please install riscv-gnu-toolchain.")

    def initialise(self, suite, work_dir, archtest_env):
        """Initialize the plugin for a test suite"""
        self.suite = suite
        self.work_dir = work_dir
        self.archtest_env = archtest_env
        
        # Create work directory structure
        self.objdir = os.path.join(work_dir, 'zeronyte_work')
        os.makedirs(self.objdir, exist_ok=True)
        
        logger.info(f"ZeroNyte plugin initialized for suite: {suite}")

    def build(self, isa_yaml, platform_yaml):
        """Build the DUT (compile RTL if needed)"""
        logger.info("Building ZeroNyte DUT")
        
        # Check if RISC-V toolchain is available
        if not shutil.which(f"{self.prefix}gcc"):
            logger.error(f"RISC-V toolchain not found: {self.prefix}gcc")
            logger.info("Please install the RISC-V toolchain using:")
            logger.info(".devcontainer/install_riscv_conformance_tests.sh --with-sudo")
            return False
        
        # Check if RTL file exists
        if not os.path.exists(self.rtl_file):
            logger.warning(f"RTL file not found: {self.rtl_file}")
            logger.info("You may need to generate RTL first using:")
            logger.info("cd rtl && sbt 'runMain generators.GenerateHierarchicalRTL'")
            return False
            
        # Check if Verilator is available
        if not shutil.which(self.verilator_cmd):
            logger.error(f"Verilator not found: {self.verilator_cmd}")
            logger.info("Please install Verilator: sudo apt-get install verilator")
            return False
            
        logger.info("ZeroNyte DUT build completed")
        return True

    def runTests(self, testList):
        """Run tests on the ZeroNyte core"""
        logger.info(f"Running {len(testList)} tests on ZeroNyte")
        
        for testname in testList:
            logger.info(f"Running test: {testname}")
            
            # Get test details
            testentry = testList[testname]
            test_path = testentry['test_path']
            test_dir = testentry['work_dir']
            base_test_name = os.path.basename(test_path).replace('.S', '')
            
            # Create test-specific directory
            os.makedirs(test_dir, exist_ok=True)
            
            try:
                # Compile the test
                elf_file = self._compile_test(test_path, test_dir)
                
                # Convert to hex format
                hex_file = self._elf_to_hex(elf_file, test_dir)
                
                # Create Verilator testbench
                tb_file = self._create_testbench(hex_file, test_dir, base_test_name)
                
                # Run simulation
                self._run_simulation(tb_file, test_dir, base_test_name, hex_file)
                
                # Create dut directory
                dut_dir = os.path.join(test_dir, 'dut')
                os.makedirs(dut_dir, exist_ok=True)

                # Handle signature file
                tb_sig_file = os.path.join(test_dir, f"{base_test_name}.signature")
                dut_sig_file = os.path.join(dut_dir, 'DUT-zeronyte.signature')
                if os.path.exists(tb_sig_file):
                    shutil.copy(tb_sig_file, dut_sig_file)
                else:
                    with open(dut_sig_file, 'w') as f:
                        f.write("# Test failed to generate signature\n")

                logger.info(f"Test {testname} completed successfully")
                
            except Exception as e:
                logger.error(f"Test {testname} failed: {str(e)}")
                # Create empty signature file to indicate failure
                dut_dir = os.path.join(test_dir, 'dut')
                os.makedirs(dut_dir, exist_ok=True)
                dut_sig_file = os.path.join(dut_dir, 'DUT-zeronyte.signature')
                with open(dut_sig_file, 'w') as f:
                    f.write(f"# Test failed with exception: {e}\n")

    def _compile_test(self, test_path, work_dir):
        """Compile test to ELF format"""
        test_name = os.path.basename(test_path).replace('.S', '')
        elf_file = os.path.join(work_dir, f"{test_name}.elf")
        
        # Use our local environment directory which contains working arch_test.h
        # This avoids the problematic system arch_test.h that has macro expansion issues
        
        # Compilation command with assembler flags to handle macros
        cmd = [
            f"{self.prefix}gcc",
            "-march=rv32imc",  # Enable compressed instructions for compatibility
            "-DXLEN=32",
            "-mabi=ilp32",
            "-static",
            "-mcmodel=medany",
            "-fvisibility=hidden",
            "-nostdlib",
            "-nostartfiles",
            "-Wa,-march=rv32imc",  # Pass march to assembler
            "-Wa,--no-warn",       # Suppress assembler warnings
            f"-T{self.archtest_env}/link.ld",
            f"-I{self.archtest_env}",  # Our local environment with working arch_test.h, model_test.h, and link.ld
            "-DRVTEST_E=1",        # Define test environment
            "-o", elf_file,
            test_path
        ]
        
        logger.debug(f"Compiling: {' '.join(cmd)}")
        result = subprocess.run(cmd, capture_output=True, text=True)
        
        if result.returncode != 0:
            raise RuntimeError(f"Compilation failed: {result.stderr}")
            
        return elf_file

    def _elf_to_hex(self, elf_file, work_dir):
        """Convert ELF to Verilog hex format"""
        hex_file = elf_file.replace('.elf', '.hex')
        
        cmd = [
            f"{self.prefix}objcopy",
            "-O", "verilog",
            "--verilog-data-width=4",
            elf_file,
            hex_file
        ]
        
        logger.debug(f"Converting to hex: {' '.join(cmd)}")
        result = subprocess.run(cmd, capture_output=True, text=True)
        
        if result.returncode != 0:
            raise RuntimeError(f"ELF to hex conversion failed: {result.stderr}")
            
        return hex_file

    def _create_testbench(self, hex_file, work_dir, test_name):
        """Create Verilator testbench for the test"""
        tb_file = os.path.join(work_dir, f"{test_name}_tb.cpp")
        
        # Correctly escape C++ curly braces in f-string
        testbench_code = f'''
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "VZeroNyteRV32ICore.h"
#include <iostream>
#include <fstream>
#include <iomanip>
#include <vector>

#define MAX_CYCLES 1000000
#define MEM_BASE 0x80000000
#define SIGNATURE_START 0x80001000
#define SIGNATURE_END   0x80002000

int main(int argc, char** argv) {{ 
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);
    
    VZeroNyteRV32ICore* dut = new VZeroNyteRV32ICore;
    VerilatedVcdC* tfp = new VerilatedVcdC;

    // Simulated Memory
    std::vector<uint32_t> mem(1 << 22, 0);
    if (argc > 1) {{
        std::ifstream hex_file(argv[1]);
        std::string line;
        uint32_t addr = MEM_BASE;
        while (std::getline(hex_file, line)) {{
            if (line[0] == '@') {{
                addr = std::stoul(line.substr(1), nullptr, 16) * 4;
            }} else {{
                mem[(addr - MEM_BASE) / 4] = std::stoul(line, nullptr, 16);
                addr += 4;
            }}
        }}
    }}

    dut->trace(tfp, 99);
    tfp->open("{test_name}.vcd");
    
    // Initialize
    dut->clock = 0;
    dut->reset = 1;
    
    // Reset sequence
    for (int i = 0; i < 10; i++) {{
        dut->clock = 0;
        dut->eval();
        tfp->dump(2*i);
        dut->clock = 1;
        dut->eval();
        tfp->dump(2*i+1);
    }}
    
    dut->reset = 0;
    
    // Run simulation
    for (int cycle = 0; cycle < MAX_CYCLES; cycle++) {{
        dut->clock = 0;
        dut->eval();
        tfp->dump(2*cycle + 20);

        // Memory Read
        if ((dut->io_imem_addr - MEM_BASE) / 4 >= mem.size()) {{
            std::cout << "imem out of bounds: " << std::hex << dut->io_imem_addr << std::endl;
            exit(1);
        }}
        dut->io_imem_rdata = mem[(dut->io_imem_addr - MEM_BASE) / 4];

        if ((dut->io_dmem_addr - MEM_BASE) / 4 >= mem.size()) {{
            std::cout << "dmem out of bounds: " << std::hex << dut->io_dmem_addr << std::endl;
            exit(1);
        }}
        dut->io_dmem_rdata = mem[(dut->io_dmem_addr - MEM_BASE) / 4];
        
        dut->clock = 1;
        dut->eval();
        tfp->dump(2*cycle + 21);

        // Memory Write
        if (dut->io_dmem_wen) {{
            mem[(dut->io_dmem_addr - MEM_BASE) / 4] = dut->io_dmem_wdata;
        }}

        // Standard test completion check
        if (mem[(SIGNATURE_START - MEM_BASE) / 4] == 1) {{
            break;
        }}
    }}
    
    // Extract signature
    std::ofstream sig_file("{test_name}.signature");
    for (uint32_t i = SIGNATURE_START; i < SIGNATURE_END; i += 4) {{
        sig_file << std::hex << std::setw(8) << std::setfill('0') << mem[(i - MEM_BASE) / 4] << std::endl;
    }}
    sig_file.close();
    
    tfp->close();
    delete dut;
    delete tfp;
    
    return 0;
}}
'''
        
        with open(tb_file, 'w') as f:
            f.write(testbench_code)
            
        return tb_file

    def _run_simulation(self, tb_file, test_dir, test_name, hex_file):
        """Run Verilator simulation"""
        # Copy RTL file to work directory
        local_rtl = os.path.join(test_dir, 'ZeroNyteRV32ICore.v')
        shutil.copy2(self.rtl_file, local_rtl)
        
        # Build with Verilator
        cmd = [self.verilator_cmd] + self.verilator_args + [
            '-CFLAGS', '-std=c++14',
            '--Mdir', os.path.join(test_dir, 'obj_dir'),
            local_rtl,
            tb_file
        ]
        
        logger.debug(f"Verilator build: {' '.join(cmd)}")
        result = subprocess.run(cmd, cwd=test_dir, capture_output=True, text=True)

        
        if result.returncode != 0:
            raise RuntimeError(f"Verilator build failed: {result.stderr}")
        
        # Run simulation
        sim_exe = os.path.join(test_dir, 'obj_dir', f'V{os.path.basename(local_rtl).replace(".v", "")}')
        if os.path.exists(sim_exe):
            logger.debug(f"Running simulation: {sim_exe}")
            log_file = os.path.join(test_dir, f"{test_name}.log")
            with open(log_file, "w") as f:
                result = subprocess.run([sim_exe, hex_file], cwd=test_dir, stdout=f, stderr=f, text=True, timeout=60)



            
            if result.returncode != 0:
                logger.warning(f"Simulation returned non-zero exit code: {result.returncode}")
                logger.debug(f"Simulation output: {result.stdout}")
                logger.debug(f"Simulation errors: {result.stderr}")
        else:
            raise RuntimeError(f"Simulation executable not found: {sim_exe}")

    def _extract_signature(self, test_dir, test_name):
        """Extract test signature from simulation results"""
        # This is a simplified signature extraction
        # Real implementation would parse memory dumps or VCD files
        
        sig_file = os.path.join(test_dir, f"{test_name}.signature")
        if not os.path.exists(sig_file):
            # Create a basic signature file
            with open(sig_file, 'w') as f:
                f.write("# ZeroNyte test signature\\n")
                f.write("# Generated by ZeroNyte RISCOF plugin\\n")
                f.write("00000000\\n")  # Placeholder signature
        
        logger.debug(f"Signature extracted to: {sig_file}")
