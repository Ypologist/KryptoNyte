package OctoNyte

import chisel3._
import TileLink._
import AXI4._
import Bridges.TLToAXI4Lite

/** Wrapper to expose an AXI4-Lite master from the legacy OctoNyte memory signals. */
class OctoNyteTLToAXI4Lite(tlParams: TLParams = TLParams(),
                           axiParams: AXI4LiteParams = AXI4LiteParams()) extends Module {
  val io = IO(new Bundle {
    val legacy = new Bundle {
      val valid     = Input(Bool())
      val addr      = Input(UInt(32.W))
      val writeData = Input(UInt(32.W))
      val writeMask = Input(UInt(4.W))
      val readData  = Output(UInt(32.W))
    }

    val passthroughMem = new Bundle {
      val addr      = Output(UInt(32.W))
      val writeData = Output(UInt(32.W))
      val writeMask = Output(UInt(4.W))
      val readData  = Input(UInt(32.W))
    }

    val axi = new AXI4LiteIO(axiParams)
  })

  private val memPort = Module(new OctoNyteMemPort(tlParams))
  private val bridge = Module(new TLToAXI4Lite(tlParams, axiParams))

  memPort.io.legacy.valid := io.legacy.valid
  memPort.io.legacy.addr := io.legacy.addr
  memPort.io.legacy.writeData := io.legacy.writeData
  memPort.io.legacy.writeMask := io.legacy.writeMask
  io.legacy.readData := memPort.io.legacy.readData

  io.passthroughMem.addr := memPort.io.passthroughMem.addr
  io.passthroughMem.writeData := memPort.io.passthroughMem.writeData
  io.passthroughMem.writeMask := memPort.io.passthroughMem.writeMask
  memPort.io.passthroughMem.readData := io.passthroughMem.readData

  bridge.io.tl <> memPort.io.tl
  io.axi <> bridge.io.axi
}
