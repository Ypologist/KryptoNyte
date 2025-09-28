"""
ZeroNyte RISC-V Core RISCOF Plugin
Production-quality plugin for KryptoNyte's ZeroNyte RV32I core
"""

import os
import sys
import shutil
import subprocess
from pathlib import Path
import logging

# Add the plugins directory to Python path
sys.path.insert(0, str(Path(__file__).parent.parent / "plugins"))

from zeronyte_plugin import ZeroNytePlugin

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Export the plugin class for RISCOF
Plugin = ZeroNytePlugin
