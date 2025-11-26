package OctoNyte

import chisel3._
import chisel3.util._
import ALUs.ALU32
import Decoders.RV32IDecode
import Pipeline.PipelineScheduler
import RegFiles.RegFileMTMultiWVec

class FetchBundle(threadBits: Int) extends Bundle {
  val valid    = Bool()
  val threadId = UInt(threadBits.W)
  val pc       = UInt(32.W)
  val instr    = UInt(32.W)
}

class StageBundle(threadBits: Int) extends Bundle {
  val valid    = Bool()
  val threadId = UInt(threadBits.W)
  val pc       = UInt(32.W)
  val instr    = UInt(32.W)
  val decode   = new RV32IDecode.DecodeSignals
  val rs1Data  = UInt(32.W)
  val rs2Data  = UInt(32.W)
  val result   = UInt(32.W)
}

class OctoNyteRV32ICoreIO(val numThreads: Int, val fetchWidth: Int) extends Bundle {
  val threadEnable = Input(Vec(numThreads, Bool()))
  val instrMem     = Input(UInt((fetchWidth * 32).W))
  val dataMemResp  = Input(UInt(32.W))
  val memAddr      = Output(UInt(32.W))
  val memWrite     = Output(UInt(32.W))
  val memMask      = Output(UInt(4.W))
  val memMisaligned= Output(Bool())

  val debugRegX1      = Output(Vec(numThreads, UInt(32.W)))
  val debugRegs01234  = Output(Vec(numThreads, Vec(5, UInt(32.W))))
  val debugPC         = Output(Vec(numThreads, UInt(32.W)))
  val debugIbCount    = Output(UInt(log2Ceil(9).W))
  val debugIbThread   = Output(UInt(log2Ceil(numThreads).W))
  val debugIbValid    = Output(Bool())
  val debugStageThreads = Output(Vec(8, UInt(log2Ceil(numThreads).W)))
  val debugStageValids  = Output(Vec(8, Bool()))
}

class OctoNyteRV32ICore extends Module {
  val numThreads = 8
  val fetchWidth = 4
  val io = IO(new OctoNyteRV32ICoreIO(numThreads, fetchWidth))

  private val threadBits = log2Ceil(numThreads)

  // Default IO outputs (no memory subsystem yet)
  io.memAddr := 0.U
  io.memWrite := 0.U
  io.memMask := 0.U
  io.memMisaligned := false.B

  // Round-robin pipeline scheduler shared by all stages
  val stageCount = 8
  val scheduler = Module(new PipelineScheduler(numThreads = numThreads, stageCount = stageCount))
  scheduler.io.threadEnable := io.threadEnable
  scheduler.io.advance := true.B
  io.debugStageThreads := scheduler.io.stageThreads
  io.debugStageValids := scheduler.io.stageValids

  // Per-thread program counters
  val pcRegs = RegInit(VecInit(Seq.fill(numThreads)("h8000_0000".U(32.W))))
  io.debugPC := pcRegs

  // Per-stage pipeline registers (one entry per thread)
  val fetchRegs       = RegInit(VecInit(Seq.fill(numThreads)(0.U.asTypeOf(new FetchBundle(threadBits)))))
  val decodeRegs      = RegInit(VecInit(Seq.fill(numThreads)(0.U.asTypeOf(new StageBundle(threadBits)))))
  val dispatchRegs    = RegInit(VecInit(Seq.fill(numThreads)(0.U.asTypeOf(new StageBundle(threadBits)))))
  val regReadRegs     = RegInit(VecInit(Seq.fill(numThreads)(0.U.asTypeOf(new StageBundle(threadBits)))))
  val exec1Regs       = RegInit(VecInit(Seq.fill(numThreads)(0.U.asTypeOf(new StageBundle(threadBits)))))
  val exec2Regs       = RegInit(VecInit(Seq.fill(numThreads)(0.U.asTypeOf(new StageBundle(threadBits)))))
  val exec3Regs       = RegInit(VecInit(Seq.fill(numThreads)(0.U.asTypeOf(new StageBundle(threadBits)))))

