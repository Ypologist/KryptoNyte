module {
  firrtl.circuit "LoadUnit" {
    firrtl.module @LoadUnit(in %clock: !firrtl.clock, in %reset: !firrtl.uint<1>, in %io_addr: !firrtl.uint<32>, in %io_dataIn: !firrtl.uint<32>, in %io_funct3: !firrtl.uint<3>, out %io_dataOut: !firrtl.uint<32>) {
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
  }
}
