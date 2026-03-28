// Licensed under the BSD 3-Clause License. 
// See https://opensource.org/licenses/BSD-3-Clause for details.

package RegFiles

import chisel3._
import chisel3.util._

/**
  * A parameterized multithreaded register file implemented using memory.
  * Allows configurable numbers of read and write ports.
  *
  * The register file contains `depth` registers per thread (default 32),
  * and there are `numThreads` independent register sets.
  *
  * The effective address is computed by concatenating the threadID (as the high bits)
  * with the register index (as the low bits).
  *
  * IO:
  *   - readThreadID: Input specifying the current thread for reads.
  *   - writeThreadID: Input specifying the current thread for writes.
  *   - readAddrs: Vector of read port register indices.
  *   - readData: Vector of read port output data (asynchronous read).
  *   - writeAddrs: Vector of write port register indices.
  *   - wens: Vector of write enables for each write port.
  *   - writeData: Vector of data to be written.
  */
class RegFileMTMem(
  width: Int = 32,
  depth: Int = 32,
  numThreads: Int = 4,
  val numReadPorts: Int = 8,
  val numWritePorts: Int = 4
) extends Module {
  // Calculate the number of bits needed for a register index (per thread)
  val addrWidth    = log2Ceil(depth)
  // Calculate bits required to represent the thread ID.
  val threadWidth  = log2Ceil(numThreads)
  // The effective depth is the total number of registers across all threads.
  val effectiveDepth = depth * numThreads

  val io = IO(new Bundle {
    val readThreadID  = Input(UInt(threadWidth.W))
    val writeThreadID = Input(UInt(threadWidth.W))
    
    // Parameterized read ports
    val readAddrs     = Input(Vec(numReadPorts, UInt(addrWidth.W)))
    val readData      = Output(Vec(numReadPorts, UInt(width.W)))
    
    // Parameterized write ports
    val writeAddrs    = Input(Vec(numWritePorts, UInt(addrWidth.W)))
    val wens          = Input(Vec(numWritePorts, Bool()))
    val writeData     = Input(Vec(numWritePorts, UInt(width.W)))
    
    // Debug: expose x1 per thread for simple inspection
    val debugX1       = Output(Vec(numThreads, UInt(width.W)))
  })

  // Create the register file using Mem (asynchronous reads)
  // The synthesizer will infer the requested number of read and write ports.
  val regs = Mem(effectiveDepth, UInt(width.W))

  // Write logic: write to the register file if write enable is high and destination is not x0
  for (i <- 0 until numWritePorts) {
    val effectiveDst = Cat(io.writeThreadID, io.writeAddrs(i))
    when(io.wens(i) && io.writeAddrs(i) =/= 0.U) {
      regs.write(effectiveDst, io.writeData(i))
    }
  }

  // Read logic: reads are asynchronous, but hardwired back to 0 if reading x0
  for (i <- 0 until numReadPorts) {
    val effectiveSrc = Cat(io.readThreadID, io.readAddrs(i))
    io.readData(i) := Mux(io.readAddrs(i) === 0.U, 0.U, regs.read(effectiveSrc))
  }

  // Debug view of x1 per thread (register index 1)
  for (t <- 0 until numThreads) {
    val idx = t * depth + 1
    io.debugX1(t) := regs.read(idx.U)
  }
}
