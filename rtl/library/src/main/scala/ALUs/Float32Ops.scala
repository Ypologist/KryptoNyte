package ALUs

import chisel3._
import chisel3.util._

object Float32Ops {
  object Opcode {
    val WIDTH = 4

    val ADD   = "b0000".U(WIDTH.W)
    val SUB   = "b0001".U(WIDTH.W)
    val MUL   = "b0010".U(WIDTH.W)
    val MADD  = "b0011".U(WIDTH.W)
    val MSUB  = "b0100".U(WIDTH.W)
    val MIN   = "b0101".U(WIDTH.W)
    val MAX   = "b0110".U(WIDTH.W)
    val SGNJ  = "b0111".U(WIDTH.W)
    val SGNJN = "b1000".U(WIDTH.W)
    val SGNJX = "b1001".U(WIDTH.W)
  }

  def isZero(a: UInt): Bool = a(30, 0) === 0.U

  def isInf(a: UInt): Bool = a(30, 23) === "hff".U && a(22, 0) === 0.U

  def isNaN(a: UInt): Bool = a(30, 23) === "hff".U && a(22, 0) =/= 0.U

  def isSignalingNaN(a: UInt): Bool = isNaN(a) && !a(22)

  def isQuietNaN(a: UInt): Bool = isNaN(a) && a(22)

  def isSubnormal(a: UInt): Bool = a(30, 23) === 0.U && a(22, 0) =/= 0.U

  def isNormal(a: UInt): Bool = a(30, 23) =/= 0.U && a(30, 23) =/= "hff".U

  def canonicalNaN: UInt = "h7fc00000".U(32.W)

  def fclass(a: UInt): UInt = Cat(
    0.U(22.W),
    isQuietNaN(a).asUInt,
    isSignalingNaN(a).asUInt,
    (!a(31) && isInf(a)).asUInt,
    (!a(31) && isNormal(a)).asUInt,
    (!a(31) && isSubnormal(a)).asUInt,
    (!a(31) && isZero(a)).asUInt,
    (a(31) && isZero(a)).asUInt,
    (a(31) && isSubnormal(a)).asUInt,
    (a(31) && isNormal(a)).asUInt,
    (a(31) && isInf(a)).asUInt
  )

  def invalidForAdd(a: UInt, b: UInt): Bool =
    isSignalingNaN(a) || isSignalingNaN(b) ||
      (isInf(a) && isInf(b) && a(31) =/= b(31))

  def invalidForSub(a: UInt, b: UInt): Bool = invalidForAdd(a, negate(b))

  def invalidForMul(a: UInt, b: UInt): Bool =
    isSignalingNaN(a) || isSignalingNaN(b) ||
      ((isInf(a) && isZero(b)) || (isZero(a) && isInf(b)))

  def invalidForMAdd(a: UInt, b: UInt, c: UInt): Bool = {
    val productInvalid = invalidForMul(a, b)
    val productInf = !productInvalid && !isNaN(a) && !isNaN(b) &&
      ((isInf(a) && !isZero(b)) || (!isZero(a) && isInf(b)))
    val productSign = a(31) ^ b(31)
    productInvalid || isSignalingNaN(c) ||
      (productInf && isInf(c) && productSign =/= c(31))
  }

  def invalidForEq(a: UInt, b: UInt): Bool =
    isSignalingNaN(a) || isSignalingNaN(b)

  def invalidForOrderedCompare(a: UInt, b: UInt): Bool = isNaN(a) || isNaN(b)

  def invalidForMinMax(a: UInt, b: UInt): Bool =
    isSignalingNaN(a) || isSignalingNaN(b)

  private def magnitude(a: UInt): UInt = a(30, 0)

  def negate(a: UInt): UInt = Cat(~a(31), a(30, 0))

  def abs(a: UInt): UInt = Cat(0.U(1.W), a(30, 0))

  def signInject(a: UInt, b: UInt): UInt = Cat(b(31), a(30, 0))

  def signInjectNeg(a: UInt, b: UInt): UInt = Cat(~b(31), a(30, 0))

  def signInjectXor(a: UInt, b: UInt): UInt = Cat(a(31) ^ b(31), a(30, 0))

