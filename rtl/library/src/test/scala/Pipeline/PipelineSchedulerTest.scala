package Pipeline

import chisel3._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.flatspec.AnyFlatSpec

class PipelineSchedulerTest extends AnyFlatSpec {
  behavior of "PipelineScheduler"

  it should "rotate threads across stages in barrel fashion" in {
    val n = 8
    val stages = 8
    simulate(new PipelineScheduler(n, stages)) { dut =>
      for (i <- 0 until n) dut.io.threadEnable(i).poke(true.B)
      dut.io.advance.poke(true.B)
      val stageNames = Seq("F","DEC","DIS","RR","EX1","EX2","EX3","WB")
      for (cycle <- 0 until n) {
        val stagesStr = (0 until stages).map{i =>
          s"${stageNames(i)}:${dut.io.stageThreads(i).peek().litValue.toInt}"
        }.mkString(" ")
        println(s"[cycle $cycle] $stagesStr")
        // stage i should be owned by (cycle - i) mod n
        for (i <- 0 until stages) {
          val exp = ((cycle - i) % n + n) % n
          assert(dut.io.stageThreads(i).peek().litValue.toInt == exp)
        }
        dut.clock.step()
      }
    }
  }
}
