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

  private val sIdle :: sDiv :: sSqrt :: Nil = Enum(3)

  private def normalizedExpAndMant(value: UInt): (SInt, UInt) = {
    val exp = value(30, 23)
    val frac = value(22, 0)
    val leadingZeros = PriorityEncoder(Reverse(frac))
    val subShift = leadingZeros + 1.U
    val subMant = (Cat(0.U(1.W), frac) << subShift)(23, 0)
    val normalExp = Cat(0.U(1.W), exp).asSInt - 127.S(10.W)
    val subExp = (-126).S(10.W) - Cat(0.U(1.W), subShift).asSInt
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

  doneReg := false.B

  val (aExp, aMant) = normalizedExpAndMant(io.a)
  val (bExp, bMant) = normalizedExpAndMant(io.b)
  val divSign = io.a(31) ^ io.b(31)
  val sqrtSign = io.a(31)

  when(io.start && stateReg === sIdle) {
    val aIsNaN = Float32Ops.isNaN(io.a)
    val bIsNaN = Float32Ops.isNaN(io.b)
    val aIsZero = Float32Ops.isZero(io.a)
    val bIsZero = Float32Ops.isZero(io.b)
    val aIsInf = Float32Ops.isInf(io.a)
    val bIsInf = Float32Ops.isInf(io.b)
    val divInvalid = Float32Ops.invalidForDiv(io.a, io.b)
    val divByZero = !aIsNaN && !bIsNaN && !aIsInf && !aIsZero && bIsZero
    val sqrtInvalid = Float32Ops.invalidForSqrt(io.a)

    when(io.sqrt) {
      when(sqrtInvalid) {
        resultReg := Float32Ops.canonicalNaN
        flagsReg := Float32Ops.Flags.NV
        doneReg := true.B
      }.elsewhen(aIsNaN) {
        resultReg := Float32Ops.canonicalNaN
        flagsReg := Mux(Float32Ops.isSignalingNaN(io.a), Float32Ops.Flags.NV, 0.U)
        doneReg := true.B
      }.elsewhen(aIsZero || aIsInf) {
        resultReg := io.a
        flagsReg := 0.U
        doneReg := true.B
      }.otherwise {
        val oddExp = aExp.asUInt(0)
        val sqrtMant = Mux(oddExp, Cat(aMant, 0.U(1.W)), Cat(0.U(1.W), aMant))
        val sqrtExp = Mux(oddExp, aExp - 1.S, aExp) >> 1
        val radicand = Cat(0.U((sqrtInputBits - 25).W), sqrtMant) << (56 - 23)
        signReg := sqrtSign
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
      }.elsewhen(aIsNaN || bIsNaN) {
        resultReg := Float32Ops.canonicalNaN
        flagsReg := Mux(Float32Ops.isSignalingNaN(io.a) || Float32Ops.isSignalingNaN(io.b),
          Float32Ops.Flags.NV, 0.U)
        doneReg := true.B
      }.elsewhen(divByZero) {
        resultReg := Cat(divSign, Fill(8, 1.U), 0.U(23.W))
        flagsReg := Float32Ops.Flags.DZ
        doneReg := true.B
      }.elsewhen(aIsInf) {
        resultReg := Cat(divSign, Fill(8, 1.U), 0.U(23.W))
        flagsReg := 0.U
        doneReg := true.B
      }.elsewhen(bIsInf) {
        resultReg := Cat(divSign, 0.U(31.W))
        flagsReg := 0.U
        doneReg := true.B
      }.elsewhen(aIsZero) {
        resultReg := Cat(divSign, 0.U(31.W))
        flagsReg := 0.U
        doneReg := true.B
      }.otherwise {
        signReg := divSign
        expReg := aExp - bExp
        divDividendReg := Cat(aMant, 0.U(28.W))
        divDivisorReg := bMant
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
      val packed = packDivResult(signReg, expReg, nextQuotient, nextRemainder)
      resultReg := packed._1
      flagsReg := packed._2
      stateReg := sIdle
      doneReg := true.B
    }
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
      val packed = packSqrtResult(signReg, expReg, nextRoot, nextRemainder)
      resultReg := packed._1
      flagsReg := packed._2
      stateReg := sIdle
      doneReg := true.B
    }
  }

  io.busy := stateReg =/= sIdle
  io.done := doneReg
  io.result := resultReg
  io.flags := flagsReg
}
