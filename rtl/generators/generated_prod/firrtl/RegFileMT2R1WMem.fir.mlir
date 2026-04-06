module {
  firrtl.circuit "RegFileMT2R1WMem" {
    firrtl.module @RegFileMT2R1WMem(in %clock: !firrtl.clock, in %reset: !firrtl.uint<1>, in %io_readThreadID: !firrtl.uint<2>, in %io_writeThreadID: !firrtl.uint<2>, in %io_readAddrs: !firrtl.vector<uint<5>, 2>, out %io_readData: !firrtl.vector<uint<32>, 2>, in %io_writeAddrs: !firrtl.vector<uint<5>, 1>, in %io_wens: !firrtl.vector<uint<1>, 1>, in %io_writeData: !firrtl.vector<uint<32>, 1>) {
      %c0_ui32 = firrtl.constant 0 : !firrtl.uint<32>
      %c1_ui1 = firrtl.constant 1 : !firrtl.uint<1>
      %io = firrtl.wire : !firrtl.bundle<readThreadID: uint<2>, writeThreadID: uint<2>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      %0 = firrtl.subfield %io[readThreadID] : !firrtl.bundle<readThreadID: uint<2>, writeThreadID: uint<2>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      %1 = firrtl.subfield %io[writeThreadID] : !firrtl.bundle<readThreadID: uint<2>, writeThreadID: uint<2>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      %2 = firrtl.subfield %io[readAddrs] : !firrtl.bundle<readThreadID: uint<2>, writeThreadID: uint<2>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      %3 = firrtl.subfield %io[readData] : !firrtl.bundle<readThreadID: uint<2>, writeThreadID: uint<2>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      firrtl.matchingconnect %io_readData, %3 : !firrtl.vector<uint<32>, 2>
      %4 = firrtl.subfield %io[writeAddrs] : !firrtl.bundle<readThreadID: uint<2>, writeThreadID: uint<2>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      %5 = firrtl.subfield %io[wens] : !firrtl.bundle<readThreadID: uint<2>, writeThreadID: uint<2>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      %6 = firrtl.subfield %io[writeData] : !firrtl.bundle<readThreadID: uint<2>, writeThreadID: uint<2>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      %7 = firrtl.subindex %2[1] : !firrtl.vector<uint<5>, 2>
      %8 = firrtl.subindex %2[0] : !firrtl.vector<uint<5>, 2>
      %9 = firrtl.subindex %6[0] : !firrtl.vector<uint<32>, 1>
      %10 = firrtl.subindex %5[0] : !firrtl.vector<uint<1>, 1>
      %11 = firrtl.subindex %4[0] : !firrtl.vector<uint<5>, 1>
      %regs_MPORT, %regs_io_readData_0_MPORT, %regs_io_readData_1_MPORT = firrtl.mem  Undefined {depth = 128 : i64, name = "regs", portNames = ["MPORT", "io_readData_0_MPORT", "io_readData_1_MPORT"], readLatency = 0 : i32, writeLatency = 1 : i32} : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data: uint<32>, mask: uint<1>>, !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>, !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %12 = firrtl.subfield %regs_MPORT[addr] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data: uint<32>, mask: uint<1>>
      %13 = firrtl.subfield %regs_MPORT[en] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data: uint<32>, mask: uint<1>>
      %14 = firrtl.subfield %regs_MPORT[clk] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data: uint<32>, mask: uint<1>>
      %15 = firrtl.subfield %regs_MPORT[data] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data: uint<32>, mask: uint<1>>
      %16 = firrtl.subfield %regs_MPORT[mask] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data: uint<32>, mask: uint<1>>
      %17 = firrtl.subfield %regs_io_readData_0_MPORT[addr] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %18 = firrtl.subfield %regs_io_readData_0_MPORT[en] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %19 = firrtl.subfield %regs_io_readData_0_MPORT[clk] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %20 = firrtl.subfield %regs_io_readData_0_MPORT[data] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %21 = firrtl.subfield %regs_io_readData_1_MPORT[addr] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %22 = firrtl.subfield %regs_io_readData_1_MPORT[en] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %23 = firrtl.subfield %regs_io_readData_1_MPORT[clk] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %24 = firrtl.subfield %regs_io_readData_1_MPORT[data] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %effectiveDst = firrtl.cat %1, %11 {name = "effectiveDst"} : (!firrtl.uint<2>, !firrtl.uint<5>) -> !firrtl.uint<7>
      %25 = firrtl.orr %11 : (!firrtl.uint<5>) -> !firrtl.uint<1>
      %26 = firrtl.and %10, %25 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      firrtl.matchingconnect %12, %effectiveDst : !firrtl.uint<7>
      firrtl.matchingconnect %13, %26 : !firrtl.uint<1>
      firrtl.matchingconnect %14, %clock : !firrtl.clock
      firrtl.matchingconnect %16, %c1_ui1 : !firrtl.uint<1>
      firrtl.matchingconnect %15, %9 : !firrtl.uint<32>
      %effectiveSrc = firrtl.cat %0, %8 {name = "effectiveSrc"} : (!firrtl.uint<2>, !firrtl.uint<5>) -> !firrtl.uint<7>
      %27 = firrtl.orr %8 : (!firrtl.uint<5>) -> !firrtl.uint<1>
      %_io_readData_0_T = firrtl.not %27 {name = "_io_readData_0_T"} : (!firrtl.uint<1>) -> !firrtl.uint<1>
      firrtl.matchingconnect %17, %effectiveSrc : !firrtl.uint<7>
      firrtl.matchingconnect %18, %c1_ui1 : !firrtl.uint<1>
      firrtl.matchingconnect %19, %clock : !firrtl.clock
      %_io_readData_0_T_1 = firrtl.mux(%_io_readData_0_T, %c0_ui32, %20) {name = "_io_readData_0_T_1"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %effectiveSrc_1 = firrtl.cat %0, %7 {name = "effectiveSrc_1"} : (!firrtl.uint<2>, !firrtl.uint<5>) -> !firrtl.uint<7>
      %28 = firrtl.orr %7 : (!firrtl.uint<5>) -> !firrtl.uint<1>
      %_io_readData_1_T = firrtl.not %28 {name = "_io_readData_1_T"} : (!firrtl.uint<1>) -> !firrtl.uint<1>
      firrtl.matchingconnect %21, %effectiveSrc_1 : !firrtl.uint<7>
      firrtl.matchingconnect %22, %c1_ui1 : !firrtl.uint<1>
      firrtl.matchingconnect %23, %clock : !firrtl.clock
      %_io_readData_1_T_1 = firrtl.mux(%_io_readData_1_T, %c0_ui32, %24) {name = "_io_readData_1_T_1"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %29 = firrtl.vectorcreate %_io_readData_0_T_1, %_io_readData_1_T_1 : (!firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.vector<uint<32>, 2>
      %30 = firrtl.bundlecreate %io_readThreadID, %io_writeThreadID, %io_readAddrs, %29, %io_writeAddrs, %io_wens, %io_writeData : (!firrtl.uint<2>, !firrtl.uint<2>, !firrtl.vector<uint<5>, 2>, !firrtl.vector<uint<32>, 2>, !firrtl.vector<uint<5>, 1>, !firrtl.vector<uint<1>, 1>, !firrtl.vector<uint<32>, 1>) -> !firrtl.bundle<readThreadID: uint<2>, writeThreadID: uint<2>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      firrtl.matchingconnect %io, %30 : !firrtl.bundle<readThreadID: uint<2>, writeThreadID: uint<2>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
    }
  }
}
