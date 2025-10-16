package Units

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import OctoNyte.StoreUnit.StoreUnit

class StoreUnitTest extends AnyFlatSpec with ChiselScalatestTester with Matchers {

  behavior of "StoreUnit"

  it should "generate correct masks, memWrite data, and misalignment flags" in {
    test(new StoreUnit) { c =>

      // --- Store Byte (SB) ---
      c.io.addr.poke(1.U)
      c.io.data.poke("hDEADBEEF".U)
      c.io.storeType.poke(0.U) // 00: SB
      c.clock.step()

      c.io.mask.expect("b0010".U)
      c.io.memWrite.expect("h0000EE00".U) // byte shifted by addr(1,0)=01 → <<8
      c.io.misaligned.expect(false.B)

      // --- Store Halfword (SH) ---
      c.io.addr.poke(2.U)
      c.io.storeType.poke(1.U) // 01: SH
      c.clock.step()

      c.io.mask.expect("b1100".U)
      c.io.memWrite.expect("hBEEF0000".U) // 0xBEEF shifted by addr(1)=1 → <<16
      c.io.misaligned.expect(false.B)

      // Misaligned SH (addr = 1)
      c.io.addr.poke(1.U)
      c.clock.step()
      c.io.misaligned.expect(true.B)

      // --- Store Word (SW) ---
      c.io.addr.poke(0.U)
      c.io.storeType.poke(2.U) // 10: SW
      c.clock.step()

      c.io.mask.expect("b1111".U)
      c.io.memWrite.expect("hDEADBEEF".U)
      c.io.misaligned.expect(false.B)

      // Misaligned SW (addr = 2)
      c.io.addr.poke(2.U)
      c.clock.step()
      c.io.misaligned.expect(true.B)
    }
  }
}
