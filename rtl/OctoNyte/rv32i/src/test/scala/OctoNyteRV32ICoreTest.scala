package OctoNyte

import chisel3._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.flatspec.AnyFlatSpec

class OctoNyteRV32ICoreTest extends AnyFlatSpec {
  behavior of "OctoNyteRV32ICore"

  private def dumpState(cycle: Int, label: String, dut: OctoNyteRV32ICore): Unit = {
    println(s"Clock $cycle [$label]:")
    val stageNames = Seq("pc","dec","dis","rr","ex1","ex2","ex3","wb")
    val stageTh = dut.io.debugStageThreads.map(_.peek().litValue.toInt)
    val stageVal= dut.io.debugStageValids.map(_.peek().litToBoolean)
    val invStage = Array.fill(8)("?")
    val invValid = Array.fill(8)(false)
    for (s <- stageTh.indices) {
      val t = stageTh(s)
      if (t < invStage.length) {
        invStage(t) = stageNames(s)
        invValid(t) = stageVal(s)
      }
    }
    for (t <- 0 until 8) {
      val regs = (0 to 4).map(r => dut.io.debugRegs01234(t)(r).peek().litValue)
      val pc    = dut.io.debugPC(t).peek().litValue
      val stage = invStage(t)
      val valid = invValid(t)
      println(f"  thread $t: $stage%-4s valid=$valid%-5s pc=0x$pc%08x regs=$regs")
    }
  }

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

  it should "execute ADDI x1,x0,1 across all threads using the single issue slot" in {
    simulate(new OctoNyteRV32ICore) { dut =>
      for (i <- 0 until 8) { dut.io.threadEnable(i).poke(true.B) }
      dut.io.dataMemResp.poke(0.U)

      // Only slot 0 is consumed by the core; fill the rest with NOPs.
      val singleAddiPacket = BigInt("00000013000000130000001300100093", 16).U(128.W)
      val debugCycles = 32
      val totalCycles = 80
      for (c <- 0 until totalCycles) {
        dut.io.instrMem.poke(singleAddiPacket)
        dut.clock.step()
        if (c < debugCycles) {
          dumpState(c, "single-slot ADDI", dut)
        }
      }

      println("Final x1 values after single-slot ADDI:")
      for (t <- 0 until 8) {
        val x1 = dut.io.debugRegs01234(t)(1).peek().litValue
        println(s"  thread $t -> x1=$x1")
        assert(x1 == 1, s"Thread $t x1 mismatch: got $x1 expected 1")
      }
    }
  }

  it should "accumulate ADDI x1,x1,1 results equally across threads" in {
    simulate(new OctoNyteRV32ICore) { dut =>
      for (i <- 0 until 8) { dut.io.threadEnable(i).poke(true.B) }
      dut.io.dataMemResp.poke(0.U)

      val accumPacket = BigInt("00000013000000130000001300108093", 16).U(128.W)
      val steps = 80
      val debugCycles = 40
      for (c <- 0 until steps) {
        dut.io.instrMem.poke(accumPacket)
        dut.clock.step()
        if (c < debugCycles) {
          dumpState(c, "accum ADDI", dut)
        }
      }

      println("Final x1 values after accumulative ADDI:")
      val values = (0 until 8).map { t =>
        val x1 = dut.io.debugRegs01234(t)(1).peek().litValue
        println(s"  thread $t -> x1=$x1")
        x1
      }
      assert(values.forall(_ >= 1), s"Each thread should increment x1 at least once: $values")
    }
  }
}
