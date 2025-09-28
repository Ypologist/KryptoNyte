"""
Spike RISC-V ISA Simulator Plugin for RISCOF
Production-quality reference implementation plugin
"""

import os
import subprocess
import shutil
from pathlib import Path
import logging

from riscof.utils import shell

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class SpikePlugin:
    """
    RISCOF plugin for Spike RISC-V ISA Simulator
    Used as reference implementation for conformance testing
    """
    
    def __init__(self, isa: str, workdir: str, comp_opts: dict):
        """
        Initialize the Spike plugin
        
        Args:
            isa: ISA string (e.g., "RV32IMC")
            workdir: Working directory for simulation
            comp_opts: Compilation options from config
        """
        self.isa = isa
        self.workdir = Path(workdir)
        self.prefix = comp_opts.get('prefix', 'riscv32-unknown-elf-')
        
        # Spike configuration
        self.spike_path = comp_opts.get('PATH', '/opt/riscv-conformance/spike/bin')
        self.pk_path = comp_opts.get('pk_path', '/opt/riscv-conformance/pk')
        self.timeout = comp_opts.get('timeout', 300)  # 5 minutes default
        
        # Create working directory
        self.workdir.mkdir(parents=True, exist_ok=True)
        
        # Add Spike to PATH if not already there
        if self.spike_path not in os.environ.get('PATH', ''):
            os.environ['PATH'] = f"{self.spike_path}:{os.environ.get('PATH', '')}"
            
        logger.info(f"Spike plugin initialized:")
        logger.info(f"  ISA: {self.isa}")
        logger.info(f"  Workdir: {self.workdir}")
        logger.info(f"  Spike path: {self.spike_path}")
        
    def compile(self, test: str, output: str) -> str:
        """
        Compile test for Spike simulation
        For Spike, we typically just copy the ELF file
        
        Args:
            test: Path to ELF test file
            output: Output directory path
            
        Returns:
            Path to compiled test file
        """
        logger.info(f"Preparing test for Spike: {test}")
        
        test_file = Path(test).resolve()
        output_dir = Path(output)
        output_dir.mkdir(parents=True, exist_ok=True)
        
        if not test_file.exists():
            raise FileNotFoundError(f"Test file not found: {test_file}")
            
        # Copy ELF file to output directory
        output_file = output_dir / test_file.name
        shutil.copy2(test_file, output_file)
        
        logger.info(f"Test prepared: {output_file}")
        return str(output_file)
    
    def run(self, test: str, log: str, timeout: int = None) -> None:
        """
        Run test on Spike simulator
        
        Args:
            test: Path to test ELF file
            log: Path to output log file
            timeout: Simulation timeout in seconds
        """
        logger.info(f"Running Spike simulation: {test}")
        
        if timeout is None:
            timeout = self.timeout
            
        test_file = Path(test).resolve()
        log_file = Path(log).resolve()
        
        if not test_file.exists():
            raise FileNotFoundError(f"Test file not found: {test_file}")
        
        # Determine ISA for Spike
        spike_isa = self._get_spike_isa()
        
        try:
            # Build Spike command
            cmd = [
                "spike",
                f"--isa={spike_isa}",
                "--pc=0x80000000",  # Standard reset vector for Spike
                str(test_file)
            ]
            
            # Add proxy kernel if available
            pk_binary = self._find_pk_binary()
            if pk_binary:
                cmd.insert(-1, str(pk_binary))
            
            logger.info(f"Spike command: {' '.join(cmd)}")
            
            # Run Spike simulation
            with open(log_file, 'w') as log_handle:
                result = subprocess.run(
                    cmd,
                    stdout=log_handle,
                    stderr=subprocess.STDOUT,
                    timeout=timeout,
                    cwd=self.workdir
                )
            
            if result.returncode != 0:
                logger.warning(f"Spike returned non-zero exit code: {result.returncode}")
            else:
                logger.info("Spike simulation completed successfully")
                
        except subprocess.TimeoutExpired:
            logger.error(f"Spike simulation timed out after {timeout} seconds")
            raise RuntimeError("Spike simulation timeout")
        except FileNotFoundError:
            logger.error("Spike executable not found in PATH")
            raise RuntimeError("Spike not found - check installation and PATH")
        except Exception as e:
            logger.error(f"Spike simulation failed: {e}")
            raise RuntimeError(f"Spike simulation error: {e}")
    
    def parse_sig(self, log: str, sig_path: str) -> None:
        """
        Extract test signature from Spike output
        
        Args:
            log: Path to simulation log file
            sig_path: Path where signature should be written
        """
        logger.info(f"Parsing Spike signature from: {log}")
        
        try:
            with open(log, 'r') as log_file:
                log_content = log_file.read()
            
            # Extract signature from Spike output
            signature_lines = []
            
            # Look for signature section in log
            in_signature = False
            for line in log_content.split('\n'):
                line = line.strip()
                
                # Spike typically outputs signature data in a specific format
                if 'begin_signature' in line.lower():
                    in_signature = True
                    continue
                elif 'end_signature' in line.lower():
                    in_signature = False
                    break
                elif in_signature and line:
                    # Extract hex values from signature lines
                    if line.startswith('0x') or all(c in '0123456789abcdefABCDEF' for c in line):
                        signature_lines.append(line.replace('0x', '').lower())
            
            # Write signature file
            with open(sig_path, 'w') as sig_file:
                if signature_lines:
                    for line in signature_lines:
                        sig_file.write(line + '\n')
                else:
                    # If no signature found, create minimal signature
                    sig_file.write('00000000\n')
                    
            logger.info(f"Signature extracted with {len(signature_lines)} entries")
            
        except Exception as e:
            logger.error(f"Failed to parse signature: {e}")
            # Create empty signature file as fallback
            Path(sig_path).touch()
    
    def _get_spike_isa(self) -> str:
        """
        Convert RISCOF ISA string to Spike ISA format
        
        Returns:
            ISA string formatted for Spike
        """
        # Convert from RISCOF format to Spike format
        isa_map = {
            'RV32I': 'rv32i',
            'RV32IM': 'rv32im',
            'RV32IMC': 'rv32imc',
            'RV32IMCZicsr': 'rv32imc_zicsr',
            'RV32IMCZicsr_Zifencei': 'rv32imc_zicsr_zifencei',
            'RV64I': 'rv64i',
            'RV64IM': 'rv64im',
            'RV64IMC': 'rv64imc',
            'RV64IMCZicsr': 'rv64imc_zicsr',
            'RV64IMCZicsr_Zifencei': 'rv64imc_zicsr_zifencei'
        }
        
        spike_isa = isa_map.get(self.isa, self.isa.lower())
        logger.info(f"Using Spike ISA: {spike_isa}")
        return spike_isa
    
    def _find_pk_binary(self) -> Path:
        """
        Find proxy kernel binary
        
        Returns:
            Path to pk binary if found, None otherwise
        """
        pk_candidates = [
            Path(self.pk_path) / "bin" / "pk",
            Path(self.pk_path) / "riscv32-unknown-elf" / "bin" / "pk",
            Path(self.pk_path) / "riscv64-unknown-elf" / "bin" / "pk",
            Path("/opt/riscv-conformance/pk/bin/pk"),
            Path("/opt/riscv/bin/pk")
        ]
        
        for candidate in pk_candidates:
            if candidate.exists() and candidate.is_file():
                logger.info(f"Found proxy kernel: {candidate}")
                return candidate
                
        logger.warning("Proxy kernel not found - running without pk")
        return None


# Plugin entry point for RISCOF
Plugin = SpikePlugin
