package ALUs

import chisel3._
import chisel3.util._

/**
 * Single-cycle 32x32 multiplier.
 *
 * Provides both the full 64-bit product and the low/high 32-bit halves.
 * Sign control is per-operand so the module can cover MUL, MULH, MULHU,
 * and MULHSU style behaviors without extra glue logic.
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

  val aExt = Mux(io.signedA, io.a.asSInt, Cat(0.U(1.W), io.a).asSInt)
  val bExt = Mux(io.signedB, io.b.asSInt, Cat(0.U(1.W), io.b).asSInt)
  val prod = (aExt * bExt).asUInt

  io.product := prod
  io.lo      := prod(31, 0)
  io.hi      := prod(63, 32)
}
