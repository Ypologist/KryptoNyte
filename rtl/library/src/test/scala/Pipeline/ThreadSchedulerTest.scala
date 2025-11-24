package Pipeline

import chisel3._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.flatspec.AnyFlatSpec

class ThreadSchedulerTest extends AnyFlatSpec {
  behavior of "ThreadScheduler"

  it should "round-robin all enabled threads" in {
    simulate(new ThreadScheduler(8)) { dut =>
      for (i <- 0 until 8) dut.io.threadEnable(i).poke(true.B)
      val seen = collection.mutable.ArrayBuffer[Int]()
      for (c <- 0 until 16) {
        val cur = dut.io.currentThread.peek().litValue.toInt
        seen += cur
        if (c < 10) println(s"[cycle $c] currentThread=$cur")
        dut.clock.step()
      }
      val expected = Seq(0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7)
      assert(seen == expected, s"Unexpected sequence: $seen")
    }
  }

  it should "provide stageThreads as (sel - i) mod N for a full barrel" in {
    val n = 8
    val stages = 8
    simulate(new ThreadScheduler(n, stages)) { dut =>
      for (i <- 0 until n) dut.io.threadEnable(i).poke(true.B)
      val stageNames = Seq("F","DEC","DIS","RR","EX1","EX2","EX3","WB")
      for (cycle <- 0 until n) {
        val fetch = dut.io.currentThread.peek().litValue.toInt
        if (cycle < 8) {
          val stagesStr = (0 until stages).map(i => s"${stageNames(i)}:${dut.io.stageThreads(i).peek().litValue.toInt}").mkString(" ")
          println(s"[cycle $cycle] fetch=$fetch $stagesStr")
        }
        // stageThreads(0) should equal currentThread
        assert(dut.io.stageThreads(0).peek().litValue.toInt == fetch)
        for (i <- 0 until stages) {
          val expected = (fetch + n - i) % n
          val got = dut.io.stageThreads(i).peek().litValue.toInt
          assert(got == expected, s"cycle $cycle stage $i expected $expected got $got")
        }
        dut.clock.step()
      }
    }
  }
}
