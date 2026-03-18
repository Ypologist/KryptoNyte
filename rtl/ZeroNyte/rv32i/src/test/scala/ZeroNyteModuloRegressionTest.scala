package ZeroNyte

import ALUs.ALU32
import chisel3._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.flatspec.AnyFlatSpec
import TileLink.{TLRAM, TLParams, TLBundleUL}

import java.io.InputStream
import java.nio.file.{Files, Paths}

class TLAddressOffset(base: BigInt, p: TLParams = TLParams()) extends Module {
  val io = IO(new Bundle {
    val in = Flipped(new TLBundleUL(p))
    val out = new TLBundleUL(p)
  })

  private val baseAddr = base.U(p.addrBits.W)

  io.out.a.valid := io.in.a.valid
  io.out.a.bits := io.in.a.bits
  io.out.a.bits.address := io.in.a.bits.address - baseAddr
  io.in.a.ready := io.out.a.ready

  io.in.d.valid := io.out.d.valid
  io.in.d.bits := io.out.d.bits
  io.out.d.ready := io.in.d.ready
}

class ZeroNyteModuloHarness extends Module {
  val io = IO(new Bundle {
    val imemData = Input(UInt(32.W))
    val dmemData = Input(UInt(32.W))
    val irqSources = Input(UInt(8.W))
    val irqEnableMask = Input(UInt(8.W))
    val irqComplete = Input(Bool())
    val interruptVector = Input(UInt(32.W))
    val pc = Output(UInt(32.W))
    val instr = Output(UInt(32.W))
    val result = Output(UInt(32.W))
    val imemAddr = Output(UInt(32.W))
    val dmemAddr = Output(UInt(32.W))
    val dmemWData = Output(UInt(32.W))
    val dmemWen = Output(Bool())
    val debugAluA = Output(UInt(32.W))
    val debugAluB = Output(UInt(32.W))
    val debugAluOpcode = Output(UInt(ALU32.Opcode.WIDTH.W))
    val debugEffAddr = Output(UInt(32.W))
    val debugMemWriteData = Output(UInt(32.W))
    val debugMemWriteMask = Output(UInt(4.W))
    val debugBranchTaken = Output(Bool())
    val debugBranchTarget = Output(UInt(32.W))
    val debugDivActive = Output(Bool())
    val debugDivDone = Output(Bool())
    val debugDivDividend = Output(UInt(32.W))
    val debugDivDivisor = Output(UInt(32.W))
  })

  private val core = Module(new ZeroNyteRV32ICore)
  private val offset = Module(new TLAddressOffset(base = 0x80000000L))
  private val ram = Module(new TLRAM(depth = 1 << 16))

  offset.io.in <> core.io.tl
  ram.io.tl <> offset.io.out

  core.io.imem_rdata := io.imemData
  core.io.dmem_rdata := io.dmemData
  core.io.irqSources := io.irqSources
  core.io.irqEnableMask := io.irqEnableMask
  core.io.irqComplete := io.irqComplete
  core.io.interruptVector := io.interruptVector

  io.pc := core.io.pc_out
  io.instr := core.io.instr_out
  io.result := core.io.result
  io.imemAddr := core.io.imem_addr
  io.dmemAddr := core.io.dmem_addr
  io.dmemWData := core.io.dmem_wdata
  io.dmemWen := core.io.dmem_wen
  io.debugAluA := core.io.debug.aluA
  io.debugAluB := core.io.debug.aluB
  io.debugAluOpcode := core.io.debug.aluOpcode
  io.debugEffAddr := core.io.debug.effAddr
  io.debugMemWriteData := core.io.debug.memWriteData
  io.debugMemWriteMask := core.io.debug.memWriteMask
  io.debugBranchTaken := core.io.debug.branchTaken
  io.debugBranchTarget := core.io.debug.branchTarget
  io.debugDivActive := core.io.debug.divActive
  io.debugDivDone := core.io.debug.divDone
  io.debugDivDividend := core.io.debug.divDividend
  io.debugDivDivisor := core.io.debug.divDivisor
}

class ZeroNyteModuloRegressionTest extends AnyFlatSpec {

  behavior of "ZeroNyteCore modulo microkernel"

