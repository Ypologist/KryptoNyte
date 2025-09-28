# KryptoNyte ZeroNyteRV32ICore Signoff Timing Constraints
# Tighter constraints for final signoff analysis

# Clock definition with tighter period for signoff
create_clock -name "main_clock" -period 9.5 [get_ports clock]

# Tighter clock uncertainty for signoff
set_clock_uncertainty 0.3 [get_clocks main_clock]
set_clock_transition 0.05 [get_clocks main_clock]

# Tighter input/output delays for signoff
set_input_delay -clock main_clock -max 1.5 [all_inputs]
set_input_delay -clock main_clock -min 0.3 [all_inputs]
set_output_delay -clock main_clock -max 1.5 [all_outputs]
set_output_delay -clock main_clock -min 0.3 [all_outputs]

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
set_load 0.05 [all_outputs]

# Tighter transition time for signoff
set_max_transition 0.3 [current_design]

# Tighter fanout for signoff
set_max_fanout 15 [current_design]

# Tighter capacitance for signoff
set_max_capacitance 0.15 [current_design]

# Worst-case operating conditions for signoff
set_operating_conditions -max ss_100C_1v60 -min ff_n40C_1v95

# Additional signoff-specific constraints
set_max_area 0

# Clock skew constraints
set_clock_latency -source -max 0.5 [get_clocks main_clock]
set_clock_latency -source -min 0.2 [get_clocks main_clock]

# Clock jitter
set_system_jitter 0.1 [get_clocks main_clock]

# Temperature and voltage derating
set_timing_derate -early 0.95
set_timing_derate -late 1.05

# Power analysis constraints
set_switching_activity -period 10.0 -toggle_rate 0.1 [all_inputs]
