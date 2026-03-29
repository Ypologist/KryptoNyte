module {
  firrtl.circuit "StoreUnit" {
    firrtl.module @StoreUnit(in %clock: !firrtl.clock, in %reset: !firrtl.uint<1>, in %io_addr: !firrtl.uint<32>, in %io_data: !firrtl.uint<32>, in %io_storeType: !firrtl.uint<2>, out %io_memWrite: !firrtl.uint<32>, out %io_mask: !firrtl.uint<4>, out %io_misaligned: !firrtl.uint<1>) {
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
  }
}
