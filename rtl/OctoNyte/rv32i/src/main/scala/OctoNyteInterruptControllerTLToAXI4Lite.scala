package OctoNyte

import chisel3._
import chisel3.util._
import TileLink._
import AXI4._
import Bridges.TLToAXI4Lite

/**
  * Wrapper that pairs the OctoNyte interrupt controller with a TL->AXI4-Lite path.
  *
  * The `legacyCfg` interface can be used by software/testbench to access an external
  * AXI4-Lite interrupt register block through TileLink while interrupt aggregation is
  * handled locally by `OctoNyteInterruptController`.
  */
class OctoNyteInterruptControllerTLToAXI4Lite(
  numSources: Int = 8,
  tlParams: TLParams = TLParams(),
  axiParams: AXI4LiteParams = AXI4LiteParams()
) extends Module {
  val io = IO(new Bundle {
    // Interrupt side
    val irqSources = Input(UInt(numSources.W))
    val enableMask = Input(UInt(numSources.W))
    val complete = Input(Bool())

    val pending = Output(UInt(numSources.W))
    val hasInterrupt = Output(Bool())
    val claimId = Output(UInt(log2Ceil(numSources + 1).W))

    // Optional config/master access path to external AXI-Lite MMIO via TL bridge
    val legacyCfg = new Bundle {
      val valid = Input(Bool())
      val addr = Input(UInt(32.W))
      val writeData = Input(UInt(32.W))
      val writeMask = Input(UInt(4.W))
      val readData = Output(UInt(32.W))
    }

    val passthroughMem = new Bundle {
      val addr = Output(UInt(32.W))
      val writeData = Output(UInt(32.W))
      val writeMask = Output(UInt(4.W))
      val readData = Input(UInt(32.W))
    }

    val axi = new AXI4LiteIO(axiParams)
  })

  private val irqCtrl = Module(new OctoNyteInterruptController(numSources))
  private val memPort = Module(new OctoNyteMemPort(tlParams))
  private val bridge = Module(new TLToAXI4Lite(tlParams, axiParams))

  irqCtrl.io.irqSources := io.irqSources
  irqCtrl.io.enableMask := io.enableMask
  irqCtrl.io.complete := io.complete

  io.pending := irqCtrl.io.pending
  io.hasInterrupt := irqCtrl.io.hasInterrupt
  io.claimId := irqCtrl.io.claimId

  memPort.io.legacy.valid := io.legacyCfg.valid
  memPort.io.legacy.addr := io.legacyCfg.addr
  memPort.io.legacy.writeData := io.legacyCfg.writeData
  memPort.io.legacy.writeMask := io.legacyCfg.writeMask
  io.legacyCfg.readData := memPort.io.legacy.readData

  io.passthroughMem.addr := memPort.io.passthroughMem.addr
  io.passthroughMem.writeData := memPort.io.passthroughMem.writeData
  io.passthroughMem.writeMask := memPort.io.passthroughMem.writeMask
  memPort.io.passthroughMem.readData := io.passthroughMem.readData

  bridge.io.tl <> memPort.io.tl
  io.axi <> bridge.io.axi
}
