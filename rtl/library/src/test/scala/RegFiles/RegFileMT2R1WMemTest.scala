// Licensed under the BSD 3-Clause License. 
// See https://opensource.org/licenses/BSD-3-Clause for details.
//
// sbt "testOnly TetraNyte.RegFileMT2R1WMemTest"

package RegFiles

import chisel3._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.flatspec.AnyFlatSpec

/**
  * Unit test for the multithreaded 2-read/1-write memory-based register file (RegFileMT2R1WMem).
  *
  * This test writes a value to a specific register (dst) for several different threads,
  * then reads back from that register via both read ports to verify that each thread’s register
  * bank is independent. It also verifies that x0 is hardwired to 0.
  */
class RegFileMT2R1WMemTest extends AnyFlatSpec {
  "RegFileMT2R1WMem" should "correctly perform independent read/write accesses per thread and hardwire x0 to 0" in {
    // Instantiate the register file with width = 32, depth = 32 per thread, and 4 threads.
    simulate(new RegFileMT2R1WMem(width = 32, depth = 32, numThreads = 4)) { dut =>
      
      // Helper function that writes a value to a register for a given thread,
      // then reads back the value using both read ports.
      def writeAndRead(
        thread: BigInt,
        regIdx: BigInt,
        writeData: BigInt
      ): Unit = {
        // Set the current thread for the write and reads
        dut.io.writeThreadID.poke(thread.U)
        dut.io.readThreadID.poke(thread.U)
        // Set the destination register index and data, and enable the write.
        dut.io.writeAddrs(0).poke(regIdx.U)
        dut.io.writeData(0).poke(writeData.U)
        dut.io.wens(0).poke(true.B)
        dut.clock.step(1) // Latch the write on the clock edge.
        // Disable write for subsequent operations.
        dut.io.wens(0).poke(false.B)
        
        // Now set the read addresses to the same register.
        dut.io.readAddrs(0).poke(regIdx.U)
        dut.io.readAddrs(1).poke(regIdx.U)
        
        // Because the read ports are asynchronous, we can peek immediately.
        val read1 = dut.io.readData(0).peek().litValue
        val read2 = dut.io.readData(1).peek().litValue
        
        assert(read1 == writeData, s"Thread $thread, register $regIdx (read port1): expected $writeData, got $read1")
        assert(read2 == writeData, s"Thread $thread, register $regIdx (read port2): expected $writeData, got $read2")
      }
      
      // Test writing and reading for each thread.
      writeAndRead(0, 5, 123)
      writeAndRead(1, 5, 456)
      writeAndRead(2, 10, 789)
      writeAndRead(3, 7, 101112)
      
      // Verify x0 bypass/hardwiring behavior (reads are 0, writes are ignored)
      dut.io.readThreadID.poke(0.U)
      dut.io.writeThreadID.poke(0.U)
      
      // Check initial read of x0 (src1=0, src2=0) is 0
      dut.io.readAddrs(0).poke(0.U)
      dut.io.readAddrs(1).poke(0.U)
      val zeroVal1 = dut.io.readData(0).peek().litValue
      val zeroVal2 = dut.io.readData(1).peek().litValue
      assert(zeroVal1 == 0, s"Thread 0, register 0 expected 0, got $zeroVal1")
      assert(zeroVal2 == 0, s"Thread 0, register 0 expected 0, got $zeroVal2")
      
      // Attempt to write a non-zero value to x0
      dut.io.writeAddrs(0).poke(0.U)
      dut.io.writeData(0).poke(999.U)
      dut.io.wens(0).poke(true.B)
      dut.clock.step(1)
      dut.io.wens(0).poke(false.B)
      
      // Verify that reading from x0 still returns 0 despite the write attempt
      val zeroValPostWrite1 = dut.io.readData(0).peek().litValue
      val zeroValPostWrite2 = dut.io.readData(1).peek().litValue
      assert(zeroValPostWrite1 == 0, s"Thread 0, register 0 expected 0 after write, got $zeroValPostWrite1")
      assert(zeroValPostWrite2 == 0, s"Thread 0, register 0 expected 0 after write, got $zeroValPostWrite2")
    }
  }
}
