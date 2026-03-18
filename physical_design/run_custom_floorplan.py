#!/usr/bin/env python3
import sys
import os

import openlane
from openlane.flows.classic import Classic
from openlane.steps.openroad import GlobalPlacement
from openlane.state import State

class CustomGlobalPlacement(GlobalPlacement):
    id = "OpenROAD.CustomGlobalPlacement"
    name = "Global Placement with Floorplan Region Hook"

    def run(self, state_in: State, **kwargs):
        # Create a modified tcl script in the step dir
        orig_script_path = self.get_script_path()
        floorplan_tcl = os.path.abspath("constraints/vertical_floorplan.tcl")
        custom_script = os.path.join(self.step_dir, "custom_gpl.tcl")
        
        with open(custom_script, "w") as f:
            if os.path.exists(floorplan_tcl):
                f.write(f"puts \"Sourcing custom vertical floorplan...\"\n")
                f.write(f"source {floorplan_tcl}\n")
            with open(orig_script_path, "r") as orig_f:
                f.write(orig_f.read())
        
        # Override the script path temporarily
        orig_get_script_path = self.get_script_path
        self.get_script_path = lambda: custom_script
        try:
            return super().run(state_in, **kwargs)
        finally:
            self.get_script_path = orig_get_script_path

class CustomFlow(Classic):
    # Replace GlobalPlacement in Steps list
    Steps = [CustomGlobalPlacement if step.__name__ == "GlobalPlacement" else step for step in Classic.Steps]

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 run_custom_floorplan.py <config.json>")
        sys.exit(1)
        
    config_file = sys.argv[1]
    
    flow, exc = CustomFlow.start(
        config=config_file
    )
    if exc:
        print(f"Flow failed: {exc}")
        sys.exit(1)
