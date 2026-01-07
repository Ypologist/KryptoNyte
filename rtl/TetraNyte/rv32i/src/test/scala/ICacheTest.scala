package TetraNyte

import chisel3._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.flatspec.AnyFlatSpec

class ICacheTest extends AnyFlatSpec {

  behavior of "ICache"

  it should "return a word immediately when memory is combinational (fast path)" in {
    simulate(new ICache(new ICacheConfig(64, 16, 1))) { dut =>
      val mask32 = 0xFFFFFFFFL

      // reset
      dut.reset.poke(true.B)
      dut.clock.step()
      dut.reset.poke(false.B)

      // Drive a PC aligned to block base (wordOffset = 0)
      val pc = 0x80000000L
      val testWord = 0xdeadbeefL

      dut.io.pc.poke(pc.U)
      dut.io.pc_valid.poke(true.B)
      // combinational memory provides data immediately
      dut.io.mem_rvalid.poke(true.B)
      dut.io.mem_rdata.poke(testWord.U(32.W))

      val observed = dut.io.instr.peek().litValue.toLong & mask32
      val valid = dut.io.instr_valid.peek().litValue == 1
      assert(valid, "instr_valid should be true on fast path")
      assert(observed == (testWord & mask32), f"Expected 0x${testWord.toHexString}, got 0x${observed.toHexString}")

      dut.clock.step()
    }
  }

  it should "perform a multi-cycle block fill and then hit on subsequent fetch" in {
    simulate(new ICache(new ICacheConfig(64, 16, 1))) { dut =>
      val mask32 = 0xFFFFFFFFL

      // reset
      dut.reset.poke(true.B)
      dut.clock.step()
      dut.reset.poke(false.B)

      val pc = 0x80000000L
      dut.io.pc.poke(pc.U)
      dut.io.pc_valid.poke(true.B)

      // Ensure memory does not provide combinational data so a miss occurs
      dut.io.mem_rvalid.poke(false.B)
      dut.io.mem_rdata.poke(0.U)

      // Request fetch -> will schedule a multi-cycle fill
      dut.clock.step()

      // sMiss -> sFill
      dut.clock.step()

      // Provide words for the whole block (wordsPerLine = 4)
      val baseWord = 0x1000L
      val wordsPerLine = 4
      for (i <- 0 until wordsPerLine) {
        dut.io.mem_rvalid.poke(true.B)
        dut.io.mem_rdata.poke((baseWord + i).U(32.W))
        dut.clock.step()
      }

      val observed = dut.io.instr.peek().litValue.toLong & mask32
      val valid = dut.io.instr_valid.peek().litValue == 1
      assert(valid, "instr_valid should be true after block fill")
      assert(observed == (baseWord & mask32), f"Expected 0x${baseWord.toHexString}, got 0x${observed.toHexString}")

      dut.clock.step()
      dut.io.mem_rvalid.poke(false.B)
      dut.io.pc_valid.poke(true.B)
      val hitObserved = dut.io.instr.peek().litValue.toLong & mask32
      val hitValid = dut.io.instr_valid.peek().litValue == 1
      assert(hitValid, "instr_valid should be true on cache hit")
      assert(hitObserved == (baseWord & mask32), f"Expected 0x${baseWord.toHexString}, got 0x${hitObserved.toHexString}")
    }
  }
}
