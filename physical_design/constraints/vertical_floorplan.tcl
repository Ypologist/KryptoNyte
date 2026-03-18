# OpenROAD Floorplanning script for TetraNyteRV32ICore
puts "Applying Vertical Layout Constraints"

proc add_to_group_safe {group pattern} {
    set cells [get_cells -quiet $pattern]
    if {$cells != ""} {
        add_inst_to_group $group $cells
    } else {
        puts "Warning: No cells found for pattern $pattern"
    }
}

# Fetch Region: Y=11250 to 14900
create_inst_group fetch_group
add_to_group_safe fetch_group *pcRegs*
add_to_group_safe fetch_group *if_id*
add_to_group_safe fetch_group *flushThread*
add_to_group_safe fetch_group *threadSel*
create_region fetch_region 0 11250 14900 14900
assign_inst_group_to_region fetch_group fetch_region

# Decode + Regfile Region: Y=7500 to 11200
create_inst_group decode_group
add_to_group_safe decode_group *id_ex*
add_to_group_safe decode_group *regFile*
create_region decode_region 0 7500 14900 11200
assign_inst_group_to_region decode_group decode_region

# Execute Region: Y=3750 to 7400
create_inst_group exec_group
add_to_group_safe exec_group *alu*
add_to_group_safe exec_group *divider*
add_to_group_safe exec_group *mulUnit*
add_to_group_safe exec_group *ex_mem*
create_region exec_region 0 3750 14900 7400
assign_inst_group_to_region exec_group exec_region

# Writeback Region: Y=0 to 3700
create_inst_group wb_group
add_to_group_safe wb_group *loadUnit*
add_to_group_safe wb_group *storeUnit*
create_region wb_region 0 0 14900 3700
assign_inst_group_to_region wb_group wb_region

puts "Vertical Layout Constraints Applied!"
