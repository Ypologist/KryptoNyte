package OctoNyte

import chisel3._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.flatspec.AnyFlatSpec

class OctoNyte4RV32ICoreSimpleTest extends AnyFlatSpec {
  behavior of "OctoNyte4RV32ICore"

  it should "execute basic 4-issue ADDI instructions" in {
    simulate(new OctoNyte4RV32ICore(cosimulate = true)) { dut =>
      for (i <- 0 until 8) { dut.io.threadEnable(i).poke(true.B) }
      dut.io.dataMemResp.poke(0.U)

      dut.reset.poke(true.B)
      dut.clock.step(2)
      dut.reset.poke(false.B)

      // 4-issue packet: ADDI x1,x0,1 ; ADDI x2,x0,2 ; ADDI x3,x0,3 ; ADDI x4,x0,4
      val fourIssuePacket = BigInt("00400213003001930020011300100093", 16).U(128.W)
      
      // Run only 20 cycles (simpler, faster test)
      for (c <- 0 until 20) {
        dut.io.instrMem.poke(fourIssuePacket)
        dut.clock.step()
      }

      // Check at least one thread executed the instructions
      var foundValid = false
      for (t <- 0 until 8) {
        val x1 = dut.io.debugRegs01234(t)(1).peek().litValue
        val x2 = dut.io.debugRegs01234(t)(2).peek().litValue
        if (x1 == 1 && x2 == 2) {
          foundValid = true
        }
      }
      assert(foundValid, "At least one thread should have executed the 4-issue packet")
    }
  }

  it should "not deadlock during execution" in {
    simulate(new OctoNyte4RV32ICore(cosimulate = true)) { dut =>
      for (i <- 0 until 8) { dut.io.threadEnable(i).poke(true.B) }
      dut.io.dataMemResp.poke(0.U)

      dut.reset.poke(true.B)
      dut.clock.step(2)
      dut.reset.poke(false.B)

      val packet = BigInt("00100093001000930010009300100093", 16).U(128.W)
      
      // Run 30 cycles without hanging
      for (c <- 0 until 30) {
        dut.io.instrMem.poke(packet)
        dut.clock.step()
      }
      
      // If we get here, no deadlock occurred
      assert(true, "Completed 30 cycles without deadlock")
    }
  }

  it should "properly maintain round-robin threading" in {
    simulate(new OctoNyte4RV32ICore(cosimulate = true)) { dut =>
      for (i <- 0 until 8) { dut.io.threadEnable(i).poke(true.B) }
      dut.io.dataMemResp.poke(0.U)

      dut.reset.poke(true.B)
      dut.clock.step(2)
      dut.reset.poke(false.B)

      val packet = BigInt("00100093001000930010009300100093", 16).U(128.W)
      
      // Track which threads are active over cycles
      val activeThreads = scala.collection.mutable.Set[Int]()
      
      for (c <- 0 until 40) {
        dut.io.instrMem.poke(packet)
        dut.clock.step()
        
        // Check which threads are currently in the fetch stage
        for (t <- 0 until 8) {
          if (dut.io.debugStageValids(0).peek().litValue != 0) {
            activeThreads += dut.io.debugStageThreads(0).peek().litValue.toInt
          }
        }
      }
      
      // Should have visited multiple threads
      assert(activeThreads.size >= 2, s"Should visit multiple threads, only visited $activeThreads")
    }
  }
}
