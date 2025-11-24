package Pipeline

import chisel3._
import chisel3.util._

/**
  * PipelineScheduler: assigns one thread to each pipeline stage in a fixed barrel pattern.
  *
  * For numThreads == stageCount (typical barrel threading), initialize thread t to stage t,
  * and every cycle increment all thread stage counters mod stageCount.
  * The owner of stage i is the unique thread whose counter == i.
  *
  * Outputs:
  *  - stageThreads(i): thread ID that owns stage i on this cycle
  *  - stageValids(i):  bool indicating that some thread owns stage i (always true if at least one enabled)
  *
  * threadEnable gates assignment: disabled threads simply never match any stage.
  */
class PipelineScheduler(numThreads: Int, stageCount: Int) extends Module {
  private val threadBits = log2Ceil(numThreads)
  private val stageBits  = log2Ceil(stageCount)

  val io = IO(new Bundle {
    val threadEnable = Input(Vec(numThreads, Bool()))
    val advance      = Input(Bool())
    val stageThreads = Output(Vec(stageCount, UInt(threadBits.W)))
    val stageValids  = Output(Vec(stageCount, Bool()))
  })

  // Keep a global offset that advances one thread each cycle.
  // Stage i is owned by thread (i - offset) mod numThreads.
  val offset = RegInit(0.U(threadBits.W))
  when(io.advance) {
    offset := Mux(offset === (numThreads - 1).U, 0.U, offset + 1.U)
  }

  for (s <- 0 until stageCount) {
    // Owner of stage s: (offset - s) mod numThreads
    val num = (offset + numThreads.U((threadBits + 1).W)) - s.U
    val thread = num % numThreads.U((threadBits + 1).W)
    io.stageThreads(s) := thread(threadBits - 1, 0)
    io.stageValids(s) := io.threadEnable(io.stageThreads(s))
  }
}
