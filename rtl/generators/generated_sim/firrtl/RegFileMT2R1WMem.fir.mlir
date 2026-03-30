module {
  firrtl.circuit "RegFileMT2R1WMem" {
    firrtl.module @RegFileMT2R1WMem(in %clock: !firrtl.clock, in %reset: !firrtl.uint<1>, in %io_readThreadID: !firrtl.uint<2>, in %io_writeThreadID: !firrtl.uint<2>, in %io_readAddrs: !firrtl.vector<uint<5>, 2>, out %io_readData: !firrtl.vector<uint<32>, 2>, in %io_writeAddrs: !firrtl.vector<uint<5>, 1>, in %io_wens: !firrtl.vector<uint<1>, 1>, in %io_writeData: !firrtl.vector<uint<32>, 1>, out %io_debugX1: !firrtl.vector<uint<32>, 4>) {
      %c33_ui7 = firrtl.constant 33 : !firrtl.uint<7>
      %c1_ui7 = firrtl.constant 1 : !firrtl.uint<7>
      %c0_ui32 = firrtl.constant 0 : !firrtl.uint<32>
      %c97_ui7 = firrtl.constant 97 : !firrtl.uint<7>
      %c65_ui7 = firrtl.constant 65 : !firrtl.uint<7>
      %c1_ui1 = firrtl.constant 1 : !firrtl.uint<1>
      %io = firrtl.wire : !firrtl.bundle<readThreadID: uint<2>, writeThreadID: uint<2>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 4>>
      %0 = firrtl.subfield %io[readThreadID] : !firrtl.bundle<readThreadID: uint<2>, writeThreadID: uint<2>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 4>>
      %1 = firrtl.subfield %io[writeThreadID] : !firrtl.bundle<readThreadID: uint<2>, writeThreadID: uint<2>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 4>>
      %2 = firrtl.subfield %io[readAddrs] : !firrtl.bundle<readThreadID: uint<2>, writeThreadID: uint<2>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 4>>
      %3 = firrtl.subfield %io[readData] : !firrtl.bundle<readThreadID: uint<2>, writeThreadID: uint<2>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 4>>
      firrtl.matchingconnect %io_readData, %3 : !firrtl.vector<uint<32>, 2>
      %4 = firrtl.subfield %io[writeAddrs] : !firrtl.bundle<readThreadID: uint<2>, writeThreadID: uint<2>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 4>>
      %5 = firrtl.subfield %io[wens] : !firrtl.bundle<readThreadID: uint<2>, writeThreadID: uint<2>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 4>>
      %6 = firrtl.subfield %io[writeData] : !firrtl.bundle<readThreadID: uint<2>, writeThreadID: uint<2>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 4>>
      %7 = firrtl.subfield %io[debugX1] : !firrtl.bundle<readThreadID: uint<2>, writeThreadID: uint<2>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 4>>
      firrtl.matchingconnect %io_debugX1, %7 : !firrtl.vector<uint<32>, 4>
      %8 = firrtl.subindex %2[1] : !firrtl.vector<uint<5>, 2>
      %9 = firrtl.subindex %2[0] : !firrtl.vector<uint<5>, 2>
      %10 = firrtl.subindex %6[0] : !firrtl.vector<uint<32>, 1>
      %11 = firrtl.subindex %5[0] : !firrtl.vector<uint<1>, 1>
      %12 = firrtl.subindex %4[0] : !firrtl.vector<uint<5>, 1>
      %regs_MPORT, %regs_io_debugX1_0_MPORT, %regs_io_debugX1_1_MPORT, %regs_io_debugX1_2_MPORT, %regs_io_debugX1_3_MPORT, %regs_io_readData_0_MPORT, %regs_io_readData_1_MPORT = firrtl.mem  Undefined {depth = 128 : i64, name = "regs", portNames = ["MPORT", "io_debugX1_0_MPORT", "io_debugX1_1_MPORT", "io_debugX1_2_MPORT", "io_debugX1_3_MPORT", "io_readData_0_MPORT", "io_readData_1_MPORT"], readLatency = 0 : i32, writeLatency = 1 : i32} : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data: uint<32>, mask: uint<1>>, !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>, !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>, !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>, !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>, !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>, !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %13 = firrtl.subfield %regs_MPORT[addr] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data: uint<32>, mask: uint<1>>
      %14 = firrtl.subfield %regs_MPORT[en] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data: uint<32>, mask: uint<1>>
      %15 = firrtl.subfield %regs_MPORT[clk] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data: uint<32>, mask: uint<1>>
      %16 = firrtl.subfield %regs_MPORT[data] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data: uint<32>, mask: uint<1>>
      %17 = firrtl.subfield %regs_MPORT[mask] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data: uint<32>, mask: uint<1>>
      %18 = firrtl.subfield %regs_io_debugX1_0_MPORT[addr] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %19 = firrtl.subfield %regs_io_debugX1_0_MPORT[en] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %20 = firrtl.subfield %regs_io_debugX1_0_MPORT[clk] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %21 = firrtl.subfield %regs_io_debugX1_0_MPORT[data] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %22 = firrtl.subfield %regs_io_debugX1_1_MPORT[addr] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %23 = firrtl.subfield %regs_io_debugX1_1_MPORT[en] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %24 = firrtl.subfield %regs_io_debugX1_1_MPORT[clk] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %25 = firrtl.subfield %regs_io_debugX1_1_MPORT[data] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %26 = firrtl.subfield %regs_io_debugX1_2_MPORT[addr] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %27 = firrtl.subfield %regs_io_debugX1_2_MPORT[en] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %28 = firrtl.subfield %regs_io_debugX1_2_MPORT[clk] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %29 = firrtl.subfield %regs_io_debugX1_2_MPORT[data] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %30 = firrtl.subfield %regs_io_debugX1_3_MPORT[addr] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %31 = firrtl.subfield %regs_io_debugX1_3_MPORT[en] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %32 = firrtl.subfield %regs_io_debugX1_3_MPORT[clk] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %33 = firrtl.subfield %regs_io_debugX1_3_MPORT[data] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %34 = firrtl.subfield %regs_io_readData_0_MPORT[addr] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %35 = firrtl.subfield %regs_io_readData_0_MPORT[en] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %36 = firrtl.subfield %regs_io_readData_0_MPORT[clk] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %37 = firrtl.subfield %regs_io_readData_0_MPORT[data] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %38 = firrtl.subfield %regs_io_readData_1_MPORT[addr] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %39 = firrtl.subfield %regs_io_readData_1_MPORT[en] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %40 = firrtl.subfield %regs_io_readData_1_MPORT[clk] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %41 = firrtl.subfield %regs_io_readData_1_MPORT[data] : !firrtl.bundle<addr: uint<7>, en: uint<1>, clk: clock, data flip: uint<32>>
      %effectiveDst = firrtl.cat %1, %12 {name = "effectiveDst"} : (!firrtl.uint<2>, !firrtl.uint<5>) -> !firrtl.uint<7>
      %42 = firrtl.orr %12 : (!firrtl.uint<5>) -> !firrtl.uint<1>
      %43 = firrtl.and %11, %42 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      firrtl.matchingconnect %13, %effectiveDst : !firrtl.uint<7>
      firrtl.matchingconnect %14, %43 : !firrtl.uint<1>
      firrtl.matchingconnect %15, %clock : !firrtl.clock
      firrtl.matchingconnect %17, %c1_ui1 : !firrtl.uint<1>
      firrtl.matchingconnect %16, %10 : !firrtl.uint<32>
      %effectiveSrc = firrtl.cat %0, %9 {name = "effectiveSrc"} : (!firrtl.uint<2>, !firrtl.uint<5>) -> !firrtl.uint<7>
      %44 = firrtl.orr %9 : (!firrtl.uint<5>) -> !firrtl.uint<1>
      %_io_readData_0_T = firrtl.not %44 {name = "_io_readData_0_T"} : (!firrtl.uint<1>) -> !firrtl.uint<1>
      firrtl.matchingconnect %34, %effectiveSrc : !firrtl.uint<7>
      firrtl.matchingconnect %35, %c1_ui1 : !firrtl.uint<1>
      firrtl.matchingconnect %36, %clock : !firrtl.clock
      %_io_readData_0_T_1 = firrtl.mux(%_io_readData_0_T, %c0_ui32, %37) {name = "_io_readData_0_T_1"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %effectiveSrc_1 = firrtl.cat %0, %8 {name = "effectiveSrc_1"} : (!firrtl.uint<2>, !firrtl.uint<5>) -> !firrtl.uint<7>
      %45 = firrtl.orr %8 : (!firrtl.uint<5>) -> !firrtl.uint<1>
      %_io_readData_1_T = firrtl.not %45 {name = "_io_readData_1_T"} : (!firrtl.uint<1>) -> !firrtl.uint<1>
      firrtl.matchingconnect %38, %effectiveSrc_1 : !firrtl.uint<7>
      firrtl.matchingconnect %39, %c1_ui1 : !firrtl.uint<1>
      firrtl.matchingconnect %40, %clock : !firrtl.clock
      %_io_readData_1_T_1 = firrtl.mux(%_io_readData_1_T, %c0_ui32, %41) {name = "_io_readData_1_T_1"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      firrtl.matchingconnect %18, %c1_ui7 : !firrtl.uint<7>
      firrtl.matchingconnect %19, %c1_ui1 : !firrtl.uint<1>
      firrtl.matchingconnect %20, %clock : !firrtl.clock
      firrtl.matchingconnect %22, %c33_ui7 : !firrtl.uint<7>
      firrtl.matchingconnect %23, %c1_ui1 : !firrtl.uint<1>
      firrtl.matchingconnect %24, %clock : !firrtl.clock
      firrtl.matchingconnect %26, %c65_ui7 : !firrtl.uint<7>
      firrtl.matchingconnect %27, %c1_ui1 : !firrtl.uint<1>
      firrtl.matchingconnect %28, %clock : !firrtl.clock
      firrtl.matchingconnect %30, %c97_ui7 : !firrtl.uint<7>
      firrtl.matchingconnect %31, %c1_ui1 : !firrtl.uint<1>
      firrtl.matchingconnect %32, %clock : !firrtl.clock
      %46 = firrtl.vectorcreate %_io_readData_0_T_1, %_io_readData_1_T_1 : (!firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.vector<uint<32>, 2>
      %47 = firrtl.vectorcreate %21, %25, %29, %33 : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.vector<uint<32>, 4>
      %48 = firrtl.bundlecreate %io_readThreadID, %io_writeThreadID, %io_readAddrs, %46, %io_writeAddrs, %io_wens, %io_writeData, %47 : (!firrtl.uint<2>, !firrtl.uint<2>, !firrtl.vector<uint<5>, 2>, !firrtl.vector<uint<32>, 2>, !firrtl.vector<uint<5>, 1>, !firrtl.vector<uint<1>, 1>, !firrtl.vector<uint<32>, 1>, !firrtl.vector<uint<32>, 4>) -> !firrtl.bundle<readThreadID: uint<2>, writeThreadID: uint<2>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 4>>
      firrtl.matchingconnect %io, %48 : !firrtl.bundle<readThreadID: uint<2>, writeThreadID: uint<2>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 4>>
    }
  }
}
