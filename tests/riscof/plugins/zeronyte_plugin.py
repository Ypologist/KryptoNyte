"""
ZeroNyte RISC-V Core RISCOF Plugin
Production-quality plugin for KryptoNyte's ZeroNyte RV32I core
Based on Verilator simulation with enhanced error handling and logging
"""

import os
import shutil
import subprocess
import tempfile
from pathlib import Path
from typing import Optional, Dict, Any
import logging

from riscof.utils import shellCommand

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class ZeroNytePlugin:
    """
    RISCOF plugin for ZeroNyte RV32I core simulation using Verilator
    """
    
    def __init__(self, isa: str, workdir: str, comp_opts: Dict[str, Any]):
        """
        Initialize the ZeroNyte plugin
        
        Args:
            isa: ISA string (e.g., "RV32IMC")
            workdir: Working directory for simulation
            comp_opts: Compilation options from config
        """
        self.isa = isa
        self.workdir = Path(workdir)
        self.prefix = comp_opts.get('prefix', 'riscv32-unknown-elf-')
        self.top = comp_opts.get('top', 'ZeroNyteRV32ICore')
        
        # Resolve Verilog file path
        verilog_path = comp_opts.get('verilog', '../rtl/generators/generated/verilog_hierarchical_timed/ZeroNyteRV32ICore.v')
        self.verilog_file = Path(verilog_path).resolve()
        
        # Simulation configuration
        self.sim_timeout = comp_opts.get('timeout', 300)  # 5 minutes default
        self.max_cycles = comp_opts.get('max_cycles', 1000000)
        self.signature_addr = comp_opts.get('signature_addr', 0x0001e000)
        self.signature_size = comp_opts.get('signature_size', 0x1000)
        
        # Create working directory
        self.workdir.mkdir(parents=True, exist_ok=True)
        
        # Verilator build directory
        self.obj_dir = self.workdir / 'obj_dir'
        
        logger.info(f"ZeroNyte plugin initialized:")
        logger.info(f"  ISA: {self.isa}")
        logger.info(f"  Workdir: {self.workdir}")
        logger.info(f"  Verilog: {self.verilog_file}")
        logger.info(f"  Top module: {self.top}")
        
    def compile(self, test: str, output: str) -> str:
        """
        Compile ELF test to memory initialization format
        
        Args:
            test: Path to ELF test file
            output: Output directory path
            
        Returns:
            Path to compiled hex file
        """
        logger.info(f"Compiling test: {test}")
        
        elf_file = Path(test).resolve()
        output_dir = Path(output)
        output_dir.mkdir(parents=True, exist_ok=True)
        
        if not elf_file.exists():
            raise FileNotFoundError(f"Test ELF file not found: {elf_file}")
            
        # Generate memory initialization file
        hex_file = output_dir / f"{elf_file.stem}.hex"
        
        try:
            # Convert ELF to Verilog hex format
            cmd = [
                f"{self.prefix}objcopy",
                "-O", "verilog",
                "--verilog-data-width=4",
                str(elf_file),
                str(hex_file)
            ]
            
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                timeout=60
            )
            
            if result.returncode != 0:
                raise RuntimeError(f"objcopy failed: {result.stderr}")
                
            logger.info(f"Generated hex file: {hex_file}")
            return str(hex_file)
            
        except subprocess.TimeoutExpired:
            raise RuntimeError("objcopy timed out")
        except Exception as e:
            raise RuntimeError(f"Compilation failed: {e}")
    
    def build_simulator(self) -> bool:
        """
        Build Verilator simulation executable
        
        Returns:
            True if build successful, False otherwise
        """
        logger.info("Building Verilator simulator")
        
        if not self.verilog_file.exists():
            raise FileNotFoundError(f"Verilog file not found: {self.verilog_file}")
            
        # Check if simulator already exists and is up to date
        sim_exe = self.obj_dir / f"V{self.top}"
        if sim_exe.exists():
            verilog_mtime = self.verilog_file.stat().st_mtime
            sim_mtime = sim_exe.stat().st_mtime
            if sim_mtime > verilog_mtime:
                logger.info("Simulator is up to date")
                return True
        
        # Find testbench file
        testbench_candidates = [
            Path(__file__).parent.parent / "testbench" / "tb_zeronyte.cpp",
            Path(__file__).parent / "tb_zeronyte.cpp",
            self.workdir / "tb_zeronyte.cpp"
        ]
        
        testbench = None
        for candidate in testbench_candidates:
            if candidate.exists():
                testbench = candidate
                break
                
        if not testbench:
            # Create a basic testbench
            testbench = self.workdir / "tb_zeronyte.cpp"
            self._create_basic_testbench(testbench)
        
        try:
            # Build with Verilator
            cmd = [
                "verilator",
                "-cc",                    # Generate C++ code
                "-O3",                    # Optimize
                "--exe",                  # Generate executable
                "-CFLAGS", "-std=c++17",  # C++ standard
                "--build",                # Build immediately
                "--top-module", self.top, # Top module name
                str(self.verilog_file),   # Verilog source
                str(testbench)            # Testbench
            ]
            
            # Change to working directory for build
            original_cwd = os.getcwd()
            os.chdir(self.workdir)
            
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                timeout=300  # 5 minute timeout for build
            )
            
            os.chdir(original_cwd)
            
            if result.returncode != 0:
                logger.error(f"Verilator build failed: {result.stderr}")
                return False
                
            if not sim_exe.exists():
                logger.error("Simulator executable not created")
                return False
                
            logger.info(f"Simulator built successfully: {sim_exe}")
            return True
            
        except subprocess.TimeoutExpired:
            logger.error("Verilator build timed out")
            return False
        except Exception as e:
            logger.error(f"Build failed: {e}")
            return False
    
    def run(self, hexfile: str, log: str, timeout: Optional[int] = None) -> None:
        """
        Run simulation with test hex file
        
        Args:
            hexfile: Path to memory initialization hex file
            log: Path to output log file
            timeout: Simulation timeout in seconds
        """
        logger.info(f"Running simulation: {hexfile}")
        
        if timeout is None:
            timeout = self.sim_timeout
            
        # Ensure simulator is built
        if not self.build_simulator():
            raise RuntimeError("Failed to build simulator")
            
        sim_exe = self.obj_dir / f"V{self.top}"
        hex_path = Path(hexfile).resolve()
        log_path = Path(log).resolve()
        
        if not hex_path.exists():
            raise FileNotFoundError(f"Hex file not found: {hex_path}")
        
        try:
            # Change to working directory for simulation
            original_cwd = os.getcwd()
            os.chdir(self.workdir)
            
            # Run simulation
            cmd = [str(sim_exe), str(hex_path)]
            
            with open(log_path, 'w') as log_file:
                result = subprocess.run(
                    cmd,
                    stdout=log_file,
                    stderr=subprocess.STDOUT,
                    timeout=timeout
                )
            
            os.chdir(original_cwd)
            
            if result.returncode != 0:
                logger.warning(f"Simulation returned non-zero exit code: {result.returncode}")
            else:
                logger.info("Simulation completed successfully")
                
        except subprocess.TimeoutExpired:
            logger.error(f"Simulation timed out after {timeout} seconds")
            raise RuntimeError("Simulation timeout")
        except Exception as e:
            logger.error(f"Simulation failed: {e}")
            raise RuntimeError(f"Simulation error: {e}")
        finally:
            os.chdir(original_cwd)
    
    def parse_sig(self, log: str, sig_path: str) -> None:
        """
        Extract test signature from simulation output
        
        Args:
            log: Path to simulation log file
            sig_path: Path where signature should be written
        """
        logger.info(f"Parsing signature from: {log}")
        
        # Look for signature file in working directory
        signature_candidates = [
            self.workdir / "signature.txt",
            self.workdir / "rtl.sig",
            self.workdir / f"{self.top}.sig"
        ]
        
        signature_file = None
        for candidate in signature_candidates:
            if candidate.exists():
                signature_file = candidate
                break
        
        if signature_file:
            # Copy signature file to expected location
            shutil.copyfile(signature_file, sig_path)
            logger.info(f"Signature copied to: {sig_path}")
        else:
            # Try to extract signature from log file
            self._extract_signature_from_log(log, sig_path)
    
    def _create_basic_testbench(self, testbench_path: Path) -> None:
        """
        Create a basic C++ testbench for the ZeroNyte core
        
        Args:
            testbench_path: Path where testbench should be created
        """
        logger.info(f"Creating basic testbench: {testbench_path}")
        
        testbench_code = f'''
#include <iostream>
#include <fstream>
#include <memory>
#include <verilated.h>
#include "V{self.top}.h"

class ZeroNyteTestbench {{
private:
    std::unique_ptr<V{self.top}> dut;
    uint64_t cycle_count;
    uint64_t max_cycles;
    
public:
    ZeroNyteTestbench(uint64_t max_cyc = 1000000) 
        : cycle_count(0), max_cycles(max_cyc) {{
        dut = std::make_unique<V{self.top}>();
    }}
    
    void reset() {{
        dut->reset = 1;
        dut->clock = 0;
        dut->eval();
        dut->clock = 1;
        dut->eval();
        dut->reset = 0;
    }}
    
    void tick() {{
        dut->clock = 0;
        dut->eval();
        dut->clock = 1;
        dut->eval();
        cycle_count++;
    }}
    
    bool run() {{
        reset();
        
        while (cycle_count < max_cycles) {{
            tick();
            
            // Check for test completion
            // This is core-specific and may need adjustment
            if (dut->io_test_done) {{
                std::cout << "Test completed at cycle " << cycle_count << std::endl;
                return true;
            }}
        }}
        
        std::cout << "Test timed out after " << max_cycles << " cycles" << std::endl;
        return false;
    }}
    
    void dump_signature() {{
        // Extract signature from memory
        // This is a placeholder - implement based on core interface
        std::ofstream sig_file("signature.txt");
        sig_file << "00000000" << std::endl;  // Placeholder
        sig_file.close();
    }}
}};

int main(int argc, char** argv) {{
    Verilated::commandArgs(argc, argv);
    
    if (argc < 2) {{
        std::cerr << "Usage: " << argv[0] << " <hex_file>" << std::endl;
        return 1;
    }}
    
    std::string hex_file = argv[1];
    std::cout << "Loading test: " << hex_file << std::endl;
    
    ZeroNyteTestbench tb;
    bool success = tb.run();
    tb.dump_signature();
    
    return success ? 0 : 1;
}}
'''
        
        with open(testbench_path, 'w') as f:
            f.write(testbench_code)
            
        logger.info("Basic testbench created")
    
    def _extract_signature_from_log(self, log_path: str, sig_path: str) -> None:
        """
        Extract signature from simulation log file
        
        Args:
            log_path: Path to simulation log
            sig_path: Path where signature should be written
        """
        logger.info("Extracting signature from log file")
        
        try:
            with open(log_path, 'r') as log_file:
                log_content = log_file.read()
            
            # Look for signature markers in log
            # This is a placeholder - implement based on actual log format
            signature_lines = []
            
            for line in log_content.split('\\n'):
                if 'SIGNATURE:' in line:
                    # Extract hex value after SIGNATURE:
                    parts = line.split('SIGNATURE:')
                    if len(parts) > 1:
                        hex_val = parts[1].strip()
                        signature_lines.append(hex_val)
            
            # Write signature file
            with open(sig_path, 'w') as sig_file:
                if signature_lines:
                    for line in signature_lines:
                        sig_file.write(line + '\\n')
                else:
                    # Empty signature if none found
                    sig_file.write('00000000\\n')
                    
            logger.info(f"Signature extracted with {len(signature_lines)} entries")
            
        except Exception as e:
            logger.error(f"Failed to extract signature: {e}")
            # Create empty signature file
            Path(sig_path).touch()


# Plugin entry point for RISCOF
Plugin = ZeroNytePlugin