  // Multithreaded register file: 1 write port, 2 read groups (only port0 used for now)
  val regFile = Module(new RegFileMTMultiWVec(numThreads = numThreads, numWritePorts = 1, numReadPorts = 2))
  regFile.io.readThreadID := VecInit(Seq.fill(2)(0.U(threadBits.W)))
  regFile.io.src1 := VecInit(Seq.fill(2)(0.U(5.W)))
  regFile.io.src2 := VecInit(Seq.fill(2)(0.U(5.W)))
  regFile.io.writeThreadID := VecInit(Seq.fill(1)(0.U(threadBits.W)))
  regFile.io.dst := VecInit(Seq.fill(1)(0.U(5.W)))
  regFile.io.wen := VecInit(Seq.fill(1)(false.B))
  regFile.io.dstData := VecInit(Seq.fill(1)(0.U(32.W)))

  io.debugRegX1 := regFile.io.debugX1
  io.debugRegs01234 := regFile.io.debugRegs01234

  // =============================
  // Fetch stage
  // =============================
  val fetchThreadSel = scheduler.io.stageThreads(0)
  val fetchEntry = fetchRegs(fetchThreadSel)
  when(io.threadEnable(fetchThreadSel)) {
    val instrWord = io.instrMem(31, 0)
    fetchEntry.valid := true.B
    fetchEntry.threadId := fetchThreadSel
    fetchEntry.pc := pcRegs(fetchThreadSel)
    fetchEntry.instr := instrWord
    pcRegs(fetchThreadSel) := pcRegs(fetchThreadSel) + 4.U
  }.otherwise {
    fetchEntry.valid := false.B
  }

  // =============================
  // Decode stage
  // =============================
  val decodeThreadSel = scheduler.io.stageThreads(1)
  val fetchDecodeEntry = fetchRegs(decodeThreadSel)
  val decodeEntry = decodeRegs(decodeThreadSel)
  when(fetchDecodeEntry.valid && io.threadEnable(decodeThreadSel)) {
    val dec = RV32IDecode.decodeInstr(fetchDecodeEntry.instr)
    decodeEntry.valid := true.B
    decodeEntry.threadId := fetchDecodeEntry.threadId
    decodeEntry.pc := fetchDecodeEntry.pc
    decodeEntry.instr := fetchDecodeEntry.instr
    decodeEntry.decode := dec
    decodeEntry.rs1Data := 0.U
    decodeEntry.rs2Data := 0.U
    decodeEntry.result := 0.U
    fetchDecodeEntry.valid := false.B
  }.otherwise {
    decodeEntry.valid := false.B
  }

  // =============================
  // Dispatch stage
  // =============================
  val dispatchThreadSel = scheduler.io.stageThreads(2)
  val decodeToDispatchEntry = decodeRegs(dispatchThreadSel)
  when(decodeToDispatchEntry.valid && io.threadEnable(dispatchThreadSel)) {
    dispatchRegs(dispatchThreadSel) := decodeToDispatchEntry
    dispatchRegs(dispatchThreadSel).valid := true.B
    decodeToDispatchEntry.valid := false.B
  }.otherwise {
    dispatchRegs(dispatchThreadSel).valid := false.B
  }

  // =============================
  // Register read stage
  // =============================
  val regReadThreadSel = scheduler.io.stageThreads(3)
  val dispatchEntry = dispatchRegs(regReadThreadSel)
  when(dispatchEntry.valid && io.threadEnable(regReadThreadSel)) {
    regFile.io.readThreadID(0) := regReadThreadSel
    regFile.io.src1(0) := dispatchEntry.decode.rs1
    regFile.io.src2(0) := dispatchEntry.decode.rs2

    val rrEntry = regReadRegs(regReadThreadSel)
    rrEntry := dispatchEntry
    rrEntry.valid := true.B
    rrEntry.rs1Data := regFile.io.src1data(0)
    rrEntry.rs2Data := regFile.io.src2data(0)

    dispatchEntry.valid := false.B
  }.otherwise {
    regReadRegs(regReadThreadSel).valid := false.B
  }

