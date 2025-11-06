// Licensed under the BSD 3-Clause License. 
// See https://opensource.org/licenses/BSD-3-Clause for details.

package LoadUnit
import chisel3._
import chisel3.util._

class LoadUnit extends Module {
  val io = IO(new Bundle {
    val addr = Input(UInt(32.W))      // Memory address
    val dataIn = Input(UInt(32.W))    // Data from memory
    val funct3 = Input(UInt(3.W))     // Load type (funct3 field from instruction)
    val dataOut = Output(UInt(32.W))  // Processed load data
  })

  // Load type encoding based on RISC-V funct3 field
  val LB  = "b000".U  // Load Byte (signed)
  val LH  = "b001".U  // Load Halfword (signed)
  val LW  = "b010".U  // Load Word (signed)
  val LBU = "b100".U  // Load Byte (unsigned)
  val LHU = "b101".U  // Load Halfword (unsigned)

  // Parameterized width extraction
  val byteOffset = io.addr(1, 0)
  val halfOffset = io.addr(1)

  val bytes = VecInit(
    io.dataIn(7, 0),
    io.dataIn(15, 8),
    io.dataIn(23, 16),
    io.dataIn(31, 24)
  )
  val halfwords = VecInit(
    io.dataIn(15, 0),
    io.dataIn(31, 16)
  )

  val selectedByte = bytes(byteOffset)
  val selectedHalf = halfwords(halfOffset)

  val loadWord = io.dataIn
  val loadHalfSigned = Cat(Fill(16, selectedHalf(15)), selectedHalf)
  val loadHalfUnsigned = Cat(0.U(16.W), selectedHalf)
  val loadByteSigned = Cat(Fill(24, selectedByte(7)), selectedByte)
  val loadByteUnsigned = Cat(0.U(24.W), selectedByte)

  val loadResult = WireDefault(loadWord)
  switch(io.funct3) {
    is(LB)  { loadResult := loadByteSigned }
    is(LH)  { loadResult := loadHalfSigned }
    is(LW)  { loadResult := loadWord }
    is(LBU) { loadResult := loadByteUnsigned }
    is(LHU) { loadResult := loadHalfUnsigned }
  }

  io.dataOut := loadResult
}
