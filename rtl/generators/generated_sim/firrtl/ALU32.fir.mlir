module {
  firrtl.circuit "ALU32" {
    firrtl.module @ALU32(in %clock: !firrtl.clock, in %reset: !firrtl.uint<1>, in %io_a: !firrtl.uint<32>, in %io_b: !firrtl.uint<32>, in %io_opcode: !firrtl.uint<5>, out %io_result: !firrtl.uint<32>) {
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
  }
}
