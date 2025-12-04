package TetraNyte

import chisel3._
import chisel3.simulator.EphemeralSimulator._
import TileLink._
import org.scalatest.flatspec.AnyFlatSpec

class TetraNyteMemPortTest extends AnyFlatSpec {
  "TetraNyteMemPort" should "emit TL-UL PutFullData for a full-word store" in {
    simulate(new TetraNyteMemPort()) { dut =>
      dut.io.legacy.valid.poke(true.B)
      dut.io.legacy.addr.poke("h80000004".U)
      dut.io.legacy.writeData.poke("hdeadbeef".U)
      dut.io.legacy.writeMask.poke("b1111".U)
      dut.io.legacy.misaligned.poke(false.B)
      dut.io.passthroughMem.readData.poke(0.U)

      dut.clock.step()
      dut.io.tl.a.valid.expect(true.B)
      dut.io.tl.a.bits.opcode.expect(TLOpcodesA.PutFullData)
      dut.io.tl.a.bits.size.expect(2.U) // log2(4 bytes)
      dut.io.tl.a.bits.mask.expect("b1111".U)
      dut.io.tl.a.bits.address.expect("h80000004".U)
    }
  }

  it should "emit TL-UL PutPartialData with byte mask for a halfword store" in {
    simulate(new TetraNyteMemPort()) { dut =>
      dut.io.legacy.valid.poke(true.B)
      dut.io.legacy.addr.poke("h80000002".U)
      dut.io.legacy.writeData.poke("h0000cafe".U)
      dut.io.legacy.writeMask.poke("b0011".U)
      dut.io.legacy.misaligned.poke(false.B)
      dut.io.passthroughMem.readData.poke(0.U)

      dut.clock.step()
      dut.io.tl.a.valid.expect(true.B)
      dut.io.tl.a.bits.opcode.expect(TLOpcodesA.PutPartialData)
      dut.io.tl.a.bits.size.expect(1.U) // log2(2 bytes)
      dut.io.tl.a.bits.mask.expect("b0011".U)
    }
  }

  it should "emit TL-UL Get with a mask for a load" in {
    simulate(new TetraNyteMemPort()) { dut =>
      dut.io.legacy.valid.poke(true.B)
      dut.io.legacy.addr.poke("h80000008".U)
      dut.io.legacy.writeData.poke(0.U)
      dut.io.legacy.writeMask.poke("b0000".U) // load
      dut.io.legacy.misaligned.poke(false.B)
      dut.io.passthroughMem.readData.poke(0.U)

      dut.clock.step()
      dut.io.tl.a.valid.expect(true.B)
      dut.io.tl.a.bits.opcode.expect(TLOpcodesA.Get)
      dut.io.tl.a.bits.size.expect(2.U) // default word load
      dut.io.tl.a.bits.mask.expect("b1111".U)
    }
  }
}
