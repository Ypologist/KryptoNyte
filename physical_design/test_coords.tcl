set script_dir [file dirname [file normalize [info script]]]
set odb_path [file normalize [file join $script_dir .. .venv physical_design runs TetraNyteRV32ICore runs RUN_2026-03-22_06-09-45 23-openroad-globalplacement TetraNyteRV32ICore.odb]]
read_db $odb_path
set block [[[::ord::get_db] getChip] getBlock]
set core_box [$block getCoreArea]
puts "Core area bounds:"
puts "xMin: [$core_box xMin]"
puts "yMin: [$core_box yMin]"
puts "xMax: [$core_box xMax]"
puts "yMax: [$core_box yMax]"
