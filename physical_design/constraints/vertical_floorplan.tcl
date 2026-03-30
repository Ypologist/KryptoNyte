# OpenROAD Floorplanning script for TetraNyteRV32ICore
puts "Applying Vertical Layout Constraints"

set block [[[::ord::get_db] getChip] getBlock]

set core_box [$block getCoreArea]
set x_min [$core_box xMin]
set y_min [$core_box yMin]
set x_max [$core_box xMax]
set y_max [$core_box yMax]

set y_height [expr {$y_max - $y_min}]
set row_height 2720
set rows_per_step [expr {($y_height / 4) / $row_height}]
set y_step [expr {$rows_per_step * $row_height}]

set fetch_y_min [expr {$y_max - $y_step}]
set fetch_y_max $y_max

set decode_y_min [expr {$fetch_y_min - $y_step}]
set decode_y_max $fetch_y_min

set exec_y_min [expr {$decode_y_min - $y_step}]
set exec_y_max $decode_y_min

set wb_y_min $y_min
set wb_y_max $exec_y_min

proc add_to_group_safe {group pattern block} {
    set count 0
    foreach inst [$block getInsts] {
        set name [$inst getName]
        if {[string match "*${pattern}*" $name]} {
            odb::dbGroup_addInst $group $inst
            incr count
        }
    }
    puts "Added $count instructions to group for pattern $pattern"
}

# Fetch Region (Top quarter)
set fetch_region [odb::dbRegion_create $block "fetch_region"]
odb::dbBox_create $fetch_region $x_min $fetch_y_min $x_max $fetch_y_max
odb::dbRegion_setRegionType $fetch_region "INCLUSIVE"
set fetch_group [odb::dbGroup_create $fetch_region "fetch_group"]
odb::dbGroup_setType $fetch_group "PHYSICAL_CLUSTER"

add_to_group_safe $fetch_group "pcRegs" $block
add_to_group_safe $fetch_group "if_id" $block
add_to_group_safe $fetch_group "flushThread" $block
add_to_group_safe $fetch_group "threadSel" $block

# Decode + Regfile Region (2nd quarter)
set decode_region [odb::dbRegion_create $block "decode_region"]
odb::dbBox_create $decode_region $x_min $decode_y_min $x_max $decode_y_max
odb::dbRegion_setRegionType $decode_region "INCLUSIVE"
set decode_group [odb::dbGroup_create $decode_region "decode_group"]
odb::dbGroup_setType $decode_group "PHYSICAL_CLUSTER"

add_to_group_safe $decode_group "id_ex" $block
add_to_group_safe $decode_group "regFile" $block

# Execute Region (3rd quarter)
set exec_region [odb::dbRegion_create $block "exec_region"]
odb::dbBox_create $exec_region $x_min $exec_y_min $x_max $exec_y_max
odb::dbRegion_setRegionType $exec_region "INCLUSIVE"
set exec_group [odb::dbGroup_create $exec_region "exec_group"]
odb::dbGroup_setType $exec_group "PHYSICAL_CLUSTER"

add_to_group_safe $exec_group "alu" $block
add_to_group_safe $exec_group "divider" $block
add_to_group_safe $exec_group "mulUnit" $block
add_to_group_safe $exec_group "ex_mem" $block

# Writeback Region (Bottom quarter)
set wb_region [odb::dbRegion_create $block "wb_region"]
odb::dbBox_create $wb_region $x_min $wb_y_min $x_max $wb_y_max
odb::dbRegion_setRegionType $wb_region "INCLUSIVE"
set wb_group [odb::dbGroup_create $wb_region "wb_group"]
odb::dbGroup_setType $wb_group "PHYSICAL_CLUSTER"

add_to_group_safe $wb_group "loadUnit" $block
add_to_group_safe $wb_group "storeUnit" $block

puts "Vertical Layout Constraints Applied!"
