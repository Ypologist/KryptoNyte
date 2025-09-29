import os
import re
import shutil
import subprocess
import shlex
import logging
import random
import string
import json
from string import Template

import riscof.utils as utils
from riscof.pluginTemplate import pluginTemplate
import riscof.constants as constants

logger = logging.getLogger()

class spike(pluginTemplate):
    __model__ = "spike"
    __version__ = "0.5.0"

    def __init__(self, *args, **kwargs):
        sclass = super().__init__(*args, **kwargs)

        config = kwargs.get('config')
        if config is None:
            logger.error("Config node for spike missing.")
            raise SystemExit(1)
        
        self.pluginpath = os.path.abspath(config['pluginpath'])
        
        # Check multiple possible locations for reference signatures and ELF files
        # Priority order: user's prebuilt signatures in riscof/reference_signatures/src/ first
        possible_ref_dirs = [
            # User's actual location: tests/riscof/reference_signatures/src/
            os.path.abspath(os.path.join(os.path.dirname(self.pluginpath), 'reference_signatures/src')),
            # Alternative: from tests/ directory
            os.path.abspath(os.path.join(os.path.dirname(os.path.dirname(self.pluginpath)), 'riscof/reference_signatures/src')),
            # Fallback locations
            os.path.abspath(os.path.join(os.path.dirname(os.path.dirname(self.pluginpath)), 'reference_signatures/src')),
            os.path.abspath(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(self.pluginpath))), 'riscof/reference_signatures/src')),
            os.path.abspath(os.path.join(os.path.dirname(os.path.dirname(self.pluginpath)), 'riscof_work/reference_signatures')),
            os.path.abspath(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(self.pluginpath))), 'riscof_work/reference_signatures'))
        ]
        
        self.ref_sig_dir = None
        for ref_dir in possible_ref_dirs:
            if os.path.exists(ref_dir):
                self.ref_sig_dir = ref_dir
                break
        
        if self.ref_sig_dir:
            logger.info(f"Using pre-generated reference signatures from: {self.ref_sig_dir}")
        else:
            logger.warning(f"No reference signatures directory found. Checked: {possible_ref_dirs}")
            self.ref_sig_dir = possible_ref_dirs[0]  # Use first as fallback
        
        return sclass

    def initialise(self, suite, work_dir, archtest_env):
        self.suite = suite
        self.work_dir = work_dir

    def build(self, isa_yaml, platform_yaml):
        # Nothing to build for pre-generated signatures
        self.isa_yaml_path = isa_yaml
        ispec = utils.load_yaml(isa_yaml)['hart0']
        self.xlen = ('64' if 64 in ispec['supported_xlen'] else '32')
        pass

    def runTests(self, testList, cgf_file=None, header_file=None):
        # For each test, copy the pre-generated signature to the expected location
        for file in testList:
            testentry = testList[file]
            test = testentry['test_path']
            test_dir = testentry['work_dir']
            test_name = test.rsplit('/',1)[1][:-2]
            
            # Create the reference directory
            ref_dir = os.path.join(test_dir, 'ref')
            os.makedirs(ref_dir, exist_ok=True)
            
            # Path where RISCOF expects the reference signature
            ref_sig = os.path.join(ref_dir, f"Reference-spike.signature")
            
            # Check if reference signature already exists
            if os.path.exists(ref_sig):
                logger.info(f"Reference signature already exists for {test_name}, skipping")
                continue
            
            # Try multiple possible signature file names and locations
            # Priority order: user's prebuilt .signature files first
            possible_sig_files = [
                os.path.join(self.ref_sig_dir, f"{test_name}.signature"),  # user's prebuilt signatures
                os.path.join(self.ref_sig_dir, "I", f"{test_name}.signature"),
                os.path.join(self.ref_sig_dir, "I", f"{test_name}.reference_output"),  # generate script format
                os.path.join(self.ref_sig_dir, "I", f"{test_name}.ref"),
                os.path.join(self.ref_sig_dir, f"{test_name}.reference_output"),
                os.path.join(self.ref_sig_dir, f"{test_name}.ref"),
                os.path.join(self.ref_sig_dir, "src", f"{test_name}.signature"),
                os.path.join(self.ref_sig_dir, "src", f"{test_name}.reference_output")
            ]
            
            # Also check for corresponding ELF files in the same directory
            possible_elf_files = [
                os.path.join(self.ref_sig_dir, f"{test_name}.elf")
            ]
            
            signature_found = False
            elf_found = False
            
            # First, check if we have both signature and ELF files
            for pregenerated_sig in possible_sig_files:
                if os.path.exists(pregenerated_sig):
                    # Check if corresponding ELF file exists
                    elf_file = pregenerated_sig.replace('.signature', '.elf').replace('.reference_output', '.elf').replace('.ref', '.elf')
                    if os.path.exists(elf_file):
                        # Copy both signature and ELF file
                        shutil.copy2(pregenerated_sig, ref_sig)
                        logger.info(f"Copied prebuilt signature for {test_name} from {os.path.basename(pregenerated_sig)}")
                        logger.info(f"Found corresponding ELF file: {os.path.basename(elf_file)}")
                        signature_found = True
                        elf_found = True
                        break
                    else:
                        # Copy just the signature file
                        shutil.copy2(pregenerated_sig, ref_sig)
                        logger.info(f"Copied prebuilt signature for {test_name} from {os.path.basename(pregenerated_sig)}")
                        signature_found = True
                        break
            
            if not signature_found:
                # Try to generate signature using Spike (same method as generate_reference_signatures.sh)
                logger.info(f"No pre-generated signature found for {test_name}, attempting to generate with Spike")
                if self._generate_signature_with_spike(test, test_dir, test_name, ref_sig):
                    logger.info(f"Successfully generated reference signature for {test_name} using Spike")
                else:
                    # Create an empty signature file if generation fails
                    with open(ref_sig, 'w') as f:
                        f.write("# No pre-generated signature available and Spike generation failed\n")
                    logger.warning(f"Failed to generate signature for {test_name}")

    def _generate_signature_with_spike(self, test_path, test_dir, test_name, output_file):
        """Generate reference signature using Spike (same method as generate_reference_signatures.sh)"""
        import subprocess
        import tempfile
        import os
        
        try:
            # Create temporary directory for compilation
            with tempfile.TemporaryDirectory() as temp_dir:
                elf_file = os.path.join(temp_dir, f"{test_name}.elf")
                
                # Find RISC-V toolchain (try multiple prefixes)
                riscv_gcc = None
                for prefix in ["/opt/riscv/collab/bin/riscv32-unknown-elf-", "riscv64-linux-gnu-", "riscv32-unknown-elf-"]:
                    gcc_path = f"{prefix}gcc"
                    if shutil.which(gcc_path):
                        riscv_gcc = gcc_path
                        break
                
                if not riscv_gcc:
                    logger.warning("No RISC-V toolchain found for Spike signature generation")
                    return False
                
                # Find environment directory
                env_dir = None
                possible_env_dirs = [
                    os.path.join(os.path.dirname(os.path.dirname(self.pluginpath)), 'zeronyte/env'),
                    os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(self.pluginpath))), 'riscof/zeronyte/env')
                ]
                for env_path in possible_env_dirs:
                    if os.path.exists(env_path):
                        env_dir = env_path
                        break
                
                if not env_dir:
                    logger.warning("Environment directory not found for Spike signature generation")
                    return False
                
                # Compile test (same flags as generate_reference_signatures.sh)
                compile_cmd = [
                    riscv_gcc,
                    "-march=rv32imc",
                    "-DXLEN=32",
                    "-mabi=ilp32",
                    "-static",
                    "-mcmodel=medany",
                    "-fvisibility=hidden",
                    "-nostdlib",
                    "-nostartfiles",
                    "-Wa,-march=rv32imc",
                    "-Wa,--no-warn",
                    "-Ttext=0x80000000",
                    f"-I{env_dir}",
                    "-DRVTEST_E=1",
                    "-o", elf_file,
                    test_path
                ]
                
                logger.debug(f"Compiling for Spike: {' '.join(compile_cmd)}")
                result = subprocess.run(compile_cmd, capture_output=True, text=True)
                
                if result.returncode != 0:
                    logger.warning(f"Compilation failed for Spike: {result.stderr}")
                    return False
                
                # Run with Spike (same command as generate_reference_signatures.sh)
                spike_cmd = ["spike", "--isa=rv32imc", elf_file]
                
                logger.debug(f"Running Spike: {' '.join(spike_cmd)}")
                result = subprocess.run(spike_cmd, capture_output=True, text=True)
                
                if result.returncode == 0:
                    # Write Spike output to reference signature file
                    with open(output_file, 'w') as f:
                        f.write(result.stdout)
                    return True
                else:
                    logger.warning(f"Spike execution failed: {result.stderr}")
                    return False
                    
        except Exception as e:
            logger.warning(f"Exception during Spike signature generation: {e}")
            return False
