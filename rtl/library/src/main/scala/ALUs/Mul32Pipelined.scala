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

  private def prefixAdd64(lhs: UInt, rhs: UInt, carryIn: Bool): UInt = {
    val width = 64
    val bitPropagate = Seq.tabulate(width)(idx => lhs(idx) ^ rhs(idx))

    var groupPropagate = bitPropagate
    var groupGenerate = Seq.tabulate(width)(idx => lhs(idx) && rhs(idx))
    var distance = 1
    while (distance < width) {
      val prevPropagate = groupPropagate
      val prevGenerate = groupGenerate
      groupPropagate = Seq.tabulate(width) { idx =>
        if (idx >= distance) prevPropagate(idx) && prevPropagate(idx - distance) else prevPropagate(idx)
      }
      groupGenerate = Seq.tabulate(width) { idx =>
        if (idx >= distance) prevGenerate(idx) || (prevPropagate(idx) && prevGenerate(idx - distance)) else prevGenerate(idx)
      }
      distance *= 2
    }

    val carries = Seq.tabulate(width + 1) { idx =>
      if (idx == 0) carryIn else groupGenerate(idx - 1) || (groupPropagate(idx - 1) && carryIn)
    }
    Cat((0 until width).reverse.map(idx => bitPropagate(idx) ^ carries(idx)))
  }

  private def balancedAnd(bits: Seq[Bool]): Bool = {
    if (bits.isEmpty) {
      true.B
    } else if (bits.length == 1) {
      bits.head
    } else {
      val split = bits.length / 2
      balancedAnd(bits.take(split)) && balancedAnd(bits.drop(split))
    }
  }

  private def twosComplement64(value: UInt): UInt = {
    val segmentWidth = 8
    val numSegments = 64 / segmentWidth
    val segmentIsZero = Wire(Vec(numSegments, Bool()))
    val negatedSegments = Wire(Vec(numSegments, UInt(segmentWidth.W)))

    for (idx <- 0 until numSegments) {
      val lo = idx * segmentWidth
      val hi = lo + segmentWidth - 1
      val segment = value(hi, lo)
      segmentIsZero(idx) := segment === 0.U
    }

    for (idx <- 0 until numSegments) {
      val lo = idx * segmentWidth
      val hi = lo + segmentWidth - 1
      val segment = value(hi, lo)
      val carryIn = if (idx == 0) true.B else balancedAnd((0 until idx).map(segmentIsZero(_)))
      val segmentSum = Cat(0.U(1.W), (~segment).asUInt) + carryIn.asUInt
      negatedSegments(idx) := segmentSum(segmentWidth - 1, 0)
    }

    Cat((0 until numSegments).reverse.map(idx => negatedSegments(idx)))
  }

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

  val s4Magnitude = RegNext(prefixAdd64(s3Low, s3High, false.B))
  val s4Negative = RegNext(s3Negative)

  val s4TwosComplement = twosComplement64(s4Magnitude)
  val s5Product = RegNext(Mux(s4Negative, s4TwosComplement, s4Magnitude))
  val delayedProd = ShiftRegister(s5Product, numCycles - 6)

  io.product := delayedProd
  io.lo := delayedProd(31, 0)
  io.hi := delayedProd(63, 32)
}
