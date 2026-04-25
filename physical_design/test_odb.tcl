set script_dir [file dirname [file normalize [info script]]]
set odb_path [file normalize [file join $script_dir .. .venv physical_design runs TetraNyteRV32ICore runs RUN_2026-03-18_20-41-08 20-openroad-ioplacement TetraNyteRV32ICore.odb]]
read_db $odb_path
source constraints/vertical_floorplan.tcl
puts "Successfully executed!"
