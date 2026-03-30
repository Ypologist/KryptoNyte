module {
  firrtl.circuit "RV32IDecodeModule" {
    firrtl.module @RV32IDecodeModule(in %clock: !firrtl.clock, in %reset: !firrtl.uint<1>, in %io_instr: !firrtl.uint<32>, out %io_signals: !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>) {
      %c0_ui32 = firrtl.constant 0 : !firrtl.uint<32>
      %c0_ui5 = firrtl.constant 0 : !firrtl.uint<5>
      %c0_ui1 = firrtl.constant 0 : !firrtl.uint<1>
      %c0_ui12 = firrtl.constant 0 : !firrtl.uint<12>
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
      %c6_ui3 = firrtl.constant 6 : !firrtl.uint<3>
      %c10_ui5 = firrtl.constant 10 : !firrtl.uint<5>
      %c11_ui5 = firrtl.constant 11 : !firrtl.uint<5>
      %c5_ui3 = firrtl.constant 5 : !firrtl.uint<3>
      %c8_ui5 = firrtl.constant 8 : !firrtl.uint<5>
      %c4_ui3 = firrtl.constant 4 : !firrtl.uint<3>
      %c6_ui5 = firrtl.constant 6 : !firrtl.uint<5>
      %c3_ui2 = firrtl.constant 3 : !firrtl.uint<2>
      %c4_ui5 = firrtl.constant 4 : !firrtl.uint<5>
      %c2_ui2 = firrtl.constant 2 : !firrtl.uint<2>
      %c2_ui5 = firrtl.constant 2 : !firrtl.uint<5>
      %c1_ui5 = firrtl.constant 1 : !firrtl.uint<5>
      %c32_ui6 = firrtl.constant 32 : !firrtl.uint<6>
      %c1_ui1 = firrtl.constant 1 : !firrtl.uint<1>
      %c51_ui7 = firrtl.constant 51 : !firrtl.uint<7>
      %io = firrtl.wire : !firrtl.bundle<instr: uint<32>, signals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %0 = firrtl.subfield %io[instr] : !firrtl.bundle<instr: uint<32>, signals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %1 = firrtl.subfield %io[signals] : !firrtl.bundle<instr: uint<32>, signals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      firrtl.matchingconnect %io_signals, %1 : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %io_signals_dec = firrtl.wire : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      %io_signals_opcode = firrtl.bits %0 6 to 0 {name = "io_signals_opcode"} : (!firrtl.uint<32>) -> !firrtl.uint<7>
      %io_signals_funct3 = firrtl.bits %0 14 to 12 {name = "io_signals_funct3"} : (!firrtl.uint<32>) -> !firrtl.uint<3>
      %io_signals_funct7 = firrtl.bits %0 31 to 25 {name = "io_signals_funct7"} : (!firrtl.uint<32>) -> !firrtl.uint<7>
      %_io_signals_dec_rs1_T = firrtl.bits %0 19 to 15 {name = "_io_signals_dec_rs1_T"} : (!firrtl.uint<32>) -> !firrtl.uint<5>
      %_io_signals_dec_rs2_T = firrtl.bits %0 24 to 20 {name = "_io_signals_dec_rs2_T"} : (!firrtl.uint<32>) -> !firrtl.uint<5>
      %_io_signals_storeImm_T_1 = firrtl.bits %0 11 to 7 {name = "_io_signals_storeImm_T_1"} : (!firrtl.uint<32>) -> !firrtl.uint<5>
      %_io_signals_T = firrtl.eq %io_signals_opcode, %c51_ui7 {name = "_io_signals_T"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %2 = firrtl.orr %io_signals_funct3 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %_io_signals_T_1 = firrtl.not %2 {name = "_io_signals_T_1"} : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_signals_T_2 = firrtl.eq %io_signals_funct7, %c32_ui6 {name = "_io_signals_T_2"} : (!firrtl.uint<7>, !firrtl.uint<6>) -> !firrtl.uint<1>
      %3 = firrtl.mux(%_io_signals_T_2, %c1_ui5, %c0_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %_io_signals_T_3 = firrtl.eq %io_signals_funct3, %c1_ui1 {name = "_io_signals_T_3"} : (!firrtl.uint<3>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_signals_T_4 = firrtl.eq %io_signals_funct3, %c2_ui2 {name = "_io_signals_T_4"} : (!firrtl.uint<3>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %_io_signals_T_5 = firrtl.eq %io_signals_funct3, %c3_ui2 {name = "_io_signals_T_5"} : (!firrtl.uint<3>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %_io_signals_T_6 = firrtl.eq %io_signals_funct3, %c4_ui3 {name = "_io_signals_T_6"} : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %_io_signals_T_7 = firrtl.eq %io_signals_funct3, %c5_ui3 {name = "_io_signals_T_7"} : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %_io_signals_T_8 = firrtl.eq %io_signals_funct7, %c32_ui6 {name = "_io_signals_T_8"} : (!firrtl.uint<7>, !firrtl.uint<6>) -> !firrtl.uint<1>
      %4 = firrtl.mux(%_io_signals_T_8, %c11_ui5, %c10_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %_io_signals_T_9 = firrtl.eq %io_signals_funct3, %c6_ui3 {name = "_io_signals_T_9"} : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %_io_signals_T_10 = firrtl.andr %io_signals_funct3 {name = "_io_signals_T_10"} : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %5 = firrtl.mux(%_io_signals_T_10, %c14_ui5, %c0_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %6 = firrtl.mux(%_io_signals_T_9, %c12_ui5, %5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %7 = firrtl.mux(%_io_signals_T_7, %4, %6) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %8 = firrtl.mux(%_io_signals_T_6, %c8_ui5, %7) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %9 = firrtl.mux(%_io_signals_T_5, %c6_ui5, %8) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %10 = firrtl.mux(%_io_signals_T_4, %c4_ui5, %9) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %11 = firrtl.mux(%_io_signals_T_3, %c2_ui5, %10) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %12 = firrtl.mux(%_io_signals_T_1, %3, %11) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %_io_signals_T_11 = firrtl.eq %io_signals_opcode, %c19_ui7 {name = "_io_signals_T_11"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %13 = firrtl.or %_io_signals_T, %_io_signals_T_11 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_signals_immI_T = firrtl.bits %0 31 to 20 {name = "_io_signals_immI_T"} : (!firrtl.uint<32>) -> !firrtl.uint<12>
      %io_signals_immI_sign = firrtl.bits %0 31 to 31 {name = "io_signals_immI_sign"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_io_signals_immI_T_1 = firrtl.mux(%io_signals_immI_sign, %c1048575_ui20, %c0_ui20) {name = "_io_signals_immI_T_1"} : (!firrtl.uint<1>, !firrtl.uint<20>, !firrtl.uint<20>) -> !firrtl.uint<20>
      %io_signals_immI = firrtl.cat %_io_signals_immI_T_1, %_io_signals_immI_T {name = "io_signals_immI"} : (!firrtl.uint<20>, !firrtl.uint<12>) -> !firrtl.uint<32>
      %14 = firrtl.orr %io_signals_funct3 : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %_io_signals_T_12 = firrtl.not %14 {name = "_io_signals_T_12"} : (!firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_signals_T_13 = firrtl.eq %io_signals_funct3, %c2_ui2 {name = "_io_signals_T_13"} : (!firrtl.uint<3>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %_io_signals_T_14 = firrtl.eq %io_signals_funct3, %c3_ui2 {name = "_io_signals_T_14"} : (!firrtl.uint<3>, !firrtl.uint<2>) -> !firrtl.uint<1>
      %_io_signals_T_15 = firrtl.eq %io_signals_funct3, %c4_ui3 {name = "_io_signals_T_15"} : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %_io_signals_T_16 = firrtl.eq %io_signals_funct3, %c6_ui3 {name = "_io_signals_T_16"} : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %_io_signals_T_17 = firrtl.andr %io_signals_funct3 {name = "_io_signals_T_17"} : (!firrtl.uint<3>) -> !firrtl.uint<1>
      %_io_signals_T_18 = firrtl.eq %io_signals_funct3, %c1_ui1 {name = "_io_signals_T_18"} : (!firrtl.uint<3>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_signals_T_19 = firrtl.eq %io_signals_funct3, %c5_ui3 {name = "_io_signals_T_19"} : (!firrtl.uint<3>, !firrtl.uint<3>) -> !firrtl.uint<1>
      %_io_signals_T_21 = firrtl.bits %0 30 to 30 {name = "_io_signals_T_21"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %15 = firrtl.mux(%_io_signals_T_21, %c11_ui5, %c10_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %16 = firrtl.mux(%_io_signals_T_19, %15, %c0_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %17 = firrtl.mux(%_io_signals_T_18, %c2_ui5, %16) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %18 = firrtl.mux(%_io_signals_T_17, %c14_ui5, %17) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %19 = firrtl.mux(%_io_signals_T_16, %c12_ui5, %18) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %20 = firrtl.mux(%_io_signals_T_15, %c8_ui5, %19) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %21 = firrtl.mux(%_io_signals_T_14, %c6_ui5, %20) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %22 = firrtl.mux(%_io_signals_T_13, %c4_ui5, %21) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %23 = firrtl.mux(%_io_signals_T_12, %c0_ui5, %22) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %24 = firrtl.mux(%_io_signals_T_11, %23, %c0_ui5) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %25 = firrtl.mux(%_io_signals_T, %12, %24) : (!firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>) -> !firrtl.uint<5>
      %_io_signals_T_22 = firrtl.eq %io_signals_opcode, %c3_ui7 {name = "_io_signals_T_22"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %26 = firrtl.or %_io_signals_T, %_io_signals_T_11 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %27 = firrtl.mux(%26, %c0_ui1, %_io_signals_T_22) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_signals_dec_imm_T = firrtl.bits %0 31 to 20 {name = "_io_signals_dec_imm_T"} : (!firrtl.uint<32>) -> !firrtl.uint<12>
      %io_signals_dec_imm_sign = firrtl.bits %0 31 to 31 {name = "io_signals_dec_imm_sign"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_io_signals_dec_imm_T_1 = firrtl.mux(%io_signals_dec_imm_sign, %c1048575_ui20, %c0_ui20) {name = "_io_signals_dec_imm_T_1"} : (!firrtl.uint<1>, !firrtl.uint<20>, !firrtl.uint<20>) -> !firrtl.uint<20>
      %_io_signals_dec_imm_T_2 = firrtl.cat %_io_signals_dec_imm_T_1, %_io_signals_dec_imm_T {name = "_io_signals_dec_imm_T_2"} : (!firrtl.uint<20>, !firrtl.uint<12>) -> !firrtl.uint<32>
      %_io_signals_T_23 = firrtl.eq %io_signals_opcode, %c35_ui7 {name = "_io_signals_T_23"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %28 = firrtl.or %_io_signals_T_11, %_io_signals_T_22 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %29 = firrtl.or %_io_signals_T, %28 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %30 = firrtl.mux(%29, %c0_ui1, %_io_signals_T_23) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %io_signals_dec_imm_sign_1 = firrtl.bits %0 31 to 31 {name = "io_signals_dec_imm_sign_1"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_io_signals_dec_imm_T_3 = firrtl.mux(%io_signals_dec_imm_sign_1, %c1048575_ui20, %c0_ui20) {name = "_io_signals_dec_imm_T_3"} : (!firrtl.uint<1>, !firrtl.uint<20>, !firrtl.uint<20>) -> !firrtl.uint<20>
      %_io_signals_dec_imm_T_4 = firrtl.cat %_io_signals_dec_imm_T_3, %io_signals_funct7, %_io_signals_storeImm_T_1 {name = "_io_signals_dec_imm_T_4"} : (!firrtl.uint<20>, !firrtl.uint<7>, !firrtl.uint<5>) -> !firrtl.uint<32>
      %_io_signals_T_24 = firrtl.eq %io_signals_opcode, %c99_ui7 {name = "_io_signals_T_24"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %31 = firrtl.or %_io_signals_T_22, %_io_signals_T_23 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %32 = firrtl.or %_io_signals_T_11, %31 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %33 = firrtl.or %_io_signals_T, %32 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %34 = firrtl.mux(%33, %c0_ui1, %_io_signals_T_24) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %io_signals_dec_imm_sign_2 = firrtl.bits %0 31 to 31 {name = "io_signals_dec_imm_sign_2"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_io_signals_branchImm_T_1 = firrtl.bits %0 7 to 7 {name = "_io_signals_branchImm_T_1"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_io_signals_branchImm_T_2 = firrtl.bits %0 30 to 25 {name = "_io_signals_branchImm_T_2"} : (!firrtl.uint<32>) -> !firrtl.uint<6>
      %_io_signals_branchImm_T_3 = firrtl.bits %0 11 to 8 {name = "_io_signals_branchImm_T_3"} : (!firrtl.uint<32>) -> !firrtl.uint<4>
      %_io_signals_dec_imm_T_5 = firrtl.mux(%io_signals_dec_imm_sign_2, %c1048575_ui20, %c0_ui20) {name = "_io_signals_dec_imm_T_5"} : (!firrtl.uint<1>, !firrtl.uint<20>, !firrtl.uint<20>) -> !firrtl.uint<20>
      %_io_signals_dec_imm_T_6 = firrtl.cat %_io_signals_dec_imm_T_5, %io_signals_dec_imm_sign_2, %_io_signals_branchImm_T_1, %_io_signals_branchImm_T_2, %_io_signals_branchImm_T_3 {name = "_io_signals_dec_imm_T_6"} : (!firrtl.uint<20>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<6>, !firrtl.uint<4>) -> !firrtl.uint<32>
      %_io_signals_T_25 = firrtl.eq %io_signals_opcode, %c111_ui7 {name = "_io_signals_T_25"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %35 = firrtl.or %_io_signals_T_23, %_io_signals_T_24 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %36 = firrtl.or %_io_signals_T_22, %35 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %37 = firrtl.or %_io_signals_T_11, %36 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %38 = firrtl.or %_io_signals_T, %37 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %39 = firrtl.mux(%38, %c0_ui1, %_io_signals_T_25) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %io_signals_dec_imm_sign_3 = firrtl.bits %0 31 to 31 {name = "io_signals_dec_imm_sign_3"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_io_signals_jumpImm_T_1 = firrtl.bits %0 19 to 12 {name = "_io_signals_jumpImm_T_1"} : (!firrtl.uint<32>) -> !firrtl.uint<8>
      %_io_signals_jumpImm_T_2 = firrtl.bits %0 20 to 20 {name = "_io_signals_jumpImm_T_2"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_io_signals_jumpImm_T_3 = firrtl.bits %0 30 to 21 {name = "_io_signals_jumpImm_T_3"} : (!firrtl.uint<32>) -> !firrtl.uint<10>
      %_io_signals_dec_imm_T_8 = firrtl.mux(%io_signals_dec_imm_sign_3, %c2047_ui11, %c0_ui11) {name = "_io_signals_dec_imm_T_8"} : (!firrtl.uint<1>, !firrtl.uint<11>, !firrtl.uint<11>) -> !firrtl.uint<11>
      %_io_signals_dec_imm_T_9 = firrtl.cat %_io_signals_dec_imm_T_8, %io_signals_dec_imm_sign_3, %_io_signals_jumpImm_T_1, %_io_signals_jumpImm_T_2, %_io_signals_jumpImm_T_3, %c0_ui1 {name = "_io_signals_dec_imm_T_9"} : (!firrtl.uint<11>, !firrtl.uint<1>, !firrtl.uint<8>, !firrtl.uint<1>, !firrtl.uint<10>, !firrtl.uint<1>) -> !firrtl.uint<32>
      %_io_signals_T_26 = firrtl.eq %io_signals_opcode, %c103_ui7 {name = "_io_signals_T_26"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %40 = firrtl.or %_io_signals_T_24, %_io_signals_T_25 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %41 = firrtl.or %_io_signals_T_23, %40 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %42 = firrtl.or %_io_signals_T_22, %41 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %43 = firrtl.or %_io_signals_T_11, %42 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %44 = firrtl.or %_io_signals_T, %43 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %45 = firrtl.mux(%44, %c0_ui1, %_io_signals_T_26) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_signals_dec_imm_T_10 = firrtl.bits %0 31 to 20 {name = "_io_signals_dec_imm_T_10"} : (!firrtl.uint<32>) -> !firrtl.uint<12>
      %io_signals_dec_imm_sign_4 = firrtl.bits %0 31 to 31 {name = "io_signals_dec_imm_sign_4"} : (!firrtl.uint<32>) -> !firrtl.uint<1>
      %_io_signals_dec_imm_T_11 = firrtl.mux(%io_signals_dec_imm_sign_4, %c1048575_ui20, %c0_ui20) {name = "_io_signals_dec_imm_T_11"} : (!firrtl.uint<1>, !firrtl.uint<20>, !firrtl.uint<20>) -> !firrtl.uint<20>
      %_io_signals_dec_imm_T_12 = firrtl.cat %_io_signals_dec_imm_T_11, %_io_signals_dec_imm_T_10 {name = "_io_signals_dec_imm_T_12"} : (!firrtl.uint<20>, !firrtl.uint<12>) -> !firrtl.uint<32>
      %_io_signals_T_27 = firrtl.eq %io_signals_opcode, %c55_ui7 {name = "_io_signals_T_27"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %46 = firrtl.or %_io_signals_T_25, %_io_signals_T_26 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %47 = firrtl.or %_io_signals_T_24, %46 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %48 = firrtl.or %_io_signals_T_23, %47 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %49 = firrtl.or %_io_signals_T_22, %48 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %50 = firrtl.or %_io_signals_T_11, %49 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %51 = firrtl.or %_io_signals_T, %50 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %52 = firrtl.mux(%51, %c0_ui1, %_io_signals_T_27) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_signals_dec_imm_T_13 = firrtl.bits %0 31 to 12 {name = "_io_signals_dec_imm_T_13"} : (!firrtl.uint<32>) -> !firrtl.uint<20>
      %_io_signals_dec_imm_T_15 = firrtl.cat %_io_signals_dec_imm_T_13, %c0_ui12 {name = "_io_signals_dec_imm_T_15"} : (!firrtl.uint<20>, !firrtl.uint<12>) -> !firrtl.uint<32>
      %_io_signals_T_28 = firrtl.eq %io_signals_opcode, %c23_ui7 {name = "_io_signals_T_28"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %53 = firrtl.or %_io_signals_T_26, %_io_signals_T_27 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %54 = firrtl.or %_io_signals_T_25, %53 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %55 = firrtl.or %_io_signals_T_24, %54 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %56 = firrtl.or %_io_signals_T_23, %55 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %57 = firrtl.or %_io_signals_T_22, %56 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %58 = firrtl.or %_io_signals_T_11, %57 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %59 = firrtl.or %_io_signals_T, %58 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %60 = firrtl.mux(%59, %c0_ui1, %_io_signals_T_28) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %61 = firrtl.or %_io_signals_T_27, %_io_signals_T_28 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %62 = firrtl.or %_io_signals_T_26, %61 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %63 = firrtl.or %_io_signals_T_24, %_io_signals_T_25 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %64 = firrtl.mux(%63, %c0_ui1, %62) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %65 = firrtl.or %_io_signals_T_22, %_io_signals_T_23 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %66 = firrtl.or %_io_signals_T_11, %65 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %67 = firrtl.mux(%66, %c1_ui1, %64) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %68 = firrtl.mux(%_io_signals_T, %c0_ui1, %67) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_signals_dec_imm_T_16 = firrtl.bits %0 31 to 12 {name = "_io_signals_dec_imm_T_16"} : (!firrtl.uint<32>) -> !firrtl.uint<20>
      %_io_signals_dec_imm_T_18 = firrtl.cat %_io_signals_dec_imm_T_16, %c0_ui12 {name = "_io_signals_dec_imm_T_18"} : (!firrtl.uint<20>, !firrtl.uint<12>) -> !firrtl.uint<32>
      %69 = firrtl.mux(%_io_signals_T_28, %_io_signals_dec_imm_T_18, %c0_ui32) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %70 = firrtl.mux(%_io_signals_T_27, %_io_signals_dec_imm_T_15, %69) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %71 = firrtl.mux(%_io_signals_T_26, %_io_signals_dec_imm_T_12, %70) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %72 = firrtl.mux(%_io_signals_T_25, %_io_signals_dec_imm_T_9, %71) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %73 = firrtl.mux(%_io_signals_T_24, %_io_signals_dec_imm_T_6, %72) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %74 = firrtl.mux(%_io_signals_T_23, %_io_signals_dec_imm_T_4, %73) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %75 = firrtl.mux(%_io_signals_T_22, %_io_signals_dec_imm_T_2, %74) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %76 = firrtl.mux(%_io_signals_T_11, %io_signals_immI, %75) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %77 = firrtl.mux(%_io_signals_T, %c0_ui32, %76) : (!firrtl.uint<1>, !firrtl.uint<32>, !firrtl.uint<32>) -> !firrtl.uint<32>
      %_io_signals_T_29 = firrtl.eq %io_signals_opcode, %c115_ui7 {name = "_io_signals_T_29"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %78 = firrtl.or %_io_signals_T_27, %_io_signals_T_28 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %79 = firrtl.or %_io_signals_T_26, %78 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %80 = firrtl.or %_io_signals_T_25, %79 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %81 = firrtl.or %_io_signals_T_24, %80 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %82 = firrtl.or %_io_signals_T_23, %81 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %83 = firrtl.or %_io_signals_T_22, %82 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %84 = firrtl.or %_io_signals_T_11, %83 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %85 = firrtl.or %_io_signals_T, %84 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %86 = firrtl.mux(%85, %c0_ui1, %_io_signals_T_29) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %_io_signals_T_30 = firrtl.eq %io_signals_opcode, %c15_ui7 {name = "_io_signals_T_30"} : (!firrtl.uint<7>, !firrtl.uint<7>) -> !firrtl.uint<1>
      %87 = firrtl.or %_io_signals_T_28, %_io_signals_T_29 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %88 = firrtl.or %_io_signals_T_27, %87 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %89 = firrtl.or %_io_signals_T_26, %88 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %90 = firrtl.or %_io_signals_T_25, %89 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %91 = firrtl.or %_io_signals_T_24, %90 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %92 = firrtl.or %_io_signals_T_23, %91 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %93 = firrtl.or %_io_signals_T_22, %92 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %94 = firrtl.or %_io_signals_T_11, %93 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %95 = firrtl.or %_io_signals_T, %94 : (!firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %96 = firrtl.mux(%95, %c0_ui1, %_io_signals_T_30) : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>) -> !firrtl.uint<1>
      %97 = firrtl.bundlecreate %io_instr, %io_signals_dec : (!firrtl.uint<32>, !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>) -> !firrtl.bundle<instr: uint<32>, signals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      firrtl.matchingconnect %io, %97 : !firrtl.bundle<instr: uint<32>, signals: bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>>
      %98 = firrtl.bundlecreate %13, %27, %30, %34, %39, %45, %52, %60, %86, %96, %68, %_io_signals_dec_rs1_T, %_io_signals_dec_rs2_T, %_io_signals_storeImm_T_1, %25, %77 : (!firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<1>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<5>, !firrtl.uint<32>) -> !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
      firrtl.matchingconnect %io_signals_dec, %98 : !firrtl.bundle<isALU: uint<1>, isLoad: uint<1>, isStore: uint<1>, isBranch: uint<1>, isJAL: uint<1>, isJALR: uint<1>, isLUI: uint<1>, isAUIPC: uint<1>, isSystem: uint<1>, isFence: uint<1>, usesImm: uint<1>, rs1: uint<5>, rs2: uint<5>, rd: uint<5>, aluOp: uint<5>, imm: uint<32>>
    }
  }
}
