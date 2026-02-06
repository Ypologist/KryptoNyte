package OctoNyte

import chisel3._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.flatspec.AnyFlatSpec

class OctoNyteInterruptControllerTest extends AnyFlatSpec {
  behavior of "OctoNyteInterruptController"

  it should "capture, prioritize, and complete interrupts" in {
    simulate(new OctoNyteInterruptController(8)) { dut =>
      dut.reset.poke(true.B)
      dut.io.irqSources.poke(0.U)
      dut.io.enableMask.poke(0.U)
      dut.io.complete.poke(false.B)
      dut.clock.step()
      dut.reset.poke(false.B)

      // Raise IRQ3 and IRQ1; with priority encoder, IRQ1 should win first.
      dut.io.enableMask.poke("hff".U)
      dut.io.irqSources.poke("h0A".U)
      dut.clock.step()

      assert(dut.io.hasInterrupt.peek().litToBoolean)
      assert(dut.io.claimId.peek().litValue == 2)

      // Complete first claim (IRQ1)
      dut.io.complete.poke(true.B)
      dut.io.irqSources.poke(0.U)
      dut.clock.step()

      dut.io.complete.poke(false.B)
      dut.clock.step()

      assert(dut.io.hasInterrupt.peek().litToBoolean)
      assert(dut.io.claimId.peek().litValue == 4)
    }
  }
}