  // =============================
  // Execute 1 stage (ALU)
  // =============================
  val alu = Module(new ALU32)
  alu.io.a := 0.U
  alu.io.b := 0.U
  alu.io.opcode := ALU32.Opcode.ADD

  val ex1ThreadSel = scheduler.io.stageThreads(4)
  val regReadEntry = regReadRegs(ex1ThreadSel)
  when(regReadEntry.valid && io.threadEnable(ex1ThreadSel)) {
    val opcode = regReadEntry.instr(6, 0)
    val useImm = (opcode === RV32IDecode.OP_I) || regReadEntry.decode.isLoad || regReadEntry.decode.isStore ||
      regReadEntry.decode.isJALR || regReadEntry.decode.isLUI || regReadEntry.decode.isAUIPC
    val opA = Mux(regReadEntry.decode.isAUIPC, regReadEntry.pc,
      Mux(regReadEntry.decode.isLUI, 0.U, regReadEntry.rs1Data))
    val opB = Mux(useImm, regReadEntry.decode.imm, regReadEntry.rs2Data)

    alu.io.a := opA
    alu.io.b := opB
    alu.io.opcode := regReadEntry.decode.aluOp

    val result = Mux(regReadEntry.decode.isAUIPC, regReadEntry.pc + regReadEntry.decode.imm,
      Mux(regReadEntry.decode.isLUI, regReadEntry.decode.imm, alu.io.result))

    val nextEntry = exec1Regs(ex1ThreadSel)
    nextEntry := regReadEntry
    nextEntry.result := result
    nextEntry.valid := true.B
    regReadEntry.valid := false.B
  }.otherwise {
    exec1Regs(ex1ThreadSel).valid := false.B
  }

  // =============================
  // Execute 2 stage (pass-through)
  // =============================
  val ex2ThreadSel = scheduler.io.stageThreads(5)
  when(exec1Regs(ex2ThreadSel).valid && io.threadEnable(ex2ThreadSel)) {
    exec2Regs(ex2ThreadSel) := exec1Regs(ex2ThreadSel)
    exec2Regs(ex2ThreadSel).valid := true.B
    exec1Regs(ex2ThreadSel).valid := false.B
  }.otherwise {
    exec2Regs(ex2ThreadSel).valid := false.B
  }

  // =============================
  // Execute 3 stage (pass-through)
  // =============================
  val ex3ThreadSel = scheduler.io.stageThreads(6)
  when(exec2Regs(ex3ThreadSel).valid && io.threadEnable(ex3ThreadSel)) {
    exec3Regs(ex3ThreadSel) := exec2Regs(ex3ThreadSel)
    exec3Regs(ex3ThreadSel).valid := true.B
    exec2Regs(ex3ThreadSel).valid := false.B
  }.otherwise {
    exec3Regs(ex3ThreadSel).valid := false.B
  }

  // =============================
  // Writeback stage
  // =============================
  val wbThreadSel = scheduler.io.stageThreads(7)
  val wbEntry = exec3Regs(wbThreadSel)
  val writeEnable = wbEntry.valid && io.threadEnable(wbThreadSel) &&
    (wbEntry.decode.isALU || wbEntry.decode.isLUI || wbEntry.decode.isAUIPC)
  when(writeEnable && wbEntry.decode.rd =/= 0.U) {
    regFile.io.writeThreadID(0) := wbThreadSel
    regFile.io.dst(0) := wbEntry.decode.rd
    regFile.io.wen(0) := true.B
    regFile.io.dstData(0) := wbEntry.result

  }
  when(wbEntry.valid && io.threadEnable(wbThreadSel)) {
    wbEntry.valid := false.B
  }

  // =============================
  // Debug instrumentation placeholders
  // =============================
  io.debugIbCount := 0.U
  io.debugIbThread := fetchThreadSel
  io.debugIbValid := false.B
}
