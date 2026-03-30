#!/usr/bin/env python3
import sys
import os

from openlane.steps.openroad import GlobalPlacement
from openlane.state import State
from typing import Tuple
from openlane.__main__ import cli

# Save the original run method
_orig_run = GlobalPlacement.run

def custom_run(self, state_in: State, **kwargs) -> Tuple[dict, dict]:
    orig_script_path = self.get_script_path()
    floorplan_tcl = os.path.abspath("constraints/vertical_floorplan.tcl")
    custom_script = os.path.join(self.step_dir, "custom_gpl.tcl")
    
    # Do not apply top-level vertical floorplan if we are synthesizing a macro
    is_macro = "RegFileMT2R1WVec" in os.getcwd()

    with open(custom_script, "w") as f:
        with open(orig_script_path, "r") as orig_f:
            orig_content = orig_f.read()
            
        if os.path.exists(floorplan_tcl) and not is_macro and "read_current_odb" in orig_content:
            injection = f"read_current_odb\nputs \"Sourcing custom vertical floorplan...\"\nsource {floorplan_tcl}\n"
            orig_content = orig_content.replace("read_current_odb\n", injection, 1)
        elif os.path.exists(floorplan_tcl) and not is_macro:
            f.write(f"puts \"Sourcing custom vertical floorplan...\"\n")
            f.write(f"source {floorplan_tcl}\n")
            
        f.write(orig_content)
            
    # Override script path
    orig_get_script_path = self.get_script_path
    self.get_script_path = lambda: custom_script
    try:
        return _orig_run(self, state_in, **kwargs)
    finally:
        self.get_script_path = orig_get_script_path

# Monkey-patch the GlobalPlacement class
GlobalPlacement.run = custom_run

if __name__ == "__main__":
    # Call the OpenLane CLI
    cli()
