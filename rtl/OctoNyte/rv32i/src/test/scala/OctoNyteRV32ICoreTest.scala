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

  // Keep the packed ADDI test last for easier debug; add logging.

  it should "execute single ADDI in each slot (others NOP) across all threads" in {
    // Specific ADDIs per slot: slot0 addi x0,x0,0; slot1 addi x1,x0,1; slot2 addi x2,x0,2; slot3 addi x3,x0,3
    val addi0 = "00000013" // addi x0,x0,0
    val addi1 = "00100093" // addi x1,x0,1
    val addi2 = "00200113" // addi x2,x0,2
    val addi3 = "00308193" // addi x3,x0,3
    val nop   = "00000013"
    val packets = Seq(
      s"${nop}${nop}${nop}${addi0}",
      s"${nop}${nop}${addi1}${nop}",
      s"${nop}${addi2}${nop}${nop}",
      s"${addi3}${nop}${nop}${nop}"
    ).map(x => BigInt(x, 16))

    var allOk = true
    for ((pkt, idx) <- packets.zipWithIndex) {
      simulate(new OctoNyteRV32ICore) { dut =>
        for (i <- 0 until 8) { dut.io.threadEnable(i).poke(true.B) }
        dut.io.dataMemResp.poke(0.U)
        val packet = pkt.U(128.W)
        // Run enough cycles to cover fetch->wb for all threads
        val debugCycles = 32
        val totalCycles = 120
        println("*********************")
        println(s"* Slot $idx")
        println("*********************")
        for (c <- 0 until totalCycles) {
          dut.io.instrMem.poke(packet)
          dut.clock.step()
          if (c < debugCycles) {
            println(s"Clock $c:")
            val ibCount = dut.io.debugIbCount.peek().litValue
            val ibTh    = dut.io.debugIbThread.peek().litValue
            val ibVal   = dut.io.debugIbValid.peek().litToBoolean
            println(s"  f_dec: count=$ibCount thread=$ibTh valid=$ibVal")

            val stageNames = Seq("pc","dec","dis","rr","ex1","ex2","ex3","wb")
            val stageTh = dut.io.debugStageThreads.map(_.peek().litValue.toInt)
            val stageVal= dut.io.debugStageValids.map(_.peek().litToBoolean)
            val invMap = Array.fill(8)("?")
            val invVal = Array.fill(8)(false)
            for (s <- stageTh.indices) {
              val t = stageTh(s)
              if (t < invMap.length) {
                invMap(t) = stageNames(s)
                invVal(t) = stageVal(s)
              }
            }
            for (t <- 0 until 8) {
              val regsT = (0 to 4).map(r => dut.io.debugRegs01234(t)(r).peek().litValue)
              val pc    = dut.io.debugPC(t).peek().litValue
              val stage = invMap(t)
              val v     = invVal(t)
              println(f"  thread $t: $stage%-4s valid=$v%-5s pc=0x$pc%08x regs=$regsT")
            }
          }
        }
        val expected = idx match {
          case 0 => Seq(0, 0, 0, 0, 0) // addi x0,x0,0 is effectively a NOP
          case 1 => Seq(0, 1, 0, 0, 0) // slot1 writes x1=1
          case 2 => Seq(0, 0, 2, 0, 0) // slot2 writes x2=2
          case 3 => Seq(0, 0, 0, 3, 0) // slot3 writes x3=3
        }
        val expectedBig = expected.map(BigInt(_))
        for (t <- 0 until 8) {
          val regs = (0 to 4).map(r => dut.io.debugRegs01234(t)(r).peek().litValue)
          if (regs != expectedBig) {
            allOk = false
            println(s"[slot-$idx] thread $t regs[0..4] mismatch: $regs expected $expectedBig")
          }
        }
      }
    }
    assert(allOk, "One or more slot-shift ADDI packets failed")
  }
  it should "execute a hazard-free 4-wide ADDI packet across all threads (run last)" in {
    simulate(new OctoNyteRV32ICore) { dut =>
      // Enable all threads
      for (i <- 0 until 8) { dut.io.threadEnable(i).poke(true.B) }

      // Packet: addi x1,x0,1 ; addi x2,x0,2 ; addi x3,x0,3 ; addi x4,x0,4
      val packet = "h00400213003001930020011300100093".U(128.W)
      dut.io.dataMemResp.poke(0.U)

      // Run enough cycles to let all 8 threads fetch/retire the packet
      val debugCycles = 40
      val totalCycles = 120
      println("*********************")
      println("* Slot packed (4-wide ADDI)")
      println("*********************")
      for (c <- 0 until totalCycles) {
        dut.io.instrMem.poke(packet)
        dut.clock.step()
        if (c < debugCycles) {
          println(s"Clock $c:")
          val ibCount = dut.io.debugIbCount.peek().litValue
          val ibTh    = dut.io.debugIbThread.peek().litValue
          val ibVal   = dut.io.debugIbValid.peek().litToBoolean
          println(s"  f_dec: count=$ibCount thread=$ibTh valid=$ibVal")

          val stageNames = Seq("pc","dec","dis","rr","ex1","ex2","ex3","wb")
          val stageTh = dut.io.debugStageThreads.map(_.peek().litValue.toInt)
          val stageVal= dut.io.debugStageValids.map(_.peek().litToBoolean)
          val invMap = Array.fill(8)("?")
          val invVal = Array.fill(8)(false)
          for (s <- stageTh.indices) {
            val t = stageTh(s)
            if (t < invMap.length) {
              invMap(t) = stageNames(s)
              invVal(t) = stageVal(s)
            }
          }
          for (t <- 0 until 8) {
            val regsT = (0 to 4).map(r => dut.io.debugRegs01234(t)(r).peek().litValue)
            val pc    = dut.io.debugPC(t).peek().litValue
            val stage = invMap(t)
            val v     = invVal(t)
            println(f"  thread $t: $stage%-4s valid=$v%-5s pc=0x$pc%08x regs=$regsT")
          }
        }
      }

      // Expect x1..x4 = 1,2,3,4 for every thread (x0 stays 0)
      val expected = Seq(0, 1, 2, 3, 4).map(BigInt(_))
      for (t <- 0 until 8) {
        val regs = (0 to 4).map(r => dut.io.debugRegs01234(t)(r).peek().litValue)
        assert(regs == expected, s"Thread $t regs[0..4] mismatch: $regs expected $expected")
      }
    }
  }
}
