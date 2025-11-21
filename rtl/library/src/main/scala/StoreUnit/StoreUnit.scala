// Licensed under the BSD 3-Clause License. 
// See https://opensource.org/licenses/BSD-3-Clause for details.

package StoreUnit

import chisel3._
import chisel3.util._
class StoreUnit extends Module {
  val io = IO(new Bundle {
    val addr = Input(UInt(32.W))    // Address to store data
    val data = Input(UInt(32.W))    // Data to be stored
    val storeType = Input(UInt(3.W)) // funct3 encoding for SB/SH/SW
    val memWrite = Output(UInt(32.W)) // Output memory write data
    val mask = Output(UInt(4.W))     // Write mask for memory
    val misaligned = Output(Bool())  // Alignment check flag
  })

  val byteOffset = io.addr(1, 0)
  val halfOffset = io.addr(1)

  val isByte = io.storeType === "b000".U
  val isHalf = io.storeType === "b001".U
  val isWord = io.storeType === "b010".U

  val misalignedHalf = isHalf && (io.addr(0) =/= 0.U)
  val misalignedWord = isWord && (io.addr(1, 0) =/= 0.U)
  io.misaligned := misalignedHalf || misalignedWord

  val byteMask = (1.U(4.W) << byteOffset)
  val halfMask = Mux(halfOffset === 0.U, "b0011".U(4.W), "b1100".U(4.W))
  val wordMask = "b1111".U(4.W)

  io.mask := MuxCase(0.U, Seq(
    isByte -> byteMask,
    isHalf -> halfMask,
    isWord -> wordMask
  ))

  val byteData = (io.data(7, 0) << (byteOffset << 3)).asUInt
  val halfData = (io.data(15, 0) << (halfOffset << 4)).asUInt

  io.memWrite := MuxCase(0.U, Seq(
    isByte -> byteData,
    isHalf -> halfData,
    isWord -> io.data
  ))
}
