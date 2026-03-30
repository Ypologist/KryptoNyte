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

  require(numCycles >= 1, "Pipelined Multiplier must have at least 1 cycle of latency.")

  // Stage 1: Input alignment and operand extension
  val opA = Mux(io.signedA, io.a.asSInt, io.a.zext.asSInt)
  val opB = Mux(io.signedB, io.b.asSInt, io.b.zext.asSInt)

  // Stage 2: Hardware multiplication (Combinational inference)
  val prodCombinational = (opA * opB).asUInt(63, 0)

  // Retiming pipeline wrapper: Registers sequentially injected to allow external 
  // synthesizer logic (Yosys) to perform structural register-retiming natively across the tree.
  val delayedProd = ShiftRegister(prodCombinational, numCycles)

  io.product := delayedProd
  io.lo := delayedProd(31, 0)
  io.hi := delayedProd(63, 32)
}
