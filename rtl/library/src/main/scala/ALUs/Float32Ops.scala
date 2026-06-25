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

  object Flags {
    val NX = "b00001".U(5.W)
    val UF = "b00010".U(5.W)
    val OF = "b00100".U(5.W)
    val DZ = "b01000".U(5.W)
    val NV = "b10000".U(5.W)
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

  def invalidForDiv(a: UInt, b: UInt): Bool =
    isSignalingNaN(a) || isSignalingNaN(b) ||
      (isZero(a) && isZero(b)) || (isInf(a) && isInf(b))

  def invalidForSqrt(a: UInt): Bool =
    isSignalingNaN(a) || (a(31) && !isZero(a) && !isNaN(a))

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
    val expSum = aExp.zext + bExp.zext - 127.S + Mux(normalizedHigh, 1.S, 0.S)
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

class Float32AddPipelinePre extends Bundle {
  val sign = Bool()
  val exp = UInt(8.W)
  val sameSign = Bool()
  val addMant = UInt(25.W)
  val subMant = UInt(24.W)
  val subIsZero = Bool()
  val special = Bool()
  val specialResult = UInt(32.W)
}

class Float32AddAlignPre extends Bundle {
  val sign = Bool()
  val exp = UInt(8.W)
  val sameSign = Bool()
  val bigMant = UInt(24.W)
  val smallMant = UInt(24.W)
  val expDiff = UInt(8.W)
  val special = Bool()
  val specialResult = UInt(32.W)
}

class Float32AddShiftPre extends Bundle {
  val sign = Bool()
  val exp = UInt(8.W)
  val sameSign = Bool()
  val bigMant = UInt(24.W)
  val shiftedSmall = UInt(24.W)
  val special = Bool()
  val specialResult = UInt(32.W)
}

class Float32AddNormPre extends Bundle {
  val sign = Bool()
  val exp = UInt(8.W)
  val sameSign = Bool()
  val addMant = UInt(25.W)
  val subMant = UInt(24.W)
  val subIsZero = Bool()
  val leadingZeros = UInt(5.W)
  val special = Bool()
  val specialResult = UInt(32.W)
}

class Float32MulPipelinePre extends Bundle {
  val sign = Bool()
  val expBase = SInt(11.W)
  val p00 = UInt(24.W)
  val p01 = UInt(24.W)
  val p10 = UInt(24.W)
  val p11 = UInt(24.W)
  val special = Bool()
  val specialResult = UInt(32.W)
}

class Float32MulSumPre extends Bundle {
  val sign = Bool()
  val expBase = SInt(11.W)
  val lowSum = UInt(49.W)
  val highPart = UInt(48.W)
  val special = Bool()
  val specialResult = UInt(32.W)
}

class Float32MulChunkPre extends Bundle {
  val sign = Bool()
  val expBase = SInt(11.W)
  val a = Vec(4, UInt(6.W))
  val b = Vec(4, UInt(6.W))
  val special = Bool()
  val specialResult = UInt(32.W)
}

class Float32MulPartialPre extends Bundle {
  val sign = Bool()
  val expBase = SInt(11.W)
  val products = Vec(4, Vec(4, UInt(12.W)))
  val special = Bool()
  val specialResult = UInt(32.W)
}

class Float32MulDiagonalPre extends Bundle {
  val sign = Bool()
  val expBase = SInt(11.W)
  val diagonal = Vec(7, UInt(16.W))
  val special = Bool()
  val specialResult = UInt(32.W)
}

class Float32MulLowHighPre extends Bundle {
  val sign = Bool()
  val expBase = SInt(11.W)
  val low = UInt(49.W)
  val high = UInt(49.W)
  val special = Bool()
  val specialResult = UInt(32.W)
}

class Float32MulProductPre extends Bundle {
  val sign = Bool()
  val expBase = SInt(11.W)
  val product = UInt(48.W)
  val special = Bool()
  val specialResult = UInt(32.W)
}

class Float32ALUPipelined(val numCycles: Int = 4) extends Module {
  val io = IO(new Bundle {
    val a = Input(UInt(32.W))
    val b = Input(UInt(32.W))
    val c = Input(UInt(32.W))
    val opcode = Input(UInt(Float32Ops.Opcode.WIDTH.W))
    val result = Output(UInt(32.W))
  })

  require(numCycles >= 4, "Pipelined Float32 ALU needs at least 4 cycles for the staged datapath.")

  import Float32Ops.Opcode._

  private def addAlign(a: UInt, b: UInt): Float32AddAlignPre = {
    val pre = Wire(new Float32AddAlignPre)
    val aSign = a(31)
    val bSign = b(31)
    val aExp = a(30, 23)
    val bExp = b(30, 23)
    val aMant = Mux(aExp === 0.U, Cat(0.U(1.W), a(22, 0)), Cat(1.U(1.W), a(22, 0)))
    val bMant = Mux(bExp === 0.U, Cat(0.U(1.W), b(22, 0)), Cat(1.U(1.W), b(22, 0)))

    val aIsBigger = a(30, 0) >= b(30, 0)
    val bigSign = Mux(aIsBigger, aSign, bSign)
    val smallSign = Mux(aIsBigger, bSign, aSign)
    val bigExp = Mux(aIsBigger, aExp, bExp)
    val smallExp = Mux(aIsBigger, bExp, aExp)
    val bigMant = Mux(aIsBigger, aMant, bMant)
    val smallMant = Mux(aIsBigger, bMant, aMant)
    val expDiff = bigExp - smallExp
    val invalid = Float32Ops.isNaN(a) || Float32Ops.isNaN(b) ||
      (Float32Ops.isInf(a) && Float32Ops.isInf(b) && aSign =/= bSign)

    pre.sign := bigSign
    pre.exp := bigExp
    pre.sameSign := bigSign === smallSign
    pre.bigMant := bigMant
    pre.smallMant := smallMant
    pre.expDiff := expDiff
    pre.special := invalid || Float32Ops.isInf(a) || Float32Ops.isInf(b) ||
      Float32Ops.isZero(a) || Float32Ops.isZero(b)
    pre.specialResult := Mux(invalid, Float32Ops.canonicalNaN,
      Mux(Float32Ops.isInf(a), a,
        Mux(Float32Ops.isInf(b), b,
          Mux(Float32Ops.isZero(a), b, a))))
    pre
  }

  private def addShift(pre: Float32AddAlignPre): Float32AddShiftPre = {
    val shifted = Wire(new Float32AddShiftPre)
    shifted.sign := pre.sign
    shifted.exp := pre.exp
    shifted.sameSign := pre.sameSign
    shifted.bigMant := pre.bigMant
    shifted.shiftedSmall := Mux(pre.expDiff >= 24.U, 0.U(24.W), pre.smallMant >> pre.expDiff(4, 0))
    shifted.special := pre.special
    shifted.specialResult := pre.specialResult
    shifted
  }

  private def addArith(pre: Float32AddShiftPre): Float32AddPipelinePre = {
    val arith = Wire(new Float32AddPipelinePre)
    arith.sign := pre.sign
    arith.exp := pre.exp
    arith.sameSign := pre.sameSign
    arith.addMant := Cat(0.U(1.W), pre.bigMant) + Cat(0.U(1.W), pre.shiftedSmall)
    arith.subMant := pre.bigMant - pre.shiftedSmall
    arith.subIsZero := pre.bigMant === pre.shiftedSmall
    arith.special := pre.special
    arith.specialResult := pre.specialResult
    arith
  }

  private def addPre(a: UInt, b: UInt): Float32AddPipelinePre =
    addArith(addShift(addAlign(a, b)))

  private def addNorm(pre: Float32AddPipelinePre): Float32AddNormPre = {
    val norm = Wire(new Float32AddNormPre)
    norm.sign := pre.sign
    norm.exp := pre.exp
    norm.sameSign := pre.sameSign
    norm.addMant := pre.addMant
    norm.subMant := pre.subMant
    norm.subIsZero := pre.subIsZero
    norm.leadingZeros := PriorityEncoder(Reverse(pre.subMant))
    norm.special := pre.special
    norm.specialResult := pre.specialResult
    norm
  }

  private def addPack(pre: Float32AddPipelinePre): UInt =
    addPack(addNorm(pre))

  private def addPack(pre: Float32AddNormPre): UInt = {
    val addExp = Mux(pre.addMant(24), pre.exp + 1.U, pre.exp)
    val addFrac = Mux(pre.addMant(24), pre.addMant(23, 1), pre.addMant(22, 0))
    val addPacked = Cat(pre.sign, addExp(7, 0), addFrac)

    val normalizedSub = (pre.subMant << pre.leadingZeros)(23, 0)
    val subExp = Mux(pre.exp > pre.leadingZeros, pre.exp - pre.leadingZeros, 0.U)
    val subPacked = Cat(pre.sign, subExp(7, 0), normalizedSub(22, 0))

    val finiteResult = Mux(pre.sameSign, addPacked,
      Mux(pre.subIsZero, 0.U(32.W), subPacked))
    Mux(pre.special, pre.specialResult, finiteResult)
  }

  private def mulPre(a: UInt, b: UInt): Float32MulPipelinePre = {
    val pre = Wire(new Float32MulPipelinePre)
    val sign = a(31) ^ b(31)
    val aExp = a(30, 23)
    val bExp = b(30, 23)
    val aMant = Mux(aExp === 0.U, Cat(0.U(1.W), a(22, 0)), Cat(1.U(1.W), a(22, 0)))
    val bMant = Mux(bExp === 0.U, Cat(0.U(1.W), b(22, 0)), Cat(1.U(1.W), b(22, 0)))
    val invalid = Float32Ops.isNaN(a) || Float32Ops.isNaN(b) ||
      ((Float32Ops.isInf(a) && Float32Ops.isZero(b)) || (Float32Ops.isZero(a) && Float32Ops.isInf(b)))
    val infInput = Float32Ops.isInf(a) || Float32Ops.isInf(b)
    val zeroInput = Float32Ops.isZero(a) || Float32Ops.isZero(b)

    pre.sign := sign
    pre.expBase := Cat(0.U(2.W), aExp).asSInt + Cat(0.U(2.W), bExp).asSInt - 127.S(11.W)
    pre.p00 := aMant(11, 0) * bMant(11, 0)
    pre.p01 := aMant(11, 0) * bMant(23, 12)
    pre.p10 := aMant(23, 12) * bMant(11, 0)
    pre.p11 := aMant(23, 12) * bMant(23, 12)
    pre.special := invalid || infInput || zeroInput
    pre.specialResult := Mux(invalid, Float32Ops.canonicalNaN,
      Mux(infInput, Cat(sign, Fill(8, 1.U), 0.U(23.W)), 0.U(32.W)))
    pre
  }

  private def mulChunkPre(a: UInt, b: UInt): Float32MulChunkPre = {
    val pre = Wire(new Float32MulChunkPre)
    val sign = a(31) ^ b(31)
    val aExp = a(30, 23)
    val bExp = b(30, 23)
    val aMant = Mux(aExp === 0.U, Cat(0.U(1.W), a(22, 0)), Cat(1.U(1.W), a(22, 0)))
    val bMant = Mux(bExp === 0.U, Cat(0.U(1.W), b(22, 0)), Cat(1.U(1.W), b(22, 0)))
    val invalid = Float32Ops.isNaN(a) || Float32Ops.isNaN(b) ||
      ((Float32Ops.isInf(a) && Float32Ops.isZero(b)) || (Float32Ops.isZero(a) && Float32Ops.isInf(b)))
    val infInput = Float32Ops.isInf(a) || Float32Ops.isInf(b)
    val zeroInput = Float32Ops.isZero(a) || Float32Ops.isZero(b)

    pre.sign := sign
    pre.expBase := Cat(0.U(2.W), aExp).asSInt + Cat(0.U(2.W), bExp).asSInt - 127.S(11.W)
    for (idx <- 0 until 4) {
      pre.a(idx) := aMant(idx * 6 + 5, idx * 6)
      pre.b(idx) := bMant(idx * 6 + 5, idx * 6)
    }
    pre.special := invalid || infInput || zeroInput
    pre.specialResult := Mux(invalid, Float32Ops.canonicalNaN,
      Mux(infInput, Cat(sign, Fill(8, 1.U), 0.U(23.W)), 0.U(32.W)))
    pre
  }

  private def mulPartials(pre: Float32MulChunkPre): Float32MulPartialPre = {
    val partial = Wire(new Float32MulPartialPre)
    partial.sign := pre.sign
    partial.expBase := pre.expBase
    for (aIdx <- 0 until 4) {
      for (bIdx <- 0 until 4) {
        partial.products(aIdx)(bIdx) := pre.a(aIdx) * pre.b(bIdx)
      }
    }
    partial.special := pre.special
    partial.specialResult := pre.specialResult
    partial
  }

  private def mulDiagonals(pre: Float32MulPartialPre): Float32MulDiagonalPre = {
    val diag = Wire(new Float32MulDiagonalPre)
    diag.sign := pre.sign
    diag.expBase := pre.expBase
    for (idx <- 0 until 7) {
      val terms = (0 until 4).flatMap { aIdx =>
        (0 until 4).filter(bIdx => aIdx + bIdx == idx).map { bIdx =>
          Cat(0.U(4.W), pre.products(aIdx)(bIdx))
        }
      }
      val sum = terms.reduce((lhs, rhs) => lhs +& rhs)
      diag.diagonal(idx) := sum(15, 0)
    }
    diag.special := pre.special
    diag.specialResult := pre.specialResult
    diag
  }

  private def mulLowHigh(pre: Float32MulDiagonalPre): Float32MulLowHighPre = {
    val lowHigh = Wire(new Float32MulLowHighPre)
    def shifted49(value: UInt, shift: Int): UInt = (Cat(0.U(49.W), value) << shift)(48, 0)
    def sum49(values: Seq[UInt]): UInt = values.reduce((lhs, rhs) => (lhs +& rhs)(48, 0))

    lowHigh.sign := pre.sign
    lowHigh.expBase := pre.expBase
    lowHigh.low := sum49((0 until 4).map(idx => shifted49(pre.diagonal(idx), idx * 6)))
    lowHigh.high := sum49((4 until 7).map(idx => shifted49(pre.diagonal(idx), idx * 6)))
    lowHigh.special := pre.special
    lowHigh.specialResult := pre.specialResult
    lowHigh
  }

  private def mulProduct(pre: Float32MulLowHighPre): Float32MulProductPre = {
    val product = Wire(new Float32MulProductPre)
    product.sign := pre.sign
    product.expBase := pre.expBase
    product.product := (pre.low +& pre.high)(47, 0)
    product.special := pre.special
    product.specialResult := pre.specialResult
    product
  }

  private def mulSum(pre: Float32MulPipelinePre): Float32MulSumPre = {
    val sum = Wire(new Float32MulSumPre)
    val partial00 = Cat(0.U(24.W), pre.p00)
    val partial01 = Cat(0.U(12.W), pre.p01, 0.U(12.W))
    val partial10 = Cat(0.U(12.W), pre.p10, 0.U(12.W))
    sum.sign := pre.sign
    sum.expBase := pre.expBase
    sum.lowSum := partial00 +& partial01 +& partial10
    sum.highPart := Cat(pre.p11, 0.U(24.W))
    sum.special := pre.special
    sum.specialResult := pre.specialResult
    sum
  }

  private def mulPack(pre: Float32MulSumPre): UInt = {
    val product = (pre.lowSum +& Cat(0.U(1.W), pre.highPart))(47, 0)
    val normalizedHigh = product(47)
    val expSum = pre.expBase + Mux(normalizedHigh, 1.S(11.W), 0.S(11.W))
    val frac = Mux(normalizedHigh, product(46, 24), product(45, 23))
    val exp = expSum.asUInt
    val infResult = Cat(pre.sign, Fill(8, 1.U), 0.U(23.W))
    val finiteResult = Mux(expSum >= 255.S(11.W), infResult,
      Mux(expSum <= 0.S(11.W), 0.U(32.W), Cat(pre.sign, exp(7, 0), frac)))
    Mux(pre.special, pre.specialResult, finiteResult)
  }

  private def mulPack(pre: Float32MulProductPre): UInt = {
    val normalizedHigh = pre.product(47)
    val expSum = pre.expBase + Mux(normalizedHigh, 1.S(11.W), 0.S(11.W))
    val frac = Mux(normalizedHigh, pre.product(46, 24), pre.product(45, 23))
    val exp = expSum.asUInt
    val infResult = Cat(pre.sign, Fill(8, 1.U), 0.U(23.W))
    val finiteResult = Mux(expSum >= 255.S(11.W), infResult,
      Mux(expSum <= 0.S(11.W), 0.U(32.W), Cat(pre.sign, exp(7, 0), frac)))
    Mux(pre.special, pre.specialResult, finiteResult)
  }

  private def mulPack(pre: Float32MulPipelinePre): UInt = {
    mulPack(mulSum(pre))
  }

  private def simpleResult(opcode: UInt, a: UInt, b: UInt): UInt =
    MuxLookup(opcode, 0.U(32.W))(Seq(
      MIN -> Float32Ops.min(a, b),
      MAX -> Float32Ops.max(a, b),
      SGNJ -> Float32Ops.signInject(a, b),
      SGNJN -> Float32Ops.signInjectNeg(a, b),
      SGNJX -> Float32Ops.signInjectXor(a, b)
    ))

  val s0A = RegNext(io.a)
  val s0B = RegNext(io.b)
  val s0C = RegNext(io.c)
  val s0Opcode = RegNext(io.opcode)

  val s0AddB = Mux(s0Opcode === SUB, Float32Ops.negate(s0B), s0B)
  if (numCycles == 4) {
    val s1Opcode = RegNext(s0Opcode)
    val s1C = RegNext(s0C)
    val s1AddPre = RegNext(addPre(s0A, s0AddB))
    val s1MulPacked = RegNext(Float32Ops.mul(s0A, s0B))
    val s1Simple = RegNext(simpleResult(s0Opcode, s0A, s0B))

    val s1FmaAddend = Mux(s1Opcode === MSUB, Float32Ops.negate(s1C), s1C)
    val s2Opcode = RegNext(s1Opcode)
    val s2AddPacked = RegNext(addPack(s1AddPre))
    val s2MulPacked = RegNext(s1MulPacked)
    val s2FmaPre = RegNext(addPre(s1MulPacked, s1FmaAddend))
    val s2Simple = RegNext(s1Simple)

    val finalResult = MuxLookup(s2Opcode, 0.U(32.W))(Seq(
      ADD -> s2AddPacked,
      SUB -> s2AddPacked,
      MUL -> s2MulPacked,
      MADD -> addPack(s2FmaPre),
      MSUB -> addPack(s2FmaPre),
      MIN -> s2Simple,
      MAX -> s2Simple,
      SGNJ -> s2Simple,
      SGNJN -> s2Simple,
      SGNJX -> s2Simple
    ))

    io.result := ShiftRegister(finalResult, 1)
  } else if (numCycles < 8) {
    val s1Opcode = RegNext(s0Opcode)
    val s1C = RegNext(s0C)
    val s1AddPre = RegNext(addPre(s0A, s0AddB))
    val s1MulPre = RegNext(mulPre(s0A, s0B))
    val s1Simple = RegNext(simpleResult(s0Opcode, s0A, s0B))

    val s2Opcode = RegNext(s1Opcode)
    val s2C = RegNext(s1C)
    val s2AddPacked = RegNext(addPack(s1AddPre))
    val s2MulPacked = RegNext(mulPack(s1MulPre))
    val s2Simple = RegNext(s1Simple)

    val s2FmaAddend = Mux(s2Opcode === MSUB, Float32Ops.negate(s2C), s2C)
    val s3Opcode = RegNext(s2Opcode)
    val s3AddPacked = RegNext(s2AddPacked)
    val s3MulPacked = RegNext(s2MulPacked)
    val s3FmaPre = RegNext(addPre(s2MulPacked, s2FmaAddend))
    val s3Simple = RegNext(s2Simple)

    val finalResult = MuxLookup(s3Opcode, 0.U(32.W))(Seq(
      ADD -> s3AddPacked,
      SUB -> s3AddPacked,
      MUL -> s3MulPacked,
      MADD -> addPack(s3FmaPre),
      MSUB -> addPack(s3FmaPre),
      MIN -> s3Simple,
      MAX -> s3Simple,
      SGNJ -> s3Simple,
      SGNJN -> s3Simple,
      SGNJX -> s3Simple
    ))

    io.result := ShiftRegister(finalResult, numCycles - 4)
  } else if (numCycles < 10) {
    val s1Opcode = RegNext(s0Opcode)
    val s1C = RegNext(s0C)
    val s1AddAlign = RegNext(addAlign(s0A, s0AddB))
    val s1MulPre = RegNext(mulPre(s0A, s0B))
    val s1Simple = RegNext(simpleResult(s0Opcode, s0A, s0B))

    val s2Opcode = RegNext(s1Opcode)
    val s2C = RegNext(s1C)
    val s2AddShift = RegNext(addShift(s1AddAlign))
    val s2MulSum = RegNext(mulSum(s1MulPre))
    val s2Simple = RegNext(s1Simple)

    val s3Opcode = RegNext(s2Opcode)
    val s3C = RegNext(s2C)
    val s3AddArith = RegNext(addArith(s2AddShift))
    val s3MulPacked = RegNext(mulPack(s2MulSum))
    val s3Simple = RegNext(s2Simple)

    val s4Opcode = RegNext(s3Opcode)
    val s4C = RegNext(s3C)
    val s4AddNorm = RegNext(addNorm(s3AddArith))
    val s4MulPacked = RegNext(s3MulPacked)
    val s4Simple = RegNext(s3Simple)

    val s4FmaAddend = Mux(s4Opcode === MSUB, Float32Ops.negate(s4C), s4C)
    val s5Opcode = RegNext(s4Opcode)
    val s5AddPacked = RegNext(addPack(s4AddNorm))
    val s5MulPacked = RegNext(s4MulPacked)
    val s5FmaAlign = RegNext(addAlign(s4MulPacked, s4FmaAddend))
    val s5Simple = RegNext(s4Simple)

    val s6Opcode = RegNext(s5Opcode)
    val s6AddPacked = RegNext(s5AddPacked)
    val s6MulPacked = RegNext(s5MulPacked)
    val s6FmaShift = RegNext(addShift(s5FmaAlign))
    val s6Simple = RegNext(s5Simple)

    val s7Opcode = RegNext(s6Opcode)
    val s7AddPacked = RegNext(s6AddPacked)
    val s7MulPacked = RegNext(s6MulPacked)
    val s7FmaArith = RegNext(addArith(s6FmaShift))
    val s7Simple = RegNext(s6Simple)

    val s8Opcode = RegNext(s7Opcode)
    val s8AddPacked = RegNext(s7AddPacked)
    val s8MulPacked = RegNext(s7MulPacked)
    val s8FmaNorm = RegNext(addNorm(s7FmaArith))
    val s8Simple = RegNext(s7Simple)

    val finalResult = MuxLookup(s8Opcode, 0.U(32.W))(Seq(
      ADD -> s8AddPacked,
      SUB -> s8AddPacked,
      MUL -> s8MulPacked,
      MADD -> addPack(s8FmaNorm),
      MSUB -> addPack(s8FmaNorm),
      MIN -> s8Simple,
      MAX -> s8Simple,
      SGNJ -> s8Simple,
      SGNJN -> s8Simple,
      SGNJX -> s8Simple
    ))

    io.result := ShiftRegister(finalResult, numCycles - 8)
  } else {
    val s1Opcode = RegNext(s0Opcode)
    val s1C = RegNext(s0C)
    val s1AddAlign = RegNext(addAlign(s0A, s0AddB))
    val s1MulChunks = RegNext(mulChunkPre(s0A, s0B))
    val s1Simple = RegNext(simpleResult(s0Opcode, s0A, s0B))

    val s2Opcode = RegNext(s1Opcode)
    val s2C = RegNext(s1C)
    val s2AddShift = RegNext(addShift(s1AddAlign))
    val s2MulPartials = RegNext(mulPartials(s1MulChunks))
    val s2Simple = RegNext(s1Simple)

    val s3Opcode = RegNext(s2Opcode)
    val s3C = RegNext(s2C)
    val s3AddArith = RegNext(addArith(s2AddShift))
    val s3MulDiagonal = RegNext(mulDiagonals(s2MulPartials))
    val s3Simple = RegNext(s2Simple)

    val s4Opcode = RegNext(s3Opcode)
    val s4C = RegNext(s3C)
    val s4AddNorm = RegNext(addNorm(s3AddArith))
    val s4MulLowHigh = RegNext(mulLowHigh(s3MulDiagonal))
    val s4Simple = RegNext(s3Simple)

    val s5Opcode = RegNext(s4Opcode)
    val s5C = RegNext(s4C)
    val s5AddPacked = RegNext(addPack(s4AddNorm))
    val s5MulProduct = RegNext(mulProduct(s4MulLowHigh))
    val s5Simple = RegNext(s4Simple)

    val s6Opcode = RegNext(s5Opcode)
    val s6C = RegNext(s5C)
    val s6AddPacked = RegNext(s5AddPacked)
    val s6MulPacked = RegNext(mulPack(s5MulProduct))
    val s6Simple = RegNext(s5Simple)

    val s6FmaAddend = Mux(s6Opcode === MSUB, Float32Ops.negate(s6C), s6C)
    val s7Opcode = RegNext(s6Opcode)
    val s7AddPacked = RegNext(s6AddPacked)
    val s7MulPacked = RegNext(s6MulPacked)
    val s7FmaAlign = RegNext(addAlign(s6MulPacked, s6FmaAddend))
    val s7Simple = RegNext(s6Simple)

    val s8Opcode = RegNext(s7Opcode)
    val s8AddPacked = RegNext(s7AddPacked)
    val s8MulPacked = RegNext(s7MulPacked)
    val s8FmaShift = RegNext(addShift(s7FmaAlign))
    val s8Simple = RegNext(s7Simple)

    val s9Opcode = RegNext(s8Opcode)
    val s9AddPacked = RegNext(s8AddPacked)
    val s9MulPacked = RegNext(s8MulPacked)
    val s9FmaArith = RegNext(addArith(s8FmaShift))
    val s9Simple = RegNext(s8Simple)

    val s10Opcode = RegNext(s9Opcode)
    val s10AddPacked = RegNext(s9AddPacked)
    val s10MulPacked = RegNext(s9MulPacked)
    val s10FmaNorm = RegNext(addNorm(s9FmaArith))
    val s10Simple = RegNext(s9Simple)

    val finalResult = MuxLookup(s10Opcode, 0.U(32.W))(Seq(
      ADD -> s10AddPacked,
      SUB -> s10AddPacked,
      MUL -> s10MulPacked,
      MADD -> addPack(s10FmaNorm),
      MSUB -> addPack(s10FmaNorm),
      MIN -> s10Simple,
      MAX -> s10Simple,
      SGNJ -> s10Simple,
      SGNJN -> s10Simple,
      SGNJX -> s10Simple
    ))

    io.result := ShiftRegister(finalResult, numCycles - 10)
  }
}

class Float32DivSqrtUnit extends Module {
  val io = IO(new Bundle {
    val start = Input(Bool())
    val sqrt = Input(Bool())
    val a = Input(UInt(32.W))
    val b = Input(UInt(32.W))

    val busy = Output(Bool())
    val done = Output(Bool())
    val result = Output(UInt(32.W))
    val flags = Output(UInt(5.W))
  })

  private val divInputBits = 52
  private val sqrtInputBits = 58
  private val divIterations = divInputBits
  private val sqrtIterations = 29

  private val sIdle :: sPrepDecode :: sPrepLz :: sPrepNorm :: sPrepStart :: sDiv :: sDivFinish :: sSqrt :: sSqrtFinish :: sPackRound :: sPackClassify :: sPackShift :: sPackFinish :: Nil = Enum(13)

  private def normalizedExpAndMant(exp: UInt, frac: UInt): (SInt, UInt) = {
    val leadingZeros = PriorityEncoder(Reverse(frac))
    val subShift = leadingZeros + 1.U
    val subMant = (Cat(0.U(1.W), frac) << subShift)(23, 0)
    val normalExp = Cat(0.U(3.W), exp).asSInt - 127.S(11.W)
    val subExp = (-126).S(11.W) - Cat(0.U(6.W), subShift).asSInt
    (Mux(exp === 0.U, subExp, normalExp), Mux(exp === 0.U, subMant, Cat(1.U(1.W), frac)))
  }

  private def packRounded(sign: Bool, expBase: SInt, scaled: UInt, remNonZero: Bool): (UInt, UInt) = {
    val main = scaled(28, 5)
    val guard = scaled(4)
    val round = scaled(3)
    val sticky = scaled(2, 0).orR || remNonZero
    val inexact = guard || round || sticky
    val increment = guard && (round || sticky || main(0))
    val rounded = Cat(0.U(1.W), main) + increment.asUInt
    val carry = rounded(24)
    val mantissa = Mux(carry, rounded(24, 1), rounded(23, 0))
    val expRounded = expBase + Mux(carry, 1.S, 0.S)
    val biased = expRounded + 127.S(11.W)

    val overflow = biased >= 255.S
    val underflow = biased <= 0.S
    val subShift = (1.S(11.W) - biased).asUInt
    val subMantissa = Mux(subShift >= 31.U, 0.U(24.W), mantissa >> subShift(4, 0))
    val finiteResult = Mux(underflow,
      Cat(sign, 0.U(8.W), subMantissa(22, 0)),
      Cat(sign, biased.asUInt(7, 0), mantissa(22, 0)))
    val result = Mux(overflow, Cat(sign, Fill(8, 1.U), 0.U(23.W)), finiteResult)
    val flags = Mux(overflow, Float32Ops.Flags.OF | Float32Ops.Flags.NX,
      Mux(underflow && inexact, Float32Ops.Flags.UF | Float32Ops.Flags.NX,
        Mux(inexact, Float32Ops.Flags.NX, 0.U(5.W))))
    (result, flags)
  }

  private def packDivResult(sign: Bool, expBase: SInt, quotient: UInt, remainder: UInt): (UInt, UInt) = {
    val raw = quotient(28, 0)
    val geOne = raw(28)
    val scaled = Mux(geOne, raw, Cat(raw(27, 0), 0.U(1.W)))
    val expNorm = expBase - Mux(geOne, 0.S, 1.S)
    packRounded(sign, expNorm, scaled, remainder.orR)
  }

  private def packSqrtResult(sign: Bool, expBase: SInt, root: UInt, remainder: UInt): (UInt, UInt) =
    packRounded(sign, expBase, root(28, 0), remainder.orR)

  val stateReg = RegInit(sIdle)
  val doneReg = RegInit(false.B)
  val resultReg = RegInit(0.U(32.W))
  val flagsReg = RegInit(0.U(5.W))

  val reqSqrtReg = RegInit(false.B)
  val reqAReg = RegInit(0.U(32.W))
  val reqBReg = RegInit(0.U(32.W))

  val aSignInReg = RegInit(false.B)
  val bSignInReg = RegInit(false.B)
  val aExpInReg = RegInit(0.U(8.W))
  val bExpInReg = RegInit(0.U(8.W))
  val aFracInReg = RegInit(0.U(23.W))
  val bFracInReg = RegInit(0.U(23.W))
  val aIsNaNReg = RegInit(false.B)
  val bIsNaNReg = RegInit(false.B)
  val aIsSNaNReg = RegInit(false.B)
  val bIsSNaNReg = RegInit(false.B)
  val aIsZeroReg = RegInit(false.B)
  val bIsZeroReg = RegInit(false.B)
  val aIsInfReg = RegInit(false.B)
  val bIsInfReg = RegInit(false.B)
  val aLeadingZerosReg = RegInit(0.U(5.W))
  val bLeadingZerosReg = RegInit(0.U(5.W))

  val aNormExpReg = RegInit(0.S(11.W))
  val bNormExpReg = RegInit(0.S(11.W))
  val aNormMantReg = RegInit(0.U(24.W))
  val bNormMantReg = RegInit(0.U(24.W))

  val signReg = RegInit(false.B)
  val expReg = RegInit(0.S(11.W))

  val divDividendReg = RegInit(0.U(divInputBits.W))
  val divDivisorReg = RegInit(0.U(24.W))
  val divRemainderReg = RegInit(0.U(54.W))
  val divQuotientReg = RegInit(0.U(divInputBits.W))
  val divCountReg = RegInit(0.U(6.W))

  val sqrtRadicandReg = RegInit(0.U(sqrtInputBits.W))
  val sqrtRemainderReg = RegInit(0.U(60.W))
  val sqrtRootReg = RegInit(0.U(sqrtIterations.W))
  val sqrtCountReg = RegInit(0.U(5.W))

  val packSignReg = RegInit(false.B)
  val packExpReg = RegInit(0.S(11.W))
  val packScaledReg = RegInit(0.U(29.W))
  val packRemNonZeroReg = RegInit(false.B)

  val roundSignReg = RegInit(false.B)
  val roundExpReg = RegInit(0.S(11.W))
  val roundMantissaReg = RegInit(0.U(24.W))
  val roundInexactReg = RegInit(false.B)

  val classBiasedReg = RegInit(0.S(11.W))
  val classOverflowReg = RegInit(false.B)
  val classUnderflowReg = RegInit(false.B)
  val classSubShiftReg = RegInit(0.U(5.W))
  val subMantissaReg = RegInit(0.U(24.W))

  doneReg := false.B

  when(io.start && stateReg === sIdle) {
    reqSqrtReg := io.sqrt
    reqAReg := io.a
    reqBReg := io.b
    stateReg := sPrepDecode
  }.elsewhen(stateReg === sPrepDecode) {
    aSignInReg := reqAReg(31)
    bSignInReg := reqBReg(31)
    aExpInReg := reqAReg(30, 23)
    bExpInReg := reqBReg(30, 23)
    aFracInReg := reqAReg(22, 0)
    bFracInReg := reqBReg(22, 0)
    aIsNaNReg := reqAReg(30, 23) === "hff".U && reqAReg(22, 0) =/= 0.U
    bIsNaNReg := reqBReg(30, 23) === "hff".U && reqBReg(22, 0) =/= 0.U
    aIsSNaNReg := reqAReg(30, 23) === "hff".U && reqAReg(22, 0) =/= 0.U && !reqAReg(22)
    bIsSNaNReg := reqBReg(30, 23) === "hff".U && reqBReg(22, 0) =/= 0.U && !reqBReg(22)
    aIsZeroReg := reqAReg(30, 0) === 0.U
    bIsZeroReg := reqBReg(30, 0) === 0.U
    aIsInfReg := reqAReg(30, 23) === "hff".U && reqAReg(22, 0) === 0.U
    bIsInfReg := reqBReg(30, 23) === "hff".U && reqBReg(22, 0) === 0.U
    stateReg := sPrepLz
  }.elsewhen(stateReg === sPrepLz) {
    aLeadingZerosReg := PriorityEncoder(Reverse(aFracInReg))
    bLeadingZerosReg := PriorityEncoder(Reverse(bFracInReg))
    stateReg := sPrepNorm
  }.elsewhen(stateReg === sPrepNorm) {
    val aSubShift = aLeadingZerosReg + 1.U
    val bSubShift = bLeadingZerosReg + 1.U
    val aSubMant = (Cat(0.U(1.W), aFracInReg) << aSubShift)(23, 0)
    val bSubMant = (Cat(0.U(1.W), bFracInReg) << bSubShift)(23, 0)
    val aNormalExp = Cat(0.U(3.W), aExpInReg).asSInt - 127.S(11.W)
    val bNormalExp = Cat(0.U(3.W), bExpInReg).asSInt - 127.S(11.W)
    val aSubExp = (-126).S(11.W) - Cat(0.U(6.W), aSubShift).asSInt
    val bSubExp = (-126).S(11.W) - Cat(0.U(6.W), bSubShift).asSInt
    aNormExpReg := Mux(aExpInReg === 0.U, aSubExp, aNormalExp)
    bNormExpReg := Mux(bExpInReg === 0.U, bSubExp, bNormalExp)
    aNormMantReg := Mux(aExpInReg === 0.U, aSubMant, Cat(1.U(1.W), aFracInReg))
    bNormMantReg := Mux(bExpInReg === 0.U, bSubMant, Cat(1.U(1.W), bFracInReg))
    stateReg := sPrepStart
  }.elsewhen(stateReg === sPrepStart) {
    val divSign = aSignInReg ^ bSignInReg
    val divInvalid = aIsSNaNReg || bIsSNaNReg ||
      (aIsZeroReg && bIsZeroReg) || (aIsInfReg && bIsInfReg)
    val divByZero = !aIsNaNReg && !bIsNaNReg && !aIsInfReg && !aIsZeroReg && bIsZeroReg
    val sqrtInvalid = aIsSNaNReg || (aSignInReg && !aIsZeroReg && !aIsNaNReg)

    stateReg := sIdle
    when(reqSqrtReg) {
      when(sqrtInvalid) {
        resultReg := Float32Ops.canonicalNaN
        flagsReg := Float32Ops.Flags.NV
        doneReg := true.B
      }.elsewhen(aIsNaNReg) {
        resultReg := Float32Ops.canonicalNaN
        flagsReg := Mux(aIsSNaNReg, Float32Ops.Flags.NV, 0.U)
        doneReg := true.B
      }.elsewhen(aIsZeroReg || aIsInfReg) {
        resultReg := reqAReg
        flagsReg := 0.U
        doneReg := true.B
      }.otherwise {
        val oddExp = aNormExpReg.asUInt(0)
        val sqrtMant = Mux(oddExp, Cat(aNormMantReg, 0.U(1.W)), Cat(0.U(1.W), aNormMantReg))
        val sqrtExp = Mux(oddExp, aNormExpReg - 1.S, aNormExpReg) >> 1
        val radicand = Cat(0.U((sqrtInputBits - 25).W), sqrtMant) << (56 - 23)
        signReg := aSignInReg
        expReg := sqrtExp
        sqrtRadicandReg := radicand(sqrtInputBits - 1, 0)
        sqrtRemainderReg := 0.U
        sqrtRootReg := 0.U
        sqrtCountReg := 0.U
        stateReg := sSqrt
      }
    }.otherwise {
      when(divInvalid) {
        resultReg := Float32Ops.canonicalNaN
        flagsReg := Float32Ops.Flags.NV
        doneReg := true.B
      }.elsewhen(aIsNaNReg || bIsNaNReg) {
        resultReg := Float32Ops.canonicalNaN
        flagsReg := Mux(aIsSNaNReg || bIsSNaNReg, Float32Ops.Flags.NV, 0.U)
        doneReg := true.B
      }.elsewhen(divByZero) {
        resultReg := Cat(divSign, Fill(8, 1.U), 0.U(23.W))
        flagsReg := Float32Ops.Flags.DZ
        doneReg := true.B
      }.elsewhen(aIsInfReg) {
        resultReg := Cat(divSign, Fill(8, 1.U), 0.U(23.W))
        flagsReg := 0.U
        doneReg := true.B
      }.elsewhen(bIsInfReg) {
        resultReg := Cat(divSign, 0.U(31.W))
        flagsReg := 0.U
        doneReg := true.B
      }.elsewhen(aIsZeroReg) {
        resultReg := Cat(divSign, 0.U(31.W))
        flagsReg := 0.U
        doneReg := true.B
      }.otherwise {
        signReg := divSign
        expReg := aNormExpReg - bNormExpReg
        divDividendReg := Cat(aNormMantReg, 0.U(28.W))
        divDivisorReg := bNormMantReg
        divRemainderReg := 0.U
        divQuotientReg := 0.U
        divCountReg := 0.U
        stateReg := sDiv
      }
    }
  }.elsewhen(stateReg === sDiv) {
    val shiftedRemainder = Cat(divRemainderReg(52, 0), divDividendReg(divInputBits - 1))
    val divisorWide = Cat(0.U(30.W), divDivisorReg)
    val subtract = shiftedRemainder - divisorWide
    val takeBit = shiftedRemainder >= divisorWide
    val nextRemainder = Mux(takeBit, subtract, shiftedRemainder)
    val nextQuotient = Cat(divQuotientReg(divInputBits - 2, 0), takeBit)
    val nextDividend = Cat(divDividendReg(divInputBits - 2, 0), 0.U(1.W))

    divRemainderReg := nextRemainder
    divQuotientReg := nextQuotient
    divDividendReg := nextDividend
    divCountReg := divCountReg + 1.U
    when(divCountReg === (divIterations - 1).U) {
      stateReg := sDivFinish
    }
  }.elsewhen(stateReg === sDivFinish) {
    val raw = divQuotientReg(28, 0)
    val geOne = raw(28)
    packSignReg := signReg
    packExpReg := expReg - Mux(geOne, 0.S(11.W), 1.S(11.W))
    packScaledReg := Mux(geOne, raw, Cat(raw(27, 0), 0.U(1.W)))
    packRemNonZeroReg := divRemainderReg.orR
    stateReg := sPackRound
  }.elsewhen(stateReg === sSqrt) {
    val topPair = sqrtRadicandReg(sqrtInputBits - 1, sqrtInputBits - 2)
    val shiftedRemainder = Cat(sqrtRemainderReg(57, 0), topPair)
    val trial = Cat(0.U(29.W), sqrtRootReg, 1.U(2.W))
    val takeBit = shiftedRemainder >= trial
    val nextRemainder = Mux(takeBit, shiftedRemainder - trial, shiftedRemainder)
    val nextRoot = Cat(sqrtRootReg(sqrtIterations - 2, 0), takeBit)
    val nextRadicand = Cat(sqrtRadicandReg(sqrtInputBits - 3, 0), 0.U(2.W))

    sqrtRemainderReg := nextRemainder
    sqrtRootReg := nextRoot
    sqrtRadicandReg := nextRadicand
    sqrtCountReg := sqrtCountReg + 1.U
    when(sqrtCountReg === (sqrtIterations - 1).U) {
      stateReg := sSqrtFinish
    }
  }.elsewhen(stateReg === sSqrtFinish) {
    packSignReg := signReg
    packExpReg := expReg
    packScaledReg := sqrtRootReg(28, 0)
    packRemNonZeroReg := sqrtRemainderReg.orR
    stateReg := sPackRound
  }.elsewhen(stateReg === sPackRound) {
    val main = packScaledReg(28, 5)
    val guard = packScaledReg(4)
    val round = packScaledReg(3)
    val sticky = packScaledReg(2, 0).orR || packRemNonZeroReg
    val inexact = guard || round || sticky
    val increment = guard && (round || sticky || main(0))
    val rounded = Cat(0.U(1.W), main) + increment.asUInt
    val carry = rounded(24)

    roundSignReg := packSignReg
    roundMantissaReg := Mux(carry, rounded(24, 1), rounded(23, 0))
    roundExpReg := packExpReg + Mux(carry, 1.S(11.W), 0.S(11.W))
    roundInexactReg := inexact
    stateReg := sPackClassify
  }.elsewhen(stateReg === sPackClassify) {
    val biased = roundExpReg + 127.S(11.W)
    val rawSubShift = (1.S(11.W) - biased).asUInt

    classBiasedReg := biased
    classOverflowReg := biased >= 255.S(11.W)
    classUnderflowReg := biased <= 0.S(11.W)
    classSubShiftReg := Mux(rawSubShift >= 31.U, 31.U(5.W), rawSubShift(4, 0))
    stateReg := sPackShift
  }.elsewhen(stateReg === sPackShift) {
    subMantissaReg := Mux(classSubShiftReg === 31.U, 0.U(24.W), roundMantissaReg >> classSubShiftReg)
    stateReg := sPackFinish
  }.elsewhen(stateReg === sPackFinish) {
    val finiteResult = Mux(classUnderflowReg,
      Cat(roundSignReg, 0.U(8.W), subMantissaReg(22, 0)),
      Cat(roundSignReg, classBiasedReg.asUInt(7, 0), roundMantissaReg(22, 0)))
    resultReg := Mux(classOverflowReg, Cat(roundSignReg, Fill(8, 1.U), 0.U(23.W)), finiteResult)
    flagsReg := Mux(classOverflowReg, Float32Ops.Flags.OF | Float32Ops.Flags.NX,
      Mux(classUnderflowReg && roundInexactReg, Float32Ops.Flags.UF | Float32Ops.Flags.NX,
        Mux(roundInexactReg, Float32Ops.Flags.NX, 0.U(5.W))))
    stateReg := sIdle
    doneReg := true.B
  }

  io.busy := stateReg =/= sIdle
  io.done := doneReg
  io.result := resultReg
  io.flags := flagsReg
}
