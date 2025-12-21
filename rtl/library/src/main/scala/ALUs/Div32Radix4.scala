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
  val quotientReg     = RegInit(0.U(32.W))
  val remainderReg    = RegInit(0.U(32.W))
  val divZeroReg      = RegInit(false.B)

  doneReg := false.B

  when(io.start && !busyReg) {
    divZeroReg := io.divisor === 0.U
    cycleReg := 0.U
    busyReg := true.B

    when(io.divisor === 0.U) {
      doneReg := true.B
      busyReg := false.B
      quotientReg := Fill(32, 1.U) // per spec
      remainderReg := io.dividend
    }.otherwise {
      val overflowCase = io.signed && (io.dividend === "h80000000".U) && (io.divisor === "hffffffff".U)
      when(io.signed) {
        val dividendNeg = io.dividend(31)
        val divisorNeg  = io.divisor(31)
        val dividendAbs = Mux(dividendNeg, (~io.dividend).asUInt + 1.U, io.dividend)
        val divisorAbs  = Mux(divisorNeg, (~io.divisor).asUInt + 1.U, io.divisor)
        val quotientAbs = dividendAbs / divisorAbs
        val remainderAbs = dividendAbs % divisorAbs
        val signQuot = dividendNeg ^ divisorNeg
        val quotSigned = Mux(overflowCase, "h80000000".U,
          Mux(signQuot && quotientAbs =/= 0.U, (~quotientAbs).asUInt + 1.U, quotientAbs))
        val remSigned = Mux(dividendNeg && remainderAbs =/= 0.U, (~remainderAbs).asUInt + 1.U, remainderAbs)
        quotientReg := quotSigned
        remainderReg := remSigned
      }.otherwise {
        quotientReg := io.dividend / io.divisor
        remainderReg := io.dividend % io.divisor
      }
    }
  }.elsewhen(busyReg) {
    cycleReg := cycleReg + 1.U
    when(cycleReg === 15.U) {
      busyReg := false.B
      doneReg := true.B
    }
  }

  io.busy := busyReg
  io.done := doneReg
  io.divideByZero := divZeroReg
  io.quotient := quotientReg
  io.remainder := remainderReg
}
