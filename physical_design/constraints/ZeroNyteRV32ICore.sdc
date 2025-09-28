# KryptoNyte ZeroNyteRV32ICore Timing Constraints
# SDC (Synopsys Design Constraints) file for OpenLane2 physical design

# Clock definition
create_clock -name "main_clock" -period 10.0 [get_ports clock]

# Clock uncertainty and transition time
set_clock_uncertainty 0.5 [get_clocks main_clock]
set_clock_transition 0.1 [get_clocks main_clock]

# Input/Output delays relative to clock
set_input_delay -clock main_clock -max 2.0 [all_inputs]
set_input_delay -clock main_clock -min 0.5 [all_inputs]
set_output_delay -clock main_clock -max 2.0 [all_outputs]
set_output_delay -clock main_clock -min 0.5 [all_outputs]

# Remove clock from input/output delay constraints
set_input_delay -clock main_clock 0.0 [get_ports clock]
set_output_delay -clock main_clock 0.0 [get_ports clock]

# Reset signal constraints
if {[sizeof_collection [get_ports reset]] > 0} {
    set_input_delay -clock main_clock 0.0 [get_ports reset]
    set_false_path -from [get_ports reset]
}

# Drive strength for inputs
set_driving_cell -lib_cell sky130_fd_sc_hd__buf_1 [all_inputs]

# Load capacitance for outputs
set_load 0.1 [all_outputs]

# Maximum transition time
set_max_transition 0.5 [current_design]

# Maximum fanout
set_max_fanout 20 [current_design]

# Maximum capacitance
set_max_capacitance 0.2 [current_design]

# Operating conditions
set_operating_conditions -max ss_100C_1v60 -min ff_n40C_1v95

# Wire load model (if available)
# set_wire_load_model -name "sky130_fd_sc_hd_typical" [current_design]

# Multi-cycle paths (if any)
# Example: set_multicycle_path -setup 2 -from [get_pins reg1/Q] -to [get_pins reg2/D]

# False paths (if any)
# Example: set_false_path -from [get_pins config_reg*/Q] -to [get_pins data_path*/D]

# Case analysis (if any)
# Example: set_case_analysis 0 [get_ports test_mode]
