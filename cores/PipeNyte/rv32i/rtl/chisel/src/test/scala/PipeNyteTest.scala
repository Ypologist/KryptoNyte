package PipeNyte

import chisel3._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.flatspec.AnyFlatSpec
import PipeNyte.PipeNyteTop

class PipeNyteTest extends AnyFlatSpec {
  "PipeNyteTop" should "run 4 threads with instructions and stall-on-hazard" in {
    simulate(new PipeNyteTop) { dut =>
      val numThreads = 4
      val printDebug = true
      var cycle = 0

      // Example 4-thread programs: Seq of instructions per thread (NOP, ADDI, ADD)
      val threadInstructions = Array(
        Seq("h00000013".U, "h00100093".U, "h00208133".U), // Thread 0
        Seq("h00000013".U, "h00300113".U, "h004102B3".U), // Thread 1
        Seq("h00000013".U, "h00500193".U, "h00618333".U), // Thread 2
        Seq("h00000013".U, "h00700213".U, "h008204B3".U)  // Thread 3
      )

      val memResponses = Seq(
        "hAAAAAAAA".U,
        "hBBBBBBBB".U,
        "hCCCCCCCC".U,
        "hDDDDDDDD".U
      )

      val maxCycles = 12
      while (cycle < maxCycles) {
        val currentThread = (cycle / 3) % numThreads
        val instrIndex = cycle % 3
        val instr = threadInstructions(currentThread)(instrIndex)
        val memResp = memResponses(currentThread)

        dut.io.instrMem.poke(instr)
        dut.io.dataMemResp.poke(memResp)

        dut.clock.step(1)

        if (printDebug) {
          val memAddr = dut.io.memAddr.peek().litValue
          val memWrite = dut.io.memWrite.peek().litValue
          val memMask = dut.io.memMask.peek().litValue
          val misaligned = dut.io.memMisaligned.peek().litToBoolean

          println(f"Cycle $cycle%02d Thread $currentThread Instr: 0x${instr.litValue}%08x " +
            f"MemAddr: 0x$memAddr%08x MemWrite: 0x$memWrite%08x Mask: 0x$memMask%x Misaligned: $misaligned")
        }
        cycle += 1
      }
    }
  }
}
