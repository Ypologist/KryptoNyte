package OctoNyte

import chisel3._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.flatspec.AnyFlatSpec
import org.slf4j.LoggerFactory

class OctoNyteRV32ICoreIDTest extends AnyFlatSpec {
  behavior of "OctoNyteRV32ICore Multithreading"

  private val logger = LoggerFactory.getLogger(getClass)

  it should "execute ADDI x1, x0, <thread_id> for each thread correctly" in {
    simulate(new OctoNyteRV32ICore) { dut =>
      // Enable all threads
      for (i <- 0 until 8) { dut.io.threadEnable(i).poke(true.B) }
      dut.io.dataMemResp.poke(0.U)

      // Reset
      dut.reset.poke(true.B)
      dut.clock.step(2)
      dut.reset.poke(false.B)

      val totalCycles = 80 // Enough for ~10 instructions per thread

      logger.info("Starting thread ID verification test")

      for (c <- 0 until totalCycles) {
        // Assume round-robin starting from thread 0 after reset
        // Thread scheduling logic: curThread increments every cycle
        val currentThreadId = c % 8
        
        // Construct ADDI x1, x0, currentThreadId
        // Opcode: 0x13 (0010011)
        // rd: 1 (x1)
        // funct3: 0
        // rs1: 0 (x0)
        // imm: currentThreadId
        
        val imm = currentThreadId
        val rs1 = 0
        val rd = 1
        val opcode = 0x13
        val funct3 = 0
        
        val instr = (imm << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) | opcode
        
        val packet = instr.U(128.W) // Put instruction in slot 0 (bits 31-0)
        
        dut.io.instrMem.poke(packet)
        dut.clock.step()
      }

      logger.info("Verifying final register state...")
      var allPass = true
      for (t <- 0 until 8) {
        val x1Value = dut.io.debugRegs01234(t)(1).peek().litValue
        logger.info(s"Thread $t: x1 = $x1Value (Expected: $t)")
        
        if (x1Value != t) {
          allPass = false
          logger.error(s"Mismatch on Thread $t! Expected $t, got $x1Value")
        }
      }
      
      assert(allPass, "One or more threads failed to execute their specific instruction correctly.")
    }
  }
}
