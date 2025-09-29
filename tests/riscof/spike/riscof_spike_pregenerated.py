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
        
        # Check multiple possible locations for reference signatures
        possible_ref_dirs = [
            os.path.abspath(os.path.join(os.path.dirname(self.pluginpath), 'reference_signatures/src')),
            os.path.abspath(os.path.join(os.path.dirname(os.path.dirname(self.pluginpath)), 'reference_signatures/src')),
            os.path.abspath(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(self.pluginpath))), 'reference_signatures/src')),
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
            possible_sig_files = [
                os.path.join(self.ref_sig_dir, f"{test_name}.signature"),
                os.path.join(self.ref_sig_dir, f"{test_name}.reference_output"),
                os.path.join(self.ref_sig_dir, f"{test_name}.ref"),
                os.path.join(self.ref_sig_dir, "I", f"{test_name}.signature"),
                os.path.join(self.ref_sig_dir, "I", f"{test_name}.reference_output"),
                os.path.join(self.ref_sig_dir, "I", f"{test_name}.ref"),
                os.path.join(self.ref_sig_dir, "src", f"{test_name}.signature"),
                os.path.join(self.ref_sig_dir, "src", f"{test_name}.reference_output")
            ]
            
            signature_found = False
            for pregenerated_sig in possible_sig_files:
                if os.path.exists(pregenerated_sig):
                    # Copy the pre-generated signature to the expected location
                    shutil.copy(pregenerated_sig, ref_sig)
                    logger.info(f"Copied pre-generated signature for {test_name} from {os.path.basename(pregenerated_sig)}")
                    signature_found = True
                    break
            
            if not signature_found:
                # Create an empty signature file if no pre-generated one is found
                with open(ref_sig, 'w') as f:
                    f.write("# No pre-generated signature available for this test\n")
                logger.warning(f"No pre-generated signature found for {test_name} in {self.ref_sig_dir}")
