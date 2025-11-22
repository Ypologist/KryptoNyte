package OctoNyte

import chisel3._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.flatspec.AnyFlatSpec

class OctoNyteRV32ICoreTest extends AnyFlatSpec {
  behavior of "OctoNyteRV32ICore"

  ignore should "run ADDI on all 8 threads and finish with the same regfile result" in {
    simulate(new OctoNyteRV32ICore) { dut =>
      // Enable all threads
      for (i <- 0 until 8) {
        dut.io.threadEnable(i).poke(true.B)
      }

      // Packet: addi x1, x1, 1 then three NOPs (little endian per 32b word)
      val packet = "h00000013000000130000001300108093".U(128.W)
      dut.io.dataMemResp.poke(0.U)

      // Run enough cycles for each thread to execute the packet twice
      for (_ <- 0 until 64) {
        dut.io.instrMem.poke(packet)
        dut.clock.step()
      }

      val vals = (0 until 8).map(t => dut.io.debugRegX1(t).peek().litValue)
      val ref = vals.head
      assert(vals.forall(_ == ref), s"x1 values differ across threads: $vals")
    }
  }
}
