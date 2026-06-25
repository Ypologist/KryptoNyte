package ALUs

import chisel3._
import chisel3.util._

/** 32-bit pipelined multiplier that produces a full 64-bit product.
  * Highly configurable for custom architectures (defaults to 3-cycle latency)
  * Supports signed/unsigned operands independently based on standard RV32M constraints.
  */
class Mul32Pipelined(val numCycles: Int = 3) extends Module {
  val io = IO(new Bundle {
    val a       = Input(UInt(32.W))
    val b       = Input(UInt(32.W))
    val signedA = Input(Bool())
    val signedB = Input(Bool())
    val product = Output(UInt(64.W))
    val lo      = Output(UInt(32.W))
    val hi      = Output(UInt(32.W))
  })

  require(numCycles >= 6, "Pipelined Multiplier needs at least 6 cycles for the staged datapath.")

  val aNegative = io.signedA && io.a(31)
  val bNegative = io.signedB && io.b(31)
  val aMagnitude = Mux(aNegative, (~io.a).asUInt + 1.U, io.a)
  val bMagnitude = Mux(bNegative, (~io.b).asUInt + 1.U, io.b)

  val s0A = RegNext(VecInit(Seq.tabulate(4)(idx => aMagnitude(idx * 8 + 7, idx * 8))))
  val s0B = RegNext(VecInit(Seq.tabulate(4)(idx => bMagnitude(idx * 8 + 7, idx * 8))))
  val s0Negative = RegNext(aNegative ^ bNegative)

  val s1Products = RegNext(VecInit(Seq.tabulate(4) { aIdx =>
    VecInit(Seq.tabulate(4) { bIdx =>
      s0A(aIdx) * s0B(bIdx)
    })
  }))
  val s1Negative = RegNext(s0Negative)

  private def ext20(value: UInt): UInt =
    Cat(0.U((20 - value.getWidth).W), value)

  val s2Diagonal = RegNext(VecInit(Seq(
    ext20(s1Products(0)(0)),
    (ext20(s1Products(0)(1)) +& ext20(s1Products(1)(0)))(19, 0),
    (ext20(s1Products(0)(2)) +& ext20(s1Products(1)(1)) +& ext20(s1Products(2)(0)))(19, 0),
    (ext20(s1Products(0)(3)) +& ext20(s1Products(1)(2)) +& ext20(s1Products(2)(1)) +& ext20(s1Products(3)(0)))(19, 0),
    (ext20(s1Products(1)(3)) +& ext20(s1Products(2)(2)) +& ext20(s1Products(3)(1)))(19, 0),
    (ext20(s1Products(2)(3)) +& ext20(s1Products(3)(2)))(19, 0),
    ext20(s1Products(3)(3))
  )))
  val s2Negative = RegNext(s1Negative)

  private def shifted64(value: UInt, shift: Int): UInt =
    (Cat(0.U(64.W), value) << shift)(63, 0)

  private def sum64(values: Seq[UInt]): UInt =
    values.reduce((lhs, rhs) => (lhs +& rhs)(63, 0))

  val s3Low = RegNext(sum64(Seq(
    shifted64(s2Diagonal(0), 0),
    shifted64(s2Diagonal(1), 8),
    shifted64(s2Diagonal(2), 16),
    shifted64(s2Diagonal(3), 24)
  )))
  val s3High = RegNext(sum64(Seq(
    shifted64(s2Diagonal(4), 32),
    shifted64(s2Diagonal(5), 40),
    shifted64(s2Diagonal(6), 48)
  )))
  val s3Negative = RegNext(s2Negative)

  val s4Magnitude = RegNext((s3Low +& s3High)(63, 0))
  val s4Negative = RegNext(s3Negative)

  val s5Product = RegNext(Mux(s4Negative, (~s4Magnitude).asUInt + 1.U, s4Magnitude))
  val delayedProd = ShiftRegister(s5Product, numCycles - 6)

  io.product := delayedProd
  io.lo := delayedProd(31, 0)
  io.hi := delayedProd(63, 32)
}
