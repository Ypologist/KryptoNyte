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

      val mask32 = 0xFFFFFFFFL
      val basePC = dut.io.pc_out.peek().litValue.toLong & mask32

      // Helper to test a single instruction, providing instruction memory stimulus
      def testInstruction(expectedInstr: Long, idx: Int): Unit = {
        val expectedPC = (basePC + idx * 4L) & mask32
        val pc = dut.io.pc_out.peek().litValue.toLong & mask32

        // Drive instruction memory with expected word for the current PC
        dut.io.imem_rdata.poke((expectedInstr & mask32).U(32.W))

        val instr = dut.io.instr_out.peek().litValue.toLong & mask32

        if (printDebugInfo) {
          val pcHex = java.lang.Long.toHexString(pc)
          val instrHex = java.lang.Long.toHexString(instr)
          println(f"[Cycle $cycle%02d] PC: 0x$pcHex, Instr: 0x$instrHex")
        }

        // Assertions
        assert(pc == expectedPC, s"Expected PC 0x${java.lang.Long.toHexString(expectedPC)}, got 0x${java.lang.Long.toHexString(pc)}")
        assert(instr == (expectedInstr & mask32), s"Expected instruction 0x${java.lang.Long.toHexString(expectedInstr)}, got 0x${java.lang.Long.toHexString(instr)}")

        dut.clock.step(1)
        cycle += 1
      }

      // Sequence of instructions to exercise basic fetch/execute path
      val program = Seq(
        0x00000013L, // NOP
        0x00100093L, // ADDI
        0x00208133L  // ADD
      )

      program.zipWithIndex.foreach { case (instr, idx) =>
        testInstruction(instr, idx)
      }
    }
  }
}
