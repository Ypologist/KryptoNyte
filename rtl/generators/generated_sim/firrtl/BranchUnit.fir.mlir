module {
  firrtl.circuit "BranchUnit" {
    firrtl.module @BranchUnit(in %clock: !firrtl.clock, in %reset: !firrtl.uint<1>, in %io_rs1: !firrtl.uint<32>, in %io_rs2: !firrtl.uint<32>, in %io_pc: !firrtl.uint<32>, in %io_imm: !firrtl.sint<32>, in %io_branchOp: !firrtl.uint<3>, in %io_valid: !firrtl.uint<1>, out %io_taken: !firrtl.uint<1>, out %io_target: !firrtl.uint<32>, out %io_nextPc: !firrtl.uint<32>, out %io_misaligned: !firrtl.uint<1>) {
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
  }
}
