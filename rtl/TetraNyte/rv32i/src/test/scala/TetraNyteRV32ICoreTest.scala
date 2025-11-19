package TetraNyte

import chisel3._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.flatspec.AnyFlatSpec

class TetraNyteRV32ICoreTest extends AnyFlatSpec {
  "TetraNyteRV32ICore" should "simulate 4-threaded ALU, Load, Store, and Branch operations" in {
    simulate(new TetraNyteRV32ICore) { dut =>
      val numThreads = 4
      var resetPC = 0L
      val nop = 0x00000013L

      val program = Seq[Long](
        0x00000013L, // NOP
        0x00100093L, // ADDI x1, x0, 1
        0x00208133L, // ADD  x2, x1, x2
        0x00310233L, // ADD  x4, x2, x3
        0x004182B3L, // ADD  x5, x3, x4
        0x00520333L, // ADD  x6, x4, x5
        0x006283B3L  // ADD  x7, x5, x6
      )
      val memResponses = Seq(0xAAAA0000L, 0x55550000L, 0xDEADBEAFL, 0xCAFEBABEL)

      val threadPCs = Array.fill(numThreads)(resetPC)

      def refreshPCs(): Unit = {
        for (t <- 0 until numThreads) {
          threadPCs(t) = dut.io.if_pc(t).peek().litValue.longValue
        }
      }

      def instructionFor(pc: Long): Long = {
        if (pc < resetPC) {
          nop
        } else {
          val offset = pc - resetPC
          if (offset % 4 != 0) {
            nop
          } else {
            val index = (offset / 4).toInt
            if (index >= 0 && index < program.length) program(index) else nop
          }
        }
      }

      def driveInstructionPorts(): Unit = {
        for (t <- 0 until numThreads) {
          val instr = instructionFor(threadPCs(t))
          dut.io.instrMem(t).poke(instr.U)
        }
      }

      def driveDataMem(cycle: Int): Unit = {
        dut.io.dataMemResp.poke(memResponses(cycle % memResponses.length).U)
      }

      refreshPCs()
      val resetSnapshot = threadPCs.mkString(", ")
      resetPC = threadPCs.head
      assert(threadPCs.forall(_ == resetPC),
        f"All threads should share the same reset PC (0x$resetPC%08x) but saw $resetSnapshot")

      val pipelineLatency = 4
      val totalCycles = program.length * numThreads

      def formatThreadLog(t: Int, fetchPc: Long): String = {
        val ifPc = threadPCs(t)
        val ifInstr = dut.io.if_instr(t).peek().litValue
        val idRs1 = dut.io.id_rs1Data(t).peek().litValue
        val idRs2 = dut.io.id_rs2Data(t).peek().litValue
        val exAlu = dut.io.ex_aluResult(t).peek().litValue
        val memLoad = dut.io.mem_loadData(t).peek().litValue
        val memWrite = dut.io.memWrite.peek().litValue
        val memAddr = dut.io.memAddr.peek().litValue

        f"T$t fetchPC=0x$fetchPc%08x ifPC=0x$ifPc%08x instr=0x$ifInstr%08x " +
          f"RS1=0x$idRs1%08x RS2=0x$idRs2%08x ALU=0x$exAlu%08x " +
          f"Load=0x$memLoad%08x Store=0x$memWrite%08x Addr=0x$memAddr%08x"
      }

      for (cycle <- 0 until totalCycles + pipelineLatency) {
        val pcsBeforeStep = threadPCs.clone()
        driveInstructionPorts()
        driveDataMem(cycle)
        dut.clock.step()
        refreshPCs()

        if (cycle >= pipelineLatency) {
          val printCycle = cycle - pipelineLatency
          val perThreadLogs = (0 until numThreads).map { t =>
            formatThreadLog(t, pcsBeforeStep(t))
          }.mkString(" | ")

          println(f"[Cycle $printCycle%02d] $perThreadLogs")
        }
      }
    }
  }
}
