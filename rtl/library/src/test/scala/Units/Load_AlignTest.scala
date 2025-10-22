package Units

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import OctoNyte.LoadUnits.LoadUnit

class LoadUnitTest extends AnyFlatSpec with ChiselScalatestTester with Matchers {

  behavior of "LoadUnit"

  it should "handle all signed and unsigned load types correctly" in {
    test(new LoadUnit) { c =>
      // Input test data: 0xFF00AA55
      c.io.dataIn.poke("hFF00AA55".U)

      // --- LB (Load Byte, signed) ---
      c.io.funct3.poke("b000".U)
      c.clock.step()
      c.io.dataOut.expect("hFFFFFF55".U) // 0x55 -> 85, signed byte = -171 → 0xFFFFFF55

      // --- LBU (Load Byte Unsigned) ---
      c.io.funct3.poke("b100".U)
      c.clock.step()
      c.io.dataOut.expect("h00000055".U)

      // --- LH (Load Halfword, signed) ---
      c.io.funct3.poke("b001".U)
      c.clock.step()
      c.io.dataOut.expect("hFFFFAA55".U) // Lower 16 bits = 0xAA55 → sign-extend

      // --- LHU (Load Halfword Unsigned) ---
      c.io.funct3.poke("b101".U)
      c.clock.step()
      c.io.dataOut.expect("h0000AA55".U)

      // --- LW (Load Word) ---
      c.io.funct3.poke("b010".U)
      c.clock.step()
      c.io.dataOut.expect("hFF00AA55".U)
    }
  }
}
