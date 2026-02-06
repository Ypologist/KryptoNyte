package ZeroNyte

import chisel3._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.flatspec.AnyFlatSpec

class ZeroNyteInterruptControllerTest extends AnyFlatSpec {
  behavior of "ZeroNyteInterruptController"

  it should "capture, claim, and complete interrupts" in {
    simulate(new ZeroNyteInterruptController(8)) { dut =>
      dut.reset.poke(true.B)
      dut.io.irqSources.poke(0.U)
      dut.io.enableMask.poke(0.U)
      dut.io.complete.poke(false.B)
      dut.clock.step()
      dut.reset.poke(false.B)

      dut.io.enableMask.poke("h03".U) // enable IRQ0 and IRQ1
      dut.io.irqSources.poke("h02".U) // raise IRQ1
      dut.clock.step()

      assert(dut.io.hasInterrupt.peek().litToBoolean, "interrupt should be pending")
      assert(dut.io.claimId.peek().litValue == 2, "IRQ1 should be claimed as source id 2")

      dut.io.complete.poke(true.B)
      dut.io.irqSources.poke(0.U)
      dut.clock.step()

      assert(!dut.io.hasInterrupt.peek().litToBoolean, "interrupt should be cleared after completion")
      assert(dut.io.pending.peek().litValue == 0, "pending bits should be empty after completion")
    }
  }
}
