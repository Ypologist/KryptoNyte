# Reuse the same clock and I/O timing model for signoff in debug runs.
create_clock -name core_clk -period 25.0 [get_ports clock]
set_clock_uncertainty 0.2 [get_clocks core_clk]

set INPUT_PORTS [concat \
  [get_ports reset] \
  [get_ports io_imem_rdata*] \
  [get_ports io_dmem_rdata*]]
set OUTPUT_PORTS [concat \
  [get_ports io_imem_addr*] \
  [get_ports io_dmem_addr*] \
  [get_ports io_dmem_wdata*] \
  [get_ports io_dmem_wen] \
  [get_ports io_pc_out*] \
  [get_ports io_instr_out*] \
  [get_ports io_result*]]
set_input_delay 0.0 -clock [get_clocks core_clk] $INPUT_PORTS
set_output_delay 0.0 -clock [get_clocks core_clk] $OUTPUT_PORTS

set_false_path -from [get_ports reset]
