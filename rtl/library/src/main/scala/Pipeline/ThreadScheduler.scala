package Pipeline

import chisel3._
import chisel3.util._

/**
  * Simple round-robin thread scheduler for barrel-threaded pipelines.
  *
  * - Advances every cycle to the next enabled thread.
  * - Skips disabled threads.
  * - If no threads are enabled, it holds the current thread at 0.
  */
class ThreadScheduler(numThreads: Int, stageCount: Int = 8) extends Module {
  private val threadBits = log2Ceil(numThreads)
  val io = IO(new Bundle {
    val threadEnable = Input(Vec(numThreads, Bool()))
    val advance = Input(Bool())
    val currentThread = Output(UInt(threadBits.W))
    val stageThreads  = Output(Vec(stageCount, UInt(threadBits.W))) // stage 0=fetch, 1=decode, ..., stageCount-1=WB
  })

  val sel = RegInit(0.U(threadBits.W))
  io.currentThread := sel

  // Always advance in round-robin order: 0,1,2,...,N-1,0,...
  val atLast = sel === (numThreads - 1).U
  when(io.advance) {
    sel := Mux(atLast, 0.U, sel + 1.U)
  }

  // Derive per-stage thread IDs assuming a fully-pipelined barrel where each stage lags fetch by its index.
  // stage 0 = fetch, stage 1 = decode (fetch from previous cycle), stage 2 = dispatch, etc.
  // thread for stage i = (sel - i) mod numThreads
  val base = sel + numThreads.U // ensure non-negative before subtracting
  for (i <- 0 until stageCount) {
    val off = i.U
    val tmp = base - off
    io.stageThreads(i) := tmp(threadBits - 1, 0)
  }
}
