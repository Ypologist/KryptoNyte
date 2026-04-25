module {
  firrtl.circuit "OctoNyteRV32IZmmulCore" {
    firrtl.module private @RegFileMT2R1WMem(in %clock: !firrtl.clock, in %io_readThreadID: !firrtl.uint<3>, in %io_writeThreadID: !firrtl.uint<3>, in %io_readAddrs: !firrtl.vector<uint<5>, 2>, out %io_readData: !firrtl.vector<uint<32>, 2>, in %io_writeAddrs: !firrtl.vector<uint<5>, 1>, in %io_wens: !firrtl.vector<uint<1>, 1>, in %io_writeData: !firrtl.vector<uint<32>, 1>) {
      %c0_ui32 = firrtl.constant 0 : !firrtl.uint<32>
      %c1_ui1 = firrtl.constant 1 : !firrtl.uint<1>
      %io = firrtl.wire : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      %0 = firrtl.subfield %io[readThreadID] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      %1 = firrtl.subfield %io[writeThreadID] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      %2 = firrtl.subfield %io[readAddrs] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      %3 = firrtl.subfield %io[readData] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      firrtl.matchingconnect %io_readData, %3 : !firrtl.vector<uint<32>, 2>
      %4 = firrtl.subfield %io[writeAddrs] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      %5 = firrtl.subfield %io[wens] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      %6 = firrtl.subfield %io[writeData] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      %7 = firrtl.subindex %2[1] : !firrtl.vector<uint<5>, 2>
      %8 = firrtl.subindex %2[0] : !firrtl.vector<uint<5>, 2>
      %9 = firrtl.subindex %6[0] : !firrtl.vector<uint<32>, 1>
      %10 = firrtl.subindex %5[0] : !firrtl.vector<uint<1>, 1>
      %11 = firrtl.subindex %4[0] : !firrtl.vector<uint<5>, 1>
      %regs_MPORT, %regs_io_readData_0_MPORT, %regs_io_readData_1_MPORT = firrtl.mem Undefined {depth = 256 : i64, name = "regs", portNames = ["MPORT", "io_readData_0_MPORT", "io_readData_1_MPORT"], readLatency = 0 : i32, writeLatency = 1 : i32} : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data: uint<32>, mask: uint<1>>, !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>, !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %12 = firrtl.subfield %regs_MPORT[addr] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data: uint<32>, mask: uint<1>>
      %13 = firrtl.subfield %regs_MPORT[en] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data: uint<32>, mask: uint<1>>
      %14 = firrtl.subfield %regs_MPORT[clk] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data: uint<32>, mask: uint<1>>
      %15 = firrtl.subfield %regs_MPORT[data] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data: uint<32>, mask: uint<1>>
      %16 = firrtl.subfield %regs_MPORT[mask] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data: uint<32>, mask: uint<1>>
      %17 = firrtl.subfield %regs_io_readData_0_MPORT[addr] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %18 = firrtl.subfield %regs_io_readData_0_MPORT[en] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %19 = firrtl.subfield %regs_io_readData_0_MPORT[clk] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %20 = firrtl.subfield %regs_io_readData_0_MPORT[data] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %21 = firrtl.subfield %regs_io_readData_1_MPORT[addr] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %22 = firrtl.subfield %regs_io_readData_1_MPORT[en] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %23 = firrtl.subfield %regs_io_readData_1_MPORT[clk] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %24 = firrtl.subfield %regs_io_readData_1_MPORT[data] : !firrtl.bundle<addr: uint<8>, en: uint<1>, clk: clock, data flip: uint<32>>
      %effectiveDst = firrtl.cat %1, %11 {name = "effectiveDst"} : (!firrtl.uint<3>, !firrtl.uint<5>) -> !firrtl.uint<8>
      %25 = firrtl.orr %11 : (!firrtl.uint<5>) -> !firrtl.uint<1>
      %26 = firrtl.and %10, %25 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      firrtl.matchingconnect %12, %effectiveDst : !firrtl.uint<8>
      firrtl.matchingconnect %13, %26 : !firrtl.uint<1>
      firrtl.matchingconnect %14, %clock : !firrtl.clock
      firrtl.matchingconnect %16, %c1_ui1 : !firrtl.uint<1>
      firrtl.matchingconnect %15, %9 : !firrtl.uint<32>
      %effectiveSrc = firrtl.cat %0, %8 {name = "effectiveSrc"} : (!firrtl.uint<3>, !firrtl.uint<5>) -> !firrtl.uint<8>
      %27 = firrtl.orr %8 : (!firrtl.uint<5>) -> !firrtl.uint<1>
      %_io_readData_0_T = firrtl.not %27 {name = "_io_readData_0_T"} : (!firrtl.uint<1>) -> !firrtl.uint<1>
      firrtl.matchingconnect %17, %effectiveSrc : !firrtl.uint<8>
      firrtl.matchingconnect %18, %c1_ui1 : !firrtl.uint<1>
      firrtl.matchingconnect %19, %clock : !firrtl.clock
      %_io_readData_0_T_1 = firrtl.mux(%_io_readData_0_T, %c0_ui32, %20) {name = "_io_readData_0_T_1"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %effectiveSrc_1 = firrtl.cat %0, %7 {name = "effectiveSrc_1"} : (!firrtl.uint<3>, !firrtl.uint<5>) -> !firrtl.uint<8>
      %28 = firrtl.orr %7 : (!firrtl.uint<5>) -> !firrtl.uint<1>
      %_io_readData_1_T = firrtl.not %28 {name = "_io_readData_1_T"} : (!firrtl.uint<1>) -> !firrtl.uint<1>
      firrtl.matchingconnect %21, %effectiveSrc_1 : !firrtl.uint<8>
      firrtl.matchingconnect %22, %c1_ui1 : !firrtl.uint<1>
      firrtl.matchingconnect %23, %clock : !firrtl.clock
      %_io_readData_1_T_1 = firrtl.mux(%_io_readData_1_T, %c0_ui32, %24) {name = "_io_readData_1_T_1"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %29 = firrtl.vectorcreate %_io_readData_0_T_1, %_io_readData_1_T_1 : (!firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.vector<uint<32>, 2>
      %30 = firrtl.bundlecreate %io_readThreadID, %io_writeThreadID, %io_readAddrs, %29, %io_writeAddrs, %io_wens, %io_writeData : (!firrtl.uint<3>, !firrtl.uint<3>, !firrtl.vector<uint<5>, 2>, !firrtl.vector<uint<32>, 2>, !firrtl.vector<uint<5>, 1>, !firrtl.vector<uint<1>, 1>, !firrtl.vector<uint<32>, 1>) -> !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      firrtl.matchingconnect %io, %30 : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
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
    firrtl.module private @Mul32Pipelined(in %clock: !firrtl.clock, in %io_a: !firrtl.uint<32>, in %io_b: !firrtl.uint<32>, in %io_signedA: !firrtl.uint<1>, in %io_signedB: !firrtl.uint<1>, out %io_product: !firrtl.uint<64>, out %io_lo: !firrtl.uint<32>, out %io_hi: !firrtl.uint<32>) {
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
      %_prodCombinational_T = firrtl.mul %opA, %opB {name = "_prodCombinational_T"} : (!firrtl.sint<33>, !firrtl.sint<33>) -> !firrtl.sint<66>
      %prodCombinational = firrtl.bits %_prodCombinational_T 63 to 0 {name = "prodCombinational"} : (!firrtl.sint<66>) -> !firrtl.uint<64>
      %delayedProd_r = firrtl.reg %clock {firrtl.random_init_start = 0 : ui64} : !firrtl.clock, !firrtl.uint<64>
      firrtl.matchingconnect %delayedProd_r, %prodCombinational : !firrtl.uint<64>
      %delayedProd_r_1 = firrtl.reg %clock {firrtl.random_init_start = 64 : ui64} : !firrtl.clock, !firrtl.uint<64>
      firrtl.matchingconnect %delayedProd_r_1, %delayedProd_r : !firrtl.uint<64>
      %delayedProd_r_2 = firrtl.reg %clock {firrtl.random_init_start = 128 : ui64} : !firrtl.clock, !firrtl.uint<64>
      firrtl.matchingconnect %delayedProd_r_2, %delayedProd_r_1 : !firrtl.uint<64>
      %delayedProd = firrtl.reg %clock {firrtl.random_init_start = 192 : ui64} : !firrtl.clock, !firrtl.uint<64>
      firrtl.matchingconnect %delayedProd, %delayedProd_r_2 : !firrtl.uint<64>
      %_io_lo_T = firrtl.bits %delayedProd 31 to 0 {name = "_io_lo_T"} : (!firrtl.uint<64>) -> !firrtl.uint<32>
      %_io_hi_T = firrtl.bits %delayedProd 63 to 32 {name = "_io_hi_T"} : (!firrtl.uint<64>) -> !firrtl.uint<32>
      %11 = firrtl.bundlecreate %io_a, %io_b, %io_signedA, %io_signedB, %delayedProd, %_io_lo_T, %_io_hi_T : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<64>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
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
      %regFile_clock, %regFile_io_readThreadID, %regFile_io_writeThreadID, %regFile_io_readAddrs, %regFile_io_readData, %regFile_io_writeAddrs, %regFile_io_wens, %regFile_io_writeData = firrtl.instance regFile @RegFileMT2R1WMem(in clock: !firrtl.clock, in io_readThreadID: !firrtl.uint<3>, in io_writeThreadID: !firrtl.uint<3>, in io_readAddrs: !firrtl.vector<uint<5>, 2>, out io_readData: !firrtl.vector<uint<32>, 2>, in io_writeAddrs: !firrtl.vector<uint<5>, 1>, in io_wens: !firrtl.vector<uint<1>, 1>, in io_writeData: !firrtl.vector<uint<32>, 1>)
      %regFile.io = firrtl.wire : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      %106 = firrtl.subfield %regFile.io[readThreadID] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      firrtl.matchingconnect %regFile_io_readThreadID, %106 : !firrtl.uint<3>
      %107 = firrtl.subfield %regFile.io[writeThreadID] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      firrtl.matchingconnect %regFile_io_writeThreadID, %107 : !firrtl.uint<3>
      %108 = firrtl.subfield %regFile.io[readAddrs] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      firrtl.matchingconnect %regFile_io_readAddrs, %108 : !firrtl.vector<uint<5>, 2>
      %109 = firrtl.subfield %regFile.io[readData] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      %110 = firrtl.subfield %regFile.io[writeAddrs] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      firrtl.matchingconnect %regFile_io_writeAddrs, %110 : !firrtl.vector<uint<5>, 1>
      %111 = firrtl.subfield %regFile.io[wens] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      firrtl.matchingconnect %regFile_io_wens, %111 : !firrtl.vector<uint<1>, 1>
      %112 = firrtl.subfield %regFile.io[writeData] : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      firrtl.matchingconnect %regFile_io_writeData, %112 : !firrtl.vector<uint<32>, 1>
      %113 = firrtl.subindex %109[1] : !firrtl.vector<uint<32>, 2>
      %114 = firrtl.subindex %109[0] : !firrtl.vector<uint<32>, 2>
      firrtl.matchingconnect %regFile_clock, %clock : !firrtl.clock
      %alu_io_a, %alu_io_b, %alu_io_opcode, %alu_io_result = firrtl.instance alu @ALU32(in io_a: !firrtl.uint<32>, in io_b: !firrtl.uint<32>, in io_opcode: !firrtl.uint<5>, out io_result: !firrtl.uint<32>)
      %alu.io = firrtl.wire : !firrtl.bundle<a: uint<32>, b: uint<32>, opcode: uint<5>, result: uint<32>>
      %115 = firrtl.subfield %alu.io[a] : !firrtl.bundle<a: uint<32>, b: uint<32>, opcode: uint<5>, result: uint<32>>
      firrtl.matchingconnect %alu_io_a, %115 : !firrtl.uint<32>
      %116 = firrtl.subfield %alu.io[b] : !firrtl.bundle<a: uint<32>, b: uint<32>, opcode: uint<5>, result: uint<32>>
      firrtl.matchingconnect %alu_io_b, %116 : !firrtl.uint<32>
      %117 = firrtl.subfield %alu.io[opcode] : !firrtl.bundle<a: uint<32>, b: uint<32>, opcode: uint<5>, result: uint<32>>
      firrtl.matchingconnect %alu_io_opcode, %117 : !firrtl.uint<5>
      %118 = firrtl.subfield %alu.io[result] : !firrtl.bundle<a: uint<32>, b: uint<32>, opcode: uint<5>, result: uint<32>>
      %mulUnit_clock, %mulUnit_io_a, %mulUnit_io_b, %mulUnit_io_signedA, %mulUnit_io_signedB, %mulUnit_io_product, %mulUnit_io_lo, %mulUnit_io_hi = firrtl.instance mulUnit @Mul32Pipelined(in clock: !firrtl.clock, in io_a: !firrtl.uint<32>, in io_b: !firrtl.uint<32>, in io_signedA: !firrtl.uint<1>, in io_signedB: !firrtl.uint<1>, out io_product: !firrtl.uint<64>, out io_lo: !firrtl.uint<32>, out io_hi: !firrtl.uint<32>)
      %mulUnit.io = firrtl.wire : !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      %119 = firrtl.subfield %mulUnit.io[a] : !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      firrtl.matchingconnect %mulUnit_io_a, %119 : !firrtl.uint<32>
      %120 = firrtl.subfield %mulUnit.io[b] : !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      firrtl.matchingconnect %mulUnit_io_b, %120 : !firrtl.uint<32>
      %121 = firrtl.subfield %mulUnit.io[signedA] : !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      firrtl.matchingconnect %mulUnit_io_signedA, %121 : !firrtl.uint<1>
      %122 = firrtl.subfield %mulUnit.io[signedB] : !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      firrtl.matchingconnect %mulUnit_io_signedB, %122 : !firrtl.uint<1>
      %_mulResult_WB_T_1 = firrtl.subfield %mulUnit.io[lo] {name = "_mulResult_WB_T_1"} : !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      %123 = firrtl.subfield %mulUnit.io[hi] : !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      firrtl.matchingconnect %mulUnit_clock, %clock : !firrtl.clock
      %branchUnit_io_rs1, %branchUnit_io_rs2, %branchUnit_io_pc, %branchUnit_io_imm, %branchUnit_io_branchOp, %branchUnit_io_valid, %branchUnit_io_taken, %branchUnit_io_target, %branchUnit_io_nextPc, %branchUnit_io_misaligned = firrtl.instance branchUnit @BranchUnit(in io_rs1: !firrtl.uint<32>, in io_rs2: !firrtl.uint<32>, in io_pc: !firrtl.uint<32>, in io_imm: !firrtl.sint<32>, in io_branchOp: !firrtl.uint<3>, in io_valid: !firrtl.uint<1>, out io_taken: !firrtl.uint<1>, out io_target: !firrtl.uint<32>, out io_nextPc: !firrtl.uint<32>, out io_misaligned: !firrtl.uint<1>)
      %branchUnit.io = firrtl.wire : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      %124 = firrtl.subfield %branchUnit.io[rs1] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      firrtl.matchingconnect %branchUnit_io_rs1, %124 : !firrtl.uint<32>
      %125 = firrtl.subfield %branchUnit.io[rs2] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      firrtl.matchingconnect %branchUnit_io_rs2, %125 : !firrtl.uint<32>
      %126 = firrtl.subfield %branchUnit.io[pc] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      firrtl.matchingconnect %branchUnit_io_pc, %126 : !firrtl.uint<32>
      %127 = firrtl.subfield %branchUnit.io[imm] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      firrtl.matchingconnect %branchUnit_io_imm, %127 : !firrtl.sint<32>
      %128 = firrtl.subfield %branchUnit.io[branchOp] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      firrtl.matchingconnect %branchUnit_io_branchOp, %128 : !firrtl.uint<3>
      %129 = firrtl.subfield %branchUnit.io[valid] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      firrtl.matchingconnect %branchUnit_io_valid, %129 : !firrtl.uint<1>
      %130 = firrtl.subfield %branchUnit.io[taken] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      %131 = firrtl.subfield %branchUnit.io[target] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      %132 = firrtl.subfield %branchUnit.io[nextPc] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      %133 = firrtl.subfield %branchUnit.io[misaligned] : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      %unusedBranchNextPc = firrtl.node %132 {annotations = [{class = "firrtl.transforms.DontTouchAnnotation"}]} : !firrtl.uint<32>
      %unusedBranchMisaligned = firrtl.node %133 {annotations = [{class = "firrtl.transforms.DontTouchAnnotation"}]} : !firrtl.uint<1>
      %loadUnit_io_addr, %loadUnit_io_dataIn, %loadUnit_io_funct3, %loadUnit_io_dataOut = firrtl.instance loadUnit @LoadUnit(in io_addr: !firrtl.uint<32>, in io_dataIn: !firrtl.uint<32>, in io_funct3: !firrtl.uint<3>, out io_dataOut: !firrtl.uint<32>)
      %loadUnit.io = firrtl.wire : !firrtl.bundle<addr: uint<32>, dataIn: uint<32>, funct3: uint<3>, dataOut: uint<32>>
      %134 = firrtl.subfield %loadUnit.io[addr] : !firrtl.bundle<addr: uint<32>, dataIn: uint<32>, funct3: uint<3>, dataOut: uint<32>>
      firrtl.matchingconnect %loadUnit_io_addr, %134 : !firrtl.uint<32>
      %135 = firrtl.subfield %loadUnit.io[dataIn] : !firrtl.bundle<addr: uint<32>, dataIn: uint<32>, funct3: uint<3>, dataOut: uint<32>>
      firrtl.matchingconnect %loadUnit_io_dataIn, %135 : !firrtl.uint<32>
      %136 = firrtl.subfield %loadUnit.io[funct3] : !firrtl.bundle<addr: uint<32>, dataIn: uint<32>, funct3: uint<3>, dataOut: uint<32>>
      firrtl.matchingconnect %loadUnit_io_funct3, %136 : !firrtl.uint<3>
      %137 = firrtl.subfield %loadUnit.io[dataOut] : !firrtl.bundle<addr: uint<32>, dataIn: uint<32>, funct3: uint<3>, dataOut: uint<32>>
      %storeUnit_io_addr, %storeUnit_io_data, %storeUnit_io_storeType, %storeUnit_io_memWrite, %storeUnit_io_mask, %storeUnit_io_misaligned = firrtl.instance storeUnit @StoreUnit(in io_addr: !firrtl.uint<32>, in io_data: !firrtl.uint<32>, in io_storeType: !firrtl.uint<2>, out io_memWrite: !firrtl.uint<32>, out io_mask: !firrtl.uint<4>, out io_misaligned: !firrtl.uint<1>)
      %storeUnit.io = firrtl.wire : !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      %138 = firrtl.subfield %storeUnit.io[addr] : !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      firrtl.matchingconnect %storeUnit_io_addr, %138 : !firrtl.uint<32>
      %139 = firrtl.subfield %storeUnit.io[data] : !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      firrtl.matchingconnect %storeUnit_io_data, %139 : !firrtl.uint<32>
      %140 = firrtl.subfield %storeUnit.io[storeType] : !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      firrtl.matchingconnect %storeUnit_io_storeType, %140 : !firrtl.uint<2>
      %141 = firrtl.subfield %storeUnit.io[memWrite] : !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      %142 = firrtl.subfield %storeUnit.io[mask] : !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      %143 = firrtl.subfield %storeUnit.io[misaligned] : !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      %_fetchReg_WIRE = firrtl.wire : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      firrtl.matchingconnect %_fetchReg_WIRE, %9 : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %fetchReg = firrtl.regreset %clock, %reset, %_fetchReg_WIRE {firrtl.random_init_start = 1283 : ui64} : !firrtl.clock, !firrtl.uint<1>, !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %144 = firrtl.subfield %fetchReg[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %145 = firrtl.subfield %fetchReg[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %146 = firrtl.subfield %fetchReg[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %147 = firrtl.subfield %fetchReg[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %148 = firrtl.subfield %fetchReg[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %149 = firrtl.subfield %fetchReg[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %150 = firrtl.subaccess %io_threadEnable_0[%threadCounter] : !firrtl.vector<uint<1>, 8>, !firrtl.uint<3>
      %151 = firrtl.mux(%150, %threadCounter, %144) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %152 = firrtl.subaccess %pcRegs[%threadCounter] : !firrtl.vector<uint<32>, 8>, !firrtl.uint<3>
      %153 = firrtl.mux(%150, %152, %145) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %_fetchReg_instr_T = firrtl.bits %io_instrMem 31 to 0 {name = "_fetchReg_instr_T"} : (!firrtl.uint<128>) -> !firrtl.uint<32>
      %154 = firrtl.mux(%150, %_fetchReg_instr_T, %146) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %_pcRegs_T = firrtl.add %152, %c4_ui3 {name = "_pcRegs_T"} : (!firrtl.uint<32>, !firrtl.uint<3>) -> !firrtl.uint<33>
      %_pcRegs_T_1 = firrtl.bits %_pcRegs_T 31 to 0 {name = "_pcRegs_T_1"} : (!firrtl.uint<33>) -> !firrtl.uint<32>
      %155 = firrtl.orr %threadCounter : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %156 = firrtl.not %155 : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %157 = firrtl.and %150, %156 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %158 = firrtl.mux(%157, %_pcRegs_T_1, %10) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %159 = firrtl.eq %threadCounter, %c1_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %160 = firrtl.and %150, %159 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %161 = firrtl.mux(%160, %_pcRegs_T_1, %11) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %162 = firrtl.eq %threadCounter, %c2_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %163 = firrtl.and %150, %162 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %164 = firrtl.mux(%163, %_pcRegs_T_1, %12) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %165 = firrtl.eq %threadCounter, %c3_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %166 = firrtl.and %150, %165 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %167 = firrtl.mux(%166, %_pcRegs_T_1, %13) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %168 = firrtl.eq %threadCounter, %c4_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %169 = firrtl.and %150, %168 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %170 = firrtl.mux(%169, %_pcRegs_T_1, %14) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %171 = firrtl.eq %threadCounter, %c5_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %172 = firrtl.and %150, %171 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %173 = firrtl.mux(%172, %_pcRegs_T_1, %15) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %174 = firrtl.eq %threadCounter, %c6_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %175 = firrtl.and %150, %174 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %176 = firrtl.mux(%175, %_pcRegs_T_1, %16) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %177 = firrtl.andr %threadCounter : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %178 = firrtl.and %150, %177 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %179 = firrtl.mux(%178, %_pcRegs_T_1, %17) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %180 = firrtl.bundlecreate %150, %151, %153, %154 : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      firrtl.matchingconnect %fetchReg, %180 : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %_decodeReg_WIRE = firrtl.wire : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %decodeReg = firrtl.regreset %clock, %reset, %_decodeReg_WIRE {firrtl.random_init_start = 1351 : ui64} : !firrtl.clock, !firrtl.uint<1>, !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>, !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %181 = firrtl.subfield %decodeReg[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %182 = firrtl.subfield %181[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %183 = firrtl.subfield %181[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %184 = firrtl.subfield %181[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %185 = firrtl.subfield %decodeReg[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %186 = firrtl.subfield %185[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %187 = firrtl.subfield %185[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %188 = firrtl.subfield %185[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %189 = firrtl.subfield %185[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %190 = firrtl.subfield %185[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %191 = firrtl.subfield %185[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %192 = firrtl.subfield %185[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %193 = firrtl.subfield %185[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %194 = firrtl.subfield %185[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %195 = firrtl.subfield %185[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %196 = firrtl.subfield %185[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %197 = firrtl.subfield %185[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %198 = firrtl.subfield %185[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %199 = firrtl.subfield %185[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %200 = firrtl.subfield %185[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %201 = firrtl.subfield %185[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %202 = firrtl.subfield %decodeReg[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %203 = firrtl.subfield %202[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %204 = firrtl.subfield %202[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %205 = firrtl.subfield %fetchReg[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %206 = firrtl.subfield %fetchReg[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %207 = firrtl.mux(%149, %206, %182) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %208 = firrtl.subfield %fetchReg[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %209 = firrtl.mux(%149, %208, %183) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %210 = firrtl.subfield %fetchReg[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %211 = firrtl.mux(%149, %210, %184) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %decodeReg_decodeSignals_dec = firrtl.wire : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %decodeReg_decodeSignals_opcode = firrtl.bits %147 6 to 0 {name = "decodeReg_decodeSignals_opcode"} : (!firrtl.uint<32>) -> !firrtl.uint<7>
      %decodeReg_decodeSignals_funct3 = firrtl.bits %147 14 to 12 {name = "decodeReg_decodeSignals_funct3"} : (!firrtl.uint<32>) -> !firrtl.uint<3>
      %decodeReg_decodeSignals_funct7 = firrtl.bits %147 31 to 25 {name = "decodeReg_decodeSignals_funct7"} : (!firrtl.uint<32>) -> !firrtl.uint<7>
      %_decodeReg_decodeSignals_dec_rs1_T = firrtl.bits %147 19 to 15 {name = "_decodeReg_decodeSignals_dec_rs1_T"} : (!firrtl.uint<32>) -> !firrtl.uint<5>
      %_decodeReg_decodeSignals_dec_rs2_T = firrtl.bits %147 24 to 20 {name = "_decodeReg_decodeSignals_dec_rs2_T"} : (!firrtl.uint<32>) -> !firrtl.uint<5>
      %_decodeReg_decodeSignals_storeImm_T_1 = firrtl.bits %147 11 to 7 {name = "_decodeReg_decodeSignals_storeImm_T_1"} : (!firrtl.uint<32>) -> !firrtl.uint<5>
      %_decodeReg_decodeSignals_T = firrtl.eq %decodeReg_decodeSignals_opcode, %c51_ui7 {name = "_decodeReg_decodeSignals_T"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %212 = firrtl.orr %decodeReg_decodeSignals_funct3 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_1 = firrtl.not %212 {name = "_decodeReg_decodeSignals_T_1"} : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_2 = firrtl.eq %decodeReg_decodeSignals_funct7, %c32_ui6 {name = "_decodeReg_decodeSignals_T_2"} : (!firrtl.uint<7>, !firrtl.uint<6>) -> !firrtl.uint<1>
      %213 = firrtl.mux(%_decodeReg_decodeSignals_T_2, %c1_ui5, %c0_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %_decodeReg_decodeSignals_T_3 = firrtl.eq %decodeReg_decodeSignals_funct3, %c1_ui1 {name = "_decodeReg_decodeSignals_T_3"} : (!firrtl.uint<3>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_4 = firrtl.eq %decodeReg_decodeSignals_funct3, %c2_ui2 {name = "_decodeReg_decodeSignals_T_4"} : (!firrtl.uint<3>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_5 = firrtl.eq %decodeReg_decodeSignals_funct3, %c3_ui2 {name = "_decodeReg_decodeSignals_T_5"} : (!firrtl.uint<3>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_6 = firrtl.eq %decodeReg_decodeSignals_funct3, %c4_ui3 {name = "_decodeReg_decodeSignals_T_6"} : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_7 = firrtl.eq %decodeReg_decodeSignals_funct3, %c5_ui3 {name = "_decodeReg_decodeSignals_T_7"} : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_8 = firrtl.eq %decodeReg_decodeSignals_funct7, %c32_ui6 {name = "_decodeReg_decodeSignals_T_8"} : (!firrtl.uint<7>, !firrtl.uint<6>) -> !firrtl.uint<1>
      %214 = firrtl.mux(%_decodeReg_decodeSignals_T_8, %c11_ui5, %c10_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %_decodeReg_decodeSignals_T_9 = firrtl.eq %decodeReg_decodeSignals_funct3, %c6_ui3 {name = "_decodeReg_decodeSignals_T_9"} : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_10 = firrtl.andr %decodeReg_decodeSignals_funct3 {name = "_decodeReg_decodeSignals_T_10"} : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %215 = firrtl.mux(%_decodeReg_decodeSignals_T_10, %c14_ui5, %c0_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %216 = firrtl.mux(%_decodeReg_decodeSignals_T_9, %c12_ui5, %215) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %217 = firrtl.mux(%_decodeReg_decodeSignals_T_7, %214, %216) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %218 = firrtl.mux(%_decodeReg_decodeSignals_T_6, %c8_ui5, %217) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %219 = firrtl.mux(%_decodeReg_decodeSignals_T_5, %c6_ui5, %218) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %220 = firrtl.mux(%_decodeReg_decodeSignals_T_4, %c4_ui5, %219) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %221 = firrtl.mux(%_decodeReg_decodeSignals_T_3, %c2_ui5, %220) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %222 = firrtl.mux(%_decodeReg_decodeSignals_T_1, %213, %221) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %_decodeReg_decodeSignals_T_11 = firrtl.eq %decodeReg_decodeSignals_opcode, %c19_ui7 {name = "_decodeReg_decodeSignals_T_11"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %223 = firrtl.or %_decodeReg_decodeSignals_T, %_decodeReg_decodeSignals_T_11 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_immI_T = firrtl.bits %147 31 to 20 {name = "_decodeReg_decodeSignals_immI_T"} : (!firrtl.uint<32>) -> !firrtl.uint<12>
      %decodeReg_decodeSignals_immI_sign = firrtl.bits %147 31 to 31 {name = "decodeReg_decodeSignals_immI_sign"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_immI_T_1 = firrtl.mux(%decodeReg_decodeSignals_immI_sign, %c1048575_ui20, %c0_ui20) {name = "_decodeReg_decodeSignals_immI_T_1"} : (!firrtl.uint<1>, !firrtl.uint<20>, !firrtl.uint<20>) -> !firrtl.uint<20>
      %decodeReg_decodeSignals_immI = firrtl.cat %_decodeReg_decodeSignals_immI_T_1, %_decodeReg_decodeSignals_immI_T {name = "decodeReg_decodeSignals_immI"} : (!firrtl.uint<20>, !firrtl.uint<12>) -> !firrtl.uint<32>
      %224 = firrtl.orr %decodeReg_decodeSignals_funct3 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_12 = firrtl.not %224 {name = "_decodeReg_decodeSignals_T_12"} : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_13 = firrtl.eq %decodeReg_decodeSignals_funct3, %c2_ui2 {name = "_decodeReg_decodeSignals_T_13"} : (!firrtl.uint<3>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_14 = firrtl.eq %decodeReg_decodeSignals_funct3, %c3_ui2 {name = "_decodeReg_decodeSignals_T_14"} : (!firrtl.uint<3>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_15 = firrtl.eq %decodeReg_decodeSignals_funct3, %c4_ui3 {name = "_decodeReg_decodeSignals_T_15"} : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_16 = firrtl.eq %decodeReg_decodeSignals_funct3, %c6_ui3 {name = "_decodeReg_decodeSignals_T_16"} : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_17 = firrtl.andr %decodeReg_decodeSignals_funct3 {name = "_decodeReg_decodeSignals_T_17"} : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_18 = firrtl.eq %decodeReg_decodeSignals_funct3, %c1_ui1 {name = "_decodeReg_decodeSignals_T_18"} : (!firrtl.uint<3>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_19 = firrtl.eq %decodeReg_decodeSignals_funct3, %c5_ui3 {name = "_decodeReg_decodeSignals_T_19"} : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_21 = firrtl.bits %147 30 to 30 {name = "_decodeReg_decodeSignals_T_21"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %225 = firrtl.mux(%_decodeReg_decodeSignals_T_21, %c11_ui5, %c10_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %226 = firrtl.mux(%_decodeReg_decodeSignals_T_19, %225, %c0_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %227 = firrtl.mux(%_decodeReg_decodeSignals_T_18, %c2_ui5, %226) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %228 = firrtl.mux(%_decodeReg_decodeSignals_T_17, %c14_ui5, %227) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %229 = firrtl.mux(%_decodeReg_decodeSignals_T_16, %c12_ui5, %228) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %230 = firrtl.mux(%_decodeReg_decodeSignals_T_15, %c8_ui5, %229) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %231 = firrtl.mux(%_decodeReg_decodeSignals_T_14, %c6_ui5, %230) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %232 = firrtl.mux(%_decodeReg_decodeSignals_T_13, %c4_ui5, %231) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %233 = firrtl.mux(%_decodeReg_decodeSignals_T_12, %c0_ui5, %232) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %234 = firrtl.mux(%_decodeReg_decodeSignals_T_11, %233, %c0_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %235 = firrtl.mux(%_decodeReg_decodeSignals_T, %222, %234) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %_decodeReg_decodeSignals_T_22 = firrtl.eq %decodeReg_decodeSignals_opcode, %c3_ui7 {name = "_decodeReg_decodeSignals_T_22"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %236 = firrtl.or %_decodeReg_decodeSignals_T, %_decodeReg_decodeSignals_T_11 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %237 = firrtl.mux(%236, %c0_ui1, %_decodeReg_decodeSignals_T_22) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_dec_imm_T = firrtl.bits %147 31 to 20 {name = "_decodeReg_decodeSignals_dec_imm_T"} : (!firrtl.uint<32>) -> !firrtl.uint<12>
      %decodeReg_decodeSignals_dec_imm_sign = firrtl.bits %147 31 to 31 {name = "decodeReg_decodeSignals_dec_imm_sign"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_dec_imm_T_1 = firrtl.mux(%decodeReg_decodeSignals_dec_imm_sign, %c1048575_ui20, %c0_ui20) {name = "_decodeReg_decodeSignals_dec_imm_T_1"} : (!firrtl.uint<1>, !firrtl.uint<20>, !firrtl.uint<20>) -> !firrtl.uint<20>
      %_decodeReg_decodeSignals_dec_imm_T_2 = firrtl.cat %_decodeReg_decodeSignals_dec_imm_T_1, %_decodeReg_decodeSignals_dec_imm_T {name = "_decodeReg_decodeSignals_dec_imm_T_2"} : (!firrtl.uint<20>, !firrtl.uint<12>) -> !firrtl.uint<32>
      %_decodeReg_decodeSignals_T_23 = firrtl.eq %decodeReg_decodeSignals_opcode, %c35_ui7 {name = "_decodeReg_decodeSignals_T_23"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %238 = firrtl.or %_decodeReg_decodeSignals_T_11, %_decodeReg_decodeSignals_T_22 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %239 = firrtl.or %_decodeReg_decodeSignals_T, %238 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %240 = firrtl.mux(%239, %c0_ui1, %_decodeReg_decodeSignals_T_23) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %decodeReg_decodeSignals_dec_imm_sign_1 = firrtl.bits %147 31 to 31 {name = "decodeReg_decodeSignals_dec_imm_sign_1"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_dec_imm_T_3 = firrtl.mux(%decodeReg_decodeSignals_dec_imm_sign_1, %c1048575_ui20, %c0_ui20) {name = "_decodeReg_decodeSignals_dec_imm_T_3"} : (!firrtl.uint<1>, !firrtl.uint<20>, !firrtl.uint<20>) -> !firrtl.uint<20>
      %_decodeReg_decodeSignals_dec_imm_T_4 = firrtl.cat %_decodeReg_decodeSignals_dec_imm_T_3, %decodeReg_decodeSignals_funct7, %_decodeReg_decodeSignals_storeImm_T_1 {name = "_decodeReg_decodeSignals_dec_imm_T_4"} : (!firrtl.uint<20>, !firrtl.uint<7>, !firrtl.uint<5>) -> !firrtl.uint<32>
      %_decodeReg_decodeSignals_T_24 = firrtl.eq %decodeReg_decodeSignals_opcode, %c99_ui7 {name = "_decodeReg_decodeSignals_T_24"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %241 = firrtl.or %_decodeReg_decodeSignals_T_22, %_decodeReg_decodeSignals_T_23 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %242 = firrtl.or %_decodeReg_decodeSignals_T_11, %241 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %243 = firrtl.or %_decodeReg_decodeSignals_T, %242 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %244 = firrtl.mux(%243, %c0_ui1, %_decodeReg_decodeSignals_T_24) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %decodeReg_decodeSignals_dec_imm_sign_2 = firrtl.bits %147 31 to 31 {name = "decodeReg_decodeSignals_dec_imm_sign_2"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_branchImm_T_1 = firrtl.bits %147 7 to 7 {name = "_decodeReg_decodeSignals_branchImm_T_1"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_branchImm_T_2 = firrtl.bits %147 30 to 25 {name = "_decodeReg_decodeSignals_branchImm_T_2"} : (!firrtl.uint<32>) -> !firrtl.uint<6>
      %_decodeReg_decodeSignals_branchImm_T_3 = firrtl.bits %147 11 to 8 {name = "_decodeReg_decodeSignals_branchImm_T_3"} : (!firrtl.uint<32>) -> !firrtl.uint<4>
      %_decodeReg_decodeSignals_dec_imm_T_5 = firrtl.mux(%decodeReg_decodeSignals_dec_imm_sign_2, %c1048575_ui20, %c0_ui20) {name = "_decodeReg_decodeSignals_dec_imm_T_5"} : (!firrtl.uint<1>, !firrtl.uint<20>, !firrtl.uint<20>) -> !firrtl.uint<20>
      %_decodeReg_decodeSignals_dec_imm_T_6 = firrtl.cat %_decodeReg_decodeSignals_dec_imm_T_5, %decodeReg_decodeSignals_dec_imm_sign_2, %_decodeReg_decodeSignals_branchImm_T_1, %_decodeReg_decodeSignals_branchImm_T_2, %_decodeReg_decodeSignals_branchImm_T_3 {name = "_decodeReg_decodeSignals_dec_imm_T_6"} : (!firrtl.uint<20>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<6>, !firrtl.uint<4>) -> !firrtl.uint<32>
      %_decodeReg_decodeSignals_T_25 = firrtl.eq %decodeReg_decodeSignals_opcode, %c111_ui7 {name = "_decodeReg_decodeSignals_T_25"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %245 = firrtl.or %_decodeReg_decodeSignals_T_23, %_decodeReg_decodeSignals_T_24 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %246 = firrtl.or %_decodeReg_decodeSignals_T_22, %245 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %247 = firrtl.or %_decodeReg_decodeSignals_T_11, %246 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %248 = firrtl.or %_decodeReg_decodeSignals_T, %247 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %249 = firrtl.mux(%248, %c0_ui1, %_decodeReg_decodeSignals_T_25) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %decodeReg_decodeSignals_dec_imm_sign_3 = firrtl.bits %147 31 to 31 {name = "decodeReg_decodeSignals_dec_imm_sign_3"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_jumpImm_T_1 = firrtl.bits %147 19 to 12 {name = "_decodeReg_decodeSignals_jumpImm_T_1"} : (!firrtl.uint<32>) -> !firrtl.uint<8>
      %_decodeReg_decodeSignals_jumpImm_T_2 = firrtl.bits %147 20 to 20 {name = "_decodeReg_decodeSignals_jumpImm_T_2"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_jumpImm_T_3 = firrtl.bits %147 30 to 21 {name = "_decodeReg_decodeSignals_jumpImm_T_3"} : (!firrtl.uint<32>) -> !firrtl.uint<10>
      %_decodeReg_decodeSignals_dec_imm_T_8 = firrtl.mux(%decodeReg_decodeSignals_dec_imm_sign_3, %c2047_ui11, %c0_ui11) {name = "_decodeReg_decodeSignals_dec_imm_T_8"} : (!firrtl.uint<1>, !firrtl.uint<11>, !firrtl.uint<11>) -> !firrtl.uint<11>
      %_decodeReg_decodeSignals_dec_imm_T_9 = firrtl.cat %_decodeReg_decodeSignals_dec_imm_T_8, %decodeReg_decodeSignals_dec_imm_sign_3, %_decodeReg_decodeSignals_jumpImm_T_1, %_decodeReg_decodeSignals_jumpImm_T_2, %_decodeReg_decodeSignals_jumpImm_T_3, %c0_ui1 {name = "_decodeReg_decodeSignals_dec_imm_T_9"} : (!firrtl.uint<11>, !firrtl.uint<1>, !firrtl.uint<8>, !firrtl.uint<1>, !firrtl.uint<10>, !firrtl.uint<1>) -> !firrtl.uint<32>
      %_decodeReg_decodeSignals_T_26 = firrtl.eq %decodeReg_decodeSignals_opcode, %c103_ui7 {name = "_decodeReg_decodeSignals_T_26"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %250 = firrtl.or %_decodeReg_decodeSignals_T_24, %_decodeReg_decodeSignals_T_25 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %251 = firrtl.or %_decodeReg_decodeSignals_T_23, %250 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %252 = firrtl.or %_decodeReg_decodeSignals_T_22, %251 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %253 = firrtl.or %_decodeReg_decodeSignals_T_11, %252 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %254 = firrtl.or %_decodeReg_decodeSignals_T, %253 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %255 = firrtl.mux(%254, %c0_ui1, %_decodeReg_decodeSignals_T_26) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_dec_imm_T_10 = firrtl.bits %147 31 to 20 {name = "_decodeReg_decodeSignals_dec_imm_T_10"} : (!firrtl.uint<32>) -> !firrtl.uint<12>
      %decodeReg_decodeSignals_dec_imm_sign_4 = firrtl.bits %147 31 to 31 {name = "decodeReg_decodeSignals_dec_imm_sign_4"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_dec_imm_T_11 = firrtl.mux(%decodeReg_decodeSignals_dec_imm_sign_4, %c1048575_ui20, %c0_ui20) {name = "_decodeReg_decodeSignals_dec_imm_T_11"} : (!firrtl.uint<1>, !firrtl.uint<20>, !firrtl.uint<20>) -> !firrtl.uint<20>
      %_decodeReg_decodeSignals_dec_imm_T_12 = firrtl.cat %_decodeReg_decodeSignals_dec_imm_T_11, %_decodeReg_decodeSignals_dec_imm_T_10 {name = "_decodeReg_decodeSignals_dec_imm_T_12"} : (!firrtl.uint<20>, !firrtl.uint<12>) -> !firrtl.uint<32>
      %_decodeReg_decodeSignals_T_27 = firrtl.eq %decodeReg_decodeSignals_opcode, %c55_ui7 {name = "_decodeReg_decodeSignals_T_27"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %256 = firrtl.or %_decodeReg_decodeSignals_T_25, %_decodeReg_decodeSignals_T_26 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %257 = firrtl.or %_decodeReg_decodeSignals_T_24, %256 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %258 = firrtl.or %_decodeReg_decodeSignals_T_23, %257 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %259 = firrtl.or %_decodeReg_decodeSignals_T_22, %258 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %260 = firrtl.or %_decodeReg_decodeSignals_T_11, %259 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %261 = firrtl.or %_decodeReg_decodeSignals_T, %260 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %262 = firrtl.mux(%261, %c0_ui1, %_decodeReg_decodeSignals_T_27) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_dec_imm_T_13 = firrtl.bits %147 31 to 12 {name = "_decodeReg_decodeSignals_dec_imm_T_13"} : (!firrtl.uint<32>) -> !firrtl.uint<20>
      %_decodeReg_decodeSignals_dec_imm_T_15 = firrtl.cat %_decodeReg_decodeSignals_dec_imm_T_13, %c0_ui12 {name = "_decodeReg_decodeSignals_dec_imm_T_15"} : (!firrtl.uint<20>, !firrtl.uint<12>) -> !firrtl.uint<32>
      %_decodeReg_decodeSignals_T_28 = firrtl.eq %decodeReg_decodeSignals_opcode, %c23_ui7 {name = "_decodeReg_decodeSignals_T_28"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %263 = firrtl.or %_decodeReg_decodeSignals_T_26, %_decodeReg_decodeSignals_T_27 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %264 = firrtl.or %_decodeReg_decodeSignals_T_25, %263 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %265 = firrtl.or %_decodeReg_decodeSignals_T_24, %264 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %266 = firrtl.or %_decodeReg_decodeSignals_T_23, %265 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %267 = firrtl.or %_decodeReg_decodeSignals_T_22, %266 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %268 = firrtl.or %_decodeReg_decodeSignals_T_11, %267 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %269 = firrtl.or %_decodeReg_decodeSignals_T, %268 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %270 = firrtl.mux(%269, %c0_ui1, %_decodeReg_decodeSignals_T_28) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %271 = firrtl.or %_decodeReg_decodeSignals_T_27, %_decodeReg_decodeSignals_T_28 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %272 = firrtl.or %_decodeReg_decodeSignals_T_26, %271 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %273 = firrtl.or %_decodeReg_decodeSignals_T_24, %_decodeReg_decodeSignals_T_25 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %274 = firrtl.mux(%273, %c0_ui1, %272) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %275 = firrtl.or %_decodeReg_decodeSignals_T_22, %_decodeReg_decodeSignals_T_23 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %276 = firrtl.or %_decodeReg_decodeSignals_T_11, %275 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %277 = firrtl.mux(%276, %c1_ui1, %274) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %278 = firrtl.mux(%_decodeReg_decodeSignals_T, %c0_ui1, %277) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_dec_imm_T_16 = firrtl.bits %147 31 to 12 {name = "_decodeReg_decodeSignals_dec_imm_T_16"} : (!firrtl.uint<32>) -> !firrtl.uint<20>
      %_decodeReg_decodeSignals_dec_imm_T_18 = firrtl.cat %_decodeReg_decodeSignals_dec_imm_T_16, %c0_ui12 {name = "_decodeReg_decodeSignals_dec_imm_T_18"} : (!firrtl.uint<20>, !firrtl.uint<12>) -> !firrtl.uint<32>
      %279 = firrtl.mux(%_decodeReg_decodeSignals_T_28, %_decodeReg_decodeSignals_dec_imm_T_18, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %280 = firrtl.mux(%_decodeReg_decodeSignals_T_27, %_decodeReg_decodeSignals_dec_imm_T_15, %279) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %281 = firrtl.mux(%_decodeReg_decodeSignals_T_26, %_decodeReg_decodeSignals_dec_imm_T_12, %280) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %282 = firrtl.mux(%_decodeReg_decodeSignals_T_25, %_decodeReg_decodeSignals_dec_imm_T_9, %281) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %283 = firrtl.mux(%_decodeReg_decodeSignals_T_24, %_decodeReg_decodeSignals_dec_imm_T_6, %282) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %284 = firrtl.mux(%_decodeReg_decodeSignals_T_23, %_decodeReg_decodeSignals_dec_imm_T_4, %283) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %285 = firrtl.mux(%_decodeReg_decodeSignals_T_22, %_decodeReg_decodeSignals_dec_imm_T_2, %284) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %286 = firrtl.mux(%_decodeReg_decodeSignals_T_11, %decodeReg_decodeSignals_immI, %285) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %287 = firrtl.mux(%_decodeReg_decodeSignals_T, %c0_ui32, %286) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %_decodeReg_decodeSignals_T_29 = firrtl.eq %decodeReg_decodeSignals_opcode, %c115_ui7 {name = "_decodeReg_decodeSignals_T_29"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %288 = firrtl.or %_decodeReg_decodeSignals_T_27, %_decodeReg_decodeSignals_T_28 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %289 = firrtl.or %_decodeReg_decodeSignals_T_26, %288 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %290 = firrtl.or %_decodeReg_decodeSignals_T_25, %289 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %291 = firrtl.or %_decodeReg_decodeSignals_T_24, %290 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %292 = firrtl.or %_decodeReg_decodeSignals_T_23, %291 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %293 = firrtl.or %_decodeReg_decodeSignals_T_22, %292 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %294 = firrtl.or %_decodeReg_decodeSignals_T_11, %293 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %295 = firrtl.or %_decodeReg_decodeSignals_T, %294 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %296 = firrtl.mux(%295, %c0_ui1, %_decodeReg_decodeSignals_T_29) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_decodeReg_decodeSignals_T_30 = firrtl.eq %decodeReg_decodeSignals_opcode, %c15_ui7 {name = "_decodeReg_decodeSignals_T_30"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %297 = firrtl.or %_decodeReg_decodeSignals_T_28, %_decodeReg_decodeSignals_T_29 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %298 = firrtl.or %_decodeReg_decodeSignals_T_27, %297 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %299 = firrtl.or %_decodeReg_decodeSignals_T_26, %298 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %300 = firrtl.or %_decodeReg_decodeSignals_T_25, %299 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %301 = firrtl.or %_decodeReg_decodeSignals_T_24, %300 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %302 = firrtl.or %_decodeReg_decodeSignals_T_23, %301 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %303 = firrtl.or %_decodeReg_decodeSignals_T_22, %302 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %304 = firrtl.or %_decodeReg_decodeSignals_T_11, %303 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %305 = firrtl.or %_decodeReg_decodeSignals_T, %304 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %306 = firrtl.mux(%305, %c0_ui1, %_decodeReg_decodeSignals_T_30) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %307 = firrtl.bundlecreate %223, %237, %240, %244, %249, %255, %262, %270, %296, %306, %278, %_decodeReg_decodeSignals_dec_rs1_T, %_decodeReg_decodeSignals_dec_rs2_T, %_decodeReg_decodeSignals_storeImm_T_1, %235, %287 : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<32>) -> !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      firrtl.matchingconnect %decodeReg_decodeSignals_dec, %307 : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %308 = firrtl.subfield %decodeReg_decodeSignals_dec[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %309 = firrtl.mux(%149, %308, %186) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %310 = firrtl.subfield %decodeReg_decodeSignals_dec[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %311 = firrtl.mux(%149, %310, %187) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %312 = firrtl.subfield %decodeReg_decodeSignals_dec[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %313 = firrtl.mux(%149, %312, %188) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %314 = firrtl.subfield %decodeReg_decodeSignals_dec[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %315 = firrtl.mux(%149, %314, %189) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %316 = firrtl.subfield %decodeReg_decodeSignals_dec[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %317 = firrtl.mux(%149, %316, %190) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %318 = firrtl.subfield %decodeReg_decodeSignals_dec[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %319 = firrtl.mux(%149, %318, %191) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %320 = firrtl.subfield %decodeReg_decodeSignals_dec[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %321 = firrtl.mux(%149, %320, %192) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %322 = firrtl.subfield %decodeReg_decodeSignals_dec[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %323 = firrtl.mux(%149, %322, %193) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %324 = firrtl.subfield %decodeReg_decodeSignals_dec[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %325 = firrtl.mux(%149, %324, %194) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %326 = firrtl.subfield %decodeReg_decodeSignals_dec[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %327 = firrtl.mux(%149, %326, %195) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %328 = firrtl.subfield %decodeReg_decodeSignals_dec[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %329 = firrtl.mux(%149, %328, %196) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %330 = firrtl.subfield %decodeReg_decodeSignals_dec[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %331 = firrtl.mux(%149, %330, %197) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %332 = firrtl.subfield %decodeReg_decodeSignals_dec[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %333 = firrtl.mux(%149, %332, %198) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %334 = firrtl.subfield %decodeReg_decodeSignals_dec[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %335 = firrtl.mux(%149, %334, %199) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %336 = firrtl.subfield %decodeReg_decodeSignals_dec[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %337 = firrtl.mux(%149, %336, %200) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %338 = firrtl.subfield %decodeReg_decodeSignals_dec[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %339 = firrtl.mux(%149, %338, %201) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %340 = firrtl.mux(%149, %205, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %341 = firrtl.bundlecreate %340, %207, %209, %211 : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %_dispatchReg_WIRE = firrtl.wire : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %dispatchReg = firrtl.regreset %clock, %reset, %_dispatchReg_WIRE {firrtl.random_init_start = 1482 : ui64} : !firrtl.clock, !firrtl.uint<1>, !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %342 = firrtl.subfield %dispatchReg[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %343 = firrtl.subfield %342[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %344 = firrtl.subfield %343[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %345 = firrtl.subfield %343[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %346 = firrtl.subfield %343[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %347 = firrtl.subfield %342[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %348 = firrtl.subfield %347[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %349 = firrtl.subfield %347[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %350 = firrtl.subfield %347[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %351 = firrtl.subfield %347[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %352 = firrtl.subfield %347[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %353 = firrtl.subfield %347[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %354 = firrtl.subfield %347[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %355 = firrtl.subfield %347[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %356 = firrtl.subfield %347[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %357 = firrtl.subfield %347[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %358 = firrtl.subfield %347[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %359 = firrtl.subfield %347[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %360 = firrtl.subfield %347[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %361 = firrtl.subfield %347[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %362 = firrtl.subfield %347[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %363 = firrtl.subfield %347[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %364 = firrtl.subfield %dispatchReg[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %365 = firrtl.subfield %364[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %366 = firrtl.subfield %365[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %367 = firrtl.subfield %365[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %368 = firrtl.subfield %364[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %369 = firrtl.subfield %368[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %370 = firrtl.subfield %368[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %371 = firrtl.subfield %decodeReg[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %372 = firrtl.subfield %371[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %373 = firrtl.subfield %371[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %374 = firrtl.mux(%204, %373, %344) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %375 = firrtl.subfield %371[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %376 = firrtl.mux(%204, %375, %345) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %377 = firrtl.subfield %371[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %378 = firrtl.mux(%204, %377, %346) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %379 = firrtl.subfield %decodeReg[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %380 = firrtl.subfield %379[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %381 = firrtl.mux(%204, %380, %348) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %382 = firrtl.subfield %379[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %383 = firrtl.mux(%204, %382, %349) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %384 = firrtl.subfield %379[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %385 = firrtl.mux(%204, %384, %350) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %386 = firrtl.subfield %379[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %387 = firrtl.mux(%204, %386, %351) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %388 = firrtl.subfield %379[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %389 = firrtl.mux(%204, %388, %352) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %390 = firrtl.subfield %379[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %391 = firrtl.mux(%204, %390, %353) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %392 = firrtl.subfield %379[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %393 = firrtl.mux(%204, %392, %354) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %394 = firrtl.subfield %379[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %395 = firrtl.mux(%204, %394, %355) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %396 = firrtl.subfield %379[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %397 = firrtl.mux(%204, %396, %356) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %398 = firrtl.subfield %379[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %399 = firrtl.mux(%204, %398, %357) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %400 = firrtl.subfield %379[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %401 = firrtl.mux(%204, %400, %358) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %402 = firrtl.subfield %379[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %403 = firrtl.mux(%204, %402, %359) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %404 = firrtl.subfield %379[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %405 = firrtl.mux(%204, %404, %360) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %406 = firrtl.subfield %379[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %407 = firrtl.mux(%204, %406, %361) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %408 = firrtl.subfield %379[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %409 = firrtl.mux(%204, %408, %362) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %410 = firrtl.subfield %379[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %411 = firrtl.mux(%204, %410, %363) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %412 = firrtl.mux(%204, %372, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_regReadReg_WIRE = firrtl.wire : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %regReadReg = firrtl.regreset %clock, %reset, %_regReadReg_WIRE {firrtl.random_init_start = 1613 : ui64} : !firrtl.clock, !firrtl.uint<1>, !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %413 = firrtl.subfield %regReadReg[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %414 = firrtl.subfield %413[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %415 = firrtl.subfield %414[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %416 = firrtl.subfield %415[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %417 = firrtl.subfield %415[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %418 = firrtl.subfield %415[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %419 = firrtl.subfield %414[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %420 = firrtl.subfield %419[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %421 = firrtl.subfield %419[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %422 = firrtl.subfield %419[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %423 = firrtl.subfield %419[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %424 = firrtl.subfield %419[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %425 = firrtl.subfield %419[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %426 = firrtl.subfield %419[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %427 = firrtl.subfield %419[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %428 = firrtl.subfield %419[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %429 = firrtl.subfield %419[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %430 = firrtl.subfield %419[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %431 = firrtl.subfield %419[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %432 = firrtl.subfield %419[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %433 = firrtl.subfield %419[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %434 = firrtl.subfield %419[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %435 = firrtl.subfield %419[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %436 = firrtl.subfield %regReadReg[rs1Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %437 = firrtl.subfield %regReadReg[rs2Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %438 = firrtl.subfield %regReadReg[rs2Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %439 = firrtl.subfield %regReadReg[rs1Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %440 = firrtl.subfield %regReadReg[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %441 = firrtl.subfield %440[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %442 = firrtl.subfield %441[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %443 = firrtl.subfield %442[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %444 = firrtl.subfield %442[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %445 = firrtl.subfield %442[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %446 = firrtl.subfield %442[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %447 = firrtl.subfield %442[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %448 = firrtl.subfield %442[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %449 = firrtl.subfield %442[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %450 = firrtl.subfield %442[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %451 = firrtl.subfield %442[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %452 = firrtl.subfield %442[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %453 = firrtl.subfield %441[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %454 = firrtl.subfield %453[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %455 = firrtl.subfield %453[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %456 = firrtl.subfield %453[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %457 = firrtl.subfield %453[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %458 = firrtl.subfield %dispatchReg[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %459 = firrtl.subfield %458[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %460 = firrtl.subfield %459[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %461 = firrtl.subfield %459[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %462 = firrtl.mux(%370, %461, %416) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %463 = firrtl.subfield %459[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %464 = firrtl.mux(%370, %463, %417) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %465 = firrtl.subfield %459[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %466 = firrtl.mux(%370, %465, %418) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %467 = firrtl.subfield %458[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %468 = firrtl.subfield %467[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %469 = firrtl.mux(%370, %468, %420) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %470 = firrtl.subfield %467[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %471 = firrtl.mux(%370, %470, %421) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %472 = firrtl.subfield %467[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %473 = firrtl.mux(%370, %472, %422) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %474 = firrtl.subfield %467[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %475 = firrtl.mux(%370, %474, %423) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %476 = firrtl.subfield %467[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %477 = firrtl.mux(%370, %476, %424) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %478 = firrtl.subfield %467[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %479 = firrtl.mux(%370, %478, %425) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %480 = firrtl.subfield %467[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %481 = firrtl.mux(%370, %480, %426) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %482 = firrtl.subfield %467[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %483 = firrtl.mux(%370, %482, %427) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %484 = firrtl.subfield %467[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %485 = firrtl.mux(%370, %484, %428) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %486 = firrtl.subfield %467[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %487 = firrtl.mux(%370, %486, %429) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %488 = firrtl.subfield %467[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %489 = firrtl.mux(%370, %488, %430) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %490 = firrtl.subfield %467[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %491 = firrtl.mux(%370, %490, %431) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %492 = firrtl.subfield %467[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %493 = firrtl.mux(%370, %492, %432) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %494 = firrtl.subfield %467[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %495 = firrtl.mux(%370, %494, %433) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %496 = firrtl.subfield %467[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %497 = firrtl.mux(%370, %496, %434) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %498 = firrtl.subfield %467[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %499 = firrtl.mux(%370, %498, %435) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %500 = firrtl.mux(%370, %369, %c0_ui3) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %501 = firrtl.mux(%370, %367, %c0_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %502 = firrtl.mux(%370, %366, %c0_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %503 = firrtl.mux(%370, %114, %436) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %504 = firrtl.mux(%370, %113, %437) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %505 = firrtl.mux(%370, %460, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_exec1Reg_WIRE = firrtl.wire : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %exec1Reg = firrtl.regreset %clock, %reset, %_exec1Reg_WIRE {firrtl.random_init_start = 1808 : ui64} : !firrtl.clock, !firrtl.uint<1>, !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>, !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %506 = firrtl.subfield %exec1Reg[regReadSignals] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %507 = firrtl.subfield %506[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %508 = firrtl.subfield %507[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %509 = firrtl.subfield %508[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %510 = firrtl.subfield %509[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %511 = firrtl.subfield %509[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %512 = firrtl.subfield %509[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %513 = firrtl.subfield %508[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %514 = firrtl.subfield %513[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %515 = firrtl.subfield %513[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %516 = firrtl.subfield %513[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %517 = firrtl.subfield %513[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %518 = firrtl.subfield %513[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %519 = firrtl.subfield %513[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %520 = firrtl.subfield %513[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %521 = firrtl.subfield %513[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %522 = firrtl.subfield %513[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %523 = firrtl.subfield %513[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %524 = firrtl.subfield %513[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %525 = firrtl.subfield %513[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %526 = firrtl.subfield %513[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %527 = firrtl.subfield %513[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %528 = firrtl.subfield %513[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %529 = firrtl.subfield %513[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %530 = firrtl.subfield %506[rs1Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %531 = firrtl.subfield %506[rs2Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %532 = firrtl.subfield %exec1Reg[result] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %533 = firrtl.subfield %exec1Reg[doRegFileWrite] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %534 = firrtl.subfield %exec1Reg[ctrlTaken] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %535 = firrtl.subfield %exec1Reg[ctrlTarget] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %536 = firrtl.subfield %exec1Reg[ctrlTarget] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %537 = firrtl.subfield %exec1Reg[ctrlTaken] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %538 = firrtl.subfield %exec1Reg[regReadSignals] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %539 = firrtl.subfield %538[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %540 = firrtl.subfield %539[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %541 = firrtl.subfield %540[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %542 = firrtl.subfield %541[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %543 = firrtl.subfield %541[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %544 = firrtl.subfield %regReadReg[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %545 = firrtl.subfield %544[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %546 = firrtl.subfield %545[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %547 = firrtl.subfield %546[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %548 = firrtl.subfield %546[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %549 = firrtl.mux(%457, %548, %510) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %550 = firrtl.subfield %546[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %551 = firrtl.mux(%457, %550, %511) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %552 = firrtl.subfield %546[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %553 = firrtl.mux(%457, %552, %512) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %554 = firrtl.subfield %545[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %555 = firrtl.subfield %554[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %556 = firrtl.mux(%457, %555, %514) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %557 = firrtl.subfield %554[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %558 = firrtl.mux(%457, %557, %515) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %559 = firrtl.subfield %554[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %560 = firrtl.mux(%457, %559, %516) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %561 = firrtl.subfield %554[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %562 = firrtl.mux(%457, %561, %517) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %563 = firrtl.subfield %554[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %564 = firrtl.mux(%457, %563, %518) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %565 = firrtl.subfield %554[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %566 = firrtl.mux(%457, %565, %519) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %567 = firrtl.subfield %554[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %568 = firrtl.mux(%457, %567, %520) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %569 = firrtl.subfield %554[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %570 = firrtl.mux(%457, %569, %521) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %571 = firrtl.subfield %554[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %572 = firrtl.mux(%457, %571, %522) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %573 = firrtl.subfield %554[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %574 = firrtl.mux(%457, %573, %523) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %575 = firrtl.subfield %554[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %576 = firrtl.mux(%457, %575, %524) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %577 = firrtl.subfield %554[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %578 = firrtl.mux(%457, %577, %525) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %579 = firrtl.subfield %554[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %580 = firrtl.mux(%457, %579, %526) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %581 = firrtl.subfield %554[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %582 = firrtl.mux(%457, %581, %527) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %583 = firrtl.subfield %554[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %584 = firrtl.mux(%457, %583, %528) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %585 = firrtl.subfield %554[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %586 = firrtl.mux(%457, %585, %529) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %587 = firrtl.subfield %regReadReg[rs1Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %588 = firrtl.mux(%457, %587, %530) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %589 = firrtl.subfield %regReadReg[rs2Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %590 = firrtl.mux(%457, %589, %531) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %opcode = firrtl.bits %456 6 to 0 {name = "opcode"} : (!firrtl.uint<32>) -> !firrtl.uint<7>
      %_isMExt_T_1 = firrtl.eq %opcode, %c51_ui7 {name = "_isMExt_T_1"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %_isMExt_T_2 = firrtl.bits %456 31 to 25 {name = "_isMExt_T_2"} : (!firrtl.uint<32>) -> !firrtl.uint<7>
      %_isMExt_T_3 = firrtl.eq %_isMExt_T_2, %c1_ui7 {name = "_isMExt_T_3"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %isMExt = firrtl.and %_isMExt_T_1, %_isMExt_T_3 {name = "isMExt"} : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %funct3 = firrtl.bits %456 14 to 12 {name = "funct3"} : (!firrtl.uint<32>) -> !firrtl.uint<3>
      %_isMulInstr_T = firrtl.leq %funct3, %c3_ui2 {name = "_isMulInstr_T"} : (!firrtl.uint<3>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %isMulInstr = firrtl.and %isMExt, %_isMulInstr_T {name = "isMulInstr"} : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %591 = firrtl.mux(%457, %439, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %592 = firrtl.mux(%457, %438, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %_mulUnit_io_signedB_T = firrtl.neq %funct3, %c3_ui2 {name = "_mulUnit_io_signedB_T"} : (!firrtl.uint<3>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %593 = firrtl.mux(%457, %_mulUnit_io_signedB_T, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_mulUnit_io_signedB_T_1 = firrtl.neq %funct3, %c2_ui2 {name = "_mulUnit_io_signedB_T_1"} : (!firrtl.uint<3>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %_mulUnit_io_signedB_T_2 = firrtl.and %_mulUnit_io_signedB_T, %_mulUnit_io_signedB_T_1 {name = "_mulUnit_io_signedB_T_2"} : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %594 = firrtl.mux(%457, %_mulUnit_io_signedB_T_2, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %595 = firrtl.bundlecreate %591, %592, %593, %594, %mulUnit_io_product, %mulUnit_io_lo, %mulUnit_io_hi : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<64>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      firrtl.matchingconnect %mulUnit.io, %595 : !firrtl.bundle<a: uint<32>, b: uint<32>, signedA: uint<1>, signedB: uint<1>, product: uint<64>, lo: uint<32>, hi: uint<32>>
      %596 = firrtl.not %isMulInstr : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %597 = firrtl.and %452, %596 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %598 = firrtl.or %597, %451 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %599 = firrtl.or %598, %450 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_useImm_T = firrtl.eq %opcode, %c19_ui7 {name = "_useImm_T"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %_useImm_T_1 = firrtl.or %_useImm_T, %451 {name = "_useImm_T_1"} : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %useImm = firrtl.or %_useImm_T_1, %450 {name = "useImm"} : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_opA_T = firrtl.mux(%451, %c0_ui32, %439) {name = "_opA_T"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %opA = firrtl.mux(%450, %455, %_opA_T) {name = "opA"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %opB = firrtl.mux(%useImm, %449, %438) {name = "opB"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %600 = firrtl.and %457, %599 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %601 = firrtl.mux(%600, %opA, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %602 = firrtl.and %457, %599 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %603 = firrtl.mux(%602, %opB, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %604 = firrtl.and %457, %599 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %605 = firrtl.mux(%604, %448, %c0_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %606 = firrtl.bundlecreate %601, %603, %605, %alu_io_result : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<5>, !firrtl.uint<32>) -> !firrtl.bundle<a: uint<32>, b: uint<32>, opcode: uint<5>, result: uint<32>>
      firrtl.matchingconnect %alu.io, %606 : !firrtl.bundle<a: uint<32>, b: uint<32>, opcode: uint<5>, result: uint<32>>
      %_result_T = firrtl.add %455, %449 {name = "_result_T"} : (!firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<33>
      %_result_T_1 = firrtl.bits %_result_T 31 to 0 {name = "_result_T_1"} : (!firrtl.uint<33>) -> !firrtl.uint<32>
      %_result_T_2 = firrtl.mux(%451, %449, %118) {name = "_result_T_2"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %result = firrtl.mux(%450, %_result_T_1, %_result_T_2) {name = "result"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %_exec1Reg_result_T = firrtl.add %455, %c4_ui3 {name = "_exec1Reg_result_T"} : (!firrtl.uint<32>, !firrtl.uint<3>) -> !firrtl.uint<33>
      %_exec1Reg_result_T_1 = firrtl.bits %_exec1Reg_result_T 31 to 0 {name = "_exec1Reg_result_T_1"} : (!firrtl.uint<33>) -> !firrtl.uint<32>
      %_exec1Reg_ctrlTarget_T = firrtl.asSInt %455 {name = "_exec1Reg_ctrlTarget_T"} : (!firrtl.uint<32>) -> !firrtl.sint<32>
      %_exec1Reg_ctrlTarget_T_1 = firrtl.asSInt %449 {name = "_exec1Reg_ctrlTarget_T_1"} : (!firrtl.uint<32>) -> !firrtl.sint<32>
      %_exec1Reg_ctrlTarget_T_2 = firrtl.add %_exec1Reg_ctrlTarget_T, %_exec1Reg_ctrlTarget_T_1 {name = "_exec1Reg_ctrlTarget_T_2"} : (!firrtl.sint<32>, !firrtl.sint<32>) -> !firrtl.sint<33>
      %_exec1Reg_ctrlTarget_T_5 = firrtl.bits %_exec1Reg_ctrlTarget_T_2 31 to 0 {name = "_exec1Reg_ctrlTarget_T_5"} : (!firrtl.sint<33>) -> !firrtl.uint<32>
      %_target_T = firrtl.asSInt %439 {name = "_target_T"} : (!firrtl.uint<32>) -> !firrtl.sint<32>
      %_target_T_1 = firrtl.asSInt %449 {name = "_target_T_1"} : (!firrtl.uint<32>) -> !firrtl.sint<32>
      %_target_T_2 = firrtl.add %_target_T, %_target_T_1 {name = "_target_T_2"} : (!firrtl.sint<32>, !firrtl.sint<32>) -> !firrtl.sint<33>
      %_target_T_5 = firrtl.bits %_target_T_2 31 to 0 {name = "_target_T_5"} : (!firrtl.sint<33>) -> !firrtl.uint<32>
      %target = firrtl.and %_target_T_5, %c4294967294_ui32 {name = "target"} : (!firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %_exec1Reg_result_T_2 = firrtl.add %455, %c4_ui3 {name = "_exec1Reg_result_T_2"} : (!firrtl.uint<32>, !firrtl.uint<3>) -> !firrtl.uint<33>
      %_exec1Reg_result_T_3 = firrtl.bits %_exec1Reg_result_T_2 31 to 0 {name = "_exec1Reg_result_T_3"} : (!firrtl.uint<33>) -> !firrtl.uint<32>
      %607 = firrtl.mux(%445, %439, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %608 = firrtl.or %447, %446 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %609 = firrtl.or %isMulInstr, %608 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %610 = firrtl.or %599, %609 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %611 = firrtl.mux(%610, %c0_ui32, %607) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %612 = firrtl.mux(%457, %611, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %613 = firrtl.mux(%445, %438, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %614 = firrtl.or %447, %446 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %615 = firrtl.or %isMulInstr, %614 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %616 = firrtl.or %599, %615 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %617 = firrtl.mux(%616, %c0_ui32, %613) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %618 = firrtl.mux(%457, %617, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %619 = firrtl.mux(%445, %455, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %620 = firrtl.or %447, %446 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %621 = firrtl.or %isMulInstr, %620 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %622 = firrtl.or %599, %621 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %623 = firrtl.mux(%622, %c0_ui32, %619) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %624 = firrtl.mux(%457, %623, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %_branchUnit_io_imm_T = firrtl.shl %449, 1 {name = "_branchUnit_io_imm_T"} : (!firrtl.uint<32>) -> !firrtl.uint<33>
      %_branchUnit_io_imm_T_1 = firrtl.asSInt %_branchUnit_io_imm_T {name = "_branchUnit_io_imm_T_1"} : (!firrtl.uint<33>) -> !firrtl.sint<33>
      %625 = firrtl.bits %_branchUnit_io_imm_T_1 31 to 0 : (!firrtl.sint<33>) -> !firrtl.uint<32>
      %626 = firrtl.asSInt %625 : (!firrtl.uint<32>) -> !firrtl.sint<32>
      %627 = firrtl.mux(%445, %626, %c0_si32) : (!firrtl.uint<1>, !firrtl.sint<32>, !firrtl.sint<32>) -> !firrtl.sint<32>
      %628 = firrtl.or %447, %446 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %629 = firrtl.or %isMulInstr, %628 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %630 = firrtl.or %599, %629 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %631 = firrtl.mux(%630, %c0_si32, %627) : (!firrtl.uint<1>, !firrtl.sint<32>, !firrtl.sint<32>) -> !firrtl.sint<32>
      %632 = firrtl.mux(%457, %631, %c0_si32) : (!firrtl.uint<1>, !firrtl.sint<32>, !firrtl.sint<32>) -> !firrtl.sint<32>
      %633 = firrtl.mux(%445, %funct3, %c0_ui3) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %634 = firrtl.or %447, %446 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %635 = firrtl.or %isMulInstr, %634 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %636 = firrtl.or %599, %635 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %637 = firrtl.mux(%636, %c0_ui3, %633) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %638 = firrtl.mux(%457, %637, %c0_ui3) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %639 = firrtl.or %447, %446 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %640 = firrtl.or %isMulInstr, %639 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %641 = firrtl.or %599, %640 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %642 = firrtl.mux(%641, %c0_ui1, %445) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %643 = firrtl.mux(%457, %642, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %644 = firrtl.bundlecreate %612, %618, %624, %632, %638, %643, %branchUnit_io_taken, %branchUnit_io_target, %branchUnit_io_nextPc, %branchUnit_io_misaligned : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.sint<32>, !firrtl.uint<3>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<1>) -> !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      firrtl.matchingconnect %branchUnit.io, %644 : !firrtl.bundle<rs1: uint<32>, rs2: uint<32>, pc: uint<32>, imm: sint<32>, branchOp: uint<3>, valid: uint<1>, taken: uint<1>, target: uint<32>, nextPc: uint<32>, misaligned: uint<1>>
      %645 = firrtl.mux(%445, %130, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %646 = firrtl.or %447, %446 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %647 = firrtl.mux(%646, %c1_ui1, %645) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %648 = firrtl.or %599, %isMulInstr : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %649 = firrtl.mux(%648, %c0_ui1, %647) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %650 = firrtl.mux(%457, %649, %534) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %651 = firrtl.mux(%445, %131, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %652 = firrtl.mux(%446, %target, %651) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %653 = firrtl.mux(%447, %_exec1Reg_ctrlTarget_T_5, %652) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %654 = firrtl.or %599, %isMulInstr : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %655 = firrtl.mux(%654, %c0_ui32, %653) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %656 = firrtl.mux(%457, %655, %535) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %_address_T = firrtl.add %439, %449 {name = "_address_T"} : (!firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<33>
      %address = firrtl.bits %_address_T 31 to 0 {name = "address"} : (!firrtl.uint<33>) -> !firrtl.uint<32>
      %_io_memAddr_T = firrtl.bits %_address_T 31 to 2 {name = "_io_memAddr_T"} : (!firrtl.uint<33>) -> !firrtl.uint<30>
      %_io_memAddr_T_1 = firrtl.cat %_io_memAddr_T, %c0_ui2 {name = "_io_memAddr_T_1"} : (!firrtl.uint<30>, !firrtl.uint<2>) -> !firrtl.uint<32>
      %657 = firrtl.subaccess %io_threadEnable_0[%454] : !firrtl.vector<uint<1>, 8>, !firrtl.uint<3>
      %658 = firrtl.mux(%444, %address, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %659 = firrtl.or %446, %445 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %660 = firrtl.or %447, %659 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %661 = firrtl.or %isMulInstr, %660 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %662 = firrtl.or %599, %661 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %663 = firrtl.mux(%662, %c0_ui32, %658) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %664 = firrtl.mux(%457, %663, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %665 = firrtl.mux(%444, %funct3, %c0_ui3) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %666 = firrtl.or %446, %445 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %667 = firrtl.or %447, %666 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %668 = firrtl.or %isMulInstr, %667 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %669 = firrtl.or %599, %668 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %670 = firrtl.mux(%669, %c0_ui3, %665) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %671 = firrtl.mux(%457, %670, %c0_ui3) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %672 = firrtl.bundlecreate %664, %io_dataMemResp, %671, %loadUnit_io_dataOut : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<3>, !firrtl.uint<32>) -> !firrtl.bundle<addr: uint<32>, dataIn: uint<32>, funct3: uint<3>, dataOut: uint<32>>
      firrtl.matchingconnect %loadUnit.io, %672 : !firrtl.bundle<addr: uint<32>, dataIn: uint<32>, funct3: uint<3>, dataOut: uint<32>>
      %673 = firrtl.mux(%444, %137, %532) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %674 = firrtl.mux(%445, %532, %673) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %675 = firrtl.mux(%446, %_exec1Reg_result_T_3, %674) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %676 = firrtl.mux(%447, %_exec1Reg_result_T_1, %675) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %677 = firrtl.mux(%isMulInstr, %c0_ui32, %676) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %678 = firrtl.mux(%599, %result, %677) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %679 = firrtl.mux(%457, %678, %532) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %680 = firrtl.mux(%445, %c0_ui1, %444) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %681 = firrtl.or %447, %446 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %682 = firrtl.or %isMulInstr, %681 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %683 = firrtl.or %599, %682 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %684 = firrtl.mux(%683, %c1_ui1, %680) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %685 = firrtl.mux(%457, %684, %533) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_address_T_1 = firrtl.add %439, %449 {name = "_address_T_1"} : (!firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<33>
      %address_1 = firrtl.bits %_address_T_1 31 to 0 {name = "address_1"} : (!firrtl.uint<33>) -> !firrtl.uint<32>
      %_storeActive_T = firrtl.not %143 {name = "_storeActive_T"} : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %686 = firrtl.subaccess %io_threadEnable_0[%454] : !firrtl.vector<uint<1>, 8>, !firrtl.uint<3>
      %storeActive = firrtl.and %686, %_storeActive_T {name = "storeActive"} : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_memAddr_T_2 = firrtl.bits %_address_T_1 31 to 2 {name = "_io_memAddr_T_2"} : (!firrtl.uint<33>) -> !firrtl.uint<30>
      %_io_memAddr_T_3 = firrtl.cat %_io_memAddr_T_2, %c0_ui2 {name = "_io_memAddr_T_3"} : (!firrtl.uint<30>, !firrtl.uint<2>) -> !firrtl.uint<32>
      %687 = firrtl.mux(%443, %_io_memAddr_T_3, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %688 = firrtl.mux(%444, %_io_memAddr_T_1, %687) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %689 = firrtl.or %446, %445 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %690 = firrtl.or %447, %689 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %691 = firrtl.or %isMulInstr, %690 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %692 = firrtl.or %599, %691 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %693 = firrtl.mux(%692, %c0_ui32, %688) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %694 = firrtl.mux(%457, %693, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      firrtl.matchingconnect %io_memAddr_1, %694 : !firrtl.uint<32>
      %695 = firrtl.mux(%443, %address_1, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %696 = firrtl.or %445, %444 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %697 = firrtl.or %446, %696 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %698 = firrtl.or %447, %697 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %699 = firrtl.or %isMulInstr, %698 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %700 = firrtl.or %599, %699 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %701 = firrtl.mux(%700, %c0_ui32, %695) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %702 = firrtl.mux(%457, %701, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %703 = firrtl.mux(%443, %438, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %704 = firrtl.or %445, %444 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %705 = firrtl.or %446, %704 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %706 = firrtl.or %447, %705 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %707 = firrtl.or %isMulInstr, %706 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %708 = firrtl.or %599, %707 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %709 = firrtl.mux(%708, %c0_ui32, %703) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %710 = firrtl.mux(%457, %709, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %_storeUnit_io_storeType_T = firrtl.bits %456 13 to 12 {name = "_storeUnit_io_storeType_T"} : (!firrtl.uint<32>) -> !firrtl.uint<2>
      %711 = firrtl.mux(%443, %_storeUnit_io_storeType_T, %c0_ui2) : (!firrtl.uint<1>, !firrtl.uint<2>, !firrtl.uint<2>) -> !firrtl.uint<2>
      %712 = firrtl.or %445, %444 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %713 = firrtl.or %446, %712 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %714 = firrtl.or %447, %713 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %715 = firrtl.or %isMulInstr, %714 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %716 = firrtl.or %599, %715 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %717 = firrtl.mux(%716, %c0_ui2, %711) : (!firrtl.uint<1>, !firrtl.uint<2>, !firrtl.uint<2>) -> !firrtl.uint<2>
      %718 = firrtl.mux(%457, %717, %c0_ui2) : (!firrtl.uint<1>, !firrtl.uint<2>, !firrtl.uint<2>) -> !firrtl.uint<2>
      %719 = firrtl.bundlecreate %702, %710, %718, %storeUnit_io_memWrite, %storeUnit_io_mask, %storeUnit_io_misaligned : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<2>, !firrtl.uint<32>, !firrtl.uint<4>, !firrtl.uint<1>) -> !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      firrtl.matchingconnect %storeUnit.io, %719 : !firrtl.bundle<addr: uint<32>, data: uint<32>, storeType: uint<2>, memWrite: uint<32>, mask: uint<4>, misaligned: uint<1>>
      %720 = firrtl.and %443, %storeActive : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %721 = firrtl.mux(%720, %141, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %722 = firrtl.or %445, %444 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %723 = firrtl.or %446, %722 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %724 = firrtl.or %447, %723 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %725 = firrtl.or %isMulInstr, %724 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %726 = firrtl.or %599, %725 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %727 = firrtl.mux(%726, %c0_ui32, %721) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %728 = firrtl.mux(%457, %727, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      firrtl.matchingconnect %io_memWrite_2, %728 : !firrtl.uint<32>
      %729 = firrtl.and %443, %storeActive : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %730 = firrtl.mux(%729, %142, %c0_ui4) : (!firrtl.uint<1>, !firrtl.uint<4>, !firrtl.uint<4>) -> !firrtl.uint<4>
      %731 = firrtl.or %445, %444 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %732 = firrtl.or %446, %731 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %733 = firrtl.or %447, %732 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %734 = firrtl.or %isMulInstr, %733 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %735 = firrtl.or %599, %734 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %736 = firrtl.mux(%735, %c0_ui4, %730) : (!firrtl.uint<1>, !firrtl.uint<4>, !firrtl.uint<4>) -> !firrtl.uint<4>
      %737 = firrtl.mux(%457, %736, %c0_ui4) : (!firrtl.uint<1>, !firrtl.uint<4>, !firrtl.uint<4>) -> !firrtl.uint<4>
      firrtl.matchingconnect %io_memMask_3, %737 : !firrtl.uint<4>
      %738 = firrtl.mux(%443, %storeActive, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %739 = firrtl.mux(%444, %657, %738) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %740 = firrtl.or %446, %445 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %741 = firrtl.or %447, %740 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %742 = firrtl.or %isMulInstr, %741 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %743 = firrtl.or %599, %742 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %744 = firrtl.mux(%743, %c0_ui1, %739) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %745 = firrtl.mux(%457, %744, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      firrtl.matchingconnect %io_memValid_4, %745 : !firrtl.uint<1>
      %_io_memMisaligned_T = firrtl.and %686, %143 {name = "_io_memMisaligned_T"} : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %746 = firrtl.mux(%443, %_io_memMisaligned_T, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %747 = firrtl.or %445, %444 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %748 = firrtl.or %446, %747 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %749 = firrtl.or %447, %748 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %750 = firrtl.or %isMulInstr, %749 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %751 = firrtl.or %599, %750 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %752 = firrtl.mux(%751, %c0_ui1, %746) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %753 = firrtl.mux(%457, %752, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      firrtl.matchingconnect %io_memMisaligned_5, %753 : !firrtl.uint<1>
      %754 = firrtl.mux(%457, %547, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_exec2Reg_WIRE = firrtl.wire : !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %exec2Reg = firrtl.regreset %clock, %reset, %_exec2Reg_WIRE {firrtl.random_init_start = 2069 : ui64} : !firrtl.clock, !firrtl.uint<1>, !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>, !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %755 = firrtl.subfield %exec2Reg[exec1Signals] : !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %756 = firrtl.subfield %755[regReadSignals] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %757 = firrtl.subfield %756[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %758 = firrtl.subfield %757[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %759 = firrtl.subfield %758[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %760 = firrtl.subfield %759[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %761 = firrtl.subfield %759[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %762 = firrtl.subfield %759[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %763 = firrtl.subfield %758[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %764 = firrtl.subfield %763[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %765 = firrtl.subfield %763[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %766 = firrtl.subfield %763[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %767 = firrtl.subfield %763[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %768 = firrtl.subfield %763[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %769 = firrtl.subfield %763[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %770 = firrtl.subfield %763[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %771 = firrtl.subfield %763[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %772 = firrtl.subfield %763[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %773 = firrtl.subfield %763[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %774 = firrtl.subfield %763[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %775 = firrtl.subfield %763[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %776 = firrtl.subfield %763[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %777 = firrtl.subfield %763[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %778 = firrtl.subfield %763[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %779 = firrtl.subfield %763[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %780 = firrtl.subfield %756[rs1Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %781 = firrtl.subfield %756[rs2Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %782 = firrtl.subfield %755[result] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %783 = firrtl.subfield %755[doRegFileWrite] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %784 = firrtl.subfield %755[ctrlTaken] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %785 = firrtl.subfield %755[ctrlTarget] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %786 = firrtl.subfield %exec2Reg[exec1Signals] : !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %787 = firrtl.subfield %786[regReadSignals] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %788 = firrtl.subfield %787[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %789 = firrtl.subfield %788[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %790 = firrtl.subfield %789[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %791 = firrtl.subfield %790[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %792 = firrtl.subfield %790[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %793 = firrtl.subfield %exec1Reg[regReadSignals] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %794 = firrtl.subfield %793[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %795 = firrtl.subfield %794[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %796 = firrtl.subfield %795[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %797 = firrtl.subfield %796[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %798 = firrtl.subfield %796[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %799 = firrtl.mux(%543, %798, %760) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %800 = firrtl.subfield %796[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %801 = firrtl.mux(%543, %800, %761) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %802 = firrtl.subfield %796[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %803 = firrtl.mux(%543, %802, %762) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %804 = firrtl.subfield %795[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %805 = firrtl.subfield %804[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %806 = firrtl.mux(%543, %805, %764) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %807 = firrtl.subfield %804[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %808 = firrtl.mux(%543, %807, %765) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %809 = firrtl.subfield %804[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %810 = firrtl.mux(%543, %809, %766) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %811 = firrtl.subfield %804[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %812 = firrtl.mux(%543, %811, %767) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %813 = firrtl.subfield %804[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %814 = firrtl.mux(%543, %813, %768) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %815 = firrtl.subfield %804[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %816 = firrtl.mux(%543, %815, %769) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %817 = firrtl.subfield %804[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %818 = firrtl.mux(%543, %817, %770) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %819 = firrtl.subfield %804[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %820 = firrtl.mux(%543, %819, %771) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %821 = firrtl.subfield %804[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %822 = firrtl.mux(%543, %821, %772) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %823 = firrtl.subfield %804[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %824 = firrtl.mux(%543, %823, %773) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %825 = firrtl.subfield %804[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %826 = firrtl.mux(%543, %825, %774) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %827 = firrtl.subfield %804[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %828 = firrtl.mux(%543, %827, %775) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %829 = firrtl.subfield %804[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %830 = firrtl.mux(%543, %829, %776) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %831 = firrtl.subfield %804[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %832 = firrtl.mux(%543, %831, %777) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %833 = firrtl.subfield %804[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %834 = firrtl.mux(%543, %833, %778) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %835 = firrtl.subfield %804[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %836 = firrtl.mux(%543, %835, %779) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %837 = firrtl.subfield %793[rs1Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %838 = firrtl.mux(%543, %837, %780) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %839 = firrtl.subfield %793[rs2Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %840 = firrtl.mux(%543, %839, %781) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %841 = firrtl.subfield %exec1Reg[result] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %842 = firrtl.mux(%543, %841, %782) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %843 = firrtl.subfield %exec1Reg[doRegFileWrite] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %844 = firrtl.mux(%543, %843, %783) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %845 = firrtl.subfield %exec1Reg[ctrlTaken] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %846 = firrtl.mux(%543, %845, %784) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %847 = firrtl.subfield %exec1Reg[ctrlTarget] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %848 = firrtl.mux(%543, %847, %785) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %849 = firrtl.mux(%543, %797, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_exec3Reg_WIRE = firrtl.wire : !firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>
      %exec3Reg = firrtl.regreset %clock, %reset, %_exec3Reg_WIRE {firrtl.random_init_start = 2330 : ui64} : !firrtl.clock, !firrtl.uint<1>, !firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>, !firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>
      %850 = firrtl.subfield %exec3Reg[exec2Signals] : !firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>
      %851 = firrtl.subfield %850[exec1Signals] : !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %852 = firrtl.subfield %851[regReadSignals] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %853 = firrtl.subfield %852[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %854 = firrtl.subfield %853[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %855 = firrtl.subfield %854[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %856 = firrtl.subfield %855[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %857 = firrtl.subfield %855[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %858 = firrtl.subfield %855[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %859 = firrtl.subfield %854[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %860 = firrtl.subfield %859[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %861 = firrtl.subfield %859[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %862 = firrtl.subfield %859[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %863 = firrtl.subfield %859[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %864 = firrtl.subfield %859[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %865 = firrtl.subfield %859[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %866 = firrtl.subfield %859[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %867 = firrtl.subfield %859[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %868 = firrtl.subfield %859[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %869 = firrtl.subfield %859[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %870 = firrtl.subfield %859[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %871 = firrtl.subfield %859[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %872 = firrtl.subfield %859[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %873 = firrtl.subfield %859[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %874 = firrtl.subfield %859[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %875 = firrtl.subfield %859[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %876 = firrtl.subfield %852[rs1Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %877 = firrtl.subfield %852[rs2Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %878 = firrtl.subfield %851[result] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %879 = firrtl.subfield %851[doRegFileWrite] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %880 = firrtl.subfield %851[ctrlTaken] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %881 = firrtl.subfield %851[ctrlTarget] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %882 = firrtl.subfield %exec3Reg[exec2Signals] : !firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>
      %883 = firrtl.subfield %882[exec1Signals] : !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %884 = firrtl.subfield %883[regReadSignals] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %885 = firrtl.subfield %884[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %886 = firrtl.subfield %885[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %887 = firrtl.subfield %886[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %888 = firrtl.subfield %887[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %889 = firrtl.subfield %887[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %890 = firrtl.subfield %exec2Reg[exec1Signals] : !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %891 = firrtl.subfield %890[regReadSignals] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %892 = firrtl.subfield %891[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %893 = firrtl.subfield %892[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %894 = firrtl.subfield %893[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %895 = firrtl.subfield %894[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %896 = firrtl.subfield %894[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %897 = firrtl.mux(%792, %896, %856) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %898 = firrtl.subfield %894[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %899 = firrtl.mux(%792, %898, %857) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %900 = firrtl.subfield %894[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %901 = firrtl.mux(%792, %900, %858) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %902 = firrtl.subfield %893[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %903 = firrtl.subfield %902[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %904 = firrtl.mux(%792, %903, %860) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %905 = firrtl.subfield %902[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %906 = firrtl.mux(%792, %905, %861) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %907 = firrtl.subfield %902[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %908 = firrtl.mux(%792, %907, %862) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %909 = firrtl.subfield %902[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %910 = firrtl.mux(%792, %909, %863) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %911 = firrtl.subfield %902[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %912 = firrtl.mux(%792, %911, %864) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %913 = firrtl.subfield %902[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %914 = firrtl.mux(%792, %913, %865) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %915 = firrtl.subfield %902[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %916 = firrtl.mux(%792, %915, %866) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %917 = firrtl.subfield %902[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %918 = firrtl.mux(%792, %917, %867) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %919 = firrtl.subfield %902[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %920 = firrtl.mux(%792, %919, %868) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %921 = firrtl.subfield %902[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %922 = firrtl.mux(%792, %921, %869) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %923 = firrtl.subfield %902[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %924 = firrtl.mux(%792, %923, %870) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %925 = firrtl.subfield %902[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %926 = firrtl.mux(%792, %925, %871) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %927 = firrtl.subfield %902[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %928 = firrtl.mux(%792, %927, %872) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %929 = firrtl.subfield %902[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %930 = firrtl.mux(%792, %929, %873) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %931 = firrtl.subfield %902[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %932 = firrtl.mux(%792, %931, %874) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %933 = firrtl.subfield %902[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %934 = firrtl.mux(%792, %933, %875) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %935 = firrtl.subfield %891[rs1Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %936 = firrtl.mux(%792, %935, %876) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %937 = firrtl.subfield %891[rs2Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %938 = firrtl.mux(%792, %937, %877) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %939 = firrtl.subfield %890[result] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %940 = firrtl.mux(%792, %939, %878) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %941 = firrtl.subfield %890[doRegFileWrite] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %942 = firrtl.mux(%792, %941, %879) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %943 = firrtl.subfield %890[ctrlTaken] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %944 = firrtl.mux(%792, %943, %880) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %945 = firrtl.subfield %890[ctrlTarget] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %946 = firrtl.mux(%792, %945, %881) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %947 = firrtl.mux(%792, %895, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_wbReg_WIRE = firrtl.wire : !firrtl.bundle<exec3Signals: bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>>
      %wbReg = firrtl.regreset %clock, %reset, %_wbReg_WIRE {firrtl.random_init_start = 2591 : ui64} : !firrtl.clock, !firrtl.uint<1>, !firrtl.bundle<exec3Signals: bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>>, !firrtl.bundle<exec3Signals: bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>>
      %948 = firrtl.subfield %wbReg[exec3Signals] : !firrtl.bundle<exec3Signals: bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>>
      %949 = firrtl.subfield %948[exec2Signals] : !firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>
      %950 = firrtl.subfield %949[exec1Signals] : !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %951 = firrtl.subfield %950[regReadSignals] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %952 = firrtl.subfield %951[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %953 = firrtl.subfield %952[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %954 = firrtl.subfield %953[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %955 = firrtl.subfield %954[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %956 = firrtl.subfield %954[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %957 = firrtl.subfield %954[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %958 = firrtl.subfield %953[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %959 = firrtl.subfield %958[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %960 = firrtl.subfield %958[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %961 = firrtl.subfield %958[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %962 = firrtl.subfield %958[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %963 = firrtl.subfield %958[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %964 = firrtl.subfield %958[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %965 = firrtl.subfield %958[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %966 = firrtl.subfield %958[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %967 = firrtl.subfield %958[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %968 = firrtl.subfield %958[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %969 = firrtl.subfield %958[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %970 = firrtl.subfield %958[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %971 = firrtl.subfield %958[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %972 = firrtl.subfield %958[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %973 = firrtl.subfield %958[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %974 = firrtl.subfield %958[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %975 = firrtl.subfield %951[rs1Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %976 = firrtl.subfield %951[rs2Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %977 = firrtl.subfield %950[result] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %978 = firrtl.subfield %950[doRegFileWrite] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %979 = firrtl.subfield %950[ctrlTaken] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %980 = firrtl.subfield %950[ctrlTarget] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %981 = firrtl.subfield %wbReg[exec3Signals] : !firrtl.bundle<exec3Signals: bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>>
      %982 = firrtl.subfield %981[exec2Signals] : !firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>
      %983 = firrtl.subfield %982[exec1Signals] : !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %984 = firrtl.subfield %983[ctrlTarget] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %985 = firrtl.subfield %983[ctrlTaken] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %986 = firrtl.subfield %983[doRegFileWrite] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %987 = firrtl.subfield %983[result] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %988 = firrtl.subfield %983[regReadSignals] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %989 = firrtl.subfield %988[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %990 = firrtl.subfield %989[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %991 = firrtl.subfield %990[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %992 = firrtl.subfield %991[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %993 = firrtl.subfield %991[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %994 = firrtl.subfield %991[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %995 = firrtl.subfield %991[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %996 = firrtl.subfield %990[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %997 = firrtl.subfield %996[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %998 = firrtl.subfield %996[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %999 = firrtl.subfield %996[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %1000 = firrtl.subfield %996[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %1001 = firrtl.subfield %exec3Reg[exec2Signals] : !firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>
      %1002 = firrtl.subfield %1001[exec1Signals] : !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %1003 = firrtl.subfield %1002[regReadSignals] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %1004 = firrtl.subfield %1003[dispatchSignals] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %1005 = firrtl.subfield %1004[decodePipelineSignals] : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %1006 = firrtl.subfield %1005[fetchSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %1007 = firrtl.subfield %1006[valid] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %1008 = firrtl.subfield %1006[threadId] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %1009 = firrtl.mux(%889, %1008, %955) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %1010 = firrtl.subfield %1006[pc] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %1011 = firrtl.mux(%889, %1010, %956) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1012 = firrtl.subfield %1006[instr] : !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %1013 = firrtl.mux(%889, %1012, %957) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1014 = firrtl.subfield %1005[decodeSignals] : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %1015 = firrtl.subfield %1014[isALU] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1016 = firrtl.mux(%889, %1015, %959) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1017 = firrtl.subfield %1014[isLoad] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1018 = firrtl.mux(%889, %1017, %960) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1019 = firrtl.subfield %1014[isStore] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1020 = firrtl.mux(%889, %1019, %961) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1021 = firrtl.subfield %1014[isBranch] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1022 = firrtl.mux(%889, %1021, %962) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1023 = firrtl.subfield %1014[isJAL] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1024 = firrtl.mux(%889, %1023, %963) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1025 = firrtl.subfield %1014[isJALR] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1026 = firrtl.mux(%889, %1025, %964) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1027 = firrtl.subfield %1014[isLUI] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1028 = firrtl.mux(%889, %1027, %965) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1029 = firrtl.subfield %1014[isAUIPC] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1030 = firrtl.mux(%889, %1029, %966) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1031 = firrtl.subfield %1014[isSystem] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1032 = firrtl.mux(%889, %1031, %967) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1033 = firrtl.subfield %1014[isFence] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1034 = firrtl.mux(%889, %1033, %968) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1035 = firrtl.subfield %1014[usesImm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1036 = firrtl.mux(%889, %1035, %969) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1037 = firrtl.subfield %1014[rs1] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1038 = firrtl.mux(%889, %1037, %970) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %1039 = firrtl.subfield %1014[rs2] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1040 = firrtl.mux(%889, %1039, %971) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %1041 = firrtl.subfield %1014[rd] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1042 = firrtl.mux(%889, %1041, %972) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %1043 = firrtl.subfield %1014[aluOp] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1044 = firrtl.mux(%889, %1043, %973) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %1045 = firrtl.subfield %1014[imm] : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1046 = firrtl.mux(%889, %1045, %974) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1047 = firrtl.subfield %1003[rs1Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %1048 = firrtl.mux(%889, %1047, %975) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1049 = firrtl.subfield %1003[rs2Data] : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %1050 = firrtl.mux(%889, %1049, %976) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1051 = firrtl.subfield %1002[result] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %1052 = firrtl.mux(%889, %1051, %977) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1053 = firrtl.subfield %1002[doRegFileWrite] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %1054 = firrtl.mux(%889, %1053, %978) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1055 = firrtl.subfield %1002[ctrlTaken] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %1056 = firrtl.mux(%889, %1055, %979) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1057 = firrtl.subfield %1002[ctrlTarget] : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %1058 = firrtl.mux(%889, %1057, %980) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1059 = firrtl.mux(%889, %1007, %c0_ui1) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_wbIsMExt_T = firrtl.bits %999 6 to 0 {name = "_wbIsMExt_T"} : (!firrtl.uint<32>) -> !firrtl.uint<7>
      %_wbIsMExt_T_1 = firrtl.eq %_wbIsMExt_T, %c51_ui7 {name = "_wbIsMExt_T_1"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %_wbIsMExt_T_2 = firrtl.bits %999 31 to 25 {name = "_wbIsMExt_T_2"} : (!firrtl.uint<32>) -> !firrtl.uint<7>
      %_wbIsMExt_T_3 = firrtl.eq %_wbIsMExt_T_2, %c1_ui7 {name = "_wbIsMExt_T_3"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %wbIsMExt = firrtl.and %_wbIsMExt_T_1, %_wbIsMExt_T_3 {name = "wbIsMExt"} : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %wbFunct3 = firrtl.bits %999 14 to 12 {name = "wbFunct3"} : (!firrtl.uint<32>) -> !firrtl.uint<3>
      %_wbIsMulInstr_T = firrtl.leq %wbFunct3, %c3_ui2 {name = "_wbIsMulInstr_T"} : (!firrtl.uint<3>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %wbIsMulInstr = firrtl.and %wbIsMExt, %_wbIsMulInstr_T {name = "wbIsMulInstr"} : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_mulResult_WB_T_2 = firrtl.eq %wbFunct3, %c1_ui1 {name = "_mulResult_WB_T_2"} : (!firrtl.uint<3>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_mulResult_WB_T_4 = firrtl.eq %wbFunct3, %c2_ui2 {name = "_mulResult_WB_T_4"} : (!firrtl.uint<3>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %1060 = firrtl.or %_mulResult_WB_T_4, %_mulResult_WB_T_2 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_mulResult_WB_T_6 = firrtl.eq %wbFunct3, %c3_ui2 {name = "_mulResult_WB_T_6"} : (!firrtl.uint<3>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %1061 = firrtl.or %_mulResult_WB_T_6, %1060 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %mulResult_WB = firrtl.mux(%1061, %123, %_mulResult_WB_T_1) {name = "mulResult_WB"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %finalWBResult = firrtl.mux(%wbIsMulInstr, %mulResult_WB, %987) {name = "finalWBResult"} : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1062 = firrtl.and %1000, %986 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1063 = firrtl.orr %995 : (!firrtl.uint<5>) -> !firrtl.uint<1>
      %1064 = firrtl.and %1062, %1063 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1065 = firrtl.mux(%1064, %998, %c0_ui3) : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<3>
      %1066 = firrtl.mux(%1064, %995, %c0_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %1067 = firrtl.mux(%1064, %finalWBResult, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %ex1Redirect = firrtl.and %543, %537 {name = "ex1Redirect"} : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1068 = firrtl.orr %542 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %1069 = firrtl.not %1068 : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %1070 = firrtl.and %ex1Redirect, %1069 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1071 = firrtl.mux(%1070, %536, %158) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1072 = firrtl.eq %542, %c1_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1073 = firrtl.and %ex1Redirect, %1072 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1074 = firrtl.mux(%1073, %536, %161) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1075 = firrtl.eq %542, %c2_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1076 = firrtl.and %ex1Redirect, %1075 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1077 = firrtl.mux(%1076, %536, %164) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1078 = firrtl.eq %542, %c3_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1079 = firrtl.and %ex1Redirect, %1078 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1080 = firrtl.mux(%1079, %536, %167) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1081 = firrtl.eq %542, %c4_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1082 = firrtl.and %ex1Redirect, %1081 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1083 = firrtl.mux(%1082, %536, %170) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1084 = firrtl.eq %542, %c5_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1085 = firrtl.and %ex1Redirect, %1084 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1086 = firrtl.mux(%1085, %536, %173) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1087 = firrtl.eq %542, %c6_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1088 = firrtl.and %ex1Redirect, %1087 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1089 = firrtl.mux(%1088, %536, %176) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1090 = firrtl.andr %542 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %1091 = firrtl.and %ex1Redirect, %1090 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1092 = firrtl.mux(%1091, %536, %179) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1093 = firrtl.vectorcreate %1071, %1074, %1077, %1080, %1083, %1086, %1089, %1092 : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.vector<uint<32>, 8>
      firrtl.matchingconnect %pcRegs, %1093 : !firrtl.vector<uint<32>, 8>
      %1094 = firrtl.and %1062, %1063 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1095 = firrtl.eq %995, %c1_ui1 : (!firrtl.uint<5>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1096 = firrtl.orr %998 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %1097 = firrtl.not %1096 : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %1098 = firrtl.and %1095, %1097 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1099 = firrtl.and %1094, %1098 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1100 = firrtl.mux(%1099, %finalWBResult, %27) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1101 = firrtl.eq %998, %c1_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1102 = firrtl.and %1095, %1101 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1103 = firrtl.and %1094, %1102 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1104 = firrtl.mux(%1103, %finalWBResult, %32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1105 = firrtl.eq %998, %c2_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1106 = firrtl.and %1095, %1105 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1107 = firrtl.and %1094, %1106 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1108 = firrtl.mux(%1107, %finalWBResult, %37) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1109 = firrtl.eq %998, %c3_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1110 = firrtl.and %1095, %1109 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1111 = firrtl.and %1094, %1110 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1112 = firrtl.mux(%1111, %finalWBResult, %42) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1113 = firrtl.eq %998, %c4_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1114 = firrtl.and %1095, %1113 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1115 = firrtl.and %1094, %1114 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1116 = firrtl.mux(%1115, %finalWBResult, %47) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1117 = firrtl.eq %998, %c5_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1118 = firrtl.and %1095, %1117 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1119 = firrtl.and %1094, %1118 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1120 = firrtl.mux(%1119, %finalWBResult, %52) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1121 = firrtl.eq %998, %c6_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1122 = firrtl.and %1095, %1121 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1123 = firrtl.and %1094, %1122 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1124 = firrtl.mux(%1123, %finalWBResult, %57) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1125 = firrtl.andr %998 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %1126 = firrtl.and %1095, %1125 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1127 = firrtl.and %1094, %1126 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1128 = firrtl.mux(%1127, %finalWBResult, %62) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1129 = firrtl.eq %995, %c2_ui2 : (!firrtl.uint<5>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %1130 = firrtl.orr %998 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %1131 = firrtl.not %1130 : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %1132 = firrtl.and %1129, %1131 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1133 = firrtl.mux(%1132, %finalWBResult, %28) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1134 = firrtl.mux(%1095, %28, %1133) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1135 = firrtl.mux(%1094, %1134, %28) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1136 = firrtl.eq %998, %c1_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1137 = firrtl.and %1129, %1136 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1138 = firrtl.mux(%1137, %finalWBResult, %33) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1139 = firrtl.mux(%1095, %33, %1138) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1140 = firrtl.mux(%1094, %1139, %33) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1141 = firrtl.eq %998, %c2_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1142 = firrtl.and %1129, %1141 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1143 = firrtl.mux(%1142, %finalWBResult, %38) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1144 = firrtl.mux(%1095, %38, %1143) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1145 = firrtl.mux(%1094, %1144, %38) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1146 = firrtl.eq %998, %c3_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1147 = firrtl.and %1129, %1146 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1148 = firrtl.mux(%1147, %finalWBResult, %43) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1149 = firrtl.mux(%1095, %43, %1148) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1150 = firrtl.mux(%1094, %1149, %43) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1151 = firrtl.eq %998, %c4_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1152 = firrtl.and %1129, %1151 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1153 = firrtl.mux(%1152, %finalWBResult, %48) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1154 = firrtl.mux(%1095, %48, %1153) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1155 = firrtl.mux(%1094, %1154, %48) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1156 = firrtl.eq %998, %c5_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1157 = firrtl.and %1129, %1156 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1158 = firrtl.mux(%1157, %finalWBResult, %53) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1159 = firrtl.mux(%1095, %53, %1158) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1160 = firrtl.mux(%1094, %1159, %53) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1161 = firrtl.eq %998, %c6_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1162 = firrtl.and %1129, %1161 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1163 = firrtl.mux(%1162, %finalWBResult, %58) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1164 = firrtl.mux(%1095, %58, %1163) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1165 = firrtl.mux(%1094, %1164, %58) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1166 = firrtl.andr %998 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %1167 = firrtl.and %1129, %1166 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1168 = firrtl.mux(%1167, %finalWBResult, %63) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1169 = firrtl.mux(%1095, %63, %1168) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1170 = firrtl.mux(%1094, %1169, %63) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1171 = firrtl.eq %995, %c3_ui2 : (!firrtl.uint<5>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %1172 = firrtl.orr %998 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %1173 = firrtl.not %1172 : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %1174 = firrtl.and %1171, %1173 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1175 = firrtl.mux(%1174, %finalWBResult, %29) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1176 = firrtl.or %1095, %1129 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1177 = firrtl.mux(%1176, %29, %1175) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1178 = firrtl.mux(%1094, %1177, %29) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1179 = firrtl.eq %998, %c1_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1180 = firrtl.and %1171, %1179 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1181 = firrtl.mux(%1180, %finalWBResult, %34) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1182 = firrtl.or %1095, %1129 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1183 = firrtl.mux(%1182, %34, %1181) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1184 = firrtl.mux(%1094, %1183, %34) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1185 = firrtl.eq %998, %c2_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1186 = firrtl.and %1171, %1185 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1187 = firrtl.mux(%1186, %finalWBResult, %39) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1188 = firrtl.or %1095, %1129 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1189 = firrtl.mux(%1188, %39, %1187) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1190 = firrtl.mux(%1094, %1189, %39) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1191 = firrtl.eq %998, %c3_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1192 = firrtl.and %1171, %1191 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1193 = firrtl.mux(%1192, %finalWBResult, %44) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1194 = firrtl.or %1095, %1129 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1195 = firrtl.mux(%1194, %44, %1193) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1196 = firrtl.mux(%1094, %1195, %44) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1197 = firrtl.eq %998, %c4_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1198 = firrtl.and %1171, %1197 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1199 = firrtl.mux(%1198, %finalWBResult, %49) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1200 = firrtl.or %1095, %1129 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1201 = firrtl.mux(%1200, %49, %1199) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1202 = firrtl.mux(%1094, %1201, %49) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1203 = firrtl.eq %998, %c5_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1204 = firrtl.and %1171, %1203 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1205 = firrtl.mux(%1204, %finalWBResult, %54) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1206 = firrtl.or %1095, %1129 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1207 = firrtl.mux(%1206, %54, %1205) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1208 = firrtl.mux(%1094, %1207, %54) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1209 = firrtl.eq %998, %c6_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1210 = firrtl.and %1171, %1209 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1211 = firrtl.mux(%1210, %finalWBResult, %59) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1212 = firrtl.or %1095, %1129 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1213 = firrtl.mux(%1212, %59, %1211) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1214 = firrtl.mux(%1094, %1213, %59) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1215 = firrtl.andr %998 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %1216 = firrtl.and %1171, %1215 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1217 = firrtl.mux(%1216, %finalWBResult, %64) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1218 = firrtl.or %1095, %1129 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1219 = firrtl.mux(%1218, %64, %1217) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1220 = firrtl.mux(%1094, %1219, %64) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1221 = firrtl.eq %995, %c4_ui3 : (!firrtl.uint<5>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1222 = firrtl.orr %998 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %1223 = firrtl.not %1222 : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %1224 = firrtl.and %1221, %1223 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1225 = firrtl.mux(%1224, %finalWBResult, %30) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1226 = firrtl.or %1129, %1171 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1227 = firrtl.or %1095, %1226 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1228 = firrtl.mux(%1227, %30, %1225) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1229 = firrtl.mux(%1094, %1228, %30) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1230 = firrtl.vectorcreate %1100, %1135, %1178, %1229 : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.vector<uint<32>, 4>
      %1231 = firrtl.eq %998, %c1_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1232 = firrtl.and %1221, %1231 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1233 = firrtl.mux(%1232, %finalWBResult, %35) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1234 = firrtl.or %1129, %1171 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1235 = firrtl.or %1095, %1234 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1236 = firrtl.mux(%1235, %35, %1233) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1237 = firrtl.mux(%1094, %1236, %35) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1238 = firrtl.vectorcreate %1104, %1140, %1184, %1237 : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.vector<uint<32>, 4>
      %1239 = firrtl.eq %998, %c2_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1240 = firrtl.and %1221, %1239 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1241 = firrtl.mux(%1240, %finalWBResult, %40) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1242 = firrtl.or %1129, %1171 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1243 = firrtl.or %1095, %1242 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1244 = firrtl.mux(%1243, %40, %1241) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1245 = firrtl.mux(%1094, %1244, %40) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1246 = firrtl.vectorcreate %1108, %1145, %1190, %1245 : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.vector<uint<32>, 4>
      %1247 = firrtl.eq %998, %c3_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1248 = firrtl.and %1221, %1247 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1249 = firrtl.mux(%1248, %finalWBResult, %45) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1250 = firrtl.or %1129, %1171 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1251 = firrtl.or %1095, %1250 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1252 = firrtl.mux(%1251, %45, %1249) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1253 = firrtl.mux(%1094, %1252, %45) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1254 = firrtl.vectorcreate %1112, %1150, %1196, %1253 : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.vector<uint<32>, 4>
      %1255 = firrtl.eq %998, %c4_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1256 = firrtl.and %1221, %1255 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1257 = firrtl.mux(%1256, %finalWBResult, %50) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1258 = firrtl.or %1129, %1171 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1259 = firrtl.or %1095, %1258 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1260 = firrtl.mux(%1259, %50, %1257) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1261 = firrtl.mux(%1094, %1260, %50) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1262 = firrtl.vectorcreate %1116, %1155, %1202, %1261 : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.vector<uint<32>, 4>
      %1263 = firrtl.eq %998, %c5_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1264 = firrtl.and %1221, %1263 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1265 = firrtl.mux(%1264, %finalWBResult, %55) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1266 = firrtl.or %1129, %1171 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1267 = firrtl.or %1095, %1266 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1268 = firrtl.mux(%1267, %55, %1265) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1269 = firrtl.mux(%1094, %1268, %55) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1270 = firrtl.vectorcreate %1120, %1160, %1208, %1269 : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.vector<uint<32>, 4>
      %1271 = firrtl.eq %998, %c6_ui3 : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %1272 = firrtl.and %1221, %1271 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1273 = firrtl.mux(%1272, %finalWBResult, %60) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1274 = firrtl.or %1129, %1171 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1275 = firrtl.or %1095, %1274 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1276 = firrtl.mux(%1275, %60, %1273) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1277 = firrtl.mux(%1094, %1276, %60) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1278 = firrtl.vectorcreate %1124, %1165, %1214, %1277 : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.vector<uint<32>, 4>
      %1279 = firrtl.andr %998 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %1280 = firrtl.and %1221, %1279 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1281 = firrtl.mux(%1280, %finalWBResult, %65) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1282 = firrtl.or %1129, %1171 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1283 = firrtl.or %1095, %1282 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1284 = firrtl.mux(%1283, %65, %1281) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1285 = firrtl.mux(%1094, %1284, %65) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %1286 = firrtl.vectorcreate %1128, %1170, %1220, %1285 : (!firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.vector<uint<32>, 4>
      %1287 = firrtl.vectorcreate %1230, %1238, %1246, %1254, %1262, %1270, %1278, %1286 : (!firrtl.vector<uint<32>, 4>, !firrtl.vector<uint<32>, 4>, !firrtl.vector<uint<32>, 4>, !firrtl.vector<uint<32>, 4>, !firrtl.vector<uint<32>, 4>, !firrtl.vector<uint<32>, 4>, !firrtl.vector<uint<32>, 4>, !firrtl.vector<uint<32>, 4>) -> !firrtl.vector<vector<uint<32>, 4>, 8>
      firrtl.matchingconnect %debugRegs1to4, %1287 : !firrtl.vector<vector<uint<32>, 4>, 8>
      %1288 = firrtl.orr %995 : (!firrtl.uint<5>) -> !firrtl.uint<1>
      %1289 = firrtl.not %1288 : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %1290 = firrtl.and %1062, %1289 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1291 = firrtl.mux(%1290, %c0_ui1, %1064) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %1292 = firrtl.tail %148, 3 : (!firrtl.uint<3>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageThreads_0_6, %1292 : !firrtl.uint<0>
      %1293 = firrtl.tail %149, 1 : (!firrtl.uint<1>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageValids_0_14, %1293 : !firrtl.uint<0>
      %1294 = firrtl.tail %203, 3 : (!firrtl.uint<3>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageThreads_1_7, %1294 : !firrtl.uint<0>
      %1295 = firrtl.tail %204, 1 : (!firrtl.uint<1>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageValids_1_15, %1295 : !firrtl.uint<0>
      %1296 = firrtl.tail %369, 3 : (!firrtl.uint<3>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageThreads_2_8, %1296 : !firrtl.uint<0>
      %1297 = firrtl.tail %370, 1 : (!firrtl.uint<1>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageValids_2_16, %1297 : !firrtl.uint<0>
      %1298 = firrtl.tail %454, 3 : (!firrtl.uint<3>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageThreads_3_9, %1298 : !firrtl.uint<0>
      %1299 = firrtl.tail %457, 1 : (!firrtl.uint<1>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageValids_3_17, %1299 : !firrtl.uint<0>
      %1300 = firrtl.tail %542, 3 : (!firrtl.uint<3>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageThreads_4_10, %1300 : !firrtl.uint<0>
      %1301 = firrtl.tail %543, 1 : (!firrtl.uint<1>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageValids_4_18, %1301 : !firrtl.uint<0>
      %1302 = firrtl.tail %791, 3 : (!firrtl.uint<3>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageThreads_5_11, %1302 : !firrtl.uint<0>
      %1303 = firrtl.tail %792, 1 : (!firrtl.uint<1>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageValids_5_19, %1303 : !firrtl.uint<0>
      %1304 = firrtl.tail %888, 3 : (!firrtl.uint<3>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageThreads_6_12, %1304 : !firrtl.uint<0>
      %1305 = firrtl.tail %889, 1 : (!firrtl.uint<1>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageValids_6_20, %1305 : !firrtl.uint<0>
      %1306 = firrtl.tail %998, 3 : (!firrtl.uint<3>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageThreads_7_13, %1306 : !firrtl.uint<0>
      %1307 = firrtl.tail %1000, 1 : (!firrtl.uint<1>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugStageValids_7_21, %1307 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlValid_70, %1307 : !firrtl.uint<0>
      %1308 = firrtl.tail %999, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlInstr_71, %1308 : !firrtl.uint<0>
      %1309 = firrtl.tail %985, 1 : (!firrtl.uint<1>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlTaken_72, %1309 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlThread_73, %1306 : !firrtl.uint<0>
      %1310 = firrtl.tail %997, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlFromPC_74, %1310 : !firrtl.uint<0>
      %1311 = firrtl.tail %984, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlTarget_75, %1311 : !firrtl.uint<0>
      %1312 = firrtl.tail %994, 1 : (!firrtl.uint<1>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlIsBranch_76, %1312 : !firrtl.uint<0>
      %1313 = firrtl.tail %993, 1 : (!firrtl.uint<1>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlIsJal_77, %1313 : !firrtl.uint<0>
      %1314 = firrtl.tail %992, 1 : (!firrtl.uint<1>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugCtrlIsJalr_78, %1314 : !firrtl.uint<0>
      %1315 = firrtl.tail %105, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_0_1_30, %1315 : !firrtl.uint<0>
      %1316 = firrtl.tail %104, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_0_2_31, %1316 : !firrtl.uint<0>
      %1317 = firrtl.tail %103, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_0_3_32, %1317 : !firrtl.uint<0>
      %1318 = firrtl.tail %102, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_0_4_33, %1318 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegX1_0_62, %1315 : !firrtl.uint<0>
      %1319 = firrtl.tail %25, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugPC_0_22, %1319 : !firrtl.uint<0>
      %1320 = firrtl.tail %100, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_1_1_34, %1320 : !firrtl.uint<0>
      %1321 = firrtl.tail %99, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_1_2_35, %1321 : !firrtl.uint<0>
      %1322 = firrtl.tail %98, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_1_3_36, %1322 : !firrtl.uint<0>
      %1323 = firrtl.tail %97, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_1_4_37, %1323 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegX1_1_63, %1320 : !firrtl.uint<0>
      %1324 = firrtl.tail %24, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugPC_1_23, %1324 : !firrtl.uint<0>
      %1325 = firrtl.tail %95, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_2_1_38, %1325 : !firrtl.uint<0>
      %1326 = firrtl.tail %94, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_2_2_39, %1326 : !firrtl.uint<0>
      %1327 = firrtl.tail %93, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_2_3_40, %1327 : !firrtl.uint<0>
      %1328 = firrtl.tail %92, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_2_4_41, %1328 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegX1_2_64, %1325 : !firrtl.uint<0>
      %1329 = firrtl.tail %23, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugPC_2_24, %1329 : !firrtl.uint<0>
      %1330 = firrtl.tail %90, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_3_1_42, %1330 : !firrtl.uint<0>
      %1331 = firrtl.tail %89, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_3_2_43, %1331 : !firrtl.uint<0>
      %1332 = firrtl.tail %88, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_3_3_44, %1332 : !firrtl.uint<0>
      %1333 = firrtl.tail %87, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_3_4_45, %1333 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegX1_3_65, %1330 : !firrtl.uint<0>
      %1334 = firrtl.tail %22, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugPC_3_25, %1334 : !firrtl.uint<0>
      %1335 = firrtl.tail %85, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_4_1_46, %1335 : !firrtl.uint<0>
      %1336 = firrtl.tail %84, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_4_2_47, %1336 : !firrtl.uint<0>
      %1337 = firrtl.tail %83, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_4_3_48, %1337 : !firrtl.uint<0>
      %1338 = firrtl.tail %82, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_4_4_49, %1338 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegX1_4_66, %1335 : !firrtl.uint<0>
      %1339 = firrtl.tail %21, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugPC_4_26, %1339 : !firrtl.uint<0>
      %1340 = firrtl.tail %80, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_5_1_50, %1340 : !firrtl.uint<0>
      %1341 = firrtl.tail %79, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_5_2_51, %1341 : !firrtl.uint<0>
      %1342 = firrtl.tail %78, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_5_3_52, %1342 : !firrtl.uint<0>
      %1343 = firrtl.tail %77, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_5_4_53, %1343 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegX1_5_67, %1340 : !firrtl.uint<0>
      %1344 = firrtl.tail %20, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugPC_5_27, %1344 : !firrtl.uint<0>
      %1345 = firrtl.tail %75, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_6_1_54, %1345 : !firrtl.uint<0>
      %1346 = firrtl.tail %74, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_6_2_55, %1346 : !firrtl.uint<0>
      %1347 = firrtl.tail %73, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_6_3_56, %1347 : !firrtl.uint<0>
      %1348 = firrtl.tail %72, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_6_4_57, %1348 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegX1_6_68, %1345 : !firrtl.uint<0>
      %1349 = firrtl.tail %19, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugPC_6_28, %1349 : !firrtl.uint<0>
      %1350 = firrtl.tail %70, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_7_1_58, %1350 : !firrtl.uint<0>
      %1351 = firrtl.tail %69, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_7_2_59, %1351 : !firrtl.uint<0>
      %1352 = firrtl.tail %68, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_7_3_60, %1352 : !firrtl.uint<0>
      %1353 = firrtl.tail %67, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegs01234_7_4_61, %1353 : !firrtl.uint<0>
      firrtl.matchingconnect %io_debugRegX1_7_69, %1350 : !firrtl.uint<0>
      %1354 = firrtl.tail %18, 32 : (!firrtl.uint<32>) -> !firrtl.uint<0>
      firrtl.matchingconnect %io_debugPC_7_29, %1354 : !firrtl.uint<0>
      firrtl.matchingconnect %_debugRegs1to4_WIRE_8, %1 : !firrtl.vector<vector<uint<32>, 4>, 8>
      firrtl.matchingconnect %_decodeReg_WIRE, %8 : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %1355 = firrtl.vectorcreate %501, %502 : (!firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.vector<uint<5>, 2>
      %1356 = firrtl.vectorcreate %1066 : (!firrtl.uint<5>) -> !firrtl.vector<uint<5>, 1>
      %1357 = firrtl.vectorcreate %1291 : (!firrtl.uint<1>) -> !firrtl.vector<uint<1>, 1>
      %1358 = firrtl.vectorcreate %1067 : (!firrtl.uint<32>) -> !firrtl.vector<uint<32>, 1>
      %1359 = firrtl.bundlecreate %500, %1065, %1355, %regFile_io_readData, %1356, %1357, %1358 : (!firrtl.uint<3>, !firrtl.uint<3>, !firrtl.vector<uint<5>, 2>, !firrtl.vector<uint<32>, 2>, !firrtl.vector<uint<5>, 1>, !firrtl.vector<uint<1>, 1>, !firrtl.vector<uint<32>, 1>) -> !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      firrtl.matchingconnect %regFile.io, %1359 : !firrtl.bundle<readThreadID: uint<3>, writeThreadID: uint<3>, readAddrs: vector<uint<5>, 2>, readData: vector<uint<32>, 2>, writeAddrs: vector<uint<5>, 1>, wens: vector<uint<1>, 1>, writeData: vector<uint<32>, 1>>
      %1360 = firrtl.bundlecreate %309, %311, %313, %315, %317, %319, %321, %323, %325, %327, %329, %331, %333, %335, %337, %339 : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<32>) -> !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1361 = firrtl.bundlecreate %341, %1360 : (!firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>) -> !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      firrtl.matchingconnect %decodeReg, %1361 : !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      firrtl.matchingconnect %_dispatchReg_WIRE, %7 : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %1362 = firrtl.bundlecreate %412, %374, %376, %378 : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %1363 = firrtl.bundlecreate %381, %383, %385, %387, %389, %391, %393, %395, %397, %399, %401, %403, %405, %407, %409, %411 : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<32>) -> !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1364 = firrtl.bundlecreate %1362, %1363 : (!firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>) -> !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %1365 = firrtl.bundlecreate %1364 : (!firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>) -> !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      firrtl.matchingconnect %dispatchReg, %1365 : !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %1366 = firrtl.bundlecreate %505, %462, %464, %466 : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %1367 = firrtl.bundlecreate %469, %471, %473, %475, %477, %479, %481, %483, %485, %487, %489, %491, %493, %495, %497, %499 : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<32>) -> !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1368 = firrtl.bundlecreate %754, %549, %551, %553 : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %1369 = firrtl.bundlecreate %556, %558, %560, %562, %564, %566, %568, %570, %572, %574, %576, %578, %580, %582, %584, %586 : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<32>) -> !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1370 = firrtl.bundlecreate %849, %799, %801, %803 : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %1371 = firrtl.bundlecreate %806, %808, %810, %812, %814, %816, %818, %820, %822, %824, %826, %828, %830, %832, %834, %836 : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<32>) -> !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1372 = firrtl.bundlecreate %947, %897, %899, %901 : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %1373 = firrtl.bundlecreate %904, %906, %908, %910, %912, %914, %916, %918, %920, %922, %924, %926, %928, %930, %932, %934 : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<32>) -> !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %1374 = firrtl.bundlecreate %1059, %1009, %1011, %1013 : (!firrtl.uint<1>, !firrtl.uint<3>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>
      %1375 = firrtl.bundlecreate %1016, %1018, %1020, %1022, %1024, %1026, %1028, %1030, %1032, %1034, %1036, %1038, %1040, %1042, %1044, %1046 : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<32>) -> !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      firrtl.matchingconnect %_regReadReg_WIRE, %6 : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %1376 = firrtl.bundlecreate %1366, %1367 : (!firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>) -> !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %1377 = firrtl.bundlecreate %1376 : (!firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>) -> !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %1378 = firrtl.bundlecreate %1377, %503, %504 : (!firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      firrtl.matchingconnect %regReadReg, %1378 : !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %1379 = firrtl.bundlecreate %1368, %1369 : (!firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>) -> !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %1380 = firrtl.bundlecreate %1370, %1371 : (!firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>) -> !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %1381 = firrtl.bundlecreate %1372, %1373 : (!firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>) -> !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %1382 = firrtl.bundlecreate %1374, %1375 : (!firrtl.bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>) -> !firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      firrtl.matchingconnect %_exec1Reg_WIRE, %5 : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %1383 = firrtl.bundlecreate %1379 : (!firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>) -> !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %1384 = firrtl.bundlecreate %1383, %588, %590 : (!firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %1385 = firrtl.bundlecreate %1384, %679, %685, %650, %656 : (!firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, !firrtl.uint<32>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<32>) -> !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      firrtl.matchingconnect %exec1Reg, %1385 : !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %1386 = firrtl.bundlecreate %1380 : (!firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>) -> !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %1387 = firrtl.bundlecreate %1381 : (!firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>) -> !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      %1388 = firrtl.bundlecreate %1382 : (!firrtl.bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>) -> !firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>
      firrtl.matchingconnect %_exec2Reg_WIRE, %4 : !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %1389 = firrtl.bundlecreate %1386, %838, %840 : (!firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %1390 = firrtl.bundlecreate %1389, %842, %844, %846, %848 : (!firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, !firrtl.uint<32>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<32>) -> !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %1391 = firrtl.bundlecreate %1390 : (!firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>) -> !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      firrtl.matchingconnect %exec2Reg, %1391 : !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %1392 = firrtl.bundlecreate %1387, %936, %938 : (!firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      %1393 = firrtl.bundlecreate %1388, %1048, %1050 : (!firrtl.bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>
      firrtl.matchingconnect %_exec3Reg_WIRE, %3 : !firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>
      %1394 = firrtl.bundlecreate %1392, %940, %942, %944, %946 : (!firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, !firrtl.uint<32>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<32>) -> !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      %1395 = firrtl.bundlecreate %1394 : (!firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>) -> !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %1396 = firrtl.bundlecreate %1395 : (!firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>) -> !firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>
      firrtl.matchingconnect %exec3Reg, %1396 : !firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>
      %1397 = firrtl.bundlecreate %1393, %1052, %1054, %1056, %1058 : (!firrtl.bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, !firrtl.uint<32>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<32>) -> !firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>
      firrtl.matchingconnect %_wbReg_WIRE, %0 : !firrtl.bundle<exec3Signals: bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>>
      %1398 = firrtl.bundlecreate %1397 : (!firrtl.bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>) -> !firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>
      %1399 = firrtl.bundlecreate %1398 : (!firrtl.bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>) -> !firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>
      %1400 = firrtl.bundlecreate %1399 : (!firrtl.bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>) -> !firrtl.bundle<exec3Signals: bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>>
      firrtl.matchingconnect %wbReg, %1400 : !firrtl.bundle<exec3Signals: bundle<exec2Signals: bundle<exec1Signals: bundle<regReadSignals: bundle<dispatchSignals: bundle<decodePipelineSignals: bundle<fetchSignals: bundle<valid: uint<1>, threadId: uint<3>, pc: uint<32>, instr: uint<32>>, decodeSignals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>>, rs1Data: uint<32>, rs2Data: uint<32>>, result: uint<32>, doRegFileWrite: uint<1>, ctrlTaken: uint<1>, ctrlTarget: uint<32>>>>>
    }
  }
}
