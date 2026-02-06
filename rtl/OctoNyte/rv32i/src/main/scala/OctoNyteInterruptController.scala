package OctoNyte

import chisel3._
import chisel3.util._

/** Simple OctoNyte interrupt controller (PLIC-like core behavior).
  *
  * - Latches asserted irq sources into pending bits
  * - Applies enable mask
  * - Exposes highest-priority claimId (lowest index wins)
  * - Clears claimed source on completion pulse
  */
class OctoNyteInterruptController(numSources: Int = 8) extends Module {
  require(numSources > 0, "numSources must be > 0")

  private val sourceBits = numSources
  private val claimBits = log2Ceil(numSources + 1)

  val io = IO(new Bundle {
    val irqSources = Input(UInt(sourceBits.W))
    val enableMask = Input(UInt(sourceBits.W))
    val complete = Input(Bool())

    val pending = Output(UInt(sourceBits.W))
    val hasInterrupt = Output(Bool())
    val claimId = Output(UInt(claimBits.W))
  })

  val pendingReg = RegInit(0.U(sourceBits.W))

  // Latch incoming interrupts as pending until completed.
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
