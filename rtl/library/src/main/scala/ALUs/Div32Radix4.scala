package ALUs

import chisel3._
import chisel3.util._

/**
 * 32-bit divider that completes in 16 cycles by performing two restoring
 * division iterations per cycle (radix-4 style). Supports signed/unsigned
 * operation, signals divide-by-zero, and exposes a simple start/busy/done
 * handshake.
 */
class Div32Radix4 extends Module {
  val io = IO(new Bundle {
    val start    = Input(Bool())
    val signed   = Input(Bool())
    val dividend = Input(UInt(32.W))
    val divisor  = Input(UInt(32.W))

    val busy        = Output(Bool())
    val done        = Output(Bool())
    val quotient    = Output(UInt(32.W))
    val remainder   = Output(UInt(32.W))
    val divideByZero = Output(Bool())
  })

  val busyReg         = RegInit(false.B)
  val doneReg         = RegInit(false.B)
  val cycleReg        = RegInit(0.U(5.W)) // 0 through 15
  val dividendReg     = Reg(UInt(32.W))
  val divisorReg      = Reg(UInt(33.W))   // one extra bit for comparisons
  val remainderReg    = Reg(UInt(33.W))   // one extra bit for intermediate remainder
  val quotientReg     = Reg(UInt(32.W))
  val signQuotientReg = Reg(Bool())
  val signRemainderReg= Reg(Bool())
  val divZeroReg      = RegInit(false.B)

  doneReg := false.B

  val signedOp    = io.signed
  val dividendNeg = signedOp && io.dividend(31)
  val divisorNeg  = signedOp && io.divisor(31)
  val dividendAbs = Mux(dividendNeg, (~io.dividend).asUInt + 1.U, io.dividend)
  val divisorAbs  = Mux(divisorNeg, (~io.divisor).asUInt + 1.U, io.divisor)

  when(io.start && !busyReg) {
    divZeroReg := io.divisor === 0.U
    quotientReg := 0.U
    remainderReg := 0.U
    cycleReg := 0.U
    signQuotientReg := signedOp && (dividendNeg ^ divisorNeg)
    signRemainderReg := dividendNeg && signedOp
    dividendReg := dividendAbs
    divisorReg := Cat(0.U(1.W), divisorAbs) // 33-bit divisor for comparison

    when(io.divisor === 0.U) {
      busyReg := false.B
      doneReg := true.B
      // RISC-V DIV/DIVU define quotient as -1/all-ones on divide-by-zero,
      // remainder equals the dividend.
      quotientReg := Fill(32, 1.U)
      remainderReg := Cat(0.U(1.W), io.dividend)
    }.otherwise {
      busyReg := true.B
    }
  }.elsewhen(busyReg) {
    // Two restoring steps per cycle
    val bitIdxHigh = 31.U - (cycleReg << 1)
    val bitIdxLow  = bitIdxHigh - 1.U

    val highBit = (dividendReg >> bitIdxHigh)(0)
    val remShift1 = Cat(remainderReg(31, 0), highBit) // keep width at 33
    val remSub1 = (remShift1.asSInt - divisorReg.asSInt)
    val setBitHigh = remSub1 >= 0.S
    val remAfter1 = Mux(setBitHigh, remSub1.asUInt, remShift1)
    val quoAfter1 = quotientReg | (setBitHigh.asUInt << bitIdxHigh)

    val lowBit = (dividendReg >> bitIdxLow)(0)
    val remShift2 = Cat(remAfter1(31, 0), lowBit)
    val remSub2 = (remShift2.asSInt - divisorReg.asSInt)
    val setBitLow = remSub2 >= 0.S
    val remAfter2 = Mux(setBitLow, remSub2.asUInt, remShift2)
    val quoAfter2 = quoAfter1 | (setBitLow.asUInt << bitIdxLow)

    remainderReg := remAfter2
    quotientReg := quoAfter2
    cycleReg := cycleReg + 1.U

    when(cycleReg === 15.U) {
      busyReg := false.B
      doneReg := true.B
    }
  }

  val quotientAbs  = quotientReg
  val remainderAbs = remainderReg(31, 0)

  val quotientOut = Mux(signQuotientReg && quotientAbs =/= 0.U,
    (~quotientAbs).asUInt + 1.U,
    quotientAbs)

  val remainderOut = Mux(signRemainderReg && remainderAbs =/= 0.U,
    (~remainderAbs).asUInt + 1.U,
    remainderAbs)

  io.busy := busyReg
  io.done := doneReg
  io.divideByZero := divZeroReg
  io.quotient := quotientOut
  io.remainder := remainderOut
}
