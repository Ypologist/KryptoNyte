package TetraNyte

import chisel3._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.flatspec.AnyFlatSpec

class TetraNyteRV32ICoreTest extends AnyFlatSpec {
  "TetraNyteRV32ICore" should "simulate 4-threaded ALU, Load, Store, and Branch operations" in {
    simulate(new TetraNyteRV32ICore) { dut =>

      val numThreads = 4
      val threadPCs = Array.fill(numThreads)(0L)

      val instrs = Array(
        Array(0x00000013L, 0x00100093L, 0x00008103L),
        Array(0x00200093L, 0x00308133L, 0x0020A023L),
        Array(0x00400113L, 0x005081B3L, 0x0040B103L),
        Array(0x00600213L, 0x00708233L, 0x0060C023L)
      )

      val memResponses = Array(0xAAAA0000L, 0x55550000L, 0xDEADBEAFL, 0xCAFEBABEL)

      val pipelineLatency = 4  // Adjust to match your pipeline depth
      val cycles = instrs(0).length * numThreads

      for (cycle <- 0 until cycles + pipelineLatency) {
        if (cycle < cycles) {
          for (t <- 0 until numThreads) {
            val instrIndex = (threadPCs(t) / 4).toInt
            val instrValue = if (instrIndex < instrs(t).length) instrs(t)(instrIndex) else 0x00000013L
            dut.io.instrMem(t).poke(instrValue.U)
          }
          dut.io.dataMemResp.poke(memResponses(cycle % numThreads).U)
        } else {
          // Flush pipeline with NOPs after all instructions sent
          for (t <- 0 until numThreads) {
            dut.io.instrMem(t).poke(0x00000013.U) // NOP
          }
          dut.io.dataMemResp.poke(0.U)
        }

        dut.clock.step(1)

        if (cycle >= pipelineLatency) {
          val printCycle = cycle - pipelineLatency
          val currentThread = printCycle % numThreads

          val if_pc    = dut.io.if_pc(currentThread).peek().litValue
          val if_instr = dut.io.if_instr(currentThread).peek().litValue
          val id_rs1   = dut.io.id_rs1Data(currentThread).peek().litValue
          val id_rs2   = dut.io.id_rs2Data(currentThread).peek().litValue
          val ex_alu   = dut.io.ex_aluResult(currentThread).peek().litValue
          val mem_load = dut.io.mem_loadData(currentThread).peek().litValue
          val mem_write= dut.io.memWrite.peek().litValue
          val mem_addr = dut.io.memAddr.peek().litValue

          println(f"[Cycle $printCycle%02d][Thread $currentThread] " +
            f"PC: 0x$if_pc%08x instr: 0x$if_instr%08x RS1Data: 0x$id_rs1%08x RS2Data: 0x$id_rs2%08x " +
            f"ALU: 0x$ex_alu%08x Load: 0x$mem_load%08x Store: 0x$mem_write%08x MemAddr: 0x$mem_addr%08x")

          threadPCs(currentThread) += 4
        }
      }
    }
  }
}