  def add(a: UInt, b: UInt): UInt = {
    val aSign = a(31)
    val bSign = b(31)
    val aExp = a(30, 23)
    val bExp = b(30, 23)
    val aMant = Mux(aExp === 0.U, Cat(0.U(1.W), a(22, 0)), Cat(1.U(1.W), a(22, 0)))
    val bMant = Mux(bExp === 0.U, Cat(0.U(1.W), b(22, 0)), Cat(1.U(1.W), b(22, 0)))

    val aIsBigger = magnitude(a) >= magnitude(b)
    val bigSign = Mux(aIsBigger, aSign, bSign)
    val smallSign = Mux(aIsBigger, bSign, aSign)
    val bigExp = Mux(aIsBigger, aExp, bExp)
    val smallExp = Mux(aIsBigger, bExp, aExp)
    val bigMant = Mux(aIsBigger, aMant, bMant)
    val smallMant = Mux(aIsBigger, bMant, aMant)
    val expDiff = bigExp - smallExp
    val shiftedSmall = Mux(expDiff >= 24.U, 0.U(24.W), smallMant >> expDiff(4, 0))
    val sameSign = bigSign === smallSign

    val addMant = Cat(0.U(1.W), bigMant) + Cat(0.U(1.W), shiftedSmall)
    val addExp = Mux(addMant(24), bigExp + 1.U, bigExp)
    val addFrac = Mux(addMant(24), addMant(23, 1), addMant(22, 0))
    val addPacked = Cat(bigSign, addExp, addFrac)

    val subMant = bigMant - shiftedSmall
    val subIsZero = subMant === 0.U
    val leadingZeros = PriorityEncoder(Reverse(subMant))
    val normalizedSub = (subMant << leadingZeros)(23, 0)
    val subExp = Mux(bigExp > leadingZeros, bigExp - leadingZeros, 0.U)
    val subPacked = Cat(bigSign, subExp, normalizedSub(22, 0))

    val finiteResult = Mux(isZero(a), b,
      Mux(isZero(b), a,
        Mux(sameSign, addPacked, Mux(subIsZero, 0.U(32.W), subPacked))))

    Mux(isNaN(a) || isNaN(b) || (isInf(a) && isInf(b) && aSign =/= bSign), canonicalNaN,
      Mux(isInf(a), a,
        Mux(isInf(b), b, finiteResult)))
  }

  def sub(a: UInt, b: UInt): UInt = add(a, negate(b))

  def mul(a: UInt, b: UInt): UInt = {
    val sign = a(31) ^ b(31)
    val aExp = a(30, 23)
    val bExp = b(30, 23)
    val aMant = Mux(aExp === 0.U, Cat(0.U(1.W), a(22, 0)), Cat(1.U(1.W), a(22, 0)))
    val bMant = Mux(bExp === 0.U, Cat(0.U(1.W), b(22, 0)), Cat(1.U(1.W), b(22, 0)))
    val product = aMant * bMant
    val normalizedHigh = product(47)
    val expSum = aExp.zext + bExp.zext - 127.S + normalizedHigh.asSInt
    val frac = Mux(normalizedHigh, product(46, 24), product(45, 23))
    val exp = expSum.asUInt

    val infResult = Cat(sign, Fill(8, 1.U), 0.U(23.W))
    Mux(isNaN(a) || isNaN(b) || ((isInf(a) && isZero(b)) || (isZero(a) && isInf(b))), canonicalNaN,
      Mux(isInf(a) || isInf(b) || expSum >= 255.S, infResult,
        Mux(isZero(a) || isZero(b) || expSum <= 0.S, 0.U(32.W),
          Cat(sign, exp(7, 0), frac))))
  }

  def madd(a: UInt, b: UInt, c: UInt): UInt = add(mul(a, b), c)

  def msub(a: UInt, b: UInt, c: UInt): UInt = sub(mul(a, b), c)

  def lessThan(a: UInt, b: UInt): Bool = {
    val aZero = isZero(a)
    val bZero = isZero(b)
    val signsDiffer = a(31) =/= b(31)
    Mux(aZero && bZero, false.B,
      Mux(signsDiffer, a(31),
        Mux(a(31), magnitude(a) > magnitude(b), magnitude(a) < magnitude(b))))
  }

  def lessOrEqual(a: UInt, b: UInt): Bool = lessThan(a, b) || a === b || (isZero(a) && isZero(b))

  def min(a: UInt, b: UInt): UInt = {
    val minZero = Mux(a(31) || b(31), "h80000000".U(32.W), 0.U(32.W))
    Mux(isNaN(a) && isNaN(b), canonicalNaN,
      Mux(isNaN(a), b,
        Mux(isNaN(b), a,
          Mux(isZero(a) && isZero(b), minZero,
            Mux(lessThan(a, b), a, b)))))
  }

