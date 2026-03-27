// Licensed under the BSD 3-Clause License. 
// See https://opensource.org/licenses/BSD-3-Clause for details.

package RegFiles

import chisel3._
import chisel3.util._

/**
  * A multithreaded 2-read, 1-write register file implemented using memory.
  *
  * The register file contains `depth` registers per thread (default 32),
  * and there are `numThreads` independent register sets.
  *
  * The effective address is computed by concatenating the threadID (as the high bits)
  * with the register index (as the low bits). For example, if depth = 32 (5 bits)
  * and numThreads = 4 (2 bits), then the effective address width is 7 bits,
  * and there are 128 registers in total.
  *
  * IO:
  *   - threadID: Input specifying the current thread (width = log2Ceil(numThreads)).
  *   - src1, src2: Read port register indices (each width = log2Ceil(depth)).
  *   - dst1: Write port register index (width = log2Ceil(depth)).
  *   - wen: Write enable.
  *   - dst1data: Data to be written.
  *   - src1data, src2data: Outputs from read ports (asynchronous read).
  */
class RegFileMT2R1WMem(width: Int = 32, depth: Int = 32, numThreads: Int = 4) extends Module {
  // Calculate the number of bits needed for a register index (per thread)
  val addrWidth    = log2Ceil(depth)
  // Calculate bits required to represent the thread ID.
  val threadWidth  = log2Ceil(numThreads)
  // The effective depth is the total number of registers across all threads.
  val effectiveDepth = depth * numThreads
  // The effective address width is log2Ceil(effectiveDepth)
  val effectiveAddrWidth = log2Ceil(effectiveDepth)

  val io = IO(new Bundle {
    val readThreadID  = Input(UInt(threadWidth.W))   // Thread identifier for reads
    val writeThreadID = Input(UInt(threadWidth.W))   // Thread identifier for writes
    val src1          = Input(UInt(addrWidth.W))     // Read port 1 address (per-thread)
    val src2          = Input(UInt(addrWidth.W))     // Read port 2 address (per-thread)
    val dst1          = Input(UInt(addrWidth.W))     // Write port address (per-thread)
    val wen           = Input(Bool())                // Write enable
    val dst1data      = Input(UInt(width.W))         // Data to write
    val src1data      = Output(UInt(width.W))        // Read port 1 data
    val src2data      = Output(UInt(width.W))        // Read port 2 data
    // Debug: expose x1 per thread for simple inspection
    val debugX1       = Output(Vec(numThreads, UInt(width.W)))
  })

  // Create the register file using Mem (asynchronous reads)
  val regs = Mem(effectiveDepth, UInt(width.W))

  // Compute effective addresses by concatenating the thread ID (MSBs) with the register index.
  val effectiveSrc1 = Cat(io.readThreadID, io.src1)  // Result is UInt(effectiveAddrWidth.W)
  val effectiveSrc2 = Cat(io.readThreadID, io.src2)
  val effectiveDst1 = Cat(io.writeThreadID, io.dst1)

  // Write logic: write to the register file if write enable is high and destination is not x0 (0.U)
  when(io.wen && io.dst1 =/= 0.U) {
    regs.write(effectiveDst1, io.dst1data)
  }

  // Read logic: reads are asynchronous, but hardwired back to 0 if reading x0
  io.src1data := Mux(io.src1 === 0.U, 0.U, regs.read(effectiveSrc1))
  io.src2data := Mux(io.src2 === 0.U, 0.U, regs.read(effectiveSrc2))

  // Debug view of x1 per thread (register index 1)
  for (t <- 0 until numThreads) {
    val idx = t * depth + 1
    io.debugX1(t) := regs.read(idx.U)
  }
}
