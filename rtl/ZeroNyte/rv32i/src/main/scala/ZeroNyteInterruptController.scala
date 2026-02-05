package ZeroNyte

import chisel3._
import chisel3.util._

class ZeroNyteInterruptController(numSources: Int = 8) extends Module {
  private val sourceBits = math.max(1, numSources)

  val io = IO(new Bundle {
    val irqSources = Input(UInt(sourceBits.W))

    val enableMask = Input(UInt(sourceBits.W))
    val complete = Input(Bool())

    val pending = Output(UInt(sourceBits.W))
    val hasInterrupt = Output(Bool())
    val claimId = Output(UInt(log2Ceil(numSources + 1).W))
  })

  val pendingReg = RegInit(0.U(sourceBits.W))
  pendingReg := pendingReg | io.irqSources

  val activeMask = pendingReg & io.enableMask
  val hasInterrupt = activeMask.orR

  val claimedIdx = PriorityEncoder(activeMask)
  val claimOneHot = UIntToOH(claimedIdx, sourceBits)

  when(io.complete && hasInterrupt) {
    pendingReg := pendingReg & (~claimOneHot).asUInt
  }

  io.pending := pendingReg
  io.hasInterrupt := hasInterrupt
  io.claimId := Mux(hasInterrupt, claimedIdx + 1.U, 0.U)
}