  def max(a: UInt, b: UInt): UInt = {
    val maxZero = Mux(a(31) && b(31), "h80000000".U(32.W), 0.U(32.W))
    Mux(isNaN(a) && isNaN(b), canonicalNaN,
      Mux(isNaN(a), b,
        Mux(isNaN(b), a,
          Mux(isZero(a) && isZero(b), maxZero,
            Mux(lessThan(a, b), b, a)))))
  }

  def intToFloat(value: UInt, signed: Bool): UInt = {
    val negative = signed && value(31)
    val absValue = Mux(negative, (~value).asUInt + 1.U, value)
    val zero = absValue === 0.U
    val leadingZeros = PriorityEncoder(Reverse(absValue))
    val normalized = (absValue << leadingZeros)(31, 0)
    val exp = 158.U - leadingZeros
    Cat(negative, exp(7, 0), normalized(30, 8)) & Fill(32, !zero)
  }

  def floatToInt(value: UInt, signed: Bool): UInt = {
    val sign = value(31)
    val exp = value(30, 23)
    val mant = Cat(1.U(1.W), value(22, 0))
    val shift = exp.zext - 127.S
    val overRange = shift > 31.S
    val underRange = shift < 0.S
    val leftShift = (shift.asUInt - 23.U)(4, 0)
    val rightShift = (23.U - shift.asUInt)(4, 0)
    val mantWide = Cat(0.U(8.W), mant)
    val unsignedValue = Mux(shift >= 23.S,
      (mantWide << leftShift)(31, 0),
      (mantWide >> rightShift)(31, 0))
    val signedValue = Mux(sign, (~unsignedValue).asUInt + 1.U, unsignedValue)
    val saturated = Mux(signed,
      Mux(sign, "h80000000".U(32.W), "h7fffffff".U(32.W)),
      Mux(sign, 0.U(32.W), "hffffffff".U(32.W)))

    Mux(isZero(value) || underRange, 0.U(32.W),
      Mux(overRange, saturated, Mux(signed, signedValue, unsignedValue)))
  }
}

class Float32ALU extends Module {
  val io = IO(new Bundle {
    val a = Input(UInt(32.W))
    val b = Input(UInt(32.W))
    val c = Input(UInt(32.W))
    val opcode = Input(UInt(Float32Ops.Opcode.WIDTH.W))
    val result = Output(UInt(32.W))
  })

  import Float32Ops.Opcode._

  io.result := MuxLookup(io.opcode, 0.U(32.W))(Seq(
    ADD -> Float32Ops.add(io.a, io.b),
    SUB -> Float32Ops.sub(io.a, io.b),
    MUL -> Float32Ops.mul(io.a, io.b),
    MADD -> Float32Ops.madd(io.a, io.b, io.c),
    MSUB -> Float32Ops.msub(io.a, io.b, io.c),
    MIN -> Float32Ops.min(io.a, io.b),
    MAX -> Float32Ops.max(io.a, io.b),
    SGNJ -> Float32Ops.signInject(io.a, io.b),
    SGNJN -> Float32Ops.signInjectNeg(io.a, io.b),
    SGNJX -> Float32Ops.signInjectXor(io.a, io.b)
  ))
}

class Float32ALUPipelined(val numCycles: Int = 4) extends Module {
  val io = IO(new Bundle {
    val a = Input(UInt(32.W))
    val b = Input(UInt(32.W))
    val c = Input(UInt(32.W))
    val opcode = Input(UInt(Float32Ops.Opcode.WIDTH.W))
    val result = Output(UInt(32.W))
  })

  require(numCycles >= 1, "Pipelined Float32 ALU must have at least 1 cycle of latency.")

  import Float32Ops.Opcode._

  val combinational = MuxLookup(io.opcode, 0.U(32.W))(Seq(
    ADD -> Float32Ops.add(io.a, io.b),
    SUB -> Float32Ops.sub(io.a, io.b),
    MUL -> Float32Ops.mul(io.a, io.b),
    MADD -> Float32Ops.madd(io.a, io.b, io.c),
    MSUB -> Float32Ops.msub(io.a, io.b, io.c),
    MIN -> Float32Ops.min(io.a, io.b),
    MAX -> Float32Ops.max(io.a, io.b),
    SGNJ -> Float32Ops.signInject(io.a, io.b),
    SGNJN -> Float32Ops.signInjectNeg(io.a, io.b),
    SGNJX -> Float32Ops.signInjectXor(io.a, io.b)
  ))

  // Mirrors Mul32Pipelined: registers sit in the same module as the FP tree so
  // synthesis can retime them across the combinational datapath.
  io.result := ShiftRegister(combinational, numCycles)
}
