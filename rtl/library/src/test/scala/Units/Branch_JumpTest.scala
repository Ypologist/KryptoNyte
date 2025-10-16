package OctoNyte.BranchUnit

import chisel3._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.flatspec.AnyFlatSpec

class Branch_JumpTest extends AnyFlatSpec {

  "BranchUnit" should "correctly evaluate branch conditions and compute next PC" in {
    simulate(new BranchUnit) { dut =>
      val printDebugInfo = false

      def testBranch(rs1: BigInt, rs2: BigInt, pc: BigInt, imm: BigInt, branchOp: UInt,
                     valid: Boolean, expectedTaken: Boolean, expectedNextPc: BigInt): Unit = {

        dut.io.rs1.poke(rs1.U)
        dut.io.rs2.poke(rs2.U)
        dut.io.pc.poke(pc.U)
        dut.io.imm.poke(imm.S)
        dut.io.branchOp.poke(branchOp)
        dut.io.valid.poke(valid.B)
        dut.clock.step()

        val taken = dut.io.taken.peek().litToBoolean
        val nextPc = dut.io.nextPc.peek().litValue
        val target = dut.io.target.peek().litValue

        if (printDebugInfo)
          println(f"[Branch_JumpTest] rs1=$rs1 rs2=$rs2 pc=$pc imm=$imm branchOp=${branchOp.litValue} -> taken=$taken target=$target nextPc=$nextPc")

        assert(taken == expectedTaken, s"Expected branchTaken=$expectedTaken but got $taken for branchOp=${branchOp.litValue}")
        assert(nextPc == expectedNextPc, f"Expected nextPc=0x$expectedNextPc%08x but got 0x$nextPc%08x")
      }

      // ---- BEQ ----
      testBranch(rs1 = 5, rs2 = 5, pc = 100, imm = 8, branchOp = 0.U, valid = true, expectedTaken = true, expectedNextPc = 104)
      testBranch(rs1 = 5, rs2 = 7, pc = 100, imm = 8, branchOp = 0.U, valid = true, expectedTaken = false, expectedNextPc = 104)

      // ---- BNE ----
      testBranch(rs1 = 10, rs2 = 5, pc = 200, imm = 12, branchOp = 1.U, valid = true, expectedTaken = true, expectedNextPc = 212)
      testBranch(rs1 = 9, rs2 = 9, pc = 200, imm = 12, branchOp = 1.U, valid = true, expectedTaken = false, expectedNextPc = 204)

      // ---- BLT ----
      testBranch(rs1 = -3, rs2 = 2, pc = 300, imm = 16, branchOp = 4.U, valid = true, expectedTaken = true, expectedNextPc = 316)
      testBranch(rs1 = 5, rs2 = 2, pc = 300, imm = 16, branchOp = 4.U, valid = true, expectedTaken = false, expectedNextPc = 304)

      // ---- BGE ----
      testBranch(rs1 = 5, rs2 = 2, pc = 400, imm = 20, branchOp = 5.U, valid = true, expectedTaken = true, expectedNextPc = 420)
      testBranch(rs1 = -4, rs2 = 2, pc = 400, imm = 20, branchOp = 5.U, valid = true, expectedTaken = false, expectedNextPc = 404)

      // ---- BLTU ----
      testBranch(rs1 = 1, rs2 = 5, pc = 500, imm = 24, branchOp = 6.U, valid = true, expectedTaken = true, expectedNextPc = 524)
      testBranch(rs1 = 8, rs2 = 5, pc = 500, imm = 24, branchOp = 6.U, valid = true, expectedTaken = false, expectedNextPc = 504)

      // ---- BGEU ----
      testBranch(rs1 = 8, rs2 = 5, pc = 600, imm = 28, branchOp = 7.U, valid = true, expectedTaken = true, expectedNextPc = 628)
      testBranch(rs1 = 2, rs2 = 5, pc = 600, imm = 28, branchOp = 7.U, valid = true, expectedTaken = false, expectedNextPc = 604)
    }
  }
}
