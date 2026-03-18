# Basic debug constraints for OpenLane PnR.
create_clock -name core_clk -period 15.0 [get_ports clock]
set_clock_uncertainty 0.2 [get_clocks core_clk]

set INPUT_PORTS [concat \
  [get_ports reset] \
  [get_ports io_threadEnable_*] \
  [get_ports io_instrMem*] \
  [get_ports io_dataMemResp*]]
set OUTPUT_PORTS [concat \
  [get_ports io_memAddr*] \
  [get_ports io_memWrite*] \
  [get_ports io_memMask*] \
  [get_ports io_memMisaligned] \
  [get_ports io_fetchThread*] \
  [get_ports io_if_pc_*] \
  [get_ports io_if_instr_*] \
  [get_ports io_id_rs1Data_*] \
  [get_ports io_id_rs2Data_*] \
  [get_ports io_ex_aluResult_*] \
  [get_ports io_mem_loadData_*] \
  [get_ports io_ctrlTaken] \
  [get_ports io_ctrlThread*] \
  [get_ports io_ctrlFromPC*] \
  [get_ports io_ctrlTarget*] \
  [get_ports io_ctrlIsJal] \
  [get_ports io_ctrlIsJalr] \
  [get_ports io_ctrlIsBranch]]
set_input_delay 0.0 -clock [get_clocks core_clk] $INPUT_PORTS
set_output_delay 0.0 -clock [get_clocks core_clk] $OUTPUT_PORTS

# Reset is asynchronous in this core.
set_false_path -from [get_ports reset]