  it should "match software remainder for 0x16074f % 8095" in {
    val rom = RomImage.fromResource("/roms/mod_repro.bin", base = 0x80000000L)
    val seedAddr = 0x80002000L
    val signatureAddr = 0x80003000L
    val iterations = 512
    val maxCycles = 400000

    simulate(new ZeroNyteModuloHarness) { dut =>
      dut.reset.poke(true.B)
      dut.io.imemData.poke(0.U)
      dut.io.irqSources.poke(0.U)
      dut.io.irqEnableMask.poke("hff".U)
      dut.io.irqComplete.poke(false.B)
      dut.io.interruptVector.poke("h80000100".U)
      dut.clock.step()
      dut.reset.poke(false.B)

      val dataMem = scala.collection.mutable.Map.empty[Long, Long].withDefaultValue(0L)
      def aligned(addr: Long): Long = addr & 0xFFFFFFFCL
      def loadWord(addr: Long): Long = dataMem(aligned(addr))
      def storeWord(addr: Long, value: Long): Unit = {
        dataMem.update(aligned(addr), value & 0xFFFFFFFFL)
      }

      var expectedSeed = 0L
      var seedsSeen = 0
      var mismatch: Option[(Int, Long, Long)] = None
      var signatureValue: Option[Long] = None
      var cycles = 0
      var initClearSeen = false
      val storeTrace = scala.collection.mutable.ArrayBuffer.empty[(Long, Long)]
      case class CoreTrace(
        cycle: Int,
        pc: Long,
        instr: Long,
        result: Long,
        aluA: Long,
        aluB: Long,
        aluOpcode: Long,
        effAddr: Long,
        dmemAddr: Long,
        dmemWen: Boolean,
        dmemWData: Long,
        debugStoreData: Long,
        debugStoreMask: Long,
        branchTaken: Boolean,
        branchTarget: Long,
        divActive: Boolean,
        divDone: Boolean,
        divDividend: Long,
        divDivisor: Long
      )
      val recentTrace = scala.collection.mutable.Queue.empty[CoreTrace]
      val maxTraceDepth = 20
      val opcodeNames: Map[Long, String] = Map(
        ALU32.Opcode.ADD.litValue.longValue -> "ADD",
        ALU32.Opcode.SUB.litValue.longValue -> "SUB",
        ALU32.Opcode.SLL.litValue.longValue -> "SLL",
        ALU32.Opcode.SLT.litValue.longValue -> "SLT",
        ALU32.Opcode.SLTU.litValue.longValue -> "SLTU",
        ALU32.Opcode.XOR.litValue.longValue -> "XOR",
        ALU32.Opcode.SRL.litValue.longValue -> "SRL",
        ALU32.Opcode.SRA.litValue.longValue -> "SRA",
        ALU32.Opcode.OR.litValue.longValue -> "OR",
        ALU32.Opcode.AND.litValue.longValue -> "AND"
      )
      def opcodeName(op: Long): String = opcodeNames.getOrElse(op, f"0x$op%02x")
      def recordTrace(pcVal: Long, instrWord: Long): Unit = {
        val entry = CoreTrace(
          cycles,
          pcVal,
          instrWord,
          dut.io.result.peek().litValue.toLong & 0xFFFFFFFFL,
          dut.io.debugAluA.peek().litValue.toLong & 0xFFFFFFFFL,
          dut.io.debugAluB.peek().litValue.toLong & 0xFFFFFFFFL,
          dut.io.debugAluOpcode.peek().litValue.toLong,
          dut.io.debugEffAddr.peek().litValue.toLong & 0xFFFFFFFFL,
          dut.io.dmemAddr.peek().litValue.toLong & 0xFFFFFFFFL,
          dut.io.dmemWen.peek().litToBoolean,
          dut.io.dmemWData.peek().litValue.toLong & 0xFFFFFFFFL,
          dut.io.debugMemWriteData.peek().litValue.toLong & 0xFFFFFFFFL,
          dut.io.debugMemWriteMask.peek().litValue.toLong & 0xFL,
          dut.io.debugBranchTaken.peek().litToBoolean,
          dut.io.debugBranchTarget.peek().litValue.toLong & 0xFFFFFFFFL,
          dut.io.debugDivActive.peek().litToBoolean,
          dut.io.debugDivDone.peek().litToBoolean,
          dut.io.debugDivDividend.peek().litValue.toLong & 0xFFFFFFFFL,
          dut.io.debugDivDivisor.peek().litValue.toLong & 0xFFFFFFFFL
        )
        recentTrace.enqueue(entry)
        while (recentTrace.size > maxTraceDepth) { recentTrace.dequeue() }
      }
      def renderTrace(): String = {
        if (recentTrace.isEmpty) "<empty trace window>"
        else {
          recentTrace
            .map { t =>
              val storeInfo =
                if (t.dmemWen) f" store data=0x${t.dmemWData}%08x mask=0x${t.debugStoreMask}%x"
                else ""
              f"cycle=${t.cycle}%06d pc=0x${t.pc}%08x instr=0x${t.instr}%08x alu=${opcodeName(t.aluOpcode)} a=0x${t.aluA}%08x b=0x${t.aluB}%08x result=0x${t.result}%08x eff=0x${t.effAddr}%08x daddr=0x${t.dmemAddr}%08x$storeInfo branch=${t.branchTaken} div(active/done)=${t.divActive}/${t.divDone}"
            }
            .mkString("\n  ", "\n  ", "")
        }
      }

      def nextSeed(prev: Long): Long = {
        val raw = prev * 133L + 81L
        val mod = raw % 8095L
        if (mod < 0) mod + 8095L else mod
      }

      while (cycles < maxCycles && mismatch.isEmpty &&
        (seedsSeen < iterations || signatureValue.isEmpty)) {
        dut.io.irqSources.poke(0.U)
        dut.io.irqEnableMask.poke("hff".U)
        dut.io.irqComplete.poke(false.B)
        val pc = dut.io.pc.peek().litValue.toLong & 0xFFFFFFFFL
        val instr = rom.readWord(pc)
        dut.io.imemData.poke(instr.U(32.W))
        val addr = dut.io.dmemAddr.peek().litValue.toLong & 0xFFFFFFFFL
        val loadVal = loadWord(addr)
        dut.io.dmemData.poke((loadVal & 0xFFFFFFFFL).U(32.W))

        if (dut.io.dmemWen.peek().litToBoolean) {
          val data = dut.io.dmemWData.peek().litValue.toLong & 0xFFFFFFFFL
          storeWord(addr, data)
          if (storeTrace.length < 12) {
            storeTrace += addr -> data
          }
          if (addr == seedAddr) {
            if (!initClearSeen) {
              initClearSeen = true
            } else {
              val expected = nextSeed(expectedSeed) & 0xFFFFFFFFL
              if (data != expected && mismatch.isEmpty) {
                mismatch = Some((seedsSeen + 1, data, expected))
              }
              expectedSeed = expected
              seedsSeen += 1
            }
          }
          if (addr == signatureAddr) {
            signatureValue = Some(data)
          }
        }
        recordTrace(pc, instr)

        dut.clock.step()
        cycles += 1
      }

      mismatch match {
        case Some((iter, actual, expected)) =>
          val traceMsg = storeTrace.map { case (a, d) => f"0x$a%08x->0x$d%08x" }.mkString(", ")
          fail(
            f"""Seed mismatch at iteration $iter: expected 0x$expected%08x but ZeroNyte wrote 0x$actual%08x.
               |Stores: [$traceMsg]
               |Recent core trace:${renderTrace()}""".stripMargin
          )
        case None =>
          assert(
            seedsSeen == iterations,
            s"Only saw $seedsSeen seed updates before timing out (expected $iterations). Cycles=$cycles. Stores=[${storeTrace.map { case (a, d) => f"0x$a%08x->0x$d%08x" }.mkString(", ")}]. Recent core trace:${renderTrace()}"
          )
          val expectedRemainder = expectedSeed & 0xFFFFFFFFL
          val observedStr = signatureValue.map(v => f"0x$v%08x").getOrElse("<no store>")
          assert(
            signatureValue.contains(expectedRemainder),
            s"Expected ZeroNyte to store 0x${expectedRemainder.toHexString} to 0x${signatureAddr.toHexString}, " +
              s"but observed $observedStr. Recent core trace:${renderTrace()}"
          )
      }
    }
  }
}

case class RomImage(bytes: Array[Byte], base: Long) {
  private val mask32 = 0xFFFFFFFFL
  def readWord(addr: Long): Long = {
    val offset = addr - base
    if (offset < 0 || offset + 4 > bytes.length) {
      0L
    } else {
      val idx = offset.toInt
      val b0 = bytes(idx) & 0xFF
      val b1 = bytes(idx + 1) & 0xFF
      val b2 = bytes(idx + 2) & 0xFF
      val b3 = bytes(idx + 3) & 0xFF
      ((b3 << 24) | (b2 << 16) | (b1 << 8) | b0).toLong & mask32
    }
  }
}

object RomImage {
  def fromResource(path: String, base: Long): RomImage = {
    val stream = Option(getClass.getResourceAsStream(path))
      .getOrElse(throw new IllegalArgumentException(s"Missing ROM resource: $path"))
    val bytes = stream.readAllBytes()
    stream.close()
    RomImage(bytes, base)
  }
}
