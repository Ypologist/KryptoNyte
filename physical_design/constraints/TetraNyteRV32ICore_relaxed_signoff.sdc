# Reuse the same relaxed clock and I/O timing model for signoff in debug runs.
create_clock -name core_clk -period 50.0 [get_ports clock]
set_clock_uncertainty 0.2 [get_clocks core_clk]

set INPUT_PORTS [concat \
  [get_ports reset] \
  [get_ports io_threadEnable_*] \
  [get_ports io_instrMem*] \
  [get_ports io_dataMemResp*] \
  [get_ports io_jtag_tck] \
  [get_ports io_jtag_tms] \
  [get_ports io_jtag_tdi] \
  [get_ports io_jtag_trst_n]]
set OUTPUT_PORTS [concat \
  [get_ports io_memAddr*] \
  [get_ports io_memWrite*] \
  [get_ports io_memMask*] \
  [get_ports io_memMisaligned] \
  [get_ports io_fetchThread*] \
  [get_ports io_jtag_tdo]]
set_input_delay 0.0 -clock [get_clocks core_clk] $INPUT_PORTS
set_output_delay 0.0 -clock [get_clocks core_clk] $OUTPUT_PORTS

set_false_path -from [get_ports reset]
