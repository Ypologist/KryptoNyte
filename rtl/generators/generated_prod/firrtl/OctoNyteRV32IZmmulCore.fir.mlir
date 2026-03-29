module {
  firrtl.circuit "OctoNyteRV32IZmmulCore" {
    firrtl.module private @RegFileMT2R1WMem(in %clock: !firrtl.clock, in %io_readThreadID: !firrtl.uint<3>, in %io_writeThreadID: !firrtl.uint<3>, in %io_readAddrs: !firrtl.vector<uint<5>, 2>, out %io_readData: !firrtl.vector<uint<32>, 2>, in %io_writeAddrs: !firrtl.vector<uint<5>, 1>, in %io_wens: !firrtl.vector<uint<1>, 1>, in %io_writeData: !firrtl.vector<uint<32>, 1>, out %io_debugX1: !firrtl.vector<uint<32>, 8>) {
      %c97_ui8 = firrtl.constant 97 : !firrtl.uint<8>
      %c65_ui8 = firrtl.constant 65 : !firrtl.uint<8>
      %c33_ui8 = firrtl.constant 33 : !firrtl.uint<8>
      %c1_ui8 = firrtl.constant 1 : !firrtl.uint<8>
      %c0_ui32 = firrtl.constant 0 : !firrtl.uint<32>
      %c225_ui8 = firrtl.constant 225 : !firrtl.uint<8>
      %c193_ui8 = firrtl.constant 193 : !firrtl.uint<8>
      %c161_ui8 = firrtl.constant 161 : !firrtl.uint<8>
      %c129_ui8 = firrtl.constant 129 : !firrtl.uint<8>
      %c1_ui1 = firrtl.constant 1 : !firrtl.uint<1>
      %io = firrtl.wire : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 8>>
      %0 = firrtl.subfield %io[readThreadID] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 8>>
      %1 = firrtl.subfield %io[writeThreadID] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 8>>
      %2 = firrtl.subfield %io[readAddrs] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 8>>
      %3 = firrtl.subfield %io[readData] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 8>>
      firrtl.matchingconnect %io_readData, %3 : !firrtl.vector<uint<32>, 2>
      %4 = firrtl.subfield %io[writeAddrs] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 8>>
      %5 = firrtl.subfield %io[wens] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 8>>
      %6 = firrtl.subfield %io[writeData] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 8>>
      %7 = firrtl.subfield %io[debugX1] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 8>>
      firrtl.matchingconnect %io_debugX1, %7 : !firrtl.vector<uint<32>, 8>
      %8 = firrtl.subindex %2[1] : !firrtl.vector<uint<5>, 2>
      %9 = firrtl.subindex %2[0] : !firrtl.vector<uint<5>, 2>
      %10 = firrtl.subindex %6[0] : !firrtl.vector<uint<32>, 1>
      %11 = firrtl.subindex %5[0] : !firrtl.vector<uint<1>, 1>
      %12 = firrtl.subindex %4[0] : !firrtl.vector<uint<5>, 1>
      %regs_MPORT, %regs_io_debugX1_0_MPORT, %regs_io_debugX1_1_MPORT, %regs_io_debugX1_2_MPORT, %regs_io_debugX1_3_MPORT, %regs_io_debugX1_4_MPORT, %regs_io_debugX1_5_MPORT, %regs_io_debugX1_6_MPORT, %regs_io_debugX1_7_MPORT, %regs_io_readData_0_MPORT, %regs_io_readData_1_MPORT = firrtl.mem  Undefined {depth = 256 : i64, name = "regs", portNames = ["MPORT", "io_debugX1_0_MPORT", "io_debugX1_1_MPORT", "io_debugX1_2_MPORT", "io_debugX1_3_MPORT", "io_debugX1_4_MPORT", "io_debugX1_5_MPORT", "io_debugX1_6_MPORT", "io_debugX1_7_MPORT", "io_readData_0_MPORT", "io_readData_1_MPORT"], readLatency = 0 : i32, writeLatency = 1 : i32} : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data: uint<32>, mask: uint<1>>, !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>, !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>, !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>, !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>, !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>, !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>, !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>, !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>, !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>, !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %13 = firrtl.subfield %regs_MPORT[addr] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data: uint<32>, mask: uint<1>>
      %14 = firrtl.subfield %regs_MPORT[en] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data: uint<32>, mask: uint<1>>
      %15 = firrtl.subfield %regs_MPORT[clk] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data: uint<32>, mask: uint<1>>
      %16 = firrtl.subfield %regs_MPORT[data] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data: uint<32>, mask: uint<1>>
      %17 = firrtl.subfield %regs_MPORT[mask] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data: uint<32>, mask: uint<1>>
      %18 = firrtl.subfield %regs_io_debugX1_0_MPORT[addr] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %19 = firrtl.subfield %regs_io_debugX1_0_MPORT[en] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %20 = firrtl.subfield %regs_io_debugX1_0_MPORT[clk] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %21 = firrtl.subfield %regs_io_debugX1_0_MPORT[data] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %22 = firrtl.subfield %regs_io_debugX1_1_MPORT[addr] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %23 = firrtl.subfield %regs_io_debugX1_1_MPORT[en] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %24 = firrtl.subfield %regs_io_debugX1_1_MPORT[clk] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %25 = firrtl.subfield %regs_io_debugX1_1_MPORT[data] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %26 = firrtl.subfield %regs_io_debugX1_2_MPORT[addr] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %27 = firrtl.subfield %regs_io_debugX1_2_MPORT[en] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %28 = firrtl.subfield %regs_io_debugX1_2_MPORT[clk] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %29 = firrtl.subfield %regs_io_debugX1_2_MPORT[data] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %30 = firrtl.subfield %regs_io_debugX1_3_MPORT[addr] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %31 = firrtl.subfield %regs_io_debugX1_3_MPORT[en] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %32 = firrtl.subfield %regs_io_debugX1_3_MPORT[clk] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %33 = firrtl.subfield %regs_io_debugX1_3_MPORT[data] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %34 = firrtl.subfield %regs_io_debugX1_4_MPORT[addr] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %35 = firrtl.subfield %regs_io_debugX1_4_MPORT[en] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %36 = firrtl.subfield %regs_io_debugX1_4_MPORT[clk] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %37 = firrtl.subfield %regs_io_debugX1_4_MPORT[data] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %38 = firrtl.subfield %regs_io_debugX1_5_MPORT[addr] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %39 = firrtl.subfield %regs_io_debugX1_5_MPORT[en] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %40 = firrtl.subfield %regs_io_debugX1_5_MPORT[clk] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %41 = firrtl.subfield %regs_io_debugX1_5_MPORT[data] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %42 = firrtl.subfield %regs_io_debugX1_6_MPORT[addr] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %43 = firrtl.subfield %regs_io_debugX1_6_MPORT[en] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %44 = firrtl.subfield %regs_io_debugX1_6_MPORT[clk] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %45 = firrtl.subfield %regs_io_debugX1_6_MPORT[data] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %46 = firrtl.subfield %regs_io_debugX1_7_MPORT[addr] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %47 = firrtl.subfield %regs_io_debugX1_7_MPORT[en] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %48 = firrtl.subfield %regs_io_debugX1_7_MPORT[clk] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %49 = firrtl.subfield %regs_io_debugX1_7_MPORT[data] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %50 = firrtl.subfield %regs_io_readData_0_MPORT[addr] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %51 = firrtl.subfield %regs_io_readData_0_MPORT[en] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %52 = firrtl.subfield %regs_io_readData_0_MPORT[clk] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %53 = firrtl.subfield %regs_io_readData_0_MPORT[data] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %54 = firrtl.subfield %regs_io_readData_1_MPORT[addr] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %55 = firrtl.subfield %regs_io_readData_1_MPORT[en] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %56 = firrtl.subfield %regs_io_readData_1_MPORT[clk] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %57 = firrtl.subfield %regs_io_readData_1_MPORT[data] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %effectiveDst = firrtl.cat %1, %12 {name = "effectiveDst"} : (!firrtl.uint<3>, !firrtl.uint<5>) -> !firrtl.uint<8>
      %58 = firrtl.orr %12 : (!firrtl.uint<5>) -> !firrtl.uint<1>
      %59 = firrtl.and %11, %58 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      firrtl.matchingconnect %13, %effectiveDst : !firrtl.uint<8>
      firrtl.matchingconnect %14, %59 : !firrtl.uint<1>
      firrtl.matchingconnect %15, %clock : !firrtl.clock
      firrtl.matchingconnect %17, %c1_ui1 : !firrtl.uint<1>
      firrtl.matchingconnect %16, %10 : !firrtl.uint<32>
      %effectiveSrc = firrtl.cat %0, %9 {name = "effectiveSrc"} : (!firrtl.uint<3>, !firrtl.uint<5>) -> !firrtl.uint<8>
      %60 = firrtl.orr %9 : (!firrtl.uint<5>) -> !firrtl.uint<1>
      %_io_readData_0_T = firrtl.not %60 {name = "_io_readData_0_T"} : (!firrtl.uint<1>) -> !firrtl.uint<1>
      firrtl.matchingconnect %50, %effectiveSrc : !firrtl.uint<8>
      firrtl.matchingconnect %51, %c1_ui1 : !firrtl.uint<1>
      firrtl.matchingconnect %52, %clock : !firrtl.clock
      %_io_readData_0_T_1 = firrtl.mux(%_io_readData_0_T, %c0_ui32, %53) {name = "_io_readData_0_T_1"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %effectiveSrc_1 = firrtl.cat %0, %8 {name = "effectiveSrc_1"} : (!firrtl.uint<3>, !firrtl.uint<5>) -> !firrtl.uint<8>
      %61 = firrtl.orr %8 : (!firrtl.uint<5>) -> !firrtl.uint<1>
      %_io_readData_1_T = firrtl.not %61 {name = "_io_readData_1_T"} : (!firrtl.uint<1>) -> !firrtl.uint<1>
      firrtl.matchingconnect %54, %effectiveSrc_1 : !firrtl.uint<8>
      firrtl.matchingconnect %55, %c1_ui1 : !firrtl.uint<1>
      firrtl.matchingconnect %56, %clock : !firrtl.clock
      %_io_readData_1_T_1 = firrtl.mux(%_io_readData_1_T, %c0_ui32, %57) {name = "_io_readData_1_T_1"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      firrtl.matchingconnect %18, %c1_ui8 : !firrtl.uint<8>
      firrtl.matchingconnect %19, %c1_ui1 : !firrtl.uint<1>
      firrtl.matchingconnect %20, %clock : !firrtl.clock
      firrtl.matchingconnect %22, %c33_ui8 : !firrtl.uint<8>
      firrtl.matchingconnect %23, %c1_ui1 : !firrtl.uint<1>
      firrtl.matchingconnect %24, %clock : !firrtl.clock
      firrtl.matchingconnect %26, %c65_ui8 : !firrtl.uint<8>
      firrtl.matchingconnect %27, %c1_ui1 : !firrtl.uint<1>
      firrtl.matchingconnect %28, %clock : !firrtl.clock
      firrtl.matchingconnect %30, %c97_ui8 : !firrtl.uint<8>
      firrtl.matchingconnect %31, %c1_ui1 : !firrtl.uint<1>
      firrtl.matchingconnect %32, %clock : !firrtl.clock
      firrtl.matchingconnect %34, %c129_ui8 : !firrtl.uint<8>
      firrtl.matchingconnect %35, %c1_ui1 : !firrtl.uint<1>
      firrtl.matchingconnect %36, %clock : !firrtl.clock
      firrtl.matchingconnect %38, %c161_ui8 : !firrtl.uint<8>
      firrtl.matchingconnect %39, %c1_ui1 : !firrtl.uint<1>
      firrtl.matchingconnect %40, %clock : !firrtl.clock
      firrtl.matchingconnect %42, %c193_ui8 : !firrtl.uint<8>
      firrtl.matchingconnect %43, %c1_ui1 : !firrtl.uint<1>
      firrtl.matchingconnect %44, %clock : !firrtl.clock
      firrtl.matchingconnect %46, %c225_ui8 : !firrtl.uint<8>
      firrtl.matchingconnect %47, %c1_ui1 : !firrtl.uint<1>
      firrtl.matchingconnect %48, %clock : !firrtl.clock
      %62 = firrtl.vectorcreate %_io_readData_0_T_1, %_io_readData_1_T_1 : (!firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.vector<uint<32>, 2>
      %63 = firrtl.vectorcreate %21, %25, %29, %33, %37, %41, %45, %49 : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.vector<uint<32>, 8>
      %64 = firrtl.bundlecreate %io_readThreadID, %io_writeThreadID, %io_readAddrs, %62, %io_writeAddrs, %io_wens, %io_writeData, %63 : (!firrtl.uint<3>, !firrtl.uint<3>, !firrtl.vector<uint<5>, 2>, !firrtl.vector<uint<32>, 2>, !firrtl.vector<uint<5>, 1>, !firrtl.vector<uint<1>, 1>, !firrtl.vector<uint<32>, 1>, !firrtl.vector<uint<32>, 8>) -> !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 8>>
      firrtl.matchingconnect %io, %64 : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 8>>
    }
    firrtl.module private @ALU32(in %io_a: !firrtl.uint<32>, in %io_b: !firrtl.uint<32>, in %io_opcode: !firrtl.uint<5>, out %io_result: !firrtl.uint<32>) {
      %c14_ui5 = firrtl.constant 14 : !firrtl.uint<5>
      %c12_ui5 = firrtl.constant 12 : !firrtl.uint<5>
      %c11_ui5 = firrtl.constant 11 : !firrtl.uint<5>
      %c10_ui5 = firrtl.constant 10 : !firrtl.uint<5>
      %c8_ui5 = firrtl.constant 8 : !firrtl.uint<5>
      %c6_ui5 = firrtl.constant 6 : !firrtl.uint<5>
      %c4_ui5 = firrtl.constant 4 : !firrtl.uint<5>
      %c2_ui5 = firrtl.constant 2 : !firrtl.uint<5>
      %c1_ui5 = firrtl.constant 1 : !firrtl.uint<5>
      %c0_ui32 = firrtl.constant 0 : !firrtl.uint<32>
      %io = firrtl.wire : !firrtl.bundle<a: uint<32>, b: uint<32>, opcode: uint<5>, result: uint<32>>
      %0 = firrtl.subfield %io[a] : !firrtl.bundle<a: uint<32>, b: uint<32>, opcode: uint<5>, result: uint<32>>
      %1 = firrtl.subfield %io[b] : !firrtl.bundle<a: uint<32>, b: uint<32>, opcode: uint<5>, result: uint<32>>
      %2 = firrtl.subfield %io[opcode] : !firrtl.bundle<a: uint<32>, b: uint<32>, opcode: uint<5>, result: uint<32>>
      %3 = firrtl.subfield %io[result] : !firrtl.bundle<a: uint<32>, b: uint<32>, opcode: uint<5>, result: uint<32>>
      firrtl.matchingconnect %io_result, %3 : !firrtl.uint<32>
      %shamt = firrtl.bits %1 4 to 0 {name = "shamt"} : (!firrtl.uint<32>) -> !firrtl.uint<5>
      %_sraResult_T = firrtl.asSInt %0 {name = "_sraResult_T"} : (!firrtl.uint<32>) -> !firrtl.sint<32>
      %_sltResult_T_1 = firrtl.asSInt %1 {name = "_sltResult_T_1"} : (!firrtl.uint<32>) -> !firrtl.sint<32>
      %_addResult_T_2 = firrtl.add %_sraResult_T, %_sltResult_T_1 {name = "_addResult_T_2"} : (!firrtl.sint<32>, !firrtl.sint<32>) -> !firrtl.sint<33>
      %_subResult_T_2 = firrtl.sub %_sraResult_T, %_sltResult_T_1 {name = "_subResult_T_2"} : (!firrtl.sint<32>, !firrtl.sint<32>) -> !firrtl.sint<33>
      %sllResult = firrtl.dshl %0, %shamt {name = "sllResult"} : (!firrtl.uint<32>, !firrtl.uint<5>) -> !firrtl.uint<63>
      %sltResult = firrtl.lt %_sraResult_T, %_sltResult_T_1 {name = "sltResult"} : (!firrtl.sint<32>, !firrtl.sint<32>) -> !firrtl.uint<1>
      %sltuResult = firrtl.lt %0, %1 {name = "sltuResult"} : (!firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<1>
      %xorResult = firrtl.xor %0, %1 {name = "xorResult"} : (!firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %srlResult = firrtl.dshr %0, %shamt {name = "srlResult"} : (!firrtl.uint<32>, !firrtl.uint<5>) -> !firrtl.uint<32>
      %_sraResult_T_1 = firrtl.dshr %_sraResult_T, %shamt {name = "_sraResult_T_1"} : (!firrtl.sint<32>, !firrtl.uint<5>) -> !firrtl.sint<32>
      %sraResult = firrtl.asUInt %_sraResult_T_1 {name = "sraResult"} : (!firrtl.sint<32>) -> !firrtl.uint<32>
      %orResult = firrtl.or %0, %1 {name = "orResult"} : (!firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %andResult = firrtl.and %0, %1 {name = "andResult"} : (!firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %4 = firrtl.orr %2 : (!firrtl.uint<5>) -> !firrtl.uint<1>
      %5 = firrtl.not %4 : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %6 = firrtl.bits %_addResult_T_2 31 to 0 : (!firrtl.sint<33>) -> !firrtl.uint<32>
      %7 = firrtl.eq %2, %c1_ui5 : (!firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<1>
      %8 = firrtl.bits %_subResult_T_2 31 to 0 : (!firrtl.sint<33>) -> !firrtl.uint<32>
      %9 = firrtl.eq %2, %c2_ui5 : (!firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<1>
      %10 = firrtl.bits %sllResult 31 to 0 : (!firrtl.uint<63>) -> !firrtl.uint<32>
      %11 = firrtl.eq %2, %c4_ui5 : (!firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<1>
      %12 = firrtl.pad %sltResult, 32 : (!firrtl.uint<1>) -> !firrtl.uint<32>
      %13 = firrtl.eq %2, %c6_ui5 : (!firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<1>
      %14 = firrtl.pad %sltuResult, 32 : (!firrtl.uint<1>) -> !firrtl.uint<32>
      %15 = firrtl.eq %2, %c8_ui5 : (!firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<1>
      %16 = firrtl.eq %2, %c10_ui5 : (!firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<1>
      %17 = firrtl.eq %2, %c11_ui5 : (!firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<1>
      %18 = firrtl.eq %2, %c12_ui5 : (!firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<1>
      %19 = firrtl.eq %2, %c14_ui5 : (!firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<1>
      %20 = firrtl.mux(%19, %andResult, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %21 = firrtl.mux(%18, %orResult, %20) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %22 = firrtl.mux(%17, %sraResult, %21) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %23 = firrtl.mux(%16, %srlResult, %22) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %24 = firrtl.mux(%15, %xorResult, %23) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %25 = firrtl.mux(%13, %14, %24) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %26 = firrtl.mux(%11, %12, %25) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %27 = firrtl.mux(%9, %10, %26) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %28 = firrtl.mux(%7, %8, %27) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %result = firrtl.mux(%5, %6, %28) {name = "result"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %29 = firrtl.bundlecreate %io_a, %io_b, %io_opcode, %result : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<5>, !firrtl.uint<32>) -> !firrtl.bundle<a: uint<32>, b: uint<32>, opcode: uint<5>, result: uint<32>>
      firrtl.matchingconnect %io, %29 : !firrtl.bundle<a: uint<32>, b: uint<32>, opcode: uint<5>, result: uint<32>>
    }
    firrtl.module private @Mul32OneCycle(in %io_a: !firrtl.uint<32>, in %io_b: !firrtl.uint<32>, in %io_signedA: !firrtl.uint<1>, in %io_signedB: !firrtl.uint<1>, out %io_product: !firrtl.uint<64>, out %io_lo: !firrtl.uint<32>, out %io_hi: !firrtl.uint<32>) {
      %io = firrtl.wire : !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      %0 = firrtl.subfield %io[a] : !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      %1 = firrtl.subfield %io[b] : !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      %2 = firrtl.subfield %io[signedA] : !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      %3 = firrtl.subfield %io[signedB] : !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      %4 = firrtl.subfield %io[product] : !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      firrtl.matchingconnect %io_product, %4 : !firrtl.uint<64>
      %5 = firrtl.subfield %io[lo] : !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      firrtl.matchingconnect %io_lo, %5 : !firrtl.uint<32>
      %6 = firrtl.subfield %io[hi] : !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      firrtl.matchingconnect %io_hi, %6 : !firrtl.uint<32>
      %_opA_T = firrtl.asSInt %0 {name = "_opA_T"} : (!firrtl.uint<32>) -> !firrtl.sint<32>
      %7 = firrtl.pad %0, 33 : (!firrtl.uint<32>) -> !firrtl.uint<33>
      %_opA_T_1 = firrtl.asSInt %7 {name = "_opA_T_1"} : (!firrtl.uint<33>) -> !firrtl.sint<33>
      %8 = firrtl.pad %_opA_T, 33 : (!firrtl.sint<32>) -> !firrtl.sint<33>
      %opA = firrtl.mux(%2, %8, %_opA_T_1) {name = "opA"} : (!firrtl.uint<1>, !firrtl.sint<33>, !firrtl.sint<33>) -> !firrtl.sint<33>
      %_opB_T = firrtl.asSInt %1 {name = "_opB_T"} : (!firrtl.uint<32>) -> !firrtl.sint<32>
      %9 = firrtl.pad %1, 33 : (!firrtl.uint<32>) -> !firrtl.uint<33>
      %_opB_T_1 = firrtl.asSInt %9 {name = "_opB_T_1"} : (!firrtl.uint<33>) -> !firrtl.sint<33>
      %10 = firrtl.pad %_opB_T, 33 : (!firrtl.sint<32>) -> !firrtl.sint<33>
      %opB = firrtl.mux(%3, %10, %_opB_T_1) {name = "opB"} : (!firrtl.uint<1>, !firrtl.sint<33>, !firrtl.sint<33>) -> !firrtl.sint<33>
      %_prod_T = firrtl.mul %opA, %opB {name = "_prod_T"} : (!firrtl.sint<33>, !firrtl.sint<33>) -> !firrtl.sint<66>
      %prod64 = firrtl.bits %_prod_T 63 to 0 {name = "prod64"} : (!firrtl.sint<66>) -> !firrtl.uint<64>
      %_io_lo_T = firrtl.bits %_prod_T 31 to 0 {name = "_io_lo_T"} : (!firrtl.sint<66>) -> !firrtl.uint<32>
      %_io_hi_T = firrtl.bits %_prod_T 63 to 32 {name = "_io_hi_T"} : (!firrtl.sint<66>) -> !firrtl.uint<32>
      %11 = firrtl.bundlecreate %io_a, %io_b, %io_signedA, %io_signedB, %prod64, %_io_lo_T, %_io_hi_T : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<64>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      firrtl.matchingconnect %io, %11 : !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
    }
    firrtl.module private @BranchUnit(in %io_rs1: !firrtl.uint<32>, in %io_rs2: !firrtl.uint<32>, in %io_pc: !firrtl.uint<32>, in %io_imm: !firrtl.sint<32>, in %io_branchOp: !firrtl.uint<3>, in %io_valid: !firrtl.uint<1>, out %io_taken: !firrtl.uint<1>, out %io_target: !firrtl.uint<32>, out %io_nextPc: !firrtl.uint<32>, out %io_misaligned: !firrtl.uint<1>) {
      %c6_ui3 = firrtl.constant 6 : !firrtl.uint<3>
      %c5_ui3 = firrtl.constant 5 : !firrtl.uint<3>
      %c4_ui3 = firrtl.constant 4 : !firrtl.uint<3>
      %c1_ui1 = firrtl.constant 1 : !firrtl.uint<1>
      %c0_ui1 = firrtl.constant 0 : !firrtl.uint<1>
      %c4294967292_ui32 = firrtl.constant 4294967292 : !firrtl.uint<32>
      %io = firrtl.wire : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      %0 = firrtl.subfield %io[rs1] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      %1 = firrtl.subfield %io[rs2] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      %2 = firrtl.subfield %io[pc] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      %3 = firrtl.subfield %io[imm] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      %4 = firrtl.subfield %io[branchOp] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      %5 = firrtl.subfield %io[valid] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      %6 = firrtl.subfield %io[taken] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      firrtl.matchingconnect %io_taken, %6 : !firrtl.uint<1>
      %7 = firrtl.subfield %io[target] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      firrtl.matchingconnect %io_target, %7 : !firrtl.uint<32>
      %8 = firrtl.subfield %io[nextPc] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      firrtl.matchingconnect %io_nextPc, %8 : !firrtl.uint<32>
      %9 = firrtl.subfield %io[misaligned] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      firrtl.matchingconnect %io_misaligned, %9 : !firrtl.uint<1>
      %_targetAddr_T = firrtl.asSInt %2 {name = "_targetAddr_T"} : (!firrtl.uint<32>) -> !firrtl.sint<32>
      %_targetAddr_T_1 = firrtl.add %_targetAddr_T, %3 {name = "_targetAddr_T_1"} : (!firrtl.sint<32>, !firrtl.sint<32>) -> !firrtl.sint<33>
      %targetAddr = firrtl.bits %_targetAddr_T_1 31 to 0 {name = "targetAddr"} : (!firrtl.sint<33>) -> !firrtl.uint<32>
      %_io_target_T = firrtl.and %targetAddr, %c4294967292_ui32 {name = "_io_target_T"} : (!firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %_io_misaligned_T = firrtl.bits %_targetAddr_T_1 1 to 0 {name = "_io_misaligned_T"} : (!firrtl.sint<33>) -> !firrtl.uint<2>
      %_io_misaligned_T_1 = firrtl.orr %_io_misaligned_T {name = "_io_misaligned_T_1"} : (!firrtl.uint<2>) -> !firrtl.uint<1>
      %10 = firrtl.orr %4 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %_io_taken_T = firrtl.not %10 {name = "_io_taken_T"} : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_taken_T_1 = firrtl.eq %0, %1 {name = "_io_taken_T_1"} : (!firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<1>
      %_io_taken_T_2 = firrtl.eq %4, %c1_ui1 {name = "_io_taken_T_2"} : (!firrtl.uint<3>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_taken_T_3 = firrtl.neq %0, %1 {name = "_io_taken_T_3"} : (!firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<1>
      %_io_taken_T_4 = firrtl.eq %4, %c4_ui3 {name = "_io_taken_T_4"} : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %_io_taken_T_9 = firrtl.asSInt %0 {name = "_io_taken_T_9"} : (!firrtl.uint<32>) -> !firrtl.sint<32>
      %_io_taken_T_10 = firrtl.asSInt %1 {name = "_io_taken_T_10"} : (!firrtl.uint<32>) -> !firrtl.sint<32>
      %_io_taken_T_7 = firrtl.lt %_io_taken_T_9, %_io_taken_T_10 {name = "_io_taken_T_7"} : (!firrtl.sint<32>, !firrtl.sint<32>) -> !firrtl.uint<1>
      %_io_taken_T_8 = firrtl.eq %4, %c5_ui3 {name = "_io_taken_T_8"} : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %_io_taken_T_11 = firrtl.geq %_io_taken_T_9, %_io_taken_T_10 {name = "_io_taken_T_11"} : (!firrtl.sint<32>, !firrtl.sint<32>) -> !firrtl.uint<1>
      %_io_taken_T_12 = firrtl.eq %4, %c6_ui3 {name = "_io_taken_T_12"} : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %_io_taken_T_13 = firrtl.lt %0, %1 {name = "_io_taken_T_13"} : (!firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<1>
      %_io_taken_T_14 = firrtl.andr %4 {name = "_io_taken_T_14"} : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %_io_taken_T_15 = firrtl.geq %0, %1 {name = "_io_taken_T_15"} : (!firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<1>
      %_io_taken_T_16 = firrtl.mux(%_io_taken_T_14, %_io_taken_T_15, %c0_ui1) {name = "_io_taken_T_16"} : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_taken_T_17 = firrtl.mux(%_io_taken_T_12, %_io_taken_T_13, %_io_taken_T_16) {name = "_io_taken_T_17"} : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_taken_T_18 = firrtl.mux(%_io_taken_T_8, %_io_taken_T_11, %_io_taken_T_17) {name = "_io_taken_T_18"} : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_taken_T_19 = firrtl.mux(%_io_taken_T_4, %_io_taken_T_7, %_io_taken_T_18) {name = "_io_taken_T_19"} : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_taken_T_20 = firrtl.mux(%_io_taken_T_2, %_io_taken_T_3, %_io_taken_T_19) {name = "_io_taken_T_20"} : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_taken_T_21 = firrtl.mux(%_io_taken_T, %_io_taken_T_1, %_io_taken_T_20) {name = "_io_taken_T_21"} : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_taken_T_22 = firrtl.and %_io_taken_T_21, %5 {name = "_io_taken_T_22"} : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_taken_T_23 = firrtl.not %9 {name = "_io_taken_T_23"} : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_taken_T_24 = firrtl.and %_io_taken_T_22, %_io_taken_T_23 {name = "_io_taken_T_24"} : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_nextPc_T = firrtl.add %2, %c4_ui3 {name = "_io_nextPc_T"} : (!firrtl.uint<32>, !firrtl.uint<3>) -> !firrtl.uint<33>
      %_io_nextPc_T_1 = firrtl.bits %_io_nextPc_T 31 to 0 {name = "_io_nextPc_T_1"} : (!firrtl.uint<33>) -> !firrtl.uint<32>
      %_io_nextPc_T_2 = firrtl.mux(%6, %7, %_io_nextPc_T_1) {name = "_io_nextPc_T_2"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %11 = firrtl.bundlecreate %io_rs1, %io_rs2, %io_pc, %io_imm, %io_branchOp, %io_valid, %_io_taken_T_24, %_io_target_T, %_io_nextPc_T_2, %_io_misaligned_T_1 : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.sint<32>, !firrtl.uint<3>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<1>) -> !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      firrtl.matchingconnect %io, %11 : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
    }
    firrtl.module private @LoadUnit(in %io_addr: !firrtl.uint<32>, in %io_dataIn: !firrtl.uint<32>, in %io_funct3: !firrtl.uint<3>, out %io_dataOut: !firrtl.uint<32>) {
      %c0_ui2 = firrtl.constant 0 : !firrtl.uint<2>
      %c1_ui2 = firrtl.constant 1 : !firrtl.uint<2>
      %c2_ui2 = firrtl.constant 2 : !firrtl.uint<2>
      %c5_ui3 = firrtl.constant 5 : !firrtl.uint<3>
      %c1_ui1 = firrtl.constant 1 : !firrtl.uint<1>
      %c4_ui3 = firrtl.constant 4 : !firrtl.uint<3>
      %io = firrtl.wire : !firrtl.bundle<addr: uint<32>, dataIn: uint<32>, funct3: uint<3>, dataOut: uint<32>>
      %0 = firrtl.subfield %io[addr] : !firrtl.bundle<addr: uint<32>, dataIn: uint<32>, funct3: uint<3>, dataOut: uint<32>>
      %1 = firrtl.subfield %io[dataIn] : !firrtl.bundle<addr: uint<32>, dataIn: uint<32>, funct3: uint<3>, dataOut: uint<32>>
      %2 = firrtl.subfield %io[funct3] : !firrtl.bundle<addr: uint<32>, dataIn: uint<32>, funct3: uint<3>, dataOut: uint<32>>
      %3 = firrtl.subfield %io[dataOut] : !firrtl.bundle<addr: uint<32>, dataIn: uint<32>, funct3: uint<3>, dataOut: uint<32>>
      firrtl.matchingconnect %io_dataOut, %3 : !firrtl.uint<32>
      %4 = firrtl.orr %2 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %_isSigned_T = firrtl.not %4 {name = "_isSigned_T"} : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %_loadWidth_T_1 = firrtl.eq %2, %c4_ui3 {name = "_loadWidth_T_1"} : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %_loadWidth_T_2 = firrtl.or %_isSigned_T, %_loadWidth_T_1 {name = "_loadWidth_T_2"} : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_isSigned_T_1 = firrtl.eq %2, %c1_ui1 {name = "_isSigned_T_1"} : (!firrtl.uint<3>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_loadWidth_T_4 = firrtl.eq %2, %c5_ui3 {name = "_loadWidth_T_4"} : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %_loadWidth_T_5 = firrtl.or %_isSigned_T_1, %_loadWidth_T_4 {name = "_loadWidth_T_5"} : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_isSigned_T_3 = firrtl.eq %2, %c2_ui2 {name = "_isSigned_T_3"} : (!firrtl.uint<3>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %_loadWidth_T_8 = firrtl.mux(%_loadWidth_T_5, %c1_ui2, %c2_ui2) {name = "_loadWidth_T_8"} : (!firrtl.uint<1>, !firrtl.uint<2>, !firrtl.uint<2>) -> !firrtl.uint<2>
      %loadWidth = firrtl.mux(%_loadWidth_T_2, %c0_ui2, %_loadWidth_T_8) {name = "loadWidth"} : (!firrtl.uint<1>, !firrtl.uint<2>, !firrtl.uint<2>) -> !firrtl.uint<2>
      %_isSigned_T_2 = firrtl.or %_isSigned_T, %_isSigned_T_1 {name = "_isSigned_T_2"} : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %isSigned = firrtl.or %_isSigned_T_2, %_isSigned_T_3 {name = "isSigned"} : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_byteShift_T = firrtl.bits %0 1 to 0 {name = "_byteShift_T"} : (!firrtl.uint<32>) -> !firrtl.uint<2>
      %byteShift = firrtl.shl %_byteShift_T, 3 {name = "byteShift"} : (!firrtl.uint<2>) -> !firrtl.uint<5>
      %aligned = firrtl.dshr %1, %byteShift {name = "aligned"} : (!firrtl.uint<32>, !firrtl.uint<5>) -> !firrtl.uint<32>
      %byteLane = firrtl.bits %aligned 7 to 0 {name = "byteLane"} : (!firrtl.uint<32>) -> !firrtl.uint<8>
      %halfLane = firrtl.bits %aligned 15 to 0 {name = "halfLane"} : (!firrtl.uint<32>) -> !firrtl.uint<16>
      %5 = firrtl.orr %loadWidth : (!firrtl.uint<2>) -> !firrtl.uint<1>
      %_unsignedData_T = firrtl.not %5 {name = "_unsignedData_T"} : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %_signedData_T_1 = firrtl.asSInt %byteLane {name = "_signedData_T_1"} : (!firrtl.uint<8>) -> !firrtl.sint<8>
      %_signedData_T_2 = firrtl.pad %_signedData_T_1, 32 {name = "_signedData_T_2"} : (!firrtl.sint<8>) -> !firrtl.sint<32>
      %_signedData_T_3 = firrtl.asUInt %_signedData_T_2 {name = "_signedData_T_3"} : (!firrtl.sint<32>) -> !firrtl.uint<32>
      %_unsignedData_T_4 = firrtl.eq %loadWidth, %c1_ui1 {name = "_unsignedData_T_4"} : (!firrtl.uint<2>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_signedData_T_5 = firrtl.asSInt %halfLane {name = "_signedData_T_5"} : (!firrtl.uint<16>) -> !firrtl.sint<16>
      %_signedData_T_6 = firrtl.pad %_signedData_T_5, 32 {name = "_signedData_T_6"} : (!firrtl.sint<16>) -> !firrtl.sint<32>
      %_signedData_T_7 = firrtl.asUInt %_signedData_T_6 {name = "_signedData_T_7"} : (!firrtl.sint<32>) -> !firrtl.uint<32>
      %_signedData_T_8 = firrtl.mux(%_unsignedData_T_4, %_signedData_T_7, %1) {name = "_signedData_T_8"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %signedData = firrtl.mux(%_unsignedData_T, %_signedData_T_3, %_signedData_T_8) {name = "signedData"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %6 = firrtl.pad %byteLane, 9 : (!firrtl.uint<8>) -> !firrtl.uint<9>
      %_unsignedData_T_1 = firrtl.asSInt %6 {name = "_unsignedData_T_1"} : (!firrtl.uint<9>) -> !firrtl.sint<9>
      %_unsignedData_T_2 = firrtl.pad %_unsignedData_T_1, 32 {name = "_unsignedData_T_2"} : (!firrtl.sint<9>) -> !firrtl.sint<32>
      %_unsignedData_T_3 = firrtl.asUInt %_unsignedData_T_2 {name = "_unsignedData_T_3"} : (!firrtl.sint<32>) -> !firrtl.uint<32>
      %7 = firrtl.pad %halfLane, 17 : (!firrtl.uint<16>) -> !firrtl.uint<17>
      %_unsignedData_T_5 = firrtl.asSInt %7 {name = "_unsignedData_T_5"} : (!firrtl.uint<17>) -> !firrtl.sint<17>
      %_unsignedData_T_6 = firrtl.pad %_unsignedData_T_5, 32 {name = "_unsignedData_T_6"} : (!firrtl.sint<17>) -> !firrtl.sint<32>
      %_unsignedData_T_7 = firrtl.asUInt %_unsignedData_T_6 {name = "_unsignedData_T_7"} : (!firrtl.sint<32>) -> !firrtl.uint<32>
      %_unsignedData_T_8 = firrtl.mux(%_unsignedData_T_4, %_unsignedData_T_7, %1) {name = "_unsignedData_T_8"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %unsignedData = firrtl.mux(%_unsignedData_T, %_unsignedData_T_3, %_unsignedData_T_8) {name = "unsignedData"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %_io_dataOut_T = firrtl.mux(%isSigned, %signedData, %unsignedData) {name = "_io_dataOut_T"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %8 = firrtl.bundlecreate %io_addr, %io_dataIn, %io_funct3, %_io_dataOut_T : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<3>, !firrtl.uint<32>) -> !firrtl.bundle<addr: uint<32>, dataIn: uint<32>, funct3: uint<3>, dataOut: uint<32>>
      firrtl.matchingconnect %io, %8 : !firrtl.bundle<addr: uint<32>, dataIn: uint<32>, funct3: uint<3>, dataOut: uint<32>>
    }
    firrtl.module private @StoreUnit(in %io_addr: !firrtl.uint<32>, in %io_data: !firrtl.uint<32>, in %io_storeType: !firrtl.uint<2>, out %io_memWrite: !firrtl.uint<32>, out %io_mask: !firrtl.uint<4>, out %io_misaligned: !firrtl.uint<1>) {
      %c0_ui32 = firrtl.constant 0 : !firrtl.uint<32>
      %c16_ui5 = firrtl.constant 16 : !firrtl.uint<5>
      %c8_ui4 = firrtl.constant 8 : !firrtl.uint<4>
      %c0_ui4 = firrtl.constant 0 : !firrtl.uint<4>
      %c15_ui4 = firrtl.constant 15 : !firrtl.uint<4>
      %c3_ui4 = firrtl.constant 3 : !firrtl.uint<4>
      %c1_ui4 = firrtl.constant 1 : !firrtl.uint<4>
      %c2_ui2 = firrtl.constant 2 : !firrtl.uint<2>
      %c1_ui1 = firrtl.constant 1 : !firrtl.uint<1>
      %c0_ui1 = firrtl.constant 0 : !firrtl.uint<1>
      %io = firrtl.wire : !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      %0 = firrtl.subfield %io[addr] : !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      %1 = firrtl.subfield %io[data] : !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      %2 = firrtl.subfield %io[storeType] : !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      %3 = firrtl.subfield %io[memWrite] : !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      firrtl.matchingconnect %io_memWrite, %3 : !firrtl.uint<32>
      %4 = firrtl.subfield %io[mask] : !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      firrtl.matchingconnect %io_mask, %4 : !firrtl.uint<4>
      %5 = firrtl.subfield %io[misaligned] : !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      firrtl.matchingconnect %io_misaligned, %5 : !firrtl.uint<1>
      %_io_misaligned_T_1 = firrtl.bits %0 0 to 0 {name = "_io_misaligned_T_1"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_io_memWrite_T_2 = firrtl.bits %0 1 to 0 {name = "_io_memWrite_T_2"} : (!firrtl.uint<32>) -> !firrtl.uint<2>
      %_io_misaligned_T_3 = firrtl.orr %_io_memWrite_T_2 {name = "_io_misaligned_T_3"} : (!firrtl.uint<2>) -> !firrtl.uint<1>
      %_io_memWrite_T_5 = firrtl.eq %2, %c1_ui1 {name = "_io_memWrite_T_5"} : (!firrtl.uint<2>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_memWrite_T_10 = firrtl.eq %2, %c2_ui2 {name = "_io_memWrite_T_10"} : (!firrtl.uint<2>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %_io_misaligned_T_4 = firrtl.mux(%_io_memWrite_T_10, %_io_misaligned_T_3, %c0_ui1) {name = "_io_misaligned_T_4"} : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_misaligned_T_5 = firrtl.mux(%_io_memWrite_T_5, %_io_misaligned_T_1, %_io_misaligned_T_4) {name = "_io_misaligned_T_5"} : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %6 = firrtl.orr %2 : (!firrtl.uint<2>) -> !firrtl.uint<1>
      %_io_memWrite_T = firrtl.not %6 {name = "_io_memWrite_T"} : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_mask_T_2 = firrtl.dshl %c1_ui4, %_io_memWrite_T_2 {name = "_io_mask_T_2"} : (!firrtl.uint<4>, !firrtl.uint<2>) -> !firrtl.uint<7>
      %_io_mask_T_5 = firrtl.dshl %c3_ui4, %_io_memWrite_T_2 {name = "_io_mask_T_5"} : (!firrtl.uint<4>, !firrtl.uint<2>) -> !firrtl.uint<7>
      %_io_mask_T_7 = firrtl.mux(%_io_memWrite_T_10, %c15_ui4, %c0_ui4) {name = "_io_mask_T_7"} : (!firrtl.uint<1>, !firrtl.uint<4>, !firrtl.uint<4>) -> !firrtl.uint<4>
      %7 = firrtl.pad %_io_mask_T_7, 7 : (!firrtl.uint<4>) -> !firrtl.uint<7>
      %_io_mask_T_8 = firrtl.mux(%_io_memWrite_T_5, %_io_mask_T_5, %7) {name = "_io_mask_T_8"} : (!firrtl.uint<1>, !firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<7>
      %_io_mask_T_9 = firrtl.mux(%_io_memWrite_T, %_io_mask_T_2, %_io_mask_T_8) {name = "_io_mask_T_9"} : (!firrtl.uint<1>, !firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<7>
      %8 = firrtl.bits %_io_mask_T_9 3 to 0 : (!firrtl.uint<7>) -> !firrtl.uint<4>
      %_io_memWrite_T_1 = firrtl.bits %1 7 to 0 {name = "_io_memWrite_T_1"} : (!firrtl.uint<32>) -> !firrtl.uint<8>
      %_io_memWrite_T_3 = firrtl.mul %_io_memWrite_T_2, %c8_ui4 {name = "_io_memWrite_T_3"} : (!firrtl.uint<2>, !firrtl.uint<4>) -> !firrtl.uint<6>
      %_io_memWrite_T_4 = firrtl.dshl %_io_memWrite_T_1, %_io_memWrite_T_3 {name = "_io_memWrite_T_4"} : (!firrtl.uint<8>, !firrtl.uint<6>) -> !firrtl.uint<71>
      %_io_memWrite_T_6 = firrtl.bits %1 15 to 0 {name = "_io_memWrite_T_6"} : (!firrtl.uint<32>) -> !firrtl.uint<16>
      %_io_memWrite_T_7 = firrtl.bits %0 1 to 1 {name = "_io_memWrite_T_7"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_io_memWrite_T_8 = firrtl.mul %_io_memWrite_T_7, %c16_ui5 {name = "_io_memWrite_T_8"} : (!firrtl.uint<1>, !firrtl.uint<5>) -> !firrtl.uint<6>
      %_io_memWrite_T_9 = firrtl.dshl %_io_memWrite_T_6, %_io_memWrite_T_8 {name = "_io_memWrite_T_9"} : (!firrtl.uint<16>, !firrtl.uint<6>) -> !firrtl.uint<79>
      %_io_memWrite_T_11 = firrtl.mux(%_io_memWrite_T_10, %1, %c0_ui32) {name = "_io_memWrite_T_11"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %9 = firrtl.pad %_io_memWrite_T_11, 79 : (!firrtl.uint<32>) -> !firrtl.uint<79>
      %_io_memWrite_T_12 = firrtl.mux(%_io_memWrite_T_5, %_io_memWrite_T_9, %9) {name = "_io_memWrite_T_12"} : (!firrtl.uint<1>, !firrtl.uint<79>, !firrtl.uint<79>) -> !firrtl.uint<79>
      %10 = firrtl.pad %_io_memWrite_T_4, 79 : (!firrtl.uint<71>) -> !firrtl.uint<79>
      %_io_memWrite_T_13 = firrtl.mux(%_io_memWrite_T, %10, %_io_memWrite_T_12) {name = "_io_memWrite_T_13"} : (!firrtl.uint<1>, !firrtl.uint<79>, !firrtl.uint<79>) -> !firrtl.uint<79>
      %11 = firrtl.bits %_io_memWrite_T_13 31 to 0 : (!firrtl.uint<79>) -> !firrtl.uint<32>
      %12 = firrtl.bundlecreate %io_addr, %io_data, %io_storeType, %11, %8, %_io_misaligned_T_5 : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<2>, !firrtl.uint<32>, !firrtl.uint<4>, !firrtl.uint<1>) -> !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      firrtl.matchingconnect %io, %12 : !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
    }
    firrtl.module @OctoNyteRV32IZmmulCore(in %clock: !firrtl.clock, in %reset: !firrtl.uint<1>, in %io_threadEnable: !firrtl.vector<uint<1>, 8>, in %io_instrMem: !firrtl.uint<128>, in %io_dataMemResp: !firrtl.uint<32>, out %io_memAddr: !firrtl.uint<32>, out %io_memWrite: !firrtl.uint<32>, out %io_memMask: !firrtl.uint<4>, out %io_memValid: !firrtl.uint<1>, out %io_memMisaligned: !firrtl.uint<1>, out %io_debugStageThreads_0: !firrtl.uint<0>, out %io_debugStageThreads_1: !firrtl.uint<0>, out %io_debugStageThreads_2: !firrtl.uint<0>, out %io_debugStageThreads_3: !firrtl.uint<0>, out %io_debugStageThreads_4: !firrtl.uint<0>, out %io_debugStageThreads_5: !firrtl.uint<0>, out %io_debugStageThreads_6: !firrtl.uint<0>, out %io_debugStageThreads_7: !firrtl.uint<0>, out %io_debugStageValids_0: !firrtl.uint<0>, out %io_debugStageValids_1: !firrtl.uint<0>, out %io_debugStageValids_2: !firrtl.uint<0>, out %io_debugStageValids_3: !firrtl.uint<0>, out %io_debugStageValids_4: !firrtl.uint<0>, out %io_debugStageValids_5: !firrtl.uint<0>, out %io_debugStageValids_6: !firrtl.uint<0>, out %io_debugStageValids_7: !firrtl.uint<0>, out %io_debugPC_0: !firrtl.uint<0>, out %io_debugPC_1: !firrtl.uint<0>, out %io_debugPC_2: !firrtl.uint<0>, out %io_debugPC_3: !firrtl.uint<0>, out %io_debugPC_4: !firrtl.uint<0>, out %io_debugPC_5: !firrtl.uint<0>, out %io_debugPC_6: !firrtl.uint<0>, out %io_debugPC_7: !firrtl.uint<0>, out %io_debugRegs01234_0_0: !firrtl.uint<0>, out %io_debugRegs01234_0_1: !firrtl.uint<0>, out %io_debugRegs01234_0_2: !firrtl.uint<0>, out %io_debugRegs01234_0_3: !firrtl.uint<0>, out %io_debugRegs01234_0_4: !firrtl.uint<0>, out %io_debugRegs01234_1_0: !firrtl.uint<0>, out %io_debugRegs01234_1_1: !firrtl.uint<0>, out %io_debugRegs01234_1_2: !firrtl.uint<0>, out %io_debugRegs01234_1_3: !firrtl.uint<0>, out %io_debugRegs01234_1_4: !firrtl.uint<0>, out %io_debugRegs01234_2_0: !firrtl.uint<0>, out %io_debugRegs01234_2_1: !firrtl.uint<0>, out %io_debugRegs01234_2_2: !firrtl.uint<0>, out %io_debugRegs01234_2_3: !firrtl.uint<0>, out %io_debugRegs01234_2_4: !firrtl.uint<0>, out %io_debugRegs01234_3_0: !firrtl.uint<0>, out %io_debugRegs01234_3_1: !firrtl.uint<0>, out %io_debugRegs01234_3_2: !firrtl.uint<0>, out %io_debugRegs01234_3_3: !firrtl.uint<0>, out %io_debugRegs01234_3_4: !firrtl.uint<0>, out %io_debugRegs01234_4_0: !firrtl.uint<0>, out %io_debugRegs01234_4_1: !firrtl.uint<0>, out %io_debugRegs01234_4_2: !firrtl.uint<0>, out %io_debugRegs01234_4_3: !firrtl.uint<0>, out %io_debugRegs01234_4_4: !firrtl.uint<0>, out %io_debugRegs01234_5_0: !firrtl.uint<0>, out %io_debugRegs01234_5_1: !firrtl.uint<0>, out %io_debugRegs01234_5_2: !firrtl.uint<0>, out %io_debugRegs01234_5_3: !firrtl.uint<0>, out %io_debugRegs01234_5_4: !firrtl.uint<0>, out %io_debugRegs01234_6_0: !firrtl.uint<0>, out %io_debugRegs01234_6_1: !firrtl.uint<0>, out %io_debugRegs01234_6_2: !firrtl.uint<0>, out %io_debugRegs01234_6_3: !firrtl.uint<0>, out %io_debugRegs01234_6_4: !firrtl.uint<0>, out %io_debugRegs01234_7_0: !firrtl.uint<0>, out %io_debugRegs01234_7_1: !firrtl.uint<0>, out %io_debugRegs01234_7_2: !firrtl.uint<0>, out %io_debugRegs01234_7_3: !firrtl.uint<0>, out %io_debugRegs01234_7_4: !firrtl.uint<0>, out %io_debugRegX1_0: !firrtl.uint<0>, out %io_debugRegX1_1: !firrtl.uint<0>, out %io_debugRegX1_2: !firrtl.uint<0>, out %io_debugRegX1_3: !firrtl.uint<0>, out %io_debugRegX1_4: !firrtl.uint<0>, out %io_debugRegX1_5: !firrtl.uint<0>, out %io_debugRegX1_6: !firrtl.uint<0>, out %io_debugRegX1_7: !firrtl.uint<0>, out %io_debugCtrlValid: !firrtl.uint<0>, out %io_debugCtrlInstr: !firrtl.uint<0>, out %io_debugCtrlTaken: !firrtl.uint<0>, out %io_debugCtrlThread: !firrtl.uint<0>, out %io_debugCtrlFromPC: !firrtl.uint<0>, out %io_debugCtrlTarget: !firrtl.uint<0>, out %io_debugCtrlIsBranch: !firrtl.uint<0>, out %io_debugCtrlIsJal: !firrtl.uint<0>, out %io_debugCtrlIsJalr: !firrtl.uint<0>, out %io_debugExecValid: !firrtl.uint<0>, out %io_debugExecThread: !firrtl.uint<0>, out %io_debugExecPC: !firrtl.uint<0>, out %io_debugExecInstr: !firrtl.uint<0>, out %io_debugExecIsBranch: !firrtl.uint<0>, out %io_debugExecIsJal: !firrtl.uint<0>, out %io_debugExecIsJalr: !firrtl.uint<0>, out %io_debugExecBranchOp: !firrtl.uint<0>, out %io_debugExecRs1: !firrtl.uint<0>, out %io_debugExecRs2: !firrtl.uint<0>, out %io_debugExecCtrlTaken: !firrtl.uint<0>, out %io_debugExecCtrlTarget: !firrtl.uint<0>, in %io_jtag_tck: !firrtl.uint<1>, in %io_jtag_tms: !firrtl.uint<1>, in %io_jtag_tdi: !firrtl.uint<1>, out %io_jtag_tdo: !firrtl.uint<1>, in %io_jtag_trst_n: !firrtl.uint<1>) {
      %0 = firrtl.aggregateconstant [[[[[[[[0 : ui1, 0 : ui3, 0 : ui32, 0 : ui32], [0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui5, 0 : ui5, 0 : ui5, 0 : ui5, 0 : ui32]]], 0 : ui32, 0 : ui32], 0 : ui32, 0 : ui1, 0 : ui1, 0 : ui32]]]] : !firrtl.bundle<exec3Signals: bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>>
      %1 = firrtl.aggregateconstant [[0 : ui32, 0 : ui32, 0 : ui32, 0 : ui32], [0 : ui32, 0 : ui32, 0 : ui32, 0 : ui32], [0 : ui32, 0 : ui32, 0 : ui32, 0 : ui32], [0 : ui32, 0 : ui32, 0 : ui32, 0 : ui32], [0 : ui32, 0 : ui32, 0 : ui32, 0 : ui32], [0 : ui32, 0 : ui32, 0 : ui32, 0 : ui32], [0 : ui32, 0 : ui32, 0 : ui32, 0 : ui32], [0 : ui32, 0 : ui32, 0 : ui32, 0 : ui32]] : !firrtl.vector<vector<uint<32>, 4>, 8>
      %2 = firrtl.aggregateconstant [2147483648 : ui32, 2147483648 : ui32, 2147483648 : ui32, 2147483648 : ui32, 2147483648 : ui32, 2147483648 : ui32, 2147483648 : ui32, 2147483648 : ui32] : !firrtl.vector<uint<32>, 8>
      %c0_ui32 = firrtl.constant 0 : !firrtl.uint<32>
      %c0_ui1 = firrtl.constant 0 : !firrtl.uint<1>
      %c0_ui5 = firrtl.constant 0 : !firrtl.uint<5>
      %3 = firrtl.aggregateconstant [[[[[[[0 : ui1, 0 : ui3, 0 : ui32, 0 : ui32], [0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui5, 0 : ui5, 0 : ui5, 0 : ui5, 0 : ui32]]], 0 : ui32, 0 : ui32], 0 : ui32, 0 : ui1, 0 : ui1, 0 : ui32]]] : !firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>
      %4 = firrtl.aggregateconstant [[[[[[0 : ui1, 0 : ui3, 0 : ui32, 0 : ui32], [0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui5, 0 : ui5, 0 : ui5, 0 : ui5, 0 : ui32]]], 0 : ui32, 0 : ui32], 0 : ui32, 0 : ui1, 0 : ui1, 0 : ui32]] : !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %5 = firrtl.aggregateconstant [[[[[0 : ui1, 0 : ui3, 0 : ui32, 0 : ui32], [0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui5, 0 : ui5, 0 : ui5, 0 : ui5, 0 : ui32]]], 0 : ui32, 0 : ui32], 0 : ui32, 0 : ui1, 0 : ui1, 0 : ui32] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %6 = firrtl.aggregateconstant [[[[0 : ui1, 0 : ui3, 0 : ui32, 0 : ui32], [0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui5, 0 : ui5, 0 : ui5, 0 : ui5, 0 : ui32]]], 0 : ui32, 0 : ui32] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %7 = firrtl.aggregateconstant [[[0 : ui1, 0 : ui3, 0 : ui32, 0 : ui32], [0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui5, 0 : ui5, 0 : ui5, 0 : ui5, 0 : ui32]]] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %8 = firrtl.aggregateconstant [[0 : ui1, 0 : ui3, 0 : ui32, 0 : ui32], [0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui1, 0 : ui5, 0 : ui5, 0 : ui5, 0 : ui5, 0 : ui32]] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %9 = firrtl.aggregateconstant [0 : ui1, 0 : ui3, 0 : ui32, 0 : ui32] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %c4294967294_ui32 = firrtl.constant 4294967294 : !firrtl.uint<32>
      %c0_ui12 = firrtl.constant 0 : !firrtl.uint<12>
      %c0_si32 = firrtl.constant 0 : !firrtl.sint<32>
      %c0_ui4 = firrtl.constant 0 : !firrtl.uint<4>
      %c0_ui0 = firrtl.constant 0 : !firrtl.uint<0> {name = "io_debugExecPC"}
      %c0_ui2 = firrtl.constant 0 : !firrtl.uint<2>
      %c1_ui7 = firrtl.constant 1 : !firrtl.uint<7>
      %c15_ui7 = firrtl.constant 15 : !firrtl.uint<7>
      %c115_ui7 = firrtl.constant 115 : !firrtl.uint<7>
      %c23_ui7 = firrtl.constant 23 : !firrtl.uint<7>
      %c55_ui7 = firrtl.constant 55 : !firrtl.uint<7>
      %c103_ui7 = firrtl.constant 103 : !firrtl.uint<7>
      %c0_ui11 = firrtl.constant 0 : !firrtl.uint<11>
      %c2047_ui11 = firrtl.constant 2047 : !firrtl.uint<11>
      %c111_ui7 = firrtl.constant 111 : !firrtl.uint<7>
      %c99_ui7 = firrtl.constant 99 : !firrtl.uint<7>
      %c35_ui7 = firrtl.constant 35 : !firrtl.uint<7>
      %c3_ui7 = firrtl.constant 3 : !firrtl.uint<7>
      %c0_ui20 = firrtl.constant 0 : !firrtl.uint<20>
      %c1048575_ui20 = firrtl.constant 1048575 : !firrtl.uint<20>
      %c19_ui7 = firrtl.constant 19 : !firrtl.uint<7>
      %c14_ui5 = firrtl.constant 14 : !firrtl.uint<5>
      %c12_ui5 = firrtl.constant 12 : !firrtl.uint<5>
      %c10_ui5 = firrtl.constant 10 : !firrtl.uint<5>
      %c11_ui5 = firrtl.constant 11 : !firrtl.uint<5>
      %c8_ui5 = firrtl.constant 8 : !firrtl.uint<5>
      %c6_ui5 = firrtl.constant 6 : !firrtl.uint<5>
      %c3_ui2 = firrtl.constant 3 : !firrtl.uint<2>
      %c4_ui5 = firrtl.constant 4 : !firrtl.uint<5>
      %c2_ui2 = firrtl.constant 2 : !firrtl.uint<2>
      %c2_ui5 = firrtl.constant 2 : !firrtl.uint<5>
      %c1_ui5 = firrtl.constant 1 : !firrtl.uint<5>
      %c32_ui6 = firrtl.constant 32 : !firrtl.uint<6>
      %c51_ui7 = firrtl.constant 51 : !firrtl.uint<7>
      %c6_ui3 = firrtl.constant 6 : !firrtl.uint<3>
      %c5_ui3 = firrtl.constant 5 : !firrtl.uint<3>
      %c3_ui3 = firrtl.constant 3 : !firrtl.uint<3>
      %c2_ui3 = firrtl.constant 2 : !firrtl.uint<3>
      %c1_ui3 = firrtl.constant 1 : !firrtl.uint<3>
      %c4_ui3 = firrtl.constant 4 : !firrtl.uint<3>
      %c1_ui1 = firrtl.constant 1 : !firrtl.uint<1>
      %c0_ui3 = firrtl.constant 0 : !firrtl.uint<3>
      %io_threadEnable_0 = firrtl.wire {name = "io_threadEnable"} : !firrtl.vector<uint<1>, 8>
      %io_memAddr_1 = firrtl.wire {name = "io_memAddr"} : !firrtl.uint<32>
      %io_memWrite_2 = firrtl.wire {name = "io_memWrite"} : !firrtl.uint<32>
      %io_memMask_3 = firrtl.wire {name = "io_memMask"} : !firrtl.uint<4>
      %io_memValid_4 = firrtl.wire {name = "io_memValid"} : !firrtl.uint<1>
      %io_memMisaligned_5 = firrtl.wire {name = "io_memMisaligned"} : !firrtl.uint<1>
      %io_debugStageThreads_0_6 = firrtl.wire {name = "io_debugStageThreads_0"} : !firrtl.uint<0>
      %io_debugStageThreads_1_7 = firrtl.wire {name = "io_debugStageThreads_1"} : !firrtl.uint<0>
      %io_debugStageThreads_2_8 = firrtl.wire {name = "io_debugStageThreads_2"} : !firrtl.uint<0>
      %io_debugStageThreads_3_9 = firrtl.wire {name = "io_debugStageThreads_3"} : !firrtl.uint<0>
      %io_debugStageThreads_4_10 = firrtl.wire {name = "io_debugStageThreads_4"} : !firrtl.uint<0>
      %io_debugStageThreads_5_11 = firrtl.wire {name = "io_debugStageThreads_5"} : !firrtl.uint<0>
      %io_debugStageThreads_6_12 = firrtl.wire {name = "io_debugStageThreads_6"} : !firrtl.uint<0>
      %io_debugStageThreads_7_13 = firrtl.wire {name = "io_debugStageThreads_7"} : !firrtl.uint<0>
      %io_debugStageValids_0_14 = firrtl.wire {name = "io_debugStageValids_0"} : !firrtl.uint<0>
      %io_debugStageValids_1_15 = firrtl.wire {name = "io_debugStageValids_1"} : !firrtl.uint<0>
      %io_debugStageValids_2_16 = firrtl.wire {name = "io_debugStageValids_2"} : !firrtl.uint<0>
      %io_debugStageValids_3_17 = firrtl.wire {name = "io_debugStageValids_3"} : !firrtl.uint<0>
      %io_debugStageValids_4_18 = firrtl.wire {name = "io_debugStageValids_4"} : !firrtl.uint<0>
      %io_debugStageValids_5_19 = firrtl.wire {name = "io_debugStageValids_5"} : !firrtl.uint<0>
      %io_debugStageValids_6_20 = firrtl.wire {name = "io_debugStageValids_6"} : !firrtl.uint<0>
      %io_debugStageValids_7_21 = firrtl.wire {name = "io_debugStageValids_7"} : !firrtl.uint<0>
      %io_debugPC_0_22 = firrtl.wire {name = "io_debugPC_0"} : !firrtl.uint<0>
      %io_debugPC_1_23 = firrtl.wire {name = "io_debugPC_1"} : !firrtl.uint<0>
      %io_debugPC_2_24 = firrtl.wire {name = "io_debugPC_2"} : !firrtl.uint<0>
      %io_debugPC_3_25 = firrtl.wire {name = "io_debugPC_3"} : !firrtl.uint<0>
      %io_debugPC_4_26 = firrtl.wire {name = "io_debugPC_4"} : !firrtl.uint<0>
      %io_debugPC_5_27 = firrtl.wire {name = "io_debugPC_5"} : !firrtl.uint<0>
      %io_debugPC_6_28 = firrtl.wire {name = "io_debugPC_6"} : !firrtl.uint<0>
      %io_debugPC_7_29 = firrtl.wire {name = "io_debugPC_7"} : !firrtl.uint<0>
      %io_debugRegs01234_0_1_30 = firrtl.wire {name = "io_debugRegs01234_0_1"} : !firrtl.uint<0>
      %io_debugRegs01234_0_2_31 = firrtl.wire {name = "io_debugRegs01234_0_2"} : !firrtl.uint<0>
      %io_debugRegs01234_0_3_32 = firrtl.wire {name = "io_debugRegs01234_0_3"} : !firrtl.uint<0>
      %io_debugRegs01234_0_4_33 = firrtl.wire {name = "io_debugRegs01234_0_4"} : !firrtl.uint<0>
      %io_debugRegs01234_1_1_34 = firrtl.wire {name = "io_debugRegs01234_1_1"} : !firrtl.uint<0>
      %io_debugRegs01234_1_2_35 = firrtl.wire {name = "io_debugRegs01234_1_2"} : !firrtl.uint<0>
      %io_debugRegs01234_1_3_36 = firrtl.wire {name = "io_debugRegs01234_1_3"} : !firrtl.uint<0>
      %io_debugRegs01234_1_4_37 = firrtl.wire {name = "io_debugRegs01234_1_4"} : !firrtl.uint<0>
      %io_debugRegs01234_2_1_38 = firrtl.wire {name = "io_debugRegs01234_2_1"} : !firrtl.uint<0>
      %io_debugRegs01234_2_2_39 = firrtl.wire {name = "io_debugRegs01234_2_2"} : !firrtl.uint<0>
      %io_debugRegs01234_2_3_40 = firrtl.wire {name = "io_debugRegs01234_2_3"} : !firrtl.uint<0>
      %io_debugRegs01234_2_4_41 = firrtl.wire {name = "io_debugRegs01234_2_4"} : !firrtl.uint<0>
      %io_debugRegs01234_3_1_42 = firrtl.wire {name = "io_debugRegs01234_3_1"} : !firrtl.uint<0>
      %io_debugRegs01234_3_2_43 = firrtl.wire {name = "io_debugRegs01234_3_2"} : !firrtl.uint<0>
      %io_debugRegs01234_3_3_44 = firrtl.wire {name = "io_debugRegs01234_3_3"} : !firrtl.uint<0>
      %io_debugRegs01234_3_4_45 = firrtl.wire {name = "io_debugRegs01234_3_4"} : !firrtl.uint<0>
      %io_debugRegs01234_4_1_46 = firrtl.wire {name = "io_debugRegs01234_4_1"} : !firrtl.uint<0>
      %io_debugRegs01234_4_2_47 = firrtl.wire {name = "io_debugRegs01234_4_2"} : !firrtl.uint<0>
      %io_debugRegs01234_4_3_48 = firrtl.wire {name = "io_debugRegs01234_4_3"} : !firrtl.uint<0>
      %io_debugRegs01234_4_4_49 = firrtl.wire {name = "io_debugRegs01234_4_4"} : !firrtl.uint<0>
      %io_debugRegs01234_5_1_50 = firrtl.wire {name = "io_debugRegs01234_5_1"} : !firrtl.uint<0>
      %io_debugRegs01234_5_2_51 = firrtl.wire {name = "io_debugRegs01234_5_2"} : !firrtl.uint<0>
      %io_debugRegs01234_5_3_52 = firrtl.wire {name = "io_debugRegs01234_5_3"} : !firrtl.uint<0>
      %io_debugRegs01234_5_4_53 = firrtl.wire {name = "io_debugRegs01234_5_4"} : !firrtl.uint<0>
      %io_debugRegs01234_6_1_54 = firrtl.wire {name = "io_debugRegs01234_6_1"} : !firrtl.uint<0>
      %io_debugRegs01234_6_2_55 = firrtl.wire {name = "io_debugRegs01234_6_2"} : !firrtl.uint<0>
      %io_debugRegs01234_6_3_56 = firrtl.wire {name = "io_debugRegs01234_6_3"} : !firrtl.uint<0>
      %io_debugRegs01234_6_4_57 = firrtl.wire {name = "io_debugRegs01234_6_4"} : !firrtl.uint<0>
      %io_debugRegs01234_7_1_58 = firrtl.wire {name = "io_debugRegs01234_7_1"} : !firrtl.uint<0>
      %io_debugRegs01234_7_2_59 = firrtl.wire {name = "io_debugRegs01234_7_2"} : !firrtl.uint<0>
      %io_debugRegs01234_7_3_60 = firrtl.wire {name = "io_debugRegs01234_7_3"} : !firrtl.uint<0>
      %io_debugRegs01234_7_4_61 = firrtl.wire {name = "io_debugRegs01234_7_4"} : !firrtl.uint<0>
      %io_debugRegX1_0_62 = firrtl.wire {name = "io_debugRegX1_0"} : !firrtl.uint<0>
      %io_debugRegX1_1_63 = firrtl.wire {name = "io_debugRegX1_1"} : !firrtl.uint<0>
      %io_debugRegX1_2_64 = firrtl.wire {name = "io_debugRegX1_2"} : !firrtl.uint<0>
      %io_debugRegX1_3_65 = firrtl.wire {name = "io_debugRegX1_3"} : !firrtl.uint<0>
      %io_debugRegX1_4_66 = firrtl.wire {name = "io_debugRegX1_4"} : !firrtl.uint<0>
      %io_debugRegX1_5_67 = firrtl.wire {name = "io_debugRegX1_5"} : !firrtl.uint<0>
      %io_debugRegX1_6_68 = firrtl.wire {name = "io_debugRegX1_6"} : !firrtl.uint<0>
      %io_debugRegX1_7_69 = firrtl.wire {name = "io_debugRegX1_7"} : !firrtl.uint<0>
      %io_debugCtrlValid_70 = firrtl.wire {name = "io_debugCtrlValid"} : !firrtl.uint<0>
      %io_debugCtrlInstr_71 = firrtl.wire {name = "io_debugCtrlInstr"} : !firrtl.uint<0>
      %io_debugCtrlTaken_72 = firrtl.wire {name = "io_debugCtrlTaken"} : !firrtl.uint<0>
      %io_debugCtrlThread_73 = firrtl.wire {name = "io_debugCtrlThread"} : !firrtl.uint<0>
      %io_debugCtrlFromPC_74 = firrtl.wire {name = "io_debugCtrlFromPC"} : !firrtl.uint<0>
      %io_debugCtrlTarget_75 = firrtl.wire {name = "io_debugCtrlTarget"} : !firrtl.uint<0>
      %io_debugCtrlIsBranch_76 = firrtl.wire {name = "io_debugCtrlIsBranch"} : !firrtl.uint<0>
      %io_debugCtrlIsJal_77 = firrtl.wire {name = "io_debugCtrlIsJal"} : !firrtl.uint<0>
      %io_debugCtrlIsJalr_78 = firrtl.wire {name = "io_debugCtrlIsJalr"} : !firrtl.uint<0>
      firrtl.matchingconnect %io_threadEnable_0, %io_threadEnable : !firrtl.vector<uint<1>, 8>
      firrtl.matchingconnect %io_memAddr, %io_memAddr_1 : !firrtl.uint<32>
      firrtl.matchingconnect %io_memWrite, %io_memWrite_2 : !firrtl.uint<32>
      firrtl.matchingconnect %io_memMask, %io_memMask_3 : !firrtl.uint<4>
      firrtl.matchingconnect %io_memValid, %io_memValid_4 : !firrtl.uint<1>
      firrtl.matchingconnect %io_memMisaligned, %io_memMisaligned_5 : !firrtl.uint<1>
      firrtl.matchingconnect %io_debugStageThreads_0, %io_debugStageThreads_0_6 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageThreads_1, %io_debugStageThreads_1_7 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageThreads_2, %io_debugStageThreads_2_8 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageThreads_3, %io_debugStageThreads_3_9 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageThreads_4, %io_debugStageThreads_4_10 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageThreads_5, %io_debugStageThreads_5_11 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageThreads_6, %io_debugStageThreads_6_12 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageThreads_7, %io_debugStageThreads_7_13 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageValids_0, %io_debugStageValids_0_14 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageValids_1, %io_debugStageValids_1_15 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageValids_2, %io_debugStageValids_2_16 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageValids_3, %io_debugStageValids_3_17 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageValids_4, %io_debugStageValids_4_18 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageValids_5, %io_debugStageValids_5_19 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageValids_6, %io_debugStageValids_6_20 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageValids_7, %io_debugStageValids_7_21 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugPC_0, %io_debugPC_0_22 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugPC_1, %io_debugPC_1_23 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugPC_2, %io_debugPC_2_24 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugPC_3, %io_debugPC_3_25 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugPC_4, %io_debugPC_4_26 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugPC_5, %io_debugPC_5_27 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugPC_6, %io_debugPC_6_28 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugPC_7, %io_debugPC_7_29 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_0_0, %c0_ui0 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_0_1, %io_debugRegs01234_0_1_30 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_0_2, %io_debugRegs01234_0_2_31 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_0_3, %io_debugRegs01234_0_3_32 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_0_4, %io_debugRegs01234_0_4_33 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_1_0, %c0_ui0 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_1_1, %io_debugRegs01234_1_1_34 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_1_2, %io_debugRegs01234_1_2_35 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_1_3, %io_debugRegs01234_1_3_36 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_1_4, %io_debugRegs01234_1_4_37 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_2_0, %c0_ui0 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_2_1, %io_debugRegs01234_2_1_38 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_2_2, %io_debugRegs01234_2_2_39 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_2_3, %io_debugRegs01234_2_3_40 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_2_4, %io_debugRegs01234_2_4_41 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_3_0, %c0_ui0 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_3_1, %io_debugRegs01234_3_1_42 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_3_2, %io_debugRegs01234_3_2_43 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_3_3, %io_debugRegs01234_3_3_44 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_3_4, %io_debugRegs01234_3_4_45 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_4_0, %c0_ui0 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_4_1, %io_debugRegs01234_4_1_46 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_4_2, %io_debugRegs01234_4_2_47 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_4_3, %io_debugRegs01234_4_3_48 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_4_4, %io_debugRegs01234_4_4_49 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_5_0, %c0_ui0 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_5_1, %io_debugRegs01234_5_1_50 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_5_2, %io_debugRegs01234_5_2_51 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_5_3, %io_debugRegs01234_5_3_52 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_5_4, %io_debugRegs01234_5_4_53 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_6_0, %c0_ui0 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_6_1, %io_debugRegs01234_6_1_54 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_6_2, %io_debugRegs01234_6_2_55 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_6_3, %io_debugRegs01234_6_3_56 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_6_4, %io_debugRegs01234_6_4_57 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_7_0, %c0_ui0 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_7_1, %io_debugRegs01234_7_1_58 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_7_2, %io_debugRegs01234_7_2_59 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_7_3, %io_debugRegs01234_7_3_60 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_7_4, %io_debugRegs01234_7_4_61 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegX1_0, %io_debugRegX1_0_62 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegX1_1, %io_debugRegX1_1_63 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegX1_2, %io_debugRegX1_2_64 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegX1_3, %io_debugRegX1_3_65 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegX1_4, %io_debugRegX1_4_66 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegX1_5, %io_debugRegX1_5_67 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegX1_6, %io_debugRegX1_6_68 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegX1_7, %io_debugRegX1_7_69 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlValid, %io_debugCtrlValid_70 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlInstr, %io_debugCtrlInstr_71 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlTaken, %io_debugCtrlTaken_72 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlThread, %io_debugCtrlThread_73 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlFromPC, %io_debugCtrlFromPC_74 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlTarget, %io_debugCtrlTarget_75 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlIsBranch, %io_debugCtrlIsBranch_76 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlIsJal, %io_debugCtrlIsJal_77 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlIsJalr, %io_debugCtrlIsJalr_78 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugExecValid, %c0_ui0 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugExecThread, %c0_ui0 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugExecPC, %c0_ui0 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugExecInstr, %c0_ui0 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugExecIsBranch, %c0_ui0 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugExecIsJal, %c0_ui0 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugExecIsJalr, %c0_ui0 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugExecBranchOp, %c0_ui0 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugExecRs1, %c0_ui0 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugExecRs2, %c0_ui0 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugExecCtrlTaken, %c0_ui0 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugExecCtrlTarget, %c0_ui0 : !firrtl.uint<0>
      firrtl.matchingconnect %io_jtag_tdo, %c0_ui1 : !firrtl.uint<1>
      %threadCounter = firrtl.regreset %clock, %reset, %c0_ui3 {firrtl.random_init_start = 0 : ui64} : !firrtl.clock, !firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>
      %_nextThread_T = firrtl.andr %threadCounter {name = "_nextThread_T"} : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %_nextThread_T_1 = firrtl.add %threadCounter, %c1_ui1 {name = "_nextThread_T_1"} : (!firrtl.uint<3>, !firrtl.uint<1>) -> !firrtl.uint<4>
      %_nextThread_T_2 = firrtl.bits %_nextThread_T_1 2 to 0 {name = "_nextThread_T_2"} : (!firrtl.uint<4>) -> !firrtl.uint<3>
      %nextThread = firrtl.mux(%_nextThread_T, %c0_ui3, %_nextThread_T_2) {name = "nextThread"} : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      firrtl.matchingconnect %threadCounter, %nextThread : !firrtl.uint<3>
      %_pcRegs_WIRE = firrtl.wire : !firrtl.vector<uint<32>, 8>
      firrtl.matchingconnect %_pcRegs_WIRE, %2 : !firrtl.vector<uint<32>, 8>
      %pcRegs = firrtl.regreset %clock, %reset, %_pcRegs_WIRE {firrtl.random_init_start = 3 : ui64} : !firrtl.clock, !firrtl.uint<1>, !firrtl.vector<uint<32>, 8>, !firrtl.vector<uint<32>, 8>
      %10 = firrtl.subindex %pcRegs[0] : !firrtl.vector<uint<32>, 8>
      %11 = firrtl.subindex %pcRegs[1] : !firrtl.vector<uint<32>, 8>
      %12 = firrtl.subindex %pcRegs[2] : !firrtl.vector<uint<32>, 8>
      %13 = firrtl.subindex %pcRegs[3] : !firrtl.vector<uint<32>, 8>
      %14 = firrtl.subindex %pcRegs[4] : !firrtl.vector<uint<32>, 8>
      %15 = firrtl.subindex %pcRegs[5] : !firrtl.vector<uint<32>, 8>
      %16 = firrtl.subindex %pcRegs[6] : !firrtl.vector<uint<32>, 8>
      %17 = firrtl.subindex %pcRegs[7] : !firrtl.vector<uint<32>, 8>
      %18 = firrtl.subindex %pcRegs[7] : !firrtl.vector<uint<32>, 8>
      %19 = firrtl.subindex %pcRegs[6] : !firrtl.vector<uint<32>, 8>
      %20 = firrtl.subindex %pcRegs[5] : !firrtl.vector<uint<32>, 8>
      %21 = firrtl.subindex %pcRegs[4] : !firrtl.vector<uint<32>, 8>
      %22 = firrtl.subindex %pcRegs[3] : !firrtl.vector<uint<32>, 8>
      %23 = firrtl.subindex %pcRegs[2] : !firrtl.vector<uint<32>, 8>
      %24 = firrtl.subindex %pcRegs[1] : !firrtl.vector<uint<32>, 8>
      %25 = firrtl.subindex %pcRegs[0] : !firrtl.vector<uint<32>, 8>
      %_debugRegs1to4_WIRE_8 = firrtl.wire : !firrtl.vector<vector<uint<32>, 4>, 8>
      %debugRegs1to4 = firrtl.regreset %clock, %reset, %_debugRegs1to4_WIRE_8 {firrtl.random_init_start = 259 : ui64} : !firrtl.clock, !firrtl.uint<1>, !firrtl.vector<vector<uint<32>, 4>, 8>, !firrtl.vector<vector<uint<32>, 4>, 8>
      %26 = firrtl.subindex %debugRegs1to4[0] : !firrtl.vector<vector<uint<32>, 4>, 8>
      %27 = firrtl.subindex %26[0] : !firrtl.vector<uint<32>, 4>
      %28 = firrtl.subindex %26[1] : !firrtl.vector<uint<32>, 4>
      %29 = firrtl.subindex %26[2] : !firrtl.vector<uint<32>, 4>
      %30 = firrtl.subindex %26[3] : !firrtl.vector<uint<32>, 4>
      %31 = firrtl.subindex %debugRegs1to4[1] : !firrtl.vector<vector<uint<32>, 4>, 8>
      %32 = firrtl.subindex %31[0] : !firrtl.vector<uint<32>, 4>
      %33 = firrtl.subindex %31[1] : !firrtl.vector<uint<32>, 4>
      %34 = firrtl.subindex %31[2] : !firrtl.vector<uint<32>, 4>
      %35 = firrtl.subindex %31[3] : !firrtl.vector<uint<32>, 4>
      %36 = firrtl.subindex %debugRegs1to4[2] : !firrtl.vector<vector<uint<32>, 4>, 8>
      %37 = firrtl.subindex %36[0] : !firrtl.vector<uint<32>, 4>
      %38 = firrtl.subindex %36[1] : !firrtl.vector<uint<32>, 4>
      %39 = firrtl.subindex %36[2] : !firrtl.vector<uint<32>, 4>
      %40 = firrtl.subindex %36[3] : !firrtl.vector<uint<32>, 4>
      %41 = firrtl.subindex %debugRegs1to4[3] : !firrtl.vector<vector<uint<32>, 4>, 8>
      %42 = firrtl.subindex %41[0] : !firrtl.vector<uint<32>, 4>
      %43 = firrtl.subindex %41[1] : !firrtl.vector<uint<32>, 4>
      %44 = firrtl.subindex %41[2] : !firrtl.vector<uint<32>, 4>
      %45 = firrtl.subindex %41[3] : !firrtl.vector<uint<32>, 4>
      %46 = firrtl.subindex %debugRegs1to4[4] : !firrtl.vector<vector<uint<32>, 4>, 8>
      %47 = firrtl.subindex %46[0] : !firrtl.vector<uint<32>, 4>
      %48 = firrtl.subindex %46[1] : !firrtl.vector<uint<32>, 4>
      %49 = firrtl.subindex %46[2] : !firrtl.vector<uint<32>, 4>
      %50 = firrtl.subindex %46[3] : !firrtl.vector<uint<32>, 4>
      %51 = firrtl.subindex %debugRegs1to4[5] : !firrtl.vector<vector<uint<32>, 4>, 8>
      %52 = firrtl.subindex %51[0] : !firrtl.vector<uint<32>, 4>
      %53 = firrtl.subindex %51[1] : !firrtl.vector<uint<32>, 4>
      %54 = firrtl.subindex %51[2] : !firrtl.vector<uint<32>, 4>
      %55 = firrtl.subindex %51[3] : !firrtl.vector<uint<32>, 4>
      %56 = firrtl.subindex %debugRegs1to4[6] : !firrtl.vector<vector<uint<32>, 4>, 8>
      %57 = firrtl.subindex %56[0] : !firrtl.vector<uint<32>, 4>
      %58 = firrtl.subindex %56[1] : !firrtl.vector<uint<32>, 4>
      %59 = firrtl.subindex %56[2] : !firrtl.vector<uint<32>, 4>
      %60 = firrtl.subindex %56[3] : !firrtl.vector<uint<32>, 4>
      %61 = firrtl.subindex %debugRegs1to4[7] : !firrtl.vector<vector<uint<32>, 4>, 8>
      %62 = firrtl.subindex %61[0] : !firrtl.vector<uint<32>, 4>
      %63 = firrtl.subindex %61[1] : !firrtl.vector<uint<32>, 4>
      %64 = firrtl.subindex %61[2] : !firrtl.vector<uint<32>, 4>
      %65 = firrtl.subindex %61[3] : !firrtl.vector<uint<32>, 4>
      %66 = firrtl.subindex %debugRegs1to4[7] : !firrtl.vector<vector<uint<32>, 4>, 8>
      %67 = firrtl.subindex %66[3] : !firrtl.vector<uint<32>, 4>
      %68 = firrtl.subindex %66[2] : !firrtl.vector<uint<32>, 4>
      %69 = firrtl.subindex %66[1] : !firrtl.vector<uint<32>, 4>
      %70 = firrtl.subindex %66[0] : !firrtl.vector<uint<32>, 4>
      %71 = firrtl.subindex %debugRegs1to4[6] : !firrtl.vector<vector<uint<32>, 4>, 8>
      %72 = firrtl.subindex %71[3] : !firrtl.vector<uint<32>, 4>
      %73 = firrtl.subindex %71[2] : !firrtl.vector<uint<32>, 4>
      %74 = firrtl.subindex %71[1] : !firrtl.vector<uint<32>, 4>
      %75 = firrtl.subindex %71[0] : !firrtl.vector<uint<32>, 4>
      %76 = firrtl.subindex %debugRegs1to4[5] : !firrtl.vector<vector<uint<32>, 4>, 8>
      %77 = firrtl.subindex %76[3] : !firrtl.vector<uint<32>, 4>
      %78 = firrtl.subindex %76[2] : !firrtl.vector<uint<32>, 4>
      %79 = firrtl.subindex %76[1] : !firrtl.vector<uint<32>, 4>
      %80 = firrtl.subindex %76[0] : !firrtl.vector<uint<32>, 4>
      %81 = firrtl.subindex %debugRegs1to4[4] : !firrtl.vector<vector<uint<32>, 4>, 8>
      %82 = firrtl.subindex %81[3] : !firrtl.vector<uint<32>, 4>
      %83 = firrtl.subindex %81[2] : !firrtl.vector<uint<32>, 4>
      %84 = firrtl.subindex %81[1] : !firrtl.vector<uint<32>, 4>
      %85 = firrtl.subindex %81[0] : !firrtl.vector<uint<32>, 4>
      %86 = firrtl.subindex %debugRegs1to4[3] : !firrtl.vector<vector<uint<32>, 4>, 8>
      %87 = firrtl.subindex %86[3] : !firrtl.vector<uint<32>, 4>
      %88 = firrtl.subindex %86[2] : !firrtl.vector<uint<32>, 4>
      %89 = firrtl.subindex %86[1] : !firrtl.vector<uint<32>, 4>
      %90 = firrtl.subindex %86[0] : !firrtl.vector<uint<32>, 4>
      %91 = firrtl.subindex %debugRegs1to4[2] : !firrtl.vector<vector<uint<32>, 4>, 8>
      %92 = firrtl.subindex %91[3] : !firrtl.vector<uint<32>, 4>
      %93 = firrtl.subindex %91[2] : !firrtl.vector<uint<32>, 4>
      %94 = firrtl.subindex %91[1] : !firrtl.vector<uint<32>, 4>
      %95 = firrtl.subindex %91[0] : !firrtl.vector<uint<32>, 4>
      %96 = firrtl.subindex %debugRegs1to4[1] : !firrtl.vector<vector<uint<32>, 4>, 8>
      %97 = firrtl.subindex %96[3] : !firrtl.vector<uint<32>, 4>
      %98 = firrtl.subindex %96[2] : !firrtl.vector<uint<32>, 4>
      %99 = firrtl.subindex %96[1] : !firrtl.vector<uint<32>, 4>
      %100 = firrtl.subindex %96[0] : !firrtl.vector<uint<32>, 4>
      %101 = firrtl.subindex %debugRegs1to4[0] : !firrtl.vector<vector<uint<32>, 4>, 8>
      %102 = firrtl.subindex %101[3] : !firrtl.vector<uint<32>, 4>
      %103 = firrtl.subindex %101[2] : !firrtl.vector<uint<32>, 4>
      %104 = firrtl.subindex %101[1] : !firrtl.vector<uint<32>, 4>
      %105 = firrtl.subindex %101[0] : !firrtl.vector<uint<32>, 4>
      %regFile_clock, %regFile_io_readThreadID, %regFile_io_writeThreadID, %regFile_io_readAddrs, %regFile_io_readData, %regFile_io_writeAddrs, %regFile_io_wens, %regFile_io_writeData, %regFile_io_debugX1 = firrtl.instance regFile @RegFileMT2R1WMem(in clock: !firrtl.clock, in io_readThreadID: !firrtl.uint<3>, in io_writeThreadID: !firrtl.uint<3>, in io_readAddrs: !firrtl.vector<uint<5>, 2>, out io_readData: !firrtl.vector<uint<32>, 2>, in io_writeAddrs: !firrtl.vector<uint<5>, 1>, in io_wens: !firrtl.vector<uint<1>, 1>, in io_writeData: !firrtl.vector<uint<32>, 1>, out io_debugX1: !firrtl.vector<uint<32>, 8>)
      %regFile.io = firrtl.wire : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 8>>
      %106 = firrtl.subfield %regFile.io[readThreadID] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 8>>
      firrtl.matchingconnect %regFile_io_readThreadID, %106 : !firrtl.uint<3>
      %107 = firrtl.subfield %regFile.io[writeThreadID] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 8>>
      firrtl.matchingconnect %regFile_io_writeThreadID, %107 : !firrtl.uint<3>
      %108 = firrtl.subfield %regFile.io[readAddrs] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 8>>
      firrtl.matchingconnect %regFile_io_readAddrs, %108 : !firrtl.vector<uint<5>, 2>
      %109 = firrtl.subfield %regFile.io[readData] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 8>>
      %110 = firrtl.subfield %regFile.io[writeAddrs] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 8>>
      firrtl.matchingconnect %regFile_io_writeAddrs, %110 : !firrtl.vector<uint<5>, 1>
      %111 = firrtl.subfield %regFile.io[wens] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 8>>
      firrtl.matchingconnect %regFile_io_wens, %111 : !firrtl.vector<uint<1>, 1>
      %112 = firrtl.subfield %regFile.io[writeData] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 8>>
      firrtl.matchingconnect %regFile_io_writeData, %112 : !firrtl.vector<uint<32>, 1>
      %113 = firrtl.subfield %regFile.io[debugX1] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 8>>
      %114 = firrtl.subindex %109[1] : !firrtl.vector<uint<32>, 2>
      %115 = firrtl.subindex %109[0] : !firrtl.vector<uint<32>, 2>
      firrtl.matchingconnect %regFile_clock, %clock : !firrtl.clock
      %alu_io_a, %alu_io_b, %alu_io_opcode, %alu_io_result = firrtl.instance alu @ALU32(in io_a: !firrtl.uint<32>, in io_b: !firrtl.uint<32>, in io_opcode: !firrtl.uint<5>, out io_result: !firrtl.uint<32>)
      %alu.io = firrtl.wire : !firrtl.bundle<a: uint<32>, b: uint<32>, opcode: uint<5>, result: uint<32>>
      %116 = firrtl.subfield %alu.io[a] : !firrtl.bundle<a: uint<32>, b: uint<32>, opcode: uint<5>, result: uint<32>>
      firrtl.matchingconnect %alu_io_a, %116 : !firrtl.uint<32>
      %117 = firrtl.subfield %alu.io[b] : !firrtl.bundle<a: uint<32>, b: uint<32>, opcode: uint<5>, result: uint<32>>
      firrtl.matchingconnect %alu_io_b, %117 : !firrtl.uint<32>
      %118 = firrtl.subfield %alu.io[opcode] : !firrtl.bundle<a: uint<32>, b: uint<32>, opcode: uint<5>, result: uint<32>>
      firrtl.matchingconnect %alu_io_opcode, %118 : !firrtl.uint<5>
      %119 = firrtl.subfield %alu.io[result] : !firrtl.bundle<a: uint<32>, b: uint<32>, opcode: uint<5>, result: uint<32>>
      %mulUnit_io_a, %mulUnit_io_b, %mulUnit_io_signedA, %mulUnit_io_signedB, %mulUnit_io_product, %mulUnit_io_lo, %mulUnit_io_hi = firrtl.instance mulUnit @Mul32OneCycle(in io_a: !firrtl.uint<32>, in io_b: !firrtl.uint<32>, in io_signedA: !firrtl.uint<1>, in io_signedB: !firrtl.uint<1>, out io_product: !firrtl.uint<64>, out io_lo: !firrtl.uint<32>, out io_hi: !firrtl.uint<32>)
      %mulUnit.io = firrtl.wire : !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      %120 = firrtl.subfield %mulUnit.io[a] : !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      firrtl.matchingconnect %mulUnit_io_a, %120 : !firrtl.uint<32>
      %121 = firrtl.subfield %mulUnit.io[b] : !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      firrtl.matchingconnect %mulUnit_io_b, %121 : !firrtl.uint<32>
      %122 = firrtl.subfield %mulUnit.io[signedA] : !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      firrtl.matchingconnect %mulUnit_io_signedA, %122 : !firrtl.uint<1>
      %123 = firrtl.subfield %mulUnit.io[signedB] : !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      firrtl.matchingconnect %mulUnit_io_signedB, %123 : !firrtl.uint<1>
      %_mulResult_T_1 = firrtl.subfield %mulUnit.io[lo] {name = "_mulResult_T_1"} : !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      %124 = firrtl.subfield %mulUnit.io[hi] : !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      %branchUnit_io_rs1, %branchUnit_io_rs2, %branchUnit_io_pc, %branchUnit_io_imm, %branchUnit_io_branchOp, %branchUnit_io_valid, %branchUnit_io_taken, %branchUnit_io_target, %branchUnit_io_nextPc, %branchUnit_io_misaligned = firrtl.instance branchUnit @BranchUnit(in io_rs1: !firrtl.uint<32>, in io_rs2: !firrtl.uint<32>, in io_pc: !firrtl.uint<32>, in io_imm: !firrtl.sint<32>, in io_branchOp: !firrtl.uint<3>, in io_valid: !firrtl.uint<1>, out io_taken: !firrtl.uint<1>, out io_target: !firrtl.uint<32>, out io_nextPc: !firrtl.uint<32>, out io_misaligned: !firrtl.uint<1>)
      %branchUnit.io = firrtl.wire : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      %125 = firrtl.subfield %branchUnit.io[rs1] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      firrtl.matchingconnect %branchUnit_io_rs1, %125 : !firrtl.uint<32>
      %126 = firrtl.subfield %branchUnit.io[rs2] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      firrtl.matchingconnect %branchUnit_io_rs2, %126 : !firrtl.uint<32>
      %127 = firrtl.subfield %branchUnit.io[pc] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      firrtl.matchingconnect %branchUnit_io_pc, %127 : !firrtl.uint<32>
      %128 = firrtl.subfield %branchUnit.io[imm] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      firrtl.matchingconnect %branchUnit_io_imm, %128 : !firrtl.sint<32>
      %129 = firrtl.subfield %branchUnit.io[branchOp] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      firrtl.matchingconnect %branchUnit_io_branchOp, %129 : !firrtl.uint<3>
      %130 = firrtl.subfield %branchUnit.io[valid] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      firrtl.matchingconnect %branchUnit_io_valid, %130 : !firrtl.uint<1>
      %131 = firrtl.subfield %branchUnit.io[taken] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      %132 = firrtl.subfield %branchUnit.io[target] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      %133 = firrtl.subfield %branchUnit.io[nextPc] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      %134 = firrtl.subfield %branchUnit.io[misaligned] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      %unusedBranchNextPc = firrtl.node %133 {annotations = [{class = "firrtl.transforms.DontTouchAnnotation"}]} : !firrtl.uint<32>
      %unusedBranchMisaligned = firrtl.node %134 {annotations = [{class = "firrtl.transforms.DontTouchAnnotation"}]} : !firrtl.uint<1>
      %loadUnit_io_addr, %loadUnit_io_dataIn, %loadUnit_io_funct3, %loadUnit_io_dataOut = firrtl.instance loadUnit @LoadUnit(in io_addr: !firrtl.uint<32>, in io_dataIn: !firrtl.uint<32>, in io_funct3: !firrtl.uint<3>, out io_dataOut: !firrtl.uint<32>)
      %loadUnit.io = firrtl.wire : !firrtl.bundle<addr: uint<32>, dataIn: uint<32>, funct3: uint<3>, dataOut: uint<32>>
      %135 = firrtl.subfield %loadUnit.io[addr] : !firrtl.bundle<addr: uint<32>, dataIn: uint<32>, funct3: uint<3>, dataOut: uint<32>>
      firrtl.matchingconnect %loadUnit_io_addr, %135 : !firrtl.uint<32>
      %136 = firrtl.subfield %loadUnit.io[dataIn] : !firrtl.bundle<addr: uint<32>, dataIn: uint<32>, funct3: uint<3>, dataOut: uint<32>>
      firrtl.matchingconnect %loadUnit_io_dataIn, %136 : !firrtl.uint<32>
      %137 = firrtl.subfield %loadUnit.io[funct3] : !firrtl.bundle<addr: uint<32>, dataIn: uint<32>, funct3: uint<3>, dataOut: uint<32>>
      firrtl.matchingconnect %loadUnit_io_funct3, %137 : !firrtl.uint<3>
      %138 = firrtl.subfield %loadUnit.io[dataOut] : !firrtl.bundle<addr: uint<32>, dataIn: uint<32>, funct3: uint<3>, dataOut: uint<32>>
      %storeUnit_io_addr, %storeUnit_io_data, %storeUnit_io_storeType, %storeUnit_io_memWrite, %storeUnit_io_mask, %storeUnit_io_misaligned = firrtl.instance storeUnit @StoreUnit(in io_addr: !firrtl.uint<32>, in io_data: !firrtl.uint<32>, in io_storeType: !firrtl.uint<2>, out io_memWrite: !firrtl.uint<32>, out io_mask: !firrtl.uint<4>, out io_misaligned: !firrtl.uint<1>)
      %storeUnit.io = firrtl.wire : !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      %139 = firrtl.subfield %storeUnit.io[addr] : !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      firrtl.matchingconnect %storeUnit_io_addr, %139 : !firrtl.uint<32>
      %140 = firrtl.subfield %storeUnit.io[data] : !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      firrtl.matchingconnect %storeUnit_io_data, %140 : !firrtl.uint<32>
      %141 = firrtl.subfield %storeUnit.io[storeType] : !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      firrtl.matchingconnect %storeUnit_io_storeType, %141 : !firrtl.uint<2>
      %142 = firrtl.subfield %storeUnit.io[memWrite] : !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      %143 = firrtl.subfield %storeUnit.io[mask] : !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      %144 = firrtl.subfield %storeUnit.io[misaligned] : !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      %_fetchReg_WIRE = firrtl.wire : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      firrtl.matchingconnect %_fetchReg_WIRE, %9 : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %fetchReg = firrtl.regreset %clock, %reset, %_fetchReg_WIRE {firrtl.random_init_start = 1283 : ui64} : !firrtl.clock, !firrtl.uint<1>, !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %145 = firrtl.subfield %fetchReg[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %146 = firrtl.subfield %fetchReg[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %147 = firrtl.subfield %fetchReg[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %148 = firrtl.subfield %fetchReg[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %149 = firrtl.subfield %fetchReg[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %150 = firrtl.subfield %fetchReg[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %151 = firrtl.subaccess %io_threadEnable_0[%threadCounter] : !firrtl.vector<uint<1>, 8>, !firrtl.uint<3>
      %152 = firrtl.mux(%151, %threadCounter, %145) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %153 = firrtl.subaccess %pcRegs[%threadCounter] : !firrtl.vector<uint<32>, 8>, !firrtl.uint<3>
      %154 = firrtl.mux(%151, %153, %146) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %_fetchReg_instr_T = firrtl.bits %io_instrMem 31 to 0 {name = "_fetchReg_instr_T"} : (!firrtl.uint<128>) -> !firrtl.uint<32>
      %155 = firrtl.mux(%151, %_fetchReg_instr_T, %147) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %_pcRegs_T = firrtl.add %153, %c4_ui3 {name = "_pcRegs_T"} : (!firrtl.uint<32>, !firrtl.uint<3>) -> !firrtl.uint<33>
      %_pcRegs_T_1 = firrtl.bits %_pcRegs_T 31 to 0 {name = "_pcRegs_T_1"} : (!firrtl.uint<33>) -> !firrtl.uint<32>
      %156 = firrtl.orr %threadCounter : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %157 = firrtl.not %156 : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %158 = firrtl.and %151, %157 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %159 = firrtl.mux(%158, %_pcRegs_T_1, %10) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %160 = firrtl.eq %threadCounter, %c1_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %161 = firrtl.and %151, %160 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %162 = firrtl.mux(%161, %_pcRegs_T_1, %11) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %163 = firrtl.eq %threadCounter, %c2_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %164 = firrtl.and %151, %163 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %165 = firrtl.mux(%164, %_pcRegs_T_1, %12) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %166 = firrtl.eq %threadCounter, %c3_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %167 = firrtl.and %151, %166 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %168 = firrtl.mux(%167, %_pcRegs_T_1, %13) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %169 = firrtl.eq %threadCounter, %c4_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %170 = firrtl.and %151, %169 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %171 = firrtl.mux(%170, %_pcRegs_T_1, %14) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %172 = firrtl.eq %threadCounter, %c5_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %173 = firrtl.and %151, %172 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %174 = firrtl.mux(%173, %_pcRegs_T_1, %15) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %175 = firrtl.eq %threadCounter, %c6_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %176 = firrtl.and %151, %175 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %177 = firrtl.mux(%176, %_pcRegs_T_1, %16) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %178 = firrtl.andr %threadCounter : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %179 = firrtl.and %151, %178 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %180 = firrtl.mux(%179, %_pcRegs_T_1, %17) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %181 = firrtl.bundlecreate %151, %152, %154, %155 : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      firrtl.matchingconnect %fetchReg, %181 : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %_decodeReg_WIRE = firrtl.wire : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %decodeReg = firrtl.regreset %clock, %reset, %_decodeReg_WIRE {firrtl.random_init_start = 1351 : ui64} : !firrtl.clock, !firrtl.uint<1>, !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>, !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %182 = firrtl.subfield %decodeReg[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %183 = firrtl.subfield %182[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %184 = firrtl.subfield %182[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %185 = firrtl.subfield %182[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %186 = firrtl.subfield %decodeReg[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %187 = firrtl.subfield %186[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %188 = firrtl.subfield %186[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %189 = firrtl.subfield %186[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %190 = firrtl.subfield %186[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %191 = firrtl.subfield %186[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %192 = firrtl.subfield %186[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %193 = firrtl.subfield %186[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %194 = firrtl.subfield %186[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %195 = firrtl.subfield %186[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %196 = firrtl.subfield %186[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %197 = firrtl.subfield %186[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %198 = firrtl.subfield %186[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %199 = firrtl.subfield %186[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %200 = firrtl.subfield %186[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %201 = firrtl.subfield %186[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %202 = firrtl.subfield %186[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %203 = firrtl.subfield %decodeReg[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %204 = firrtl.subfield %203[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %205 = firrtl.subfield %203[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %206 = firrtl.subfield %fetchReg[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %207 = firrtl.subfield %fetchReg[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %208 = firrtl.mux(%150, %207, %183) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %209 = firrtl.subfield %fetchReg[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %210 = firrtl.mux(%150, %209, %184) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %211 = firrtl.subfield %fetchReg[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %212 = firrtl.mux(%150, %211, %185) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %decodeReg_decodeSignals_dec = firrtl.wire : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %decodeReg_decodeSignals_opcode = firrtl.bits %148 6 to 0 {name = "decodeReg_decodeSignals_opcode"} : (!firrtl.uint<32>) -> !firrtl.uint<7>
      %decodeReg_decodeSignals_funct3 = firrtl.bits %148 14 to 12 {name = "decodeReg_decodeSignals_funct3"} : (!firrtl.uint<32>) -> !firrtl.uint<3>
      %decodeReg_decodeSignals_funct7 = firrtl.bits %148 31 to 25 {name = "decodeReg_decodeSignals_funct7"} : (!firrtl.uint<32>) -> !firrtl.uint<7>
      %_decodeReg_decodeSignals_dec_rs1_T = firrtl.bits %148 19 to 15 {name = "_decodeReg_decodeSignals_dec_rs1_T"} : (!firrtl.uint<32>) -> !firrtl.uint<5>
      %_decodeReg_decodeSignals_dec_rs2_T = firrtl.bits %148 24 to 20 {name = "_decodeReg_decodeSignals_dec_rs2_T"} : (!firrtl.uint<32>) -> !firrtl.uint<5>
      %_decodeReg_decodeSignals_storeImm_T_1 = firrtl.bits %148 11 to 7 {name = "_decodeReg_decodeSignals_storeImm_T_1"} : (!firrtl.uint<32>) -> !firrtl.uint<5>
      %_decodeReg_decodeSignals_T = firrtl.eq %decodeReg_decodeSignals_opcode, %c51_ui7 {name = "_decodeReg_decodeSignals_T"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %213 = firrtl.orr %decodeReg_decodeSignals_funct3 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_1 = firrtl.not %213 {name = "_decodeReg_decodeSignals_T_1"} : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_2 = firrtl.eq %decodeReg_decodeSignals_funct7, %c32_ui6 {name = "_decodeReg_decodeSignals_T_2"} : (!firrtl.uint<7>, !firrtl.uint<6>) -> !firrtl.uint<1>
      %214 = firrtl.mux(%_decodeReg_decodeSignals_T_2, %c1_ui5, %c0_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %_decodeReg_decodeSignals_T_3 = firrtl.eq %decodeReg_decodeSignals_funct3, %c1_ui1 {name = "_decodeReg_decodeSignals_T_3"} : (!firrtl.uint<3>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_4 = firrtl.eq %decodeReg_decodeSignals_funct3, %c2_ui2 {name = "_decodeReg_decodeSignals_T_4"} : (!firrtl.uint<3>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_5 = firrtl.eq %decodeReg_decodeSignals_funct3, %c3_ui2 {name = "_decodeReg_decodeSignals_T_5"} : (!firrtl.uint<3>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_6 = firrtl.eq %decodeReg_decodeSignals_funct3, %c4_ui3 {name = "_decodeReg_decodeSignals_T_6"} : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_7 = firrtl.eq %decodeReg_decodeSignals_funct3, %c5_ui3 {name = "_decodeReg_decodeSignals_T_7"} : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_8 = firrtl.eq %decodeReg_decodeSignals_funct7, %c32_ui6 {name = "_decodeReg_decodeSignals_T_8"} : (!firrtl.uint<7>, !firrtl.uint<6>) -> !firrtl.uint<1>
      %215 = firrtl.mux(%_decodeReg_decodeSignals_T_8, %c11_ui5, %c10_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %_decodeReg_decodeSignals_T_9 = firrtl.eq %decodeReg_decodeSignals_funct3, %c6_ui3 {name = "_decodeReg_decodeSignals_T_9"} : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_10 = firrtl.andr %decodeReg_decodeSignals_funct3 {name = "_decodeReg_decodeSignals_T_10"} : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %216 = firrtl.mux(%_decodeReg_decodeSignals_T_10, %c14_ui5, %c0_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %217 = firrtl.mux(%_decodeReg_decodeSignals_T_9, %c12_ui5, %216) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %218 = firrtl.mux(%_decodeReg_decodeSignals_T_7, %215, %217) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %219 = firrtl.mux(%_decodeReg_decodeSignals_T_6, %c8_ui5, %218) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %220 = firrtl.mux(%_decodeReg_decodeSignals_T_5, %c6_ui5, %219) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %221 = firrtl.mux(%_decodeReg_decodeSignals_T_4, %c4_ui5, %220) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %222 = firrtl.mux(%_decodeReg_decodeSignals_T_3, %c2_ui5, %221) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %223 = firrtl.mux(%_decodeReg_decodeSignals_T_1, %214, %222) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %_decodeReg_decodeSignals_T_11 = firrtl.eq %decodeReg_decodeSignals_opcode, %c19_ui7 {name = "_decodeReg_decodeSignals_T_11"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %224 = firrtl.or %_decodeReg_decodeSignals_T, %_decodeReg_decodeSignals_T_11 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_immI_T = firrtl.bits %148 31 to 20 {name = "_decodeReg_decodeSignals_immI_T"} : (!firrtl.uint<32>) -> !firrtl.uint<12>
      %decodeReg_decodeSignals_immI_sign = firrtl.bits %148 31 to 31 {name = "decodeReg_decodeSignals_immI_sign"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_immI_T_1 = firrtl.mux(%decodeReg_decodeSignals_immI_sign, %c1048575_ui20, %c0_ui20) {name = "_decodeReg_decodeSignals_immI_T_1"} : (!firrtl.uint<1>, !firrtl.uint<20>, !firrtl.uint<20>) -> !firrtl.uint<20>
      %decodeReg_decodeSignals_immI = firrtl.cat %_decodeReg_decodeSignals_immI_T_1, %_decodeReg_decodeSignals_immI_T {name = "decodeReg_decodeSignals_immI"} : (!firrtl.uint<20>, !firrtl.uint<12>) -> !firrtl.uint<32>
      %225 = firrtl.orr %decodeReg_decodeSignals_funct3 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_12 = firrtl.not %225 {name = "_decodeReg_decodeSignals_T_12"} : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_13 = firrtl.eq %decodeReg_decodeSignals_funct3, %c2_ui2 {name = "_decodeReg_decodeSignals_T_13"} : (!firrtl.uint<3>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_14 = firrtl.eq %decodeReg_decodeSignals_funct3, %c3_ui2 {name = "_decodeReg_decodeSignals_T_14"} : (!firrtl.uint<3>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_15 = firrtl.eq %decodeReg_decodeSignals_funct3, %c4_ui3 {name = "_decodeReg_decodeSignals_T_15"} : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_16 = firrtl.eq %decodeReg_decodeSignals_funct3, %c6_ui3 {name = "_decodeReg_decodeSignals_T_16"} : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_17 = firrtl.andr %decodeReg_decodeSignals_funct3 {name = "_decodeReg_decodeSignals_T_17"} : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_18 = firrtl.eq %decodeReg_decodeSignals_funct3, %c1_ui1 {name = "_decodeReg_decodeSignals_T_18"} : (!firrtl.uint<3>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_19 = firrtl.eq %decodeReg_decodeSignals_funct3, %c5_ui3 {name = "_decodeReg_decodeSignals_T_19"} : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_21 = firrtl.bits %148 30 to 30 {name = "_decodeReg_decodeSignals_T_21"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %226 = firrtl.mux(%_decodeReg_decodeSignals_T_21, %c11_ui5, %c10_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %227 = firrtl.mux(%_decodeReg_decodeSignals_T_19, %226, %c0_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %228 = firrtl.mux(%_decodeReg_decodeSignals_T_18, %c2_ui5, %227) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %229 = firrtl.mux(%_decodeReg_decodeSignals_T_17, %c14_ui5, %228) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %230 = firrtl.mux(%_decodeReg_decodeSignals_T_16, %c12_ui5, %229) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %231 = firrtl.mux(%_decodeReg_decodeSignals_T_15, %c8_ui5, %230) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %232 = firrtl.mux(%_decodeReg_decodeSignals_T_14, %c6_ui5, %231) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %233 = firrtl.mux(%_decodeReg_decodeSignals_T_13, %c4_ui5, %232) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %234 = firrtl.mux(%_decodeReg_decodeSignals_T_12, %c0_ui5, %233) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %235 = firrtl.mux(%_decodeReg_decodeSignals_T_11, %234, %c0_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %236 = firrtl.mux(%_decodeReg_decodeSignals_T, %223, %235) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %_decodeReg_decodeSignals_T_22 = firrtl.eq %decodeReg_decodeSignals_opcode, %c3_ui7 {name = "_decodeReg_decodeSignals_T_22"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %237 = firrtl.or %_decodeReg_decodeSignals_T, %_decodeReg_decodeSignals_T_11 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %238 = firrtl.mux(%237, %c0_ui1, %_decodeReg_decodeSignals_T_22) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_dec_imm_T = firrtl.bits %148 31 to 20 {name = "_decodeReg_decodeSignals_dec_imm_T"} : (!firrtl.uint<32>) -> !firrtl.uint<12>
      %decodeReg_decodeSignals_dec_imm_sign = firrtl.bits %148 31 to 31 {name = "decodeReg_decodeSignals_dec_imm_sign"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_dec_imm_T_1 = firrtl.mux(%decodeReg_decodeSignals_dec_imm_sign, %c1048575_ui20, %c0_ui20) {name = "_decodeReg_decodeSignals_dec_imm_T_1"} : (!firrtl.uint<1>, !firrtl.uint<20>, !firrtl.uint<20>) -> !firrtl.uint<20>
      %_decodeReg_decodeSignals_dec_imm_T_2 = firrtl.cat %_decodeReg_decodeSignals_dec_imm_T_1, %_decodeReg_decodeSignals_dec_imm_T {name = "_decodeReg_decodeSignals_dec_imm_T_2"} : (!firrtl.uint<20>, !firrtl.uint<12>) -> !firrtl.uint<32>
      %_decodeReg_decodeSignals_T_23 = firrtl.eq %decodeReg_decodeSignals_opcode, %c35_ui7 {name = "_decodeReg_decodeSignals_T_23"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %239 = firrtl.or %_decodeReg_decodeSignals_T_11, %_decodeReg_decodeSignals_T_22 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %240 = firrtl.or %_decodeReg_decodeSignals_T, %239 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %241 = firrtl.mux(%240, %c0_ui1, %_decodeReg_decodeSignals_T_23) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %decodeReg_decodeSignals_dec_imm_sign_1 = firrtl.bits %148 31 to 31 {name = "decodeReg_decodeSignals_dec_imm_sign_1"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_dec_imm_T_3 = firrtl.mux(%decodeReg_decodeSignals_dec_imm_sign_1, %c1048575_ui20, %c0_ui20) {name = "_decodeReg_decodeSignals_dec_imm_T_3"} : (!firrtl.uint<1>, !firrtl.uint<20>, !firrtl.uint<20>) -> !firrtl.uint<20>
      %_decodeReg_decodeSignals_dec_imm_T_4 = firrtl.cat %_decodeReg_decodeSignals_dec_imm_T_3, %decodeReg_decodeSignals_funct7, %_decodeReg_decodeSignals_storeImm_T_1 {name = "_decodeReg_decodeSignals_dec_imm_T_4"} : (!firrtl.uint<20>, !firrtl.uint<7>, !firrtl.uint<5>) -> !firrtl.uint<32>
      %_decodeReg_decodeSignals_T_24 = firrtl.eq %decodeReg_decodeSignals_opcode, %c99_ui7 {name = "_decodeReg_decodeSignals_T_24"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %242 = firrtl.or %_decodeReg_decodeSignals_T_22, %_decodeReg_decodeSignals_T_23 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %243 = firrtl.or %_decodeReg_decodeSignals_T_11, %242 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %244 = firrtl.or %_decodeReg_decodeSignals_T, %243 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %245 = firrtl.mux(%244, %c0_ui1, %_decodeReg_decodeSignals_T_24) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %decodeReg_decodeSignals_dec_imm_sign_2 = firrtl.bits %148 31 to 31 {name = "decodeReg_decodeSignals_dec_imm_sign_2"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_branchImm_T_1 = firrtl.bits %148 7 to 7 {name = "_decodeReg_decodeSignals_branchImm_T_1"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_branchImm_T_2 = firrtl.bits %148 30 to 25 {name = "_decodeReg_decodeSignals_branchImm_T_2"} : (!firrtl.uint<32>) -> !firrtl.uint<6>
      %_decodeReg_decodeSignals_branchImm_T_3 = firrtl.bits %148 11 to 8 {name = "_decodeReg_decodeSignals_branchImm_T_3"} : (!firrtl.uint<32>) -> !firrtl.uint<4>
      %_decodeReg_decodeSignals_dec_imm_T_5 = firrtl.mux(%decodeReg_decodeSignals_dec_imm_sign_2, %c1048575_ui20, %c0_ui20) {name = "_decodeReg_decodeSignals_dec_imm_T_5"} : (!firrtl.uint<1>, !firrtl.uint<20>, !firrtl.uint<20>) -> !firrtl.uint<20>
      %_decodeReg_decodeSignals_dec_imm_T_6 = firrtl.cat %_decodeReg_decodeSignals_dec_imm_T_5, %decodeReg_decodeSignals_dec_imm_sign_2, %_decodeReg_decodeSignals_branchImm_T_1, %_decodeReg_decodeSignals_branchImm_T_2, %_decodeReg_decodeSignals_branchImm_T_3 {name = "_decodeReg_decodeSignals_dec_imm_T_6"} : (!firrtl.uint<20>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<6>, !firrtl.uint<4>) -> !firrtl.uint<32>
      %_decodeReg_decodeSignals_T_25 = firrtl.eq %decodeReg_decodeSignals_opcode, %c111_ui7 {name = "_decodeReg_decodeSignals_T_25"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %246 = firrtl.or %_decodeReg_decodeSignals_T_23, %_decodeReg_decodeSignals_T_24 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %247 = firrtl.or %_decodeReg_decodeSignals_T_22, %246 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %248 = firrtl.or %_decodeReg_decodeSignals_T_11, %247 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %249 = firrtl.or %_decodeReg_decodeSignals_T, %248 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %250 = firrtl.mux(%249, %c0_ui1, %_decodeReg_decodeSignals_T_25) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %decodeReg_decodeSignals_dec_imm_sign_3 = firrtl.bits %148 31 to 31 {name = "decodeReg_decodeSignals_dec_imm_sign_3"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_jumpImm_T_1 = firrtl.bits %148 19 to 12 {name = "_decodeReg_decodeSignals_jumpImm_T_1"} : (!firrtl.uint<32>) -> !firrtl.uint<8>
      %_decodeReg_decodeSignals_jumpImm_T_2 = firrtl.bits %148 20 to 20 {name = "_decodeReg_decodeSignals_jumpImm_T_2"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_jumpImm_T_3 = firrtl.bits %148 30 to 21 {name = "_decodeReg_decodeSignals_jumpImm_T_3"} : (!firrtl.uint<32>) -> !firrtl.uint<10>
      %_decodeReg_decodeSignals_dec_imm_T_8 = firrtl.mux(%decodeReg_decodeSignals_dec_imm_sign_3, %c2047_ui11, %c0_ui11) {name = "_decodeReg_decodeSignals_dec_imm_T_8"} : (!firrtl.uint<1>, !firrtl.uint<11>, !firrtl.uint<11>) -> !firrtl.uint<11>
      %_decodeReg_decodeSignals_dec_imm_T_9 = firrtl.cat %_decodeReg_decodeSignals_dec_imm_T_8, %decodeReg_decodeSignals_dec_imm_sign_3, %_decodeReg_decodeSignals_jumpImm_T_1, %_decodeReg_decodeSignals_jumpImm_T_2, %_decodeReg_decodeSignals_jumpImm_T_3, %c0_ui1 {name = "_decodeReg_decodeSignals_dec_imm_T_9"} : (!firrtl.uint<11>, !firrtl.uint<1>, !firrtl.uint<8>, !firrtl.uint<1>, !firrtl.uint<10>, !firrtl.uint<1>) -> !firrtl.uint<32>
      %_decodeReg_decodeSignals_T_26 = firrtl.eq %decodeReg_decodeSignals_opcode, %c103_ui7 {name = "_decodeReg_decodeSignals_T_26"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %251 = firrtl.or %_decodeReg_decodeSignals_T_24, %_decodeReg_decodeSignals_T_25 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %252 = firrtl.or %_decodeReg_decodeSignals_T_23, %251 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %253 = firrtl.or %_decodeReg_decodeSignals_T_22, %252 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %254 = firrtl.or %_decodeReg_decodeSignals_T_11, %253 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %255 = firrtl.or %_decodeReg_decodeSignals_T, %254 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %256 = firrtl.mux(%255, %c0_ui1, %_decodeReg_decodeSignals_T_26) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_dec_imm_T_10 = firrtl.bits %148 31 to 20 {name = "_decodeReg_decodeSignals_dec_imm_T_10"} : (!firrtl.uint<32>) -> !firrtl.uint<12>
      %decodeReg_decodeSignals_dec_imm_sign_4 = firrtl.bits %148 31 to 31 {name = "decodeReg_decodeSignals_dec_imm_sign_4"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_dec_imm_T_11 = firrtl.mux(%decodeReg_decodeSignals_dec_imm_sign_4, %c1048575_ui20, %c0_ui20) {name = "_decodeReg_decodeSignals_dec_imm_T_11"} : (!firrtl.uint<1>, !firrtl.uint<20>, !firrtl.uint<20>) -> !firrtl.uint<20>
      %_decodeReg_decodeSignals_dec_imm_T_12 = firrtl.cat %_decodeReg_decodeSignals_dec_imm_T_11, %_decodeReg_decodeSignals_dec_imm_T_10 {name = "_decodeReg_decodeSignals_dec_imm_T_12"} : (!firrtl.uint<20>, !firrtl.uint<12>) -> !firrtl.uint<32>
      %_decodeReg_decodeSignals_T_27 = firrtl.eq %decodeReg_decodeSignals_opcode, %c55_ui7 {name = "_decodeReg_decodeSignals_T_27"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %257 = firrtl.or %_decodeReg_decodeSignals_T_25, %_decodeReg_decodeSignals_T_26 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %258 = firrtl.or %_decodeReg_decodeSignals_T_24, %257 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %259 = firrtl.or %_decodeReg_decodeSignals_T_23, %258 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %260 = firrtl.or %_decodeReg_decodeSignals_T_22, %259 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %261 = firrtl.or %_decodeReg_decodeSignals_T_11, %260 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %262 = firrtl.or %_decodeReg_decodeSignals_T, %261 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %263 = firrtl.mux(%262, %c0_ui1, %_decodeReg_decodeSignals_T_27) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_dec_imm_T_13 = firrtl.bits %148 31 to 12 {name = "_decodeReg_decodeSignals_dec_imm_T_13"} : (!firrtl.uint<32>) -> !firrtl.uint<20>
      %_decodeReg_decodeSignals_dec_imm_T_15 = firrtl.cat %_decodeReg_decodeSignals_dec_imm_T_13, %c0_ui12 {name = "_decodeReg_decodeSignals_dec_imm_T_15"} : (!firrtl.uint<20>, !firrtl.uint<12>) -> !firrtl.uint<32>
      %_decodeReg_decodeSignals_T_28 = firrtl.eq %decodeReg_decodeSignals_opcode, %c23_ui7 {name = "_decodeReg_decodeSignals_T_28"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %264 = firrtl.or %_decodeReg_decodeSignals_T_26, %_decodeReg_decodeSignals_T_27 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %265 = firrtl.or %_decodeReg_decodeSignals_T_25, %264 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %266 = firrtl.or %_decodeReg_decodeSignals_T_24, %265 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %267 = firrtl.or %_decodeReg_decodeSignals_T_23, %266 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %268 = firrtl.or %_decodeReg_decodeSignals_T_22, %267 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %269 = firrtl.or %_decodeReg_decodeSignals_T_11, %268 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %270 = firrtl.or %_decodeReg_decodeSignals_T, %269 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %271 = firrtl.mux(%270, %c0_ui1, %_decodeReg_decodeSignals_T_28) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %272 = firrtl.or %_decodeReg_decodeSignals_T_27, %_decodeReg_decodeSignals_T_28 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %273 = firrtl.or %_decodeReg_decodeSignals_T_26, %272 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %274 = firrtl.or %_decodeReg_decodeSignals_T_24, %_decodeReg_decodeSignals_T_25 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %275 = firrtl.mux(%274, %c0_ui1, %273) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %276 = firrtl.or %_decodeReg_decodeSignals_T_22, %_decodeReg_decodeSignals_T_23 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %277 = firrtl.or %_decodeReg_decodeSignals_T_11, %276 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %278 = firrtl.mux(%277, %c1_ui1, %275) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %279 = firrtl.mux(%_decodeReg_decodeSignals_T, %c0_ui1, %278) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_dec_imm_T_16 = firrtl.bits %148 31 to 12 {name = "_decodeReg_decodeSignals_dec_imm_T_16"} : (!firrtl.uint<32>) -> !firrtl.uint<20>
      %_decodeReg_decodeSignals_dec_imm_T_18 = firrtl.cat %_decodeReg_decodeSignals_dec_imm_T_16, %c0_ui12 {name = "_decodeReg_decodeSignals_dec_imm_T_18"} : (!firrtl.uint<20>, !firrtl.uint<12>) -> !firrtl.uint<32>
      %280 = firrtl.mux(%_decodeReg_decodeSignals_T_28, %_decodeReg_decodeSignals_dec_imm_T_18, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %281 = firrtl.mux(%_decodeReg_decodeSignals_T_27, %_decodeReg_decodeSignals_dec_imm_T_15, %280) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %282 = firrtl.mux(%_decodeReg_decodeSignals_T_26, %_decodeReg_decodeSignals_dec_imm_T_12, %281) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %283 = firrtl.mux(%_decodeReg_decodeSignals_T_25, %_decodeReg_decodeSignals_dec_imm_T_9, %282) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %284 = firrtl.mux(%_decodeReg_decodeSignals_T_24, %_decodeReg_decodeSignals_dec_imm_T_6, %283) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %285 = firrtl.mux(%_decodeReg_decodeSignals_T_23, %_decodeReg_decodeSignals_dec_imm_T_4, %284) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %286 = firrtl.mux(%_decodeReg_decodeSignals_T_22, %_decodeReg_decodeSignals_dec_imm_T_2, %285) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %287 = firrtl.mux(%_decodeReg_decodeSignals_T_11, %decodeReg_decodeSignals_immI, %286) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %288 = firrtl.mux(%_decodeReg_decodeSignals_T, %c0_ui32, %287) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %_decodeReg_decodeSignals_T_29 = firrtl.eq %decodeReg_decodeSignals_opcode, %c115_ui7 {name = "_decodeReg_decodeSignals_T_29"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %289 = firrtl.or %_decodeReg_decodeSignals_T_27, %_decodeReg_decodeSignals_T_28 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %290 = firrtl.or %_decodeReg_decodeSignals_T_26, %289 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %291 = firrtl.or %_decodeReg_decodeSignals_T_25, %290 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %292 = firrtl.or %_decodeReg_decodeSignals_T_24, %291 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %293 = firrtl.or %_decodeReg_decodeSignals_T_23, %292 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %294 = firrtl.or %_decodeReg_decodeSignals_T_22, %293 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %295 = firrtl.or %_decodeReg_decodeSignals_T_11, %294 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %296 = firrtl.or %_decodeReg_decodeSignals_T, %295 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %297 = firrtl.mux(%296, %c0_ui1, %_decodeReg_decodeSignals_T_29) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_30 = firrtl.eq %decodeReg_decodeSignals_opcode, %c15_ui7 {name = "_decodeReg_decodeSignals_T_30"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %298 = firrtl.or %_decodeReg_decodeSignals_T_28, %_decodeReg_decodeSignals_T_29 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %299 = firrtl.or %_decodeReg_decodeSignals_T_27, %298 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %300 = firrtl.or %_decodeReg_decodeSignals_T_26, %299 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %301 = firrtl.or %_decodeReg_decodeSignals_T_25, %300 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %302 = firrtl.or %_decodeReg_decodeSignals_T_24, %301 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %303 = firrtl.or %_decodeReg_decodeSignals_T_23, %302 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %304 = firrtl.or %_decodeReg_decodeSignals_T_22, %303 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %305 = firrtl.or %_decodeReg_decodeSignals_T_11, %304 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %306 = firrtl.or %_decodeReg_decodeSignals_T, %305 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %307 = firrtl.mux(%306, %c0_ui1, %_decodeReg_decodeSignals_T_30) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %308 = firrtl.bundlecreate %224, %238, %241, %245, %250, %256, %263, %271, %297, %307, %279, %_decodeReg_decodeSignals_dec_rs1_T, %_decodeReg_decodeSignals_dec_rs2_T, %_decodeReg_decodeSignals_storeImm_T_1, %236, %288 : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<32>) -> !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      firrtl.matchingconnect %decodeReg_decodeSignals_dec, %308 : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %309 = firrtl.subfield %decodeReg_decodeSignals_dec[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %310 = firrtl.mux(%150, %309, %187) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %311 = firrtl.subfield %decodeReg_decodeSignals_dec[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %312 = firrtl.mux(%150, %311, %188) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %313 = firrtl.subfield %decodeReg_decodeSignals_dec[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %314 = firrtl.mux(%150, %313, %189) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %315 = firrtl.subfield %decodeReg_decodeSignals_dec[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %316 = firrtl.mux(%150, %315, %190) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %317 = firrtl.subfield %decodeReg_decodeSignals_dec[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %318 = firrtl.mux(%150, %317, %191) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %319 = firrtl.subfield %decodeReg_decodeSignals_dec[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %320 = firrtl.mux(%150, %319, %192) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %321 = firrtl.subfield %decodeReg_decodeSignals_dec[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %322 = firrtl.mux(%150, %321, %193) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %323 = firrtl.subfield %decodeReg_decodeSignals_dec[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %324 = firrtl.mux(%150, %323, %194) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %325 = firrtl.subfield %decodeReg_decodeSignals_dec[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %326 = firrtl.mux(%150, %325, %195) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %327 = firrtl.subfield %decodeReg_decodeSignals_dec[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %328 = firrtl.mux(%150, %327, %196) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %329 = firrtl.subfield %decodeReg_decodeSignals_dec[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %330 = firrtl.mux(%150, %329, %197) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %331 = firrtl.subfield %decodeReg_decodeSignals_dec[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %332 = firrtl.mux(%150, %331, %198) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %333 = firrtl.subfield %decodeReg_decodeSignals_dec[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %334 = firrtl.mux(%150, %333, %199) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %335 = firrtl.subfield %decodeReg_decodeSignals_dec[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %336 = firrtl.mux(%150, %335, %200) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %337 = firrtl.subfield %decodeReg_decodeSignals_dec[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %338 = firrtl.mux(%150, %337, %201) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %339 = firrtl.subfield %decodeReg_decodeSignals_dec[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %340 = firrtl.mux(%150, %339, %202) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %341 = firrtl.mux(%150, %206, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %342 = firrtl.bundlecreate %341, %208, %210, %212 : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %_dispatchReg_WIRE = firrtl.wire : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %dispatchReg = firrtl.regreset %clock, %reset, %_dispatchReg_WIRE {firrtl.random_init_start = 1482 : ui64} : !firrtl.clock, !firrtl.uint<1>, !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %343 = firrtl.subfield %dispatchReg[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %344 = firrtl.subfield %343[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %345 = firrtl.subfield %344[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %346 = firrtl.subfield %344[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %347 = firrtl.subfield %344[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %348 = firrtl.subfield %343[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %349 = firrtl.subfield %348[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %350 = firrtl.subfield %348[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %351 = firrtl.subfield %348[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %352 = firrtl.subfield %348[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %353 = firrtl.subfield %348[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %354 = firrtl.subfield %348[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %355 = firrtl.subfield %348[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %356 = firrtl.subfield %348[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %357 = firrtl.subfield %348[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %358 = firrtl.subfield %348[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %359 = firrtl.subfield %348[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %360 = firrtl.subfield %348[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %361 = firrtl.subfield %348[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %362 = firrtl.subfield %348[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %363 = firrtl.subfield %348[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %364 = firrtl.subfield %348[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %365 = firrtl.subfield %dispatchReg[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %366 = firrtl.subfield %365[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %367 = firrtl.subfield %366[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %368 = firrtl.subfield %366[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %369 = firrtl.subfield %365[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %370 = firrtl.subfield %369[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %371 = firrtl.subfield %369[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %372 = firrtl.subfield %decodeReg[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %373 = firrtl.subfield %372[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %374 = firrtl.subfield %372[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %375 = firrtl.mux(%205, %374, %345) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %376 = firrtl.subfield %372[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %377 = firrtl.mux(%205, %376, %346) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %378 = firrtl.subfield %372[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %379 = firrtl.mux(%205, %378, %347) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %380 = firrtl.subfield %decodeReg[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %381 = firrtl.subfield %380[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %382 = firrtl.mux(%205, %381, %349) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %383 = firrtl.subfield %380[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %384 = firrtl.mux(%205, %383, %350) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %385 = firrtl.subfield %380[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %386 = firrtl.mux(%205, %385, %351) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %387 = firrtl.subfield %380[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %388 = firrtl.mux(%205, %387, %352) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %389 = firrtl.subfield %380[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %390 = firrtl.mux(%205, %389, %353) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %391 = firrtl.subfield %380[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %392 = firrtl.mux(%205, %391, %354) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %393 = firrtl.subfield %380[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %394 = firrtl.mux(%205, %393, %355) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %395 = firrtl.subfield %380[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %396 = firrtl.mux(%205, %395, %356) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %397 = firrtl.subfield %380[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %398 = firrtl.mux(%205, %397, %357) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %399 = firrtl.subfield %380[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %400 = firrtl.mux(%205, %399, %358) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %401 = firrtl.subfield %380[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %402 = firrtl.mux(%205, %401, %359) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %403 = firrtl.subfield %380[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %404 = firrtl.mux(%205, %403, %360) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %405 = firrtl.subfield %380[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %406 = firrtl.mux(%205, %405, %361) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %407 = firrtl.subfield %380[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %408 = firrtl.mux(%205, %407, %362) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %409 = firrtl.subfield %380[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %410 = firrtl.mux(%205, %409, %363) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %411 = firrtl.subfield %380[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %412 = firrtl.mux(%205, %411, %364) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %413 = firrtl.mux(%205, %373, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_regReadReg_WIRE = firrtl.wire : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %regReadReg = firrtl.regreset %clock, %reset, %_regReadReg_WIRE {firrtl.random_init_start = 1613 : ui64} : !firrtl.clock, !firrtl.uint<1>, !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %414 = firrtl.subfield %regReadReg[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %415 = firrtl.subfield %414[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %416 = firrtl.subfield %415[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %417 = firrtl.subfield %416[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %418 = firrtl.subfield %416[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %419 = firrtl.subfield %416[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %420 = firrtl.subfield %415[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %421 = firrtl.subfield %420[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %422 = firrtl.subfield %420[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %423 = firrtl.subfield %420[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %424 = firrtl.subfield %420[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %425 = firrtl.subfield %420[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %426 = firrtl.subfield %420[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %427 = firrtl.subfield %420[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %428 = firrtl.subfield %420[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %429 = firrtl.subfield %420[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %430 = firrtl.subfield %420[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %431 = firrtl.subfield %420[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %432 = firrtl.subfield %420[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %433 = firrtl.subfield %420[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %434 = firrtl.subfield %420[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %435 = firrtl.subfield %420[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %436 = firrtl.subfield %420[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %437 = firrtl.subfield %regReadReg[rs1Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %438 = firrtl.subfield %regReadReg[rs2Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %439 = firrtl.subfield %regReadReg[rs2Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %440 = firrtl.subfield %regReadReg[rs1Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %441 = firrtl.subfield %regReadReg[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %442 = firrtl.subfield %441[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %443 = firrtl.subfield %442[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %444 = firrtl.subfield %443[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %445 = firrtl.subfield %443[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %446 = firrtl.subfield %443[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %447 = firrtl.subfield %443[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %448 = firrtl.subfield %443[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %449 = firrtl.subfield %443[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %450 = firrtl.subfield %443[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %451 = firrtl.subfield %443[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %452 = firrtl.subfield %443[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %453 = firrtl.subfield %443[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %454 = firrtl.subfield %442[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %455 = firrtl.subfield %454[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %456 = firrtl.subfield %454[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %457 = firrtl.subfield %454[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %458 = firrtl.subfield %454[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %459 = firrtl.subfield %dispatchReg[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %460 = firrtl.subfield %459[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %461 = firrtl.subfield %460[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %462 = firrtl.subfield %460[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %463 = firrtl.mux(%371, %462, %417) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %464 = firrtl.subfield %460[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %465 = firrtl.mux(%371, %464, %418) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %466 = firrtl.subfield %460[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %467 = firrtl.mux(%371, %466, %419) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %468 = firrtl.subfield %459[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %469 = firrtl.subfield %468[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %470 = firrtl.mux(%371, %469, %421) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %471 = firrtl.subfield %468[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %472 = firrtl.mux(%371, %471, %422) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %473 = firrtl.subfield %468[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %474 = firrtl.mux(%371, %473, %423) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %475 = firrtl.subfield %468[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %476 = firrtl.mux(%371, %475, %424) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %477 = firrtl.subfield %468[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %478 = firrtl.mux(%371, %477, %425) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %479 = firrtl.subfield %468[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %480 = firrtl.mux(%371, %479, %426) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %481 = firrtl.subfield %468[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %482 = firrtl.mux(%371, %481, %427) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %483 = firrtl.subfield %468[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %484 = firrtl.mux(%371, %483, %428) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %485 = firrtl.subfield %468[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %486 = firrtl.mux(%371, %485, %429) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %487 = firrtl.subfield %468[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %488 = firrtl.mux(%371, %487, %430) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %489 = firrtl.subfield %468[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %490 = firrtl.mux(%371, %489, %431) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %491 = firrtl.subfield %468[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %492 = firrtl.mux(%371, %491, %432) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %493 = firrtl.subfield %468[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %494 = firrtl.mux(%371, %493, %433) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %495 = firrtl.subfield %468[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %496 = firrtl.mux(%371, %495, %434) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %497 = firrtl.subfield %468[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %498 = firrtl.mux(%371, %497, %435) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %499 = firrtl.subfield %468[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %500 = firrtl.mux(%371, %499, %436) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %501 = firrtl.mux(%371, %370, %c0_ui3) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %502 = firrtl.mux(%371, %368, %c0_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %503 = firrtl.mux(%371, %367, %c0_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %504 = firrtl.mux(%371, %115, %437) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %505 = firrtl.mux(%371, %114, %438) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %506 = firrtl.mux(%371, %461, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_exec1Reg_WIRE = firrtl.wire : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %exec1Reg = firrtl.regreset %clock, %reset, %_exec1Reg_WIRE {firrtl.random_init_start = 1808 : ui64} : !firrtl.clock, !firrtl.uint<1>, !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>, !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %507 = firrtl.subfield %exec1Reg[regReadSignals] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %508 = firrtl.subfield %507[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %509 = firrtl.subfield %508[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %510 = firrtl.subfield %509[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %511 = firrtl.subfield %510[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %512 = firrtl.subfield %510[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %513 = firrtl.subfield %510[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %514 = firrtl.subfield %509[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %515 = firrtl.subfield %514[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %516 = firrtl.subfield %514[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %517 = firrtl.subfield %514[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %518 = firrtl.subfield %514[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %519 = firrtl.subfield %514[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %520 = firrtl.subfield %514[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %521 = firrtl.subfield %514[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %522 = firrtl.subfield %514[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %523 = firrtl.subfield %514[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %524 = firrtl.subfield %514[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %525 = firrtl.subfield %514[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %526 = firrtl.subfield %514[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %527 = firrtl.subfield %514[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %528 = firrtl.subfield %514[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %529 = firrtl.subfield %514[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %530 = firrtl.subfield %514[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %531 = firrtl.subfield %507[rs1Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %532 = firrtl.subfield %507[rs2Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %533 = firrtl.subfield %exec1Reg[result] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %534 = firrtl.subfield %exec1Reg[doRegFileWrite] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %535 = firrtl.subfield %exec1Reg[ctrlTaken] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %536 = firrtl.subfield %exec1Reg[ctrlTarget] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %537 = firrtl.subfield %exec1Reg[ctrlTarget] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %538 = firrtl.subfield %exec1Reg[ctrlTaken] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %539 = firrtl.subfield %exec1Reg[regReadSignals] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %540 = firrtl.subfield %539[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %541 = firrtl.subfield %540[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %542 = firrtl.subfield %541[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %543 = firrtl.subfield %542[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %544 = firrtl.subfield %542[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %545 = firrtl.subfield %regReadReg[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %546 = firrtl.subfield %545[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %547 = firrtl.subfield %546[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %548 = firrtl.subfield %547[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %549 = firrtl.subfield %547[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %550 = firrtl.mux(%458, %549, %511) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %551 = firrtl.subfield %547[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %552 = firrtl.mux(%458, %551, %512) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %553 = firrtl.subfield %547[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %554 = firrtl.mux(%458, %553, %513) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %555 = firrtl.subfield %546[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %556 = firrtl.subfield %555[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %557 = firrtl.mux(%458, %556, %515) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %558 = firrtl.subfield %555[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %559 = firrtl.mux(%458, %558, %516) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %560 = firrtl.subfield %555[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %561 = firrtl.mux(%458, %560, %517) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %562 = firrtl.subfield %555[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %563 = firrtl.mux(%458, %562, %518) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %564 = firrtl.subfield %555[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %565 = firrtl.mux(%458, %564, %519) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %566 = firrtl.subfield %555[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %567 = firrtl.mux(%458, %566, %520) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %568 = firrtl.subfield %555[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %569 = firrtl.mux(%458, %568, %521) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %570 = firrtl.subfield %555[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %571 = firrtl.mux(%458, %570, %522) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %572 = firrtl.subfield %555[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %573 = firrtl.mux(%458, %572, %523) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %574 = firrtl.subfield %555[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %575 = firrtl.mux(%458, %574, %524) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %576 = firrtl.subfield %555[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %577 = firrtl.mux(%458, %576, %525) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %578 = firrtl.subfield %555[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %579 = firrtl.mux(%458, %578, %526) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %580 = firrtl.subfield %555[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %581 = firrtl.mux(%458, %580, %527) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %582 = firrtl.subfield %555[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %583 = firrtl.mux(%458, %582, %528) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %584 = firrtl.subfield %555[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %585 = firrtl.mux(%458, %584, %529) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %586 = firrtl.subfield %555[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %587 = firrtl.mux(%458, %586, %530) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %588 = firrtl.subfield %regReadReg[rs1Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %589 = firrtl.mux(%458, %588, %531) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %590 = firrtl.subfield %regReadReg[rs2Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %591 = firrtl.mux(%458, %590, %532) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %opcode = firrtl.bits %457 6 to 0 {name = "opcode"} : (!firrtl.uint<32>) -> !firrtl.uint<7>
      %_isMExt_T_1 = firrtl.eq %opcode, %c51_ui7 {name = "_isMExt_T_1"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %_isMExt_T_2 = firrtl.bits %457 31 to 25 {name = "_isMExt_T_2"} : (!firrtl.uint<32>) -> !firrtl.uint<7>
      %_isMExt_T_3 = firrtl.eq %_isMExt_T_2, %c1_ui7 {name = "_isMExt_T_3"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %isMExt = firrtl.and %_isMExt_T_1, %_isMExt_T_3 {name = "isMExt"} : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %funct3 = firrtl.bits %457 14 to 12 {name = "funct3"} : (!firrtl.uint<32>) -> !firrtl.uint<3>
      %_isMulInstr_T = firrtl.leq %funct3, %c3_ui2 {name = "_isMulInstr_T"} : (!firrtl.uint<3>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %isMulInstr = firrtl.and %isMExt, %_isMulInstr_T {name = "isMulInstr"} : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %592 = firrtl.mux(%458, %440, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %593 = firrtl.mux(%458, %439, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %_mulUnit_io_signedB_T = firrtl.neq %funct3, %c3_ui2 {name = "_mulUnit_io_signedB_T"} : (!firrtl.uint<3>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %594 = firrtl.mux(%458, %_mulUnit_io_signedB_T, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_mulUnit_io_signedB_T_1 = firrtl.neq %funct3, %c2_ui2 {name = "_mulUnit_io_signedB_T_1"} : (!firrtl.uint<3>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %_mulUnit_io_signedB_T_2 = firrtl.and %_mulUnit_io_signedB_T, %_mulUnit_io_signedB_T_1 {name = "_mulUnit_io_signedB_T_2"} : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %595 = firrtl.mux(%458, %_mulUnit_io_signedB_T_2, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %596 = firrtl.bundlecreate %592, %593, %594, %595, %mulUnit_io_product, %mulUnit_io_lo, %mulUnit_io_hi : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<64>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      firrtl.matchingconnect %mulUnit.io, %596 : !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      %_mulResult_T_2 = firrtl.eq %funct3, %c1_ui1 {name = "_mulResult_T_2"} : (!firrtl.uint<3>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_mulResult_T_4 = firrtl.eq %funct3, %c2_ui2 {name = "_mulResult_T_4"} : (!firrtl.uint<3>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %597 = firrtl.or %_mulResult_T_4, %_mulResult_T_2 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_mulResult_T_6 = firrtl.eq %funct3, %c3_ui2 {name = "_mulResult_T_6"} : (!firrtl.uint<3>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %598 = firrtl.or %_mulResult_T_6, %597 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %mulResult = firrtl.mux(%598, %124, %_mulResult_T_1) {name = "mulResult"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %599 = firrtl.or %453, %452 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %600 = firrtl.or %599, %451 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_useImm_T = firrtl.eq %opcode, %c19_ui7 {name = "_useImm_T"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %_useImm_T_1 = firrtl.or %_useImm_T, %452 {name = "_useImm_T_1"} : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %useImm = firrtl.or %_useImm_T_1, %451 {name = "useImm"} : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_opA_T = firrtl.mux(%452, %c0_ui32, %440) {name = "_opA_T"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %opA = firrtl.mux(%451, %456, %_opA_T) {name = "opA"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %opB = firrtl.mux(%useImm, %450, %439) {name = "opB"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %601 = firrtl.and %458, %600 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %602 = firrtl.mux(%601, %opA, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %603 = firrtl.and %458, %600 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %604 = firrtl.mux(%603, %opB, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %605 = firrtl.and %458, %600 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %606 = firrtl.mux(%605, %449, %c0_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %607 = firrtl.bundlecreate %602, %604, %606, %alu_io_result : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<5>, !firrtl.uint<32>) -> !firrtl.bundle<a: uint<32>, b: uint<32>, opcode: uint<5>, result: uint<32>>
      firrtl.matchingconnect %alu.io, %607 : !firrtl.bundle<a: uint<32>, b: uint<32>, opcode: uint<5>, result: uint<32>>
      %_result_T = firrtl.add %456, %450 {name = "_result_T"} : (!firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<33>
      %_result_T_1 = firrtl.bits %_result_T 31 to 0 {name = "_result_T_1"} : (!firrtl.uint<33>) -> !firrtl.uint<32>
      %_result_T_2 = firrtl.mux(%452, %450, %119) {name = "_result_T_2"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %result = firrtl.mux(%451, %_result_T_1, %_result_T_2) {name = "result"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %_exec1Reg_result_T = firrtl.add %456, %c4_ui3 {name = "_exec1Reg_result_T"} : (!firrtl.uint<32>, !firrtl.uint<3>) -> !firrtl.uint<33>
      %_exec1Reg_result_T_1 = firrtl.bits %_exec1Reg_result_T 31 to 0 {name = "_exec1Reg_result_T_1"} : (!firrtl.uint<33>) -> !firrtl.uint<32>
      %_exec1Reg_ctrlTarget_T = firrtl.asSInt %456 {name = "_exec1Reg_ctrlTarget_T"} : (!firrtl.uint<32>) -> !firrtl.sint<32>
      %_exec1Reg_ctrlTarget_T_1 = firrtl.asSInt %450 {name = "_exec1Reg_ctrlTarget_T_1"} : (!firrtl.uint<32>) -> !firrtl.sint<32>
      %_exec1Reg_ctrlTarget_T_2 = firrtl.add %_exec1Reg_ctrlTarget_T, %_exec1Reg_ctrlTarget_T_1 {name = "_exec1Reg_ctrlTarget_T_2"} : (!firrtl.sint<32>, !firrtl.sint<32>) -> !firrtl.sint<33>
      %_exec1Reg_ctrlTarget_T_5 = firrtl.bits %_exec1Reg_ctrlTarget_T_2 31 to 0 {name = "_exec1Reg_ctrlTarget_T_5"} : (!firrtl.sint<33>) -> !firrtl.uint<32>
      %_target_T = firrtl.asSInt %440 {name = "_target_T"} : (!firrtl.uint<32>) -> !firrtl.sint<32>
      %_target_T_1 = firrtl.asSInt %450 {name = "_target_T_1"} : (!firrtl.uint<32>) -> !firrtl.sint<32>
      %_target_T_2 = firrtl.add %_target_T, %_target_T_1 {name = "_target_T_2"} : (!firrtl.sint<32>, !firrtl.sint<32>) -> !firrtl.sint<33>
      %_target_T_5 = firrtl.bits %_target_T_2 31 to 0 {name = "_target_T_5"} : (!firrtl.sint<33>) -> !firrtl.uint<32>
      %target = firrtl.and %_target_T_5, %c4294967294_ui32 {name = "target"} : (!firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %_exec1Reg_result_T_2 = firrtl.add %456, %c4_ui3 {name = "_exec1Reg_result_T_2"} : (!firrtl.uint<32>, !firrtl.uint<3>) -> !firrtl.uint<33>
      %_exec1Reg_result_T_3 = firrtl.bits %_exec1Reg_result_T_2 31 to 0 {name = "_exec1Reg_result_T_3"} : (!firrtl.uint<33>) -> !firrtl.uint<32>
      %608 = firrtl.mux(%446, %440, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %609 = firrtl.or %448, %447 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %610 = firrtl.or %isMulInstr, %609 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %611 = firrtl.or %600, %610 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %612 = firrtl.mux(%611, %c0_ui32, %608) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %613 = firrtl.mux(%458, %612, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %614 = firrtl.mux(%446, %439, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %615 = firrtl.or %448, %447 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %616 = firrtl.or %isMulInstr, %615 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %617 = firrtl.or %600, %616 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %618 = firrtl.mux(%617, %c0_ui32, %614) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %619 = firrtl.mux(%458, %618, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %620 = firrtl.mux(%446, %456, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %621 = firrtl.or %448, %447 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %622 = firrtl.or %isMulInstr, %621 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %623 = firrtl.or %600, %622 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %624 = firrtl.mux(%623, %c0_ui32, %620) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %625 = firrtl.mux(%458, %624, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %_branchUnit_io_imm_T = firrtl.shl %450, 1 {name = "_branchUnit_io_imm_T"} : (!firrtl.uint<32>) -> !firrtl.uint<33>
      %_branchUnit_io_imm_T_1 = firrtl.asSInt %_branchUnit_io_imm_T {name = "_branchUnit_io_imm_T_1"} : (!firrtl.uint<33>) -> !firrtl.sint<33>
      %626 = firrtl.bits %_branchUnit_io_imm_T_1 31 to 0 : (!firrtl.sint<33>) -> !firrtl.uint<32>
      %627 = firrtl.asSInt %626 : (!firrtl.uint<32>) -> !firrtl.sint<32>
      %628 = firrtl.mux(%446, %627, %c0_si32) : (!firrtl.uint<1>, !firrtl.sint<32>, !firrtl.sint<32>) -> !firrtl.sint<32>
      %629 = firrtl.or %448, %447 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %630 = firrtl.or %isMulInstr, %629 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %631 = firrtl.or %600, %630 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %632 = firrtl.mux(%631, %c0_si32, %628) : (!firrtl.uint<1>, !firrtl.sint<32>, !firrtl.sint<32>) -> !firrtl.sint<32>
      %633 = firrtl.mux(%458, %632, %c0_si32) : (!firrtl.uint<1>, !firrtl.sint<32>, !firrtl.sint<32>) -> !firrtl.sint<32>
      %634 = firrtl.mux(%446, %funct3, %c0_ui3) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %635 = firrtl.or %448, %447 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %636 = firrtl.or %isMulInstr, %635 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %637 = firrtl.or %600, %636 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %638 = firrtl.mux(%637, %c0_ui3, %634) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %639 = firrtl.mux(%458, %638, %c0_ui3) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %640 = firrtl.or %448, %447 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %641 = firrtl.or %isMulInstr, %640 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %642 = firrtl.or %600, %641 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %643 = firrtl.mux(%642, %c0_ui1, %446) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %644 = firrtl.mux(%458, %643, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %645 = firrtl.bundlecreate %613, %619, %625, %633, %639, %644, %branchUnit_io_taken, %branchUnit_io_target, %branchUnit_io_nextPc, %branchUnit_io_misaligned : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.sint<32>, !firrtl.uint<3>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<1>) -> !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      firrtl.matchingconnect %branchUnit.io, %645 : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      %646 = firrtl.mux(%446, %131, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %647 = firrtl.or %448, %447 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %648 = firrtl.mux(%647, %c1_ui1, %646) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %649 = firrtl.or %600, %isMulInstr : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %650 = firrtl.mux(%649, %c0_ui1, %648) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %651 = firrtl.mux(%458, %650, %535) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %652 = firrtl.mux(%446, %132, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %653 = firrtl.mux(%447, %target, %652) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %654 = firrtl.mux(%448, %_exec1Reg_ctrlTarget_T_5, %653) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %655 = firrtl.or %600, %isMulInstr : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %656 = firrtl.mux(%655, %c0_ui32, %654) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %657 = firrtl.mux(%458, %656, %536) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %_address_T = firrtl.add %440, %450 {name = "_address_T"} : (!firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<33>
      %address = firrtl.bits %_address_T 31 to 0 {name = "address"} : (!firrtl.uint<33>) -> !firrtl.uint<32>
      %_io_memAddr_T = firrtl.bits %_address_T 31 to 2 {name = "_io_memAddr_T"} : (!firrtl.uint<33>) -> !firrtl.uint<30>
      %_io_memAddr_T_1 = firrtl.cat %_io_memAddr_T, %c0_ui2 {name = "_io_memAddr_T_1"} : (!firrtl.uint<30>, !firrtl.uint<2>) -> !firrtl.uint<32>
      %658 = firrtl.subaccess %io_threadEnable_0[%455] : !firrtl.vector<uint<1>, 8>, !firrtl.uint<3>
      %659 = firrtl.mux(%445, %address, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %660 = firrtl.or %447, %446 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %661 = firrtl.or %448, %660 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %662 = firrtl.or %isMulInstr, %661 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %663 = firrtl.or %600, %662 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %664 = firrtl.mux(%663, %c0_ui32, %659) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %665 = firrtl.mux(%458, %664, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %666 = firrtl.mux(%445, %funct3, %c0_ui3) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %667 = firrtl.or %447, %446 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %668 = firrtl.or %448, %667 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %669 = firrtl.or %isMulInstr, %668 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %670 = firrtl.or %600, %669 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %671 = firrtl.mux(%670, %c0_ui3, %666) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %672 = firrtl.mux(%458, %671, %c0_ui3) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %673 = firrtl.bundlecreate %665, %io_dataMemResp, %672, %loadUnit_io_dataOut : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<3>, !firrtl.uint<32>) -> !firrtl.bundle<addr: uint<32>, dataIn: uint<32>, funct3: uint<3>, dataOut: uint<32>>
      firrtl.matchingconnect %loadUnit.io, %673 : !firrtl.bundle<addr: uint<32>, dataIn: uint<32>, funct3: uint<3>, dataOut: uint<32>>
      %674 = firrtl.mux(%445, %138, %533) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %675 = firrtl.mux(%446, %533, %674) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %676 = firrtl.mux(%447, %_exec1Reg_result_T_3, %675) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %677 = firrtl.mux(%448, %_exec1Reg_result_T_1, %676) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %678 = firrtl.mux(%isMulInstr, %mulResult, %677) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %679 = firrtl.mux(%600, %result, %678) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %680 = firrtl.mux(%458, %679, %533) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %681 = firrtl.mux(%446, %c0_ui1, %445) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %682 = firrtl.or %448, %447 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %683 = firrtl.or %isMulInstr, %682 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %684 = firrtl.or %600, %683 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %685 = firrtl.mux(%684, %c1_ui1, %681) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %686 = firrtl.mux(%458, %685, %534) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_address_T_1 = firrtl.add %440, %450 {name = "_address_T_1"} : (!firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<33>
      %address_1 = firrtl.bits %_address_T_1 31 to 0 {name = "address_1"} : (!firrtl.uint<33>) -> !firrtl.uint<32>
      %_storeActive_T = firrtl.not %144 {name = "_storeActive_T"} : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %687 = firrtl.subaccess %io_threadEnable_0[%455] : !firrtl.vector<uint<1>, 8>, !firrtl.uint<3>
      %storeActive = firrtl.and %687, %_storeActive_T {name = "storeActive"} : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_memAddr_T_2 = firrtl.bits %_address_T_1 31 to 2 {name = "_io_memAddr_T_2"} : (!firrtl.uint<33>) -> !firrtl.uint<30>
      %_io_memAddr_T_3 = firrtl.cat %_io_memAddr_T_2, %c0_ui2 {name = "_io_memAddr_T_3"} : (!firrtl.uint<30>, !firrtl.uint<2>) -> !firrtl.uint<32>
      %688 = firrtl.mux(%444, %_io_memAddr_T_3, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %689 = firrtl.mux(%445, %_io_memAddr_T_1, %688) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %690 = firrtl.or %447, %446 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %691 = firrtl.or %448, %690 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %692 = firrtl.or %isMulInstr, %691 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %693 = firrtl.or %600, %692 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %694 = firrtl.mux(%693, %c0_ui32, %689) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %695 = firrtl.mux(%458, %694, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      firrtl.matchingconnect %io_memAddr_1, %695 : !firrtl.uint<32>
      %696 = firrtl.mux(%444, %address_1, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %697 = firrtl.or %446, %445 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %698 = firrtl.or %447, %697 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %699 = firrtl.or %448, %698 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %700 = firrtl.or %isMulInstr, %699 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %701 = firrtl.or %600, %700 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %702 = firrtl.mux(%701, %c0_ui32, %696) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %703 = firrtl.mux(%458, %702, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %704 = firrtl.mux(%444, %439, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %705 = firrtl.or %446, %445 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %706 = firrtl.or %447, %705 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %707 = firrtl.or %448, %706 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %708 = firrtl.or %isMulInstr, %707 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %709 = firrtl.or %600, %708 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %710 = firrtl.mux(%709, %c0_ui32, %704) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %711 = firrtl.mux(%458, %710, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %_storeUnit_io_storeType_T = firrtl.bits %457 13 to 12 {name = "_storeUnit_io_storeType_T"} : (!firrtl.uint<32>) -> !firrtl.uint<2>
      %712 = firrtl.mux(%444, %_storeUnit_io_storeType_T, %c0_ui2) : (!firrtl.uint<1>, !firrtl.uint<2>, !firrtl.uint<2>) -> !firrtl.uint<2>
      %713 = firrtl.or %446, %445 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %714 = firrtl.or %447, %713 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %715 = firrtl.or %448, %714 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %716 = firrtl.or %isMulInstr, %715 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %717 = firrtl.or %600, %716 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %718 = firrtl.mux(%717, %c0_ui2, %712) : (!firrtl.uint<1>, !firrtl.uint<2>, !firrtl.uint<2>) -> !firrtl.uint<2>
      %719 = firrtl.mux(%458, %718, %c0_ui2) : (!firrtl.uint<1>, !firrtl.uint<2>, !firrtl.uint<2>) -> !firrtl.uint<2>
      %720 = firrtl.bundlecreate %703, %711, %719, %storeUnit_io_memWrite, %storeUnit_io_mask, %storeUnit_io_misaligned : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<2>, !firrtl.uint<32>, !firrtl.uint<4>, !firrtl.uint<1>) -> !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      firrtl.matchingconnect %storeUnit.io, %720 : !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      %721 = firrtl.and %444, %storeActive : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %722 = firrtl.mux(%721, %142, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %723 = firrtl.or %446, %445 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %724 = firrtl.or %447, %723 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %725 = firrtl.or %448, %724 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %726 = firrtl.or %isMulInstr, %725 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %727 = firrtl.or %600, %726 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %728 = firrtl.mux(%727, %c0_ui32, %722) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %729 = firrtl.mux(%458, %728, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      firrtl.matchingconnect %io_memWrite_2, %729 : !firrtl.uint<32>
      %730 = firrtl.and %444, %storeActive : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %731 = firrtl.mux(%730, %143, %c0_ui4) : (!firrtl.uint<1>, !firrtl.uint<4>, !firrtl.uint<4>) -> !firrtl.uint<4>
      %732 = firrtl.or %446, %445 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %733 = firrtl.or %447, %732 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %734 = firrtl.or %448, %733 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %735 = firrtl.or %isMulInstr, %734 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %736 = firrtl.or %600, %735 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %737 = firrtl.mux(%736, %c0_ui4, %731) : (!firrtl.uint<1>, !firrtl.uint<4>, !firrtl.uint<4>) -> !firrtl.uint<4>
      %738 = firrtl.mux(%458, %737, %c0_ui4) : (!firrtl.uint<1>, !firrtl.uint<4>, !firrtl.uint<4>) -> !firrtl.uint<4>
      firrtl.matchingconnect %io_memMask_3, %738 : !firrtl.uint<4>
      %739 = firrtl.mux(%444, %storeActive, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %740 = firrtl.mux(%445, %658, %739) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %741 = firrtl.or %447, %446 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %742 = firrtl.or %448, %741 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %743 = firrtl.or %isMulInstr, %742 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %744 = firrtl.or %600, %743 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %745 = firrtl.mux(%744, %c0_ui1, %740) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %746 = firrtl.mux(%458, %745, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      firrtl.matchingconnect %io_memValid_4, %746 : !firrtl.uint<1>
      %_io_memMisaligned_T = firrtl.and %687, %144 {name = "_io_memMisaligned_T"} : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %747 = firrtl.mux(%444, %_io_memMisaligned_T, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %748 = firrtl.or %446, %445 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %749 = firrtl.or %447, %748 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %750 = firrtl.or %448, %749 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %751 = firrtl.or %isMulInstr, %750 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %752 = firrtl.or %600, %751 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %753 = firrtl.mux(%752, %c0_ui1, %747) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %754 = firrtl.mux(%458, %753, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      firrtl.matchingconnect %io_memMisaligned_5, %754 : !firrtl.uint<1>
      %755 = firrtl.mux(%458, %548, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_exec2Reg_WIRE = firrtl.wire : !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %exec2Reg = firrtl.regreset %clock, %reset, %_exec2Reg_WIRE {firrtl.random_init_start = 2069 : ui64} : !firrtl.clock, !firrtl.uint<1>, !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>, !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %756 = firrtl.subfield %exec2Reg[exec1Signals] : !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %757 = firrtl.subfield %756[regReadSignals] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %758 = firrtl.subfield %757[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %759 = firrtl.subfield %758[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %760 = firrtl.subfield %759[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %761 = firrtl.subfield %760[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %762 = firrtl.subfield %760[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %763 = firrtl.subfield %760[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %764 = firrtl.subfield %759[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %765 = firrtl.subfield %764[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %766 = firrtl.subfield %764[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %767 = firrtl.subfield %764[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %768 = firrtl.subfield %764[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %769 = firrtl.subfield %764[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %770 = firrtl.subfield %764[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %771 = firrtl.subfield %764[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %772 = firrtl.subfield %764[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %773 = firrtl.subfield %764[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %774 = firrtl.subfield %764[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %775 = firrtl.subfield %764[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %776 = firrtl.subfield %764[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %777 = firrtl.subfield %764[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %778 = firrtl.subfield %764[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %779 = firrtl.subfield %764[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %780 = firrtl.subfield %764[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %781 = firrtl.subfield %757[rs1Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %782 = firrtl.subfield %757[rs2Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %783 = firrtl.subfield %756[result] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %784 = firrtl.subfield %756[doRegFileWrite] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %785 = firrtl.subfield %756[ctrlTaken] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %786 = firrtl.subfield %756[ctrlTarget] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %787 = firrtl.subfield %exec2Reg[exec1Signals] : !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %788 = firrtl.subfield %787[regReadSignals] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %789 = firrtl.subfield %788[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %790 = firrtl.subfield %789[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %791 = firrtl.subfield %790[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %792 = firrtl.subfield %791[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %793 = firrtl.subfield %791[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %794 = firrtl.subfield %exec1Reg[regReadSignals] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %795 = firrtl.subfield %794[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %796 = firrtl.subfield %795[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %797 = firrtl.subfield %796[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %798 = firrtl.subfield %797[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %799 = firrtl.subfield %797[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %800 = firrtl.mux(%544, %799, %761) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %801 = firrtl.subfield %797[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %802 = firrtl.mux(%544, %801, %762) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %803 = firrtl.subfield %797[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %804 = firrtl.mux(%544, %803, %763) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %805 = firrtl.subfield %796[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %806 = firrtl.subfield %805[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %807 = firrtl.mux(%544, %806, %765) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %808 = firrtl.subfield %805[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %809 = firrtl.mux(%544, %808, %766) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %810 = firrtl.subfield %805[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %811 = firrtl.mux(%544, %810, %767) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %812 = firrtl.subfield %805[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %813 = firrtl.mux(%544, %812, %768) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %814 = firrtl.subfield %805[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %815 = firrtl.mux(%544, %814, %769) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %816 = firrtl.subfield %805[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %817 = firrtl.mux(%544, %816, %770) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %818 = firrtl.subfield %805[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %819 = firrtl.mux(%544, %818, %771) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %820 = firrtl.subfield %805[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %821 = firrtl.mux(%544, %820, %772) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %822 = firrtl.subfield %805[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %823 = firrtl.mux(%544, %822, %773) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %824 = firrtl.subfield %805[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %825 = firrtl.mux(%544, %824, %774) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %826 = firrtl.subfield %805[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %827 = firrtl.mux(%544, %826, %775) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %828 = firrtl.subfield %805[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %829 = firrtl.mux(%544, %828, %776) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %830 = firrtl.subfield %805[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %831 = firrtl.mux(%544, %830, %777) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %832 = firrtl.subfield %805[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %833 = firrtl.mux(%544, %832, %778) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %834 = firrtl.subfield %805[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %835 = firrtl.mux(%544, %834, %779) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %836 = firrtl.subfield %805[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %837 = firrtl.mux(%544, %836, %780) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %838 = firrtl.subfield %794[rs1Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %839 = firrtl.mux(%544, %838, %781) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %840 = firrtl.subfield %794[rs2Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %841 = firrtl.mux(%544, %840, %782) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %842 = firrtl.subfield %exec1Reg[result] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %843 = firrtl.mux(%544, %842, %783) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %844 = firrtl.subfield %exec1Reg[doRegFileWrite] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %845 = firrtl.mux(%544, %844, %784) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %846 = firrtl.subfield %exec1Reg[ctrlTaken] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %847 = firrtl.mux(%544, %846, %785) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %848 = firrtl.subfield %exec1Reg[ctrlTarget] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %849 = firrtl.mux(%544, %848, %786) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %850 = firrtl.mux(%544, %798, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_exec3Reg_WIRE = firrtl.wire : !firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>
      %exec3Reg = firrtl.regreset %clock, %reset, %_exec3Reg_WIRE {firrtl.random_init_start = 2330 : ui64} : !firrtl.clock, !firrtl.uint<1>, !firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>, !firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>
      %851 = firrtl.subfield %exec3Reg[exec2Signals] : !firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>
      %852 = firrtl.subfield %851[exec1Signals] : !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %853 = firrtl.subfield %852[regReadSignals] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %854 = firrtl.subfield %853[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %855 = firrtl.subfield %854[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %856 = firrtl.subfield %855[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %857 = firrtl.subfield %856[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %858 = firrtl.subfield %856[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %859 = firrtl.subfield %856[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %860 = firrtl.subfield %855[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %861 = firrtl.subfield %860[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %862 = firrtl.subfield %860[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %863 = firrtl.subfield %860[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %864 = firrtl.subfield %860[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %865 = firrtl.subfield %860[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %866 = firrtl.subfield %860[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %867 = firrtl.subfield %860[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %868 = firrtl.subfield %860[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %869 = firrtl.subfield %860[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %870 = firrtl.subfield %860[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %871 = firrtl.subfield %860[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %872 = firrtl.subfield %860[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %873 = firrtl.subfield %860[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %874 = firrtl.subfield %860[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %875 = firrtl.subfield %860[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %876 = firrtl.subfield %860[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %877 = firrtl.subfield %853[rs1Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %878 = firrtl.subfield %853[rs2Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %879 = firrtl.subfield %852[result] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %880 = firrtl.subfield %852[doRegFileWrite] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %881 = firrtl.subfield %852[ctrlTaken] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %882 = firrtl.subfield %852[ctrlTarget] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %883 = firrtl.subfield %exec3Reg[exec2Signals] : !firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>
      %884 = firrtl.subfield %883[exec1Signals] : !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %885 = firrtl.subfield %884[regReadSignals] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %886 = firrtl.subfield %885[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %887 = firrtl.subfield %886[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %888 = firrtl.subfield %887[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %889 = firrtl.subfield %888[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %890 = firrtl.subfield %888[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %891 = firrtl.subfield %exec2Reg[exec1Signals] : !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %892 = firrtl.subfield %891[regReadSignals] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %893 = firrtl.subfield %892[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %894 = firrtl.subfield %893[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %895 = firrtl.subfield %894[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %896 = firrtl.subfield %895[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %897 = firrtl.subfield %895[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %898 = firrtl.mux(%793, %897, %857) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %899 = firrtl.subfield %895[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %900 = firrtl.mux(%793, %899, %858) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %901 = firrtl.subfield %895[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %902 = firrtl.mux(%793, %901, %859) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %903 = firrtl.subfield %894[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %904 = firrtl.subfield %903[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %905 = firrtl.mux(%793, %904, %861) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %906 = firrtl.subfield %903[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %907 = firrtl.mux(%793, %906, %862) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %908 = firrtl.subfield %903[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %909 = firrtl.mux(%793, %908, %863) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %910 = firrtl.subfield %903[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %911 = firrtl.mux(%793, %910, %864) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %912 = firrtl.subfield %903[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %913 = firrtl.mux(%793, %912, %865) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %914 = firrtl.subfield %903[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %915 = firrtl.mux(%793, %914, %866) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %916 = firrtl.subfield %903[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %917 = firrtl.mux(%793, %916, %867) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %918 = firrtl.subfield %903[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %919 = firrtl.mux(%793, %918, %868) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %920 = firrtl.subfield %903[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %921 = firrtl.mux(%793, %920, %869) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %922 = firrtl.subfield %903[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %923 = firrtl.mux(%793, %922, %870) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %924 = firrtl.subfield %903[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %925 = firrtl.mux(%793, %924, %871) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %926 = firrtl.subfield %903[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %927 = firrtl.mux(%793, %926, %872) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %928 = firrtl.subfield %903[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %929 = firrtl.mux(%793, %928, %873) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %930 = firrtl.subfield %903[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %931 = firrtl.mux(%793, %930, %874) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %932 = firrtl.subfield %903[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %933 = firrtl.mux(%793, %932, %875) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %934 = firrtl.subfield %903[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %935 = firrtl.mux(%793, %934, %876) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %936 = firrtl.subfield %892[rs1Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %937 = firrtl.mux(%793, %936, %877) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %938 = firrtl.subfield %892[rs2Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %939 = firrtl.mux(%793, %938, %878) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %940 = firrtl.subfield %891[result] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %941 = firrtl.mux(%793, %940, %879) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %942 = firrtl.subfield %891[doRegFileWrite] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %943 = firrtl.mux(%793, %942, %880) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %944 = firrtl.subfield %891[ctrlTaken] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %945 = firrtl.mux(%793, %944, %881) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %946 = firrtl.subfield %891[ctrlTarget] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %947 = firrtl.mux(%793, %946, %882) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %948 = firrtl.mux(%793, %896, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_wbReg_WIRE = firrtl.wire : !firrtl.bundle<exec3Signals: bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>>
      %wbReg = firrtl.regreset %clock, %reset, %_wbReg_WIRE {firrtl.random_init_start = 2591 : ui64} : !firrtl.clock, !firrtl.uint<1>, !firrtl.bundle<exec3Signals: bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>>, !firrtl.bundle<exec3Signals: bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>>
      %949 = firrtl.subfield %wbReg[exec3Signals] : !firrtl.bundle<exec3Signals: bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>>
      %950 = firrtl.subfield %949[exec2Signals] : !firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>
      %951 = firrtl.subfield %950[exec1Signals] : !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %952 = firrtl.subfield %951[regReadSignals] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %953 = firrtl.subfield %952[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %954 = firrtl.subfield %953[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %955 = firrtl.subfield %954[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %956 = firrtl.subfield %955[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %957 = firrtl.subfield %955[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %958 = firrtl.subfield %955[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %959 = firrtl.subfield %954[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %960 = firrtl.subfield %959[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %961 = firrtl.subfield %959[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %962 = firrtl.subfield %959[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %963 = firrtl.subfield %959[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %964 = firrtl.subfield %959[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %965 = firrtl.subfield %959[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %966 = firrtl.subfield %959[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %967 = firrtl.subfield %959[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %968 = firrtl.subfield %959[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %969 = firrtl.subfield %959[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %970 = firrtl.subfield %959[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %971 = firrtl.subfield %959[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %972 = firrtl.subfield %959[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %973 = firrtl.subfield %959[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %974 = firrtl.subfield %959[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %975 = firrtl.subfield %959[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %976 = firrtl.subfield %952[rs1Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %977 = firrtl.subfield %952[rs2Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %978 = firrtl.subfield %951[result] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %979 = firrtl.subfield %951[doRegFileWrite] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %980 = firrtl.subfield %951[ctrlTaken] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %981 = firrtl.subfield %951[ctrlTarget] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %982 = firrtl.subfield %wbReg[exec3Signals] : !firrtl.bundle<exec3Signals: bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>>
      %983 = firrtl.subfield %982[exec2Signals] : !firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>
      %984 = firrtl.subfield %983[exec1Signals] : !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %985 = firrtl.subfield %984[ctrlTarget] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %986 = firrtl.subfield %984[ctrlTaken] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %987 = firrtl.subfield %984[result] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %988 = firrtl.subfield %984[doRegFileWrite] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %989 = firrtl.subfield %984[regReadSignals] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %990 = firrtl.subfield %989[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %991 = firrtl.subfield %990[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %992 = firrtl.subfield %991[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %993 = firrtl.subfield %992[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %994 = firrtl.subfield %992[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %995 = firrtl.subfield %992[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %996 = firrtl.subfield %992[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %997 = firrtl.subfield %991[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %998 = firrtl.subfield %997[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %999 = firrtl.subfield %997[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %1000 = firrtl.subfield %997[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %1001 = firrtl.subfield %997[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %1002 = firrtl.subfield %exec3Reg[exec2Signals] : !firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>
      %1003 = firrtl.subfield %1002[exec1Signals] : !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %1004 = firrtl.subfield %1003[regReadSignals] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %1005 = firrtl.subfield %1004[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %1006 = firrtl.subfield %1005[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %1007 = firrtl.subfield %1006[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %1008 = firrtl.subfield %1007[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %1009 = firrtl.subfield %1007[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %1010 = firrtl.mux(%890, %1009, %956) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %1011 = firrtl.subfield %1007[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %1012 = firrtl.mux(%890, %1011, %957) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1013 = firrtl.subfield %1007[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %1014 = firrtl.mux(%890, %1013, %958) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1015 = firrtl.subfield %1006[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %1016 = firrtl.subfield %1015[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1017 = firrtl.mux(%890, %1016, %960) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1018 = firrtl.subfield %1015[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1019 = firrtl.mux(%890, %1018, %961) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1020 = firrtl.subfield %1015[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1021 = firrtl.mux(%890, %1020, %962) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1022 = firrtl.subfield %1015[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1023 = firrtl.mux(%890, %1022, %963) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1024 = firrtl.subfield %1015[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1025 = firrtl.mux(%890, %1024, %964) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1026 = firrtl.subfield %1015[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1027 = firrtl.mux(%890, %1026, %965) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1028 = firrtl.subfield %1015[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1029 = firrtl.mux(%890, %1028, %966) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1030 = firrtl.subfield %1015[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1031 = firrtl.mux(%890, %1030, %967) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1032 = firrtl.subfield %1015[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1033 = firrtl.mux(%890, %1032, %968) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1034 = firrtl.subfield %1015[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1035 = firrtl.mux(%890, %1034, %969) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1036 = firrtl.subfield %1015[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1037 = firrtl.mux(%890, %1036, %970) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1038 = firrtl.subfield %1015[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1039 = firrtl.mux(%890, %1038, %971) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %1040 = firrtl.subfield %1015[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1041 = firrtl.mux(%890, %1040, %972) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %1042 = firrtl.subfield %1015[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1043 = firrtl.mux(%890, %1042, %973) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %1044 = firrtl.subfield %1015[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1045 = firrtl.mux(%890, %1044, %974) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %1046 = firrtl.subfield %1015[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1047 = firrtl.mux(%890, %1046, %975) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1048 = firrtl.subfield %1004[rs1Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %1049 = firrtl.mux(%890, %1048, %976) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1050 = firrtl.subfield %1004[rs2Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %1051 = firrtl.mux(%890, %1050, %977) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1052 = firrtl.subfield %1003[result] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %1053 = firrtl.mux(%890, %1052, %978) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1054 = firrtl.subfield %1003[doRegFileWrite] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %1055 = firrtl.mux(%890, %1054, %979) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1056 = firrtl.subfield %1003[ctrlTaken] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %1057 = firrtl.mux(%890, %1056, %980) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1058 = firrtl.subfield %1003[ctrlTarget] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %1059 = firrtl.mux(%890, %1058, %981) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1060 = firrtl.mux(%890, %1008, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1061 = firrtl.and %1001, %988 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1062 = firrtl.orr %996 : (!firrtl.uint<5>) -> !firrtl.uint<1>
      %1063 = firrtl.and %1061, %1062 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1064 = firrtl.mux(%1063, %1000, %c0_ui3) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %1065 = firrtl.mux(%1063, %996, %c0_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %1066 = firrtl.mux(%1063, %987, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %ex1Redirect = firrtl.and %544, %538 {name = "ex1Redirect"} : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1067 = firrtl.orr %543 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %1068 = firrtl.not %1067 : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %1069 = firrtl.and %ex1Redirect, %1068 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1070 = firrtl.mux(%1069, %537, %159) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1071 = firrtl.eq %543, %c1_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1072 = firrtl.and %ex1Redirect, %1071 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1073 = firrtl.mux(%1072, %537, %162) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1074 = firrtl.eq %543, %c2_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1075 = firrtl.and %ex1Redirect, %1074 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1076 = firrtl.mux(%1075, %537, %165) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1077 = firrtl.eq %543, %c3_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1078 = firrtl.and %ex1Redirect, %1077 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1079 = firrtl.mux(%1078, %537, %168) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1080 = firrtl.eq %543, %c4_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1081 = firrtl.and %ex1Redirect, %1080 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1082 = firrtl.mux(%1081, %537, %171) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1083 = firrtl.eq %543, %c5_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1084 = firrtl.and %ex1Redirect, %1083 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1085 = firrtl.mux(%1084, %537, %174) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1086 = firrtl.eq %543, %c6_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1087 = firrtl.and %ex1Redirect, %1086 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1088 = firrtl.mux(%1087, %537, %177) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1089 = firrtl.andr %543 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %1090 = firrtl.and %ex1Redirect, %1089 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1091 = firrtl.mux(%1090, %537, %180) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1092 = firrtl.vectorcreate %1070, %1073, %1076, %1079, %1082, %1085, %1088, %1091 : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.vector<uint<32>, 8>
      firrtl.matchingconnect %pcRegs, %1092 : !firrtl.vector<uint<32>, 8>
      %1093 = firrtl.and %1061, %1062 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1094 = firrtl.eq %996, %c1_ui1 : (!firrtl.uint<5>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1095 = firrtl.orr %1000 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %1096 = firrtl.not %1095 : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %1097 = firrtl.and %1094, %1096 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1098 = firrtl.and %1093, %1097 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1099 = firrtl.mux(%1098, %987, %27) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1100 = firrtl.eq %1000, %c1_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1101 = firrtl.and %1094, %1100 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1102 = firrtl.and %1093, %1101 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1103 = firrtl.mux(%1102, %987, %32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1104 = firrtl.eq %1000, %c2_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1105 = firrtl.and %1094, %1104 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1106 = firrtl.and %1093, %1105 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1107 = firrtl.mux(%1106, %987, %37) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1108 = firrtl.eq %1000, %c3_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1109 = firrtl.and %1094, %1108 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1110 = firrtl.and %1093, %1109 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1111 = firrtl.mux(%1110, %987, %42) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1112 = firrtl.eq %1000, %c4_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1113 = firrtl.and %1094, %1112 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1114 = firrtl.and %1093, %1113 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1115 = firrtl.mux(%1114, %987, %47) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1116 = firrtl.eq %1000, %c5_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1117 = firrtl.and %1094, %1116 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1118 = firrtl.and %1093, %1117 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1119 = firrtl.mux(%1118, %987, %52) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1120 = firrtl.eq %1000, %c6_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1121 = firrtl.and %1094, %1120 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1122 = firrtl.and %1093, %1121 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1123 = firrtl.mux(%1122, %987, %57) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1124 = firrtl.andr %1000 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %1125 = firrtl.and %1094, %1124 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1126 = firrtl.and %1093, %1125 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1127 = firrtl.mux(%1126, %987, %62) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1128 = firrtl.eq %996, %c2_ui2 : (!firrtl.uint<5>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %1129 = firrtl.orr %1000 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %1130 = firrtl.not %1129 : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %1131 = firrtl.and %1128, %1130 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1132 = firrtl.mux(%1131, %987, %28) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1133 = firrtl.mux(%1094, %28, %1132) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1134 = firrtl.mux(%1093, %1133, %28) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1135 = firrtl.eq %1000, %c1_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1136 = firrtl.and %1128, %1135 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1137 = firrtl.mux(%1136, %987, %33) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1138 = firrtl.mux(%1094, %33, %1137) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1139 = firrtl.mux(%1093, %1138, %33) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1140 = firrtl.eq %1000, %c2_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1141 = firrtl.and %1128, %1140 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1142 = firrtl.mux(%1141, %987, %38) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1143 = firrtl.mux(%1094, %38, %1142) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1144 = firrtl.mux(%1093, %1143, %38) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1145 = firrtl.eq %1000, %c3_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1146 = firrtl.and %1128, %1145 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1147 = firrtl.mux(%1146, %987, %43) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1148 = firrtl.mux(%1094, %43, %1147) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1149 = firrtl.mux(%1093, %1148, %43) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1150 = firrtl.eq %1000, %c4_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1151 = firrtl.and %1128, %1150 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1152 = firrtl.mux(%1151, %987, %48) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1153 = firrtl.mux(%1094, %48, %1152) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1154 = firrtl.mux(%1093, %1153, %48) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1155 = firrtl.eq %1000, %c5_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1156 = firrtl.and %1128, %1155 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1157 = firrtl.mux(%1156, %987, %53) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1158 = firrtl.mux(%1094, %53, %1157) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1159 = firrtl.mux(%1093, %1158, %53) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1160 = firrtl.eq %1000, %c6_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1161 = firrtl.and %1128, %1160 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1162 = firrtl.mux(%1161, %987, %58) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1163 = firrtl.mux(%1094, %58, %1162) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1164 = firrtl.mux(%1093, %1163, %58) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1165 = firrtl.andr %1000 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %1166 = firrtl.and %1128, %1165 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1167 = firrtl.mux(%1166, %987, %63) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1168 = firrtl.mux(%1094, %63, %1167) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1169 = firrtl.mux(%1093, %1168, %63) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1170 = firrtl.eq %996, %c3_ui2 : (!firrtl.uint<5>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %1171 = firrtl.orr %1000 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %1172 = firrtl.not %1171 : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %1173 = firrtl.and %1170, %1172 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1174 = firrtl.mux(%1173, %987, %29) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1175 = firrtl.or %1094, %1128 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1176 = firrtl.mux(%1175, %29, %1174) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1177 = firrtl.mux(%1093, %1176, %29) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1178 = firrtl.eq %1000, %c1_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1179 = firrtl.and %1170, %1178 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1180 = firrtl.mux(%1179, %987, %34) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1181 = firrtl.or %1094, %1128 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1182 = firrtl.mux(%1181, %34, %1180) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1183 = firrtl.mux(%1093, %1182, %34) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1184 = firrtl.eq %1000, %c2_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1185 = firrtl.and %1170, %1184 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1186 = firrtl.mux(%1185, %987, %39) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1187 = firrtl.or %1094, %1128 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1188 = firrtl.mux(%1187, %39, %1186) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1189 = firrtl.mux(%1093, %1188, %39) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1190 = firrtl.eq %1000, %c3_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1191 = firrtl.and %1170, %1190 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1192 = firrtl.mux(%1191, %987, %44) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1193 = firrtl.or %1094, %1128 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1194 = firrtl.mux(%1193, %44, %1192) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1195 = firrtl.mux(%1093, %1194, %44) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1196 = firrtl.eq %1000, %c4_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1197 = firrtl.and %1170, %1196 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1198 = firrtl.mux(%1197, %987, %49) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1199 = firrtl.or %1094, %1128 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1200 = firrtl.mux(%1199, %49, %1198) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1201 = firrtl.mux(%1093, %1200, %49) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1202 = firrtl.eq %1000, %c5_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1203 = firrtl.and %1170, %1202 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1204 = firrtl.mux(%1203, %987, %54) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1205 = firrtl.or %1094, %1128 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1206 = firrtl.mux(%1205, %54, %1204) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1207 = firrtl.mux(%1093, %1206, %54) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1208 = firrtl.eq %1000, %c6_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1209 = firrtl.and %1170, %1208 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1210 = firrtl.mux(%1209, %987, %59) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1211 = firrtl.or %1094, %1128 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1212 = firrtl.mux(%1211, %59, %1210) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1213 = firrtl.mux(%1093, %1212, %59) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1214 = firrtl.andr %1000 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %1215 = firrtl.and %1170, %1214 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1216 = firrtl.mux(%1215, %987, %64) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1217 = firrtl.or %1094, %1128 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1218 = firrtl.mux(%1217, %64, %1216) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1219 = firrtl.mux(%1093, %1218, %64) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1220 = firrtl.eq %996, %c4_ui3 : (!firrtl.uint<5>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1221 = firrtl.orr %1000 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %1222 = firrtl.not %1221 : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %1223 = firrtl.and %1220, %1222 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1224 = firrtl.mux(%1223, %987, %30) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1225 = firrtl.or %1128, %1170 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1226 = firrtl.or %1094, %1225 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1227 = firrtl.mux(%1226, %30, %1224) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1228 = firrtl.mux(%1093, %1227, %30) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1229 = firrtl.vectorcreate %1099, %1134, %1177, %1228 : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.vector<uint<32>, 4>
      %1230 = firrtl.eq %1000, %c1_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1231 = firrtl.and %1220, %1230 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1232 = firrtl.mux(%1231, %987, %35) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1233 = firrtl.or %1128, %1170 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1234 = firrtl.or %1094, %1233 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1235 = firrtl.mux(%1234, %35, %1232) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1236 = firrtl.mux(%1093, %1235, %35) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1237 = firrtl.vectorcreate %1103, %1139, %1183, %1236 : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.vector<uint<32>, 4>
      %1238 = firrtl.eq %1000, %c2_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1239 = firrtl.and %1220, %1238 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1240 = firrtl.mux(%1239, %987, %40) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1241 = firrtl.or %1128, %1170 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1242 = firrtl.or %1094, %1241 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1243 = firrtl.mux(%1242, %40, %1240) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1244 = firrtl.mux(%1093, %1243, %40) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1245 = firrtl.vectorcreate %1107, %1144, %1189, %1244 : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.vector<uint<32>, 4>
      %1246 = firrtl.eq %1000, %c3_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1247 = firrtl.and %1220, %1246 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1248 = firrtl.mux(%1247, %987, %45) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1249 = firrtl.or %1128, %1170 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1250 = firrtl.or %1094, %1249 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1251 = firrtl.mux(%1250, %45, %1248) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1252 = firrtl.mux(%1093, %1251, %45) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1253 = firrtl.vectorcreate %1111, %1149, %1195, %1252 : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.vector<uint<32>, 4>
      %1254 = firrtl.eq %1000, %c4_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1255 = firrtl.and %1220, %1254 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1256 = firrtl.mux(%1255, %987, %50) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1257 = firrtl.or %1128, %1170 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1258 = firrtl.or %1094, %1257 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1259 = firrtl.mux(%1258, %50, %1256) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1260 = firrtl.mux(%1093, %1259, %50) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1261 = firrtl.vectorcreate %1115, %1154, %1201, %1260 : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.vector<uint<32>, 4>
      %1262 = firrtl.eq %1000, %c5_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1263 = firrtl.and %1220, %1262 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1264 = firrtl.mux(%1263, %987, %55) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1265 = firrtl.or %1128, %1170 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1266 = firrtl.or %1094, %1265 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1267 = firrtl.mux(%1266, %55, %1264) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1268 = firrtl.mux(%1093, %1267, %55) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1269 = firrtl.vectorcreate %1119, %1159, %1207, %1268 : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.vector<uint<32>, 4>
      %1270 = firrtl.eq %1000, %c6_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1271 = firrtl.and %1220, %1270 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1272 = firrtl.mux(%1271, %987, %60) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1273 = firrtl.or %1128, %1170 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1274 = firrtl.or %1094, %1273 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1275 = firrtl.mux(%1274, %60, %1272) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1276 = firrtl.mux(%1093, %1275, %60) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1277 = firrtl.vectorcreate %1123, %1164, %1213, %1276 : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.vector<uint<32>, 4>
      %1278 = firrtl.andr %1000 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %1279 = firrtl.and %1220, %1278 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1280 = firrtl.mux(%1279, %987, %65) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1281 = firrtl.or %1128, %1170 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1282 = firrtl.or %1094, %1281 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1283 = firrtl.mux(%1282, %65, %1280) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1284 = firrtl.mux(%1093, %1283, %65) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1285 = firrtl.vectorcreate %1127, %1169, %1219, %1284 : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.vector<uint<32>, 4>
      %1286 = firrtl.vectorcreate %1229, %1237, %1245, %1253, %1261, %1269, %1277, %1285 : (!firrtl.vector<uint<32>, 4>, !firrtl.vector<uint<32>, 4>, !firrtl.vector<uint<32>, 4>, !firrtl.vector<uint<32>, 4>, !firrtl.vector<uint<32>, 4>, !firrtl.vector<uint<32>, 4>, !firrtl.vector<uint<32>, 4>, !firrtl.vector<uint<32>, 4>) -> !firrtl.vector<vector<uint<32>, 4>, 8>
      firrtl.matchingconnect %debugRegs1to4, %1286 : !firrtl.vector<vector<uint<32>, 4>, 8>
      %1287 = firrtl.orr %996 : (!firrtl.uint<5>) -> !firrtl.uint<1>
      %1288 = firrtl.not %1287 : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %1289 = firrtl.and %1061, %1288 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1290 = firrtl.mux(%1289, %c0_ui1, %1063) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1291 = firrtl.tail %149, 3 : (!firrtl.uint<3>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageThreads_0_6, %1291 : !firrtl.uint<0>
      %1292 = firrtl.tail %150, 1 : (!firrtl.uint<1>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageValids_0_14, %1292 : !firrtl.uint<0>
      %1293 = firrtl.tail %204, 3 : (!firrtl.uint<3>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageThreads_1_7, %1293 : !firrtl.uint<0>
      %1294 = firrtl.tail %205, 1 : (!firrtl.uint<1>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageValids_1_15, %1294 : !firrtl.uint<0>
      %1295 = firrtl.tail %370, 3 : (!firrtl.uint<3>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageThreads_2_8, %1295 : !firrtl.uint<0>
      %1296 = firrtl.tail %371, 1 : (!firrtl.uint<1>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageValids_2_16, %1296 : !firrtl.uint<0>
      %1297 = firrtl.tail %455, 3 : (!firrtl.uint<3>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageThreads_3_9, %1297 : !firrtl.uint<0>
      %1298 = firrtl.tail %458, 1 : (!firrtl.uint<1>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageValids_3_17, %1298 : !firrtl.uint<0>
      %1299 = firrtl.tail %543, 3 : (!firrtl.uint<3>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageThreads_4_10, %1299 : !firrtl.uint<0>
      %1300 = firrtl.tail %544, 1 : (!firrtl.uint<1>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageValids_4_18, %1300 : !firrtl.uint<0>
      %1301 = firrtl.tail %792, 3 : (!firrtl.uint<3>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageThreads_5_11, %1301 : !firrtl.uint<0>
      %1302 = firrtl.tail %793, 1 : (!firrtl.uint<1>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageValids_5_19, %1302 : !firrtl.uint<0>
      %1303 = firrtl.tail %889, 3 : (!firrtl.uint<3>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageThreads_6_12, %1303 : !firrtl.uint<0>
      %1304 = firrtl.tail %890, 1 : (!firrtl.uint<1>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageValids_6_20, %1304 : !firrtl.uint<0>
      %1305 = firrtl.tail %1000, 3 : (!firrtl.uint<3>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageThreads_7_13, %1305 : !firrtl.uint<0>
      %1306 = firrtl.tail %1001, 1 : (!firrtl.uint<1>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageValids_7_21, %1306 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlValid_70, %1306 : !firrtl.uint<0>
      %1307 = firrtl.tail %999, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlInstr_71, %1307 : !firrtl.uint<0>
      %1308 = firrtl.tail %986, 1 : (!firrtl.uint<1>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlTaken_72, %1308 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlThread_73, %1305 : !firrtl.uint<0>
      %1309 = firrtl.tail %998, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlFromPC_74, %1309 : !firrtl.uint<0>
      %1310 = firrtl.tail %985, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlTarget_75, %1310 : !firrtl.uint<0>
      %1311 = firrtl.tail %995, 1 : (!firrtl.uint<1>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlIsBranch_76, %1311 : !firrtl.uint<0>
      %1312 = firrtl.tail %994, 1 : (!firrtl.uint<1>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlIsJal_77, %1312 : !firrtl.uint<0>
      %1313 = firrtl.tail %993, 1 : (!firrtl.uint<1>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlIsJalr_78, %1313 : !firrtl.uint<0>
      %1314 = firrtl.tail %105, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_0_1_30, %1314 : !firrtl.uint<0>
      %1315 = firrtl.tail %104, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_0_2_31, %1315 : !firrtl.uint<0>
      %1316 = firrtl.tail %103, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_0_3_32, %1316 : !firrtl.uint<0>
      %1317 = firrtl.tail %102, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_0_4_33, %1317 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegX1_0_62, %1314 : !firrtl.uint<0>
      %1318 = firrtl.tail %25, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugPC_0_22, %1318 : !firrtl.uint<0>
      %1319 = firrtl.tail %100, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_1_1_34, %1319 : !firrtl.uint<0>
      %1320 = firrtl.tail %99, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_1_2_35, %1320 : !firrtl.uint<0>
      %1321 = firrtl.tail %98, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_1_3_36, %1321 : !firrtl.uint<0>
      %1322 = firrtl.tail %97, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_1_4_37, %1322 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegX1_1_63, %1319 : !firrtl.uint<0>
      %1323 = firrtl.tail %24, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugPC_1_23, %1323 : !firrtl.uint<0>
      %1324 = firrtl.tail %95, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_2_1_38, %1324 : !firrtl.uint<0>
      %1325 = firrtl.tail %94, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_2_2_39, %1325 : !firrtl.uint<0>
      %1326 = firrtl.tail %93, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_2_3_40, %1326 : !firrtl.uint<0>
      %1327 = firrtl.tail %92, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_2_4_41, %1327 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegX1_2_64, %1324 : !firrtl.uint<0>
      %1328 = firrtl.tail %23, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugPC_2_24, %1328 : !firrtl.uint<0>
      %1329 = firrtl.tail %90, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_3_1_42, %1329 : !firrtl.uint<0>
      %1330 = firrtl.tail %89, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_3_2_43, %1330 : !firrtl.uint<0>
      %1331 = firrtl.tail %88, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_3_3_44, %1331 : !firrtl.uint<0>
      %1332 = firrtl.tail %87, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_3_4_45, %1332 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegX1_3_65, %1329 : !firrtl.uint<0>
      %1333 = firrtl.tail %22, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugPC_3_25, %1333 : !firrtl.uint<0>
      %1334 = firrtl.tail %85, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_4_1_46, %1334 : !firrtl.uint<0>
      %1335 = firrtl.tail %84, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_4_2_47, %1335 : !firrtl.uint<0>
      %1336 = firrtl.tail %83, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_4_3_48, %1336 : !firrtl.uint<0>
      %1337 = firrtl.tail %82, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_4_4_49, %1337 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegX1_4_66, %1334 : !firrtl.uint<0>
      %1338 = firrtl.tail %21, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugPC_4_26, %1338 : !firrtl.uint<0>
      %1339 = firrtl.tail %80, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_5_1_50, %1339 : !firrtl.uint<0>
      %1340 = firrtl.tail %79, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_5_2_51, %1340 : !firrtl.uint<0>
      %1341 = firrtl.tail %78, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_5_3_52, %1341 : !firrtl.uint<0>
      %1342 = firrtl.tail %77, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_5_4_53, %1342 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegX1_5_67, %1339 : !firrtl.uint<0>
      %1343 = firrtl.tail %20, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugPC_5_27, %1343 : !firrtl.uint<0>
      %1344 = firrtl.tail %75, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_6_1_54, %1344 : !firrtl.uint<0>
      %1345 = firrtl.tail %74, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_6_2_55, %1345 : !firrtl.uint<0>
      %1346 = firrtl.tail %73, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_6_3_56, %1346 : !firrtl.uint<0>
      %1347 = firrtl.tail %72, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_6_4_57, %1347 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegX1_6_68, %1344 : !firrtl.uint<0>
      %1348 = firrtl.tail %19, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugPC_6_28, %1348 : !firrtl.uint<0>
      %1349 = firrtl.tail %70, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_7_1_58, %1349 : !firrtl.uint<0>
      %1350 = firrtl.tail %69, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_7_2_59, %1350 : !firrtl.uint<0>
      %1351 = firrtl.tail %68, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_7_3_60, %1351 : !firrtl.uint<0>
      %1352 = firrtl.tail %67, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_7_4_61, %1352 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegX1_7_69, %1349 : !firrtl.uint<0>
      %1353 = firrtl.tail %18, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugPC_7_29, %1353 : !firrtl.uint<0>
      firrtl.matchingconnect %_debugRegs1to4_WIRE_8, %1 : !firrtl.vector<vector<uint<32>, 4>, 8>
      %unusedRegDebugX1 = firrtl.node %113 {annotations = [{circt.fieldID = 1 : i32, class = "firrtl.transforms.DontTouchAnnotation"}, {circt.fieldID = 2 : i32, class = "firrtl.transforms.DontTouchAnnotation"}, {circt.fieldID = 3 : i32, class = "firrtl.transforms.DontTouchAnnotation"}, {circt.fieldID = 4 : i32, class = "firrtl.transforms.DontTouchAnnotation"}, {circt.fieldID = 5 : i32, class = "firrtl.transforms.DontTouchAnnotation"}, {circt.fieldID = 6 : i32, class = "firrtl.transforms.DontTouchAnnotation"}, {circt.fieldID = 7 : i32, class = "firrtl.transforms.DontTouchAnnotation"}, {circt.fieldID = 8 : i32, class = "firrtl.transforms.DontTouchAnnotation"}]} : !firrtl.vector<uint<32>, 8>
      firrtl.matchingconnect %_decodeReg_WIRE, %8 : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %1354 = firrtl.vectorcreate %502, %503 : (!firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.vector<uint<5>, 2>
      %1355 = firrtl.vectorcreate %1065 : (!firrtl.uint<5>) -> !firrtl.vector<uint<5>, 1>
      %1356 = firrtl.vectorcreate %1290 : (!firrtl.uint<1>) -> !firrtl.vector<uint<1>, 1>
      %1357 = firrtl.vectorcreate %1066 : (!firrtl.uint<32>) -> !firrtl.vector<uint<32>, 1>
      %1358 = firrtl.bundlecreate %501, %1064, %1354, %regFile_io_readData, %1355, %1356, %1357, %regFile_io_debugX1 : (!firrtl.uint<3>, !firrtl.uint<3>, !firrtl.vector<uint<5>, 2>, !firrtl.vector<uint<32>, 2>, !firrtl.vector<uint<5>, 1>, !firrtl.vector<uint<1>, 1>, !firrtl.vector<uint<32>, 1>, !firrtl.vector<uint<32>, 8>) -> !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 8>>
      firrtl.matchingconnect %regFile.io, %1358 : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>, debugX1: vector<uint<32>, 8>>
      %1359 = firrtl.bundlecreate %310, %312, %314, %316, %318, %320, %322, %324, %326, %328, %330, %332, %334, %336, %338, %340 : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<32>) -> !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1360 = firrtl.bundlecreate %342, %1359 : (!firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>) -> !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      firrtl.matchingconnect %decodeReg, %1360 : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      firrtl.matchingconnect %_dispatchReg_WIRE, %7 : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %1361 = firrtl.bundlecreate %413, %375, %377, %379 : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %1362 = firrtl.bundlecreate %382, %384, %386, %388, %390, %392, %394, %396, %398, %400, %402, %404, %406, %408, %410, %412 : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<32>) -> !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1363 = firrtl.bundlecreate %1361, %1362 : (!firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>) -> !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %1364 = firrtl.bundlecreate %1363 : (!firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>) -> !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      firrtl.matchingconnect %dispatchReg, %1364 : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %1365 = firrtl.bundlecreate %506, %463, %465, %467 : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %1366 = firrtl.bundlecreate %470, %472, %474, %476, %478, %480, %482, %484, %486, %488, %490, %492, %494, %496, %498, %500 : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<32>) -> !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1367 = firrtl.bundlecreate %755, %550, %552, %554 : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %1368 = firrtl.bundlecreate %557, %559, %561, %563, %565, %567, %569, %571, %573, %575, %577, %579, %581, %583, %585, %587 : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<32>) -> !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1369 = firrtl.bundlecreate %850, %800, %802, %804 : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %1370 = firrtl.bundlecreate %807, %809, %811, %813, %815, %817, %819, %821, %823, %825, %827, %829, %831, %833, %835, %837 : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<32>) -> !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1371 = firrtl.bundlecreate %948, %898, %900, %902 : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %1372 = firrtl.bundlecreate %905, %907, %909, %911, %913, %915, %917, %919, %921, %923, %925, %927, %929, %931, %933, %935 : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<32>) -> !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1373 = firrtl.bundlecreate %1060, %1010, %1012, %1014 : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %1374 = firrtl.bundlecreate %1017, %1019, %1021, %1023, %1025, %1027, %1029, %1031, %1033, %1035, %1037, %1039, %1041, %1043, %1045, %1047 : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<32>) -> !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      firrtl.matchingconnect %_regReadReg_WIRE, %6 : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %1375 = firrtl.bundlecreate %1365, %1366 : (!firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>) -> !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %1376 = firrtl.bundlecreate %1375 : (!firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>) -> !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %1377 = firrtl.bundlecreate %1376, %504, %505 : (!firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      firrtl.matchingconnect %regReadReg, %1377 : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %1378 = firrtl.bundlecreate %1367, %1368 : (!firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>) -> !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %1379 = firrtl.bundlecreate %1369, %1370 : (!firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>) -> !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %1380 = firrtl.bundlecreate %1371, %1372 : (!firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>) -> !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %1381 = firrtl.bundlecreate %1373, %1374 : (!firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>) -> !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      firrtl.matchingconnect %_exec1Reg_WIRE, %5 : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %1382 = firrtl.bundlecreate %1378 : (!firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>) -> !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %1383 = firrtl.bundlecreate %1382, %589, %591 : (!firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %1384 = firrtl.bundlecreate %1383, %680, %686, %651, %657 : (!firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, !firrtl.uint<32>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<32>) -> !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      firrtl.matchingconnect %exec1Reg, %1384 : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %1385 = firrtl.bundlecreate %1379 : (!firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>) -> !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %1386 = firrtl.bundlecreate %1380 : (!firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>) -> !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %1387 = firrtl.bundlecreate %1381 : (!firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>) -> !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      firrtl.matchingconnect %_exec2Reg_WIRE, %4 : !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %1388 = firrtl.bundlecreate %1385, %839, %841 : (!firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %1389 = firrtl.bundlecreate %1388, %843, %845, %847, %849 : (!firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, !firrtl.uint<32>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<32>) -> !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %1390 = firrtl.bundlecreate %1389 : (!firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>) -> !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      firrtl.matchingconnect %exec2Reg, %1390 : !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %1391 = firrtl.bundlecreate %1386, %937, %939 : (!firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %1392 = firrtl.bundlecreate %1387, %1049, %1051 : (!firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      firrtl.matchingconnect %_exec3Reg_WIRE, %3 : !firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>
      %1393 = firrtl.bundlecreate %1391, %941, %943, %945, %947 : (!firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, !firrtl.uint<32>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<32>) -> !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %1394 = firrtl.bundlecreate %1393 : (!firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>) -> !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %1395 = firrtl.bundlecreate %1394 : (!firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>) -> !firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>
      firrtl.matchingconnect %exec3Reg, %1395 : !firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>
      %1396 = firrtl.bundlecreate %1392, %1053, %1055, %1057, %1059 : (!firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, !firrtl.uint<32>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<32>) -> !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      firrtl.matchingconnect %_wbReg_WIRE, %0 : !firrtl.bundle<exec3Signals: bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>>
      %1397 = firrtl.bundlecreate %1396 : (!firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>) -> !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %1398 = firrtl.bundlecreate %1397 : (!firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>) -> !firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>
      %1399 = firrtl.bundlecreate %1398 : (!firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>) -> !firrtl.bundle<exec3Signals: bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>>
      firrtl.matchingconnect %wbReg, %1399 : !firrtl.bundle<exec3Signals: bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>>
    }
  }
}
