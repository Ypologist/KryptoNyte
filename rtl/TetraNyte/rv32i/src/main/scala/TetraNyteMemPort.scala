package TetraNyte

import chisel3._
import chisel3.util._
import TileLink._

/** Compatibility MemPort shell that will eventually translate the core's simple memory
  * signals onto a TileLink-UL master port. For now it passes the legacy signals through
  * while exposing an inactive TL interface, so we can integrate incrementally.
  */
class TetraNyteMemPort(p: TLParams = TLParams()) extends Module {
  val io = IO(new Bundle {
    // Legacy single-beat memory view used by the existing core and simulator
    val legacy = new Bundle {
      val valid        = Input(Bool())
      val addr         = Input(UInt(32.W))
      val writeData    = Input(UInt(32.W))
      val writeMask    = Input(UInt(4.W))
      val misaligned   = Input(Bool())
      val readData     = Output(UInt(32.W))
    }

    // Simple pass-through port to an SRAM model while TL support is built
    val passthroughMem = new Bundle {
      val addr      = Output(UInt(32.W))
      val writeData = Output(UInt(32.W))
      val writeMask = Output(UInt(4.W))
      val readData  = Input(UInt(32.W))
    }

    // Future TileLink master port
    val tl = new TLBundleUL(p)
  })

  // Legacy passthrough wiring keeps existing simulations working.
  io.passthroughMem.addr      := io.legacy.addr
  io.passthroughMem.writeData := io.legacy.writeData
  io.passthroughMem.writeMask := io.legacy.writeMask
  io.legacy.readData          := io.passthroughMem.readData

  // Opportunistically mirror the legacy request onto TileLink for future integration.
  // The core still consumes the passthrough path, so TL can be ignored until a real TL
  // memory model is wired up.
  val store = io.legacy.writeMask.orR
  val sizeFromMask = Wire(UInt(p.sizeBits.W))
  sizeFromMask := 2.U // default word
  switch(io.legacy.writeMask) {
    is("b0001".U) { sizeFromMask := 0.U } // byte
    is("b0010".U) { sizeFromMask := 0.U }
    is("b0100".U) { sizeFromMask := 0.U }
    is("b1000".U) { sizeFromMask := 0.U }
    is("b0011".U) { sizeFromMask := 1.U } // half
    is("b1100".U) { sizeFromMask := 1.U }
    is("b1111".U) { sizeFromMask := 2.U } // word
  }
  val size = sizeFromMask

  val loadMask = TLMask(io.legacy.addr, size, p.beatBytes)
  val tlMask = Mux(store, io.legacy.writeMask, loadMask)
  val opcode = Mux(store,
    Mux(io.legacy.writeMask === Fill(p.beatBytes, 1.U(1.W)), TLOpcodesA.PutFullData, TLOpcodesA.PutPartialData),
    TLOpcodesA.Get)

  io.tl.a.valid := io.legacy.valid
  io.tl.a.bits.opcode := opcode
  io.tl.a.bits.param := 0.U
  io.tl.a.bits.size := size
  io.tl.a.bits.source := 0.U
  io.tl.a.bits.address := io.legacy.addr
  io.tl.a.bits.mask := tlMask
  io.tl.a.bits.data := io.legacy.writeData
  io.tl.a.bits.corrupt := false.B

  // Always ready to sink responses for now; a real integration will route D into the core.
  io.tl.d.ready := true.B
}
