package Pipeline

import chisel3._
import chisel3.util._

/**
 * A pipeline scheduler that provides per-stage thread selections based on a given threadSelect input.
  */
class PipelineScheduler(numThreads: Int, defaultThread: Int) extends Module {
  private val threadBits = log2Ceil(numThreads)

  val io = IO(new Bundle {
    val threadSelect = Output(UInt(threadBits.W)) 
   })

  // Starts at defaultThread
  val threadSelReg = RegInit(defaultThread.U(threadBits.W))

  // Progress round robin every cycle
  threadSelReg := Mux(threadSelReg === (numThreads-1).U, 0.U, threadSelReg + 1.U)

  io.threadSelect := threadSelReg
}
