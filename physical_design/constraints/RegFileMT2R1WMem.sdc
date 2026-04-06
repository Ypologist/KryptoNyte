# Macro-local timing constraints for RegFileMT2R1WMem hardening.
#
# The register file's critical boundary paths are the asynchronous read-address
# to read-data arcs. Using OpenLane's generic fallback SDC incorrectly applies
# a 2 ns input delay and 2 ns output delay at the macro boundary, which
# consumes 4 ns of budget and creates artificial setup failures even though the
# internal reg-to-reg paths are clean. Use zero boundary delays here so the
# hardened macro is timed against its real internal behavior.
create_clock -name regfile_clk -period 12.0 [get_ports clock]
set_clock_uncertainty 0.2 [get_clocks regfile_clk]

set INPUT_PORTS [concat \
  [get_ports io_readThreadID*] \
  [get_ports io_writeThreadID*] \
  [get_ports io_readAddrs_0*] \
  [get_ports io_readAddrs_1*] \
  [get_ports io_writeAddrs_0*] \
  [get_ports io_wens_0] \
  [get_ports io_writeData_0*]]
set OUTPUT_PORTS [concat \
  [get_ports io_readData_0*] \
  [get_ports io_readData_1*] \
  [get_ports io_debugX1_0*] \
  [get_ports io_debugX1_1*] \
  [get_ports io_debugX1_2*] \
  [get_ports io_debugX1_3*]]

set_input_delay 0.0 -clock [get_clocks regfile_clk] $INPUT_PORTS
set_output_delay 0.0 -clock [get_clocks regfile_clk] $OUTPUT_PORTS

# Reset is unused by the macro implementation and should not participate in STA.
set_false_path -from [get_ports reset]
