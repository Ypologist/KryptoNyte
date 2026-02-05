package ALUs

import chisel3._

/** 32-bit multiplier that produces a full 64-bit product in one cycle.
  * Supports signed/unsigned operands independently (RV32M semantics).
  */
class Mul32OneCycle extends Module {
  val io = IO(new Bundle {
    val a       = Input(UInt(32.W))
    val b       = Input(UInt(32.W))
    val signedA = Input(Bool())
    val signedB = Input(Bool())
    val product = Output(UInt(64.W))
    val lo      = Output(UInt(32.W))
    val hi      = Output(UInt(32.W))
  })

  // Sign-extend or zero-extend operands based on control bits.
  val opA = Mux(io.signedA, io.a.asSInt, io.a.zext.asSInt)
  val opB = Mux(io.signedB, io.b.asSInt, io.b.zext.asSInt)
  val prod = (opA * opB).asUInt
  val prod64 = prod(63, 0)

  io.product := prod64
  io.lo := prod64(31, 0)
  io.hi := prod64(63, 32)
}
