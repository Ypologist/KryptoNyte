package ZeroNyte

import chisel3._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.flatspec.AnyFlatSpec
import ZeroNyte.ZeroNyteRV32ICore

class ZeroNyteRV32ICoreTest extends AnyFlatSpec {

  "ZeroNyteCore" should "fetch and execute instructions correctly" in {
    simulate(new ZeroNyteRV32ICore) { dut =>
      val printDebugInfo = true
      var cycle = 0 // cycle counter

      // Helper to test a single instruction
      def testInstruction(expectedInstr: BigInt, expectedPC: BigInt): Unit = {
        val instr = dut.io.instr_out.peek().litValue
        val pc = dut.io.pc_out.peek().litValue

        if (printDebugInfo) println(f"[Cycle $cycle%02d] PC: 0x${pc.toString(16)}, Instr: 0x${instr.toString(16)}")

        // Assertions
        assert(instr == (expectedInstr & 0xFFFFFFFFL), s"Expected instruction 0x${expectedInstr.toString(16)}, got 0x${instr.toString(16)}")
        assert(pc == (expectedPC & 0xFFFFFFFFL), s"Expected PC 0x${expectedPC.toString(16)}, got 0x${pc.toString(16)}")

        dut.clock.step(1)
        cycle += 1
      }

      // Sequence of instructions with expected PC values
      val instructionsAndPCs = Seq(
        (0x00000013L, 0x0L), // NOP
        (0x00100093L, 0x4L), // ADDI
        (0x00208133L, 0x8L)  // ADD
      )

      instructionsAndPCs.foreach { case (instr, pc) =>
        testInstruction(instr, pc)
      }
    }
  }
}
