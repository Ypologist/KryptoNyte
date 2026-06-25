package OctoNyte

import chisel3._
import chisel3.util._
import chisel3.dontTouch
import ALUs.ALU32
import ALUs.Mul32Pipelined
import Decoders.RV32IDecode
import Pipeline.ThreadScheduler
import BranchUnit.BranchUnit
import LoadUnit.LoadUnit
import StoreUnit.StoreUnit
import RegFiles.RegFileMT2R1WMem

// *********************************************************
// Core IO Definition
// *********************************************************
class OctoNyteRV32IZmmulCoreIO(val numThreads: Int, val fetchWidth: Int, val cosimulate: Boolean = false) extends Bundle {
  private val threadBits = log2Ceil(numThreads)

  val threadEnable = Input(Vec(numThreads, Bool()))
  val instrMem     = Input(UInt((fetchWidth * 32).W))
  val dataMemResp  = Input(UInt(32.W))
  val memAddr      = Output(UInt(32.W))
  val memWrite     = Output(UInt(32.W))
  val memMask      = Output(UInt(4.W))
  val memValid     = Output(Bool())
  val memMisaligned= Output(Bool())

  val debugStageThreads = Output(Vec(8, UInt((if(cosimulate) threadBits else 0).W)))
  val debugStageValids  = Output(Vec(8, UInt((if(cosimulate) 1 else 0).W)))
  val debugPC           = Output(Vec(numThreads, UInt((if(cosimulate) 32 else 0).W)))
  val debugRegs01234    = Output(Vec(numThreads, Vec(5, UInt((if(cosimulate) 32 else 0).W))))
  val debugRegX1        = Output(Vec(numThreads, UInt((if(cosimulate) 32 else 0).W)))
  val debugCtrlValid    = Output(UInt((if(cosimulate) 1 else 0).W))
  val debugCtrlInstr    = Output(UInt((if(cosimulate) 32 else 0).W))
  val debugCtrlTaken    = Output(UInt((if(cosimulate) 1 else 0).W))
  val debugCtrlThread   = Output(UInt((if(cosimulate) threadBits else 0).W))
  val debugCtrlFromPC   = Output(UInt((if(cosimulate) 32 else 0).W))
  val debugCtrlTarget   = Output(UInt((if(cosimulate) 32 else 0).W))
  val debugCtrlIsBranch = Output(UInt((if(cosimulate) 1 else 0).W))
  val debugCtrlIsJal    = Output(UInt((if(cosimulate) 1 else 0).W))
  val debugCtrlIsJalr   = Output(UInt((if(cosimulate) 1 else 0).W))
  val debugExecValid    = Output(UInt((if(cosimulate) 1 else 0).W))
  val debugExecThread   = Output(UInt((if(cosimulate) threadBits else 0).W))
  val debugExecPC       = Output(UInt((if(cosimulate) 32 else 0).W))
  val debugExecInstr    = Output(UInt((if(cosimulate) 32 else 0).W))
  val debugExecIsBranch = Output(UInt((if(cosimulate) 1 else 0).W))
  val debugExecIsJal    = Output(UInt((if(cosimulate) 1 else 0).W))
  val debugExecIsJalr   = Output(UInt((if(cosimulate) 1 else 0).W))
  val debugExecBranchOp = Output(UInt((if(cosimulate) 3 else 0).W))
  val debugExecRs1      = Output(UInt((if(cosimulate) 32 else 0).W))
  val debugExecRs2      = Output(UInt((if(cosimulate) 32 else 0).W))
  val debugExecCtrlTaken = Output(UInt((if(cosimulate) 1 else 0).W))
  val debugExecCtrlTarget = Output(UInt((if(cosimulate) 32 else 0).W))

  // JTAG Interface
  val jtag_tck    = Input(UInt((if(!cosimulate) 1 else 0).W))
  val jtag_tms    = Input(UInt((if(!cosimulate) 1 else 0).W))
  val jtag_tdi    = Input(UInt((if(!cosimulate) 1 else 0).W))
  val jtag_tdo    = Output(UInt((if(!cosimulate) 1 else 0).W))
  val jtag_trst_n = Input(UInt((if(!cosimulate) 1 else 0).W))
}

// ****************************************************************************************
// Pipeline Register Definitions
// ****************************************************************************************
class ZmmulPcSelectPipelineRegs(threadBits: Int) extends Bundle {
  val valid    = Bool()
  val threadId = UInt(threadBits.W)
  val pc       = UInt(32.W)
}

class ZmmulPcUpdatePipelineRegs(threadBits: Int) extends Bundle {
  val valid    = Bool()
  val threadId = UInt(threadBits.W)
  val pcHi     = UInt(16.W)
  val pcLow    = UInt(16.W)
  val carry    = Bool()
}

class ZmmulFetchPipelineRegs(threadBits: Int) extends Bundle {
  val valid    = Bool()
  val threadId = UInt(threadBits.W)
  val pc       = UInt(32.W)
  val instr    = UInt(32.W)
}

class ZmmulDecodePipelineRegs(threadBits: Int) extends Bundle {
  val fetchSignals = new ZmmulFetchPipelineRegs(threadBits)
  val decodeSignals = new RV32IDecode.DecodeSignals
}

class ZmmulDispatchPipelineRegs(threadBits: Int) extends Bundle {
  val decodePipelineSignals = new ZmmulDecodePipelineRegs(threadBits)
}

class ZmmulRegisterReadPipelineRegs(threadBits: Int) extends Bundle {
  val dispatchSignals = new ZmmulDispatchPipelineRegs(threadBits)
  val rs1Data  = UInt(32.W)
  val rs2Data  = UInt(32.W)
}

class ZmmulExec1PipelineRegs(threadBits: Int) extends Bundle {
  val regReadSignals = new ZmmulRegisterReadPipelineRegs(threadBits)
  val result   = UInt(32.W)
  val doRegFileWrite = Bool()
  val ctrlTaken = Bool()
  val ctrlTarget = UInt(32.W)
  val ctrlIsBranch = Bool()
  val ctrlBaseHi = UInt(16.W)
  val ctrlImmHi = UInt(16.W)
  val ctrlLow = UInt(16.W)
  val ctrlCarry = Bool()
  val ctrlClearBit0 = Bool()
  val ctrlClearBit1 = Bool()
}

class ZmmulExec2PipelineRegs(threadBits: Int) extends Bundle {
  val exec1Signals = new ZmmulExec1PipelineRegs(threadBits)
  val ctrlTaken = Bool()
  val ctrlTarget = UInt(32.W)
}

class ZmmulExec3PipelineRegs(threadBits: Int) extends Bundle {
  val exec2Signals = new ZmmulExec2PipelineRegs(threadBits)
}

class ZmmulWritebackPipelineRegs(threadBits: Int) extends Bundle {
  val exec3Signals = new ZmmulExec3PipelineRegs(threadBits)
}

class ZmmulDelayedWritebackRegs(threadBits: Int) extends Bundle {
  val valid = Bool()
  val threadId = UInt(threadBits.W)
  val rd = UInt(5.W)
  val result = UInt(32.W)
  val doRegFileWrite = Bool()
  val isMul = Bool()
  val isLoad = Bool()
  val mulFunct3 = UInt(3.W)
}

class ZmmulResultPipeIn(threadBits: Int) extends Bundle {
  val valid = Bool()
  val threadId = UInt(threadBits.W)
  val pc = UInt(32.W)
  val instr = UInt(32.W)
  val dec = new RV32IDecode.DecodeSignals
  val rs1Data = UInt(32.W)
  val rs2Data = UInt(32.W)
  val loadData = UInt(32.W)
}

class ZmmulScalarIntPre extends Bundle {
  val aluOp = UInt(ALU32.Opcode.WIDTH.W)
  val opA = UInt(32.W)
  val opB = UInt(32.W)
  val bEff = UInt(32.W)
  val isSubLike = Bool()
  val aSign = Bool()
  val bSign = Bool()
  val shiftRight = Bool()
  val shiftArithmetic = Bool()
}

class ZmmulScalarIntStage1 extends Bundle {
  val aluOp = UInt(ALU32.Opcode.WIDTH.W)
  val sumLo = UInt(8.W)
  val carry = Bool()
  val aHi = UInt(24.W)
  val bHi = UInt(24.W)
  val aSign = Bool()
  val bSign = Bool()
  val xorResult = UInt(32.W)
  val orResult = UInt(32.W)
  val andResult = UInt(32.W)
  val shiftResult = UInt(32.W)
  val shamtHi = UInt(3.W)
  val shiftRight = Bool()
  val shiftArithmetic = Bool()
}

class ZmmulScalarIntStage2 extends Bundle {
  val aluOp = UInt(ALU32.Opcode.WIDTH.W)
  val sumLo = UInt(16.W)
  val carry = Bool()
  val aHi = UInt(16.W)
  val bHi = UInt(16.W)
  val aSign = Bool()
  val bSign = Bool()
  val xorResult = UInt(32.W)
  val orResult = UInt(32.W)
  val andResult = UInt(32.W)
  val shiftResult = UInt(32.W)
  val shamtHi = UInt(1.W)
  val shiftRight = Bool()
  val shiftArithmetic = Bool()
}

class ZmmulScalarIntStage3 extends Bundle {
  val aluOp = UInt(ALU32.Opcode.WIDTH.W)
  val sumLo = UInt(24.W)
  val carry = Bool()
  val aHi = UInt(8.W)
  val bHi = UInt(8.W)
  val aSign = Bool()
  val bSign = Bool()
  val xorResult = UInt(32.W)
  val orResult = UInt(32.W)
  val andResult = UInt(32.W)
  val shiftResult = UInt(32.W)
}

class OctoNyteResultPipe(threadBits: Int) extends Module {
  val io = IO(new Bundle {
    val in = Input(new ZmmulResultPipeIn(threadBits))
    val out = Output(new ZmmulDelayedWritebackRegs(threadBits))
  })

  private def shiftStep(value: UInt, enable: Bool, amount: Int, right: Bool, arithmetic: Bool): UInt = {
    val shiftedRight = Cat(Fill(amount, arithmetic && value(31)), value(31, amount))
    val shiftedLeft = Cat(value(31 - amount, 0), 0.U(amount.W))
    Mux(enable, Mux(right, shiftedRight, shiftedLeft), value)
  }

  val inFunct3 = io.in.instr(14, 12)
  val inIsMExt = io.in.instr(6, 0) === RV32IDecode.OP_R && io.in.instr(31, 25) === "b0000001".U(7.W)
  val inIsMul = inIsMExt && !inFunct3(2)
  val inWritesAlu = (io.in.dec.isALU && !inIsMul) || io.in.dec.isLUI || io.in.dec.isAUIPC ||
    io.in.dec.isJAL || io.in.dec.isJALR
  val inWrites = io.in.valid && (inWritesAlu || io.in.dec.isLoad || inIsMul)

  val metaIn = WireDefault(0.U.asTypeOf(new ZmmulDelayedWritebackRegs(threadBits)))
  metaIn.valid := io.in.valid
  metaIn.threadId := io.in.threadId
  metaIn.rd := io.in.dec.rd
  metaIn.result := io.in.loadData
  metaIn.doRegFileWrite := inWrites
  metaIn.isMul := inIsMul
  metaIn.isLoad := io.in.dec.isLoad
  metaIn.mulFunct3 := inFunct3

  val mulUnit = Module(new Mul32Pipelined(6))
  mulUnit.io.a := io.in.rs1Data
  mulUnit.io.b := io.in.rs2Data
  mulUnit.io.signedA := inFunct3 =/= "b011".U
  mulUnit.io.signedB := (inFunct3 =/= "b011".U) && (inFunct3 =/= "b010".U)

  val raw = RegNext(io.in)
  val s0 = RegNext({
    val pre = Wire(new ZmmulScalarIntPre)
    val opcode = raw.instr(6, 0)
    val useImm = opcode === RV32IDecode.OP_I || raw.dec.isLUI || raw.dec.isAUIPC
    val linkResult = raw.dec.isJAL || raw.dec.isJALR
    val forceAdd = raw.dec.isLUI || raw.dec.isAUIPC || linkResult
    val aluOp = Mux(forceAdd, ALU32.Opcode.ADD, raw.dec.aluOp)
    pre.aluOp := aluOp
    pre.opA := Mux(linkResult || raw.dec.isAUIPC, raw.pc,
      Mux(raw.dec.isLUI, 0.U, raw.rs1Data))
    pre.opB := Mux(linkResult, 4.U(32.W), Mux(useImm, raw.dec.imm, raw.rs2Data))
    pre.isSubLike := aluOp === ALU32.Opcode.SUB || aluOp === ALU32.Opcode.SLT || aluOp === ALU32.Opcode.SLTU
    pre.bEff := Mux(pre.isSubLike, ~pre.opB, pre.opB)
    pre.aSign := pre.opA(31)
    pre.bSign := pre.opB(31)
    pre.shiftRight := aluOp === ALU32.Opcode.SRL || aluOp === ALU32.Opcode.SRA
    pre.shiftArithmetic := aluOp === ALU32.Opcode.SRA
    pre
  })

  val add0 = Cat(0.U(1.W), s0.opA(7, 0)) +& Cat(0.U(1.W), s0.bEff(7, 0)) + s0.isSubLike.asUInt
  val shiftBy1 = shiftStep(s0.opA, s0.opB(0), 1, s0.shiftRight, s0.shiftArithmetic)
  val shiftBy2 = shiftStep(shiftBy1, s0.opB(1), 2, s0.shiftRight, s0.shiftArithmetic)

  val s1 = RegNext({
    val stage = Wire(new ZmmulScalarIntStage1)
    stage.aluOp := s0.aluOp
    stage.sumLo := add0(7, 0)
    stage.carry := add0(8)
    stage.aHi := s0.opA(31, 8)
    stage.bHi := s0.bEff(31, 8)
    stage.aSign := s0.aSign
    stage.bSign := s0.bSign
    stage.xorResult := s0.opA ^ s0.opB
    stage.orResult := s0.opA | s0.opB
    stage.andResult := s0.opA & s0.opB
    stage.shiftResult := shiftBy2
    stage.shamtHi := s0.opB(4, 2)
    stage.shiftRight := s0.shiftRight
    stage.shiftArithmetic := s0.shiftArithmetic
    stage
  })

  val add1 = Cat(0.U(1.W), s1.aHi(7, 0)) +& Cat(0.U(1.W), s1.bHi(7, 0)) + s1.carry.asUInt
  val shiftBy4 = shiftStep(s1.shiftResult, s1.shamtHi(0), 4, s1.shiftRight, s1.shiftArithmetic)
  val shiftBy8 = shiftStep(shiftBy4, s1.shamtHi(1), 8, s1.shiftRight, s1.shiftArithmetic)

  val s2 = RegNext({
    val stage = Wire(new ZmmulScalarIntStage2)
    stage.aluOp := s1.aluOp
    stage.sumLo := Cat(add1(7, 0), s1.sumLo)
    stage.carry := add1(8)
    stage.aHi := s1.aHi(23, 8)
    stage.bHi := s1.bHi(23, 8)
    stage.aSign := s1.aSign
    stage.bSign := s1.bSign
    stage.xorResult := s1.xorResult
    stage.orResult := s1.orResult
    stage.andResult := s1.andResult
    stage.shiftResult := shiftBy8
    stage.shamtHi := s1.shamtHi(2).asUInt
    stage.shiftRight := s1.shiftRight
    stage.shiftArithmetic := s1.shiftArithmetic
    stage
  })

  val add2 = Cat(0.U(1.W), s2.aHi(7, 0)) +& Cat(0.U(1.W), s2.bHi(7, 0)) + s2.carry.asUInt
  val shiftBy16 = shiftStep(s2.shiftResult, s2.shamtHi(0), 16, s2.shiftRight, s2.shiftArithmetic)

  val s3 = RegNext({
    val stage = Wire(new ZmmulScalarIntStage3)
    stage.aluOp := s2.aluOp
    stage.sumLo := Cat(add2(7, 0), s2.sumLo)
    stage.carry := add2(8)
    stage.aHi := s2.aHi(15, 8)
    stage.bHi := s2.bHi(15, 8)
    stage.aSign := s2.aSign
    stage.bSign := s2.bSign
    stage.xorResult := s2.xorResult
    stage.orResult := s2.orResult
    stage.andResult := s2.andResult
    stage.shiftResult := shiftBy16
    stage
  })

  val add3 = Cat(0.U(1.W), s3.aHi) +& Cat(0.U(1.W), s3.bHi) + s3.carry.asUInt
  val sum = Cat(add3(7, 0), s3.sumLo)
  val carryOut = add3(8)
  val signedLess = Mux(s3.aSign =/= s3.bSign, s3.aSign, sum(31))
  val unsignedLess = !carryOut
  val aluResult = RegNext(MuxLookup(s3.aluOp, sum)(Seq(
    ALU32.Opcode.ADD -> sum,
    ALU32.Opcode.SUB -> sum,
    ALU32.Opcode.SLL -> s3.shiftResult,
    ALU32.Opcode.SLT -> Cat(0.U(31.W), signedLess),
    ALU32.Opcode.SLTU -> Cat(0.U(31.W), unsignedLess),
    ALU32.Opcode.XOR -> s3.xorResult,
    ALU32.Opcode.SRL -> s3.shiftResult,
    ALU32.Opcode.SRA -> s3.shiftResult,
    ALU32.Opcode.OR -> s3.orResult,
    ALU32.Opcode.AND -> s3.andResult
  )))

  val delayedMeta = ShiftRegister(metaIn, 6)
  val delayedMulResult = MuxLookup(delayedMeta.mulFunct3, mulUnit.io.lo)(Seq(
    "b000".U -> mulUnit.io.lo,
    "b001".U -> mulUnit.io.hi,
    "b010".U -> mulUnit.io.hi,
    "b011".U -> mulUnit.io.hi
  ))

  io.out := delayedMeta
  io.out.result := Mux(delayedMeta.isMul, delayedMulResult,
    Mux(delayedMeta.isLoad, delayedMeta.result, aluResult))
}

// *********************************************************
// OctoNyte Zmmul Core Definition
// *********************************************************
class OctoNyteRV32IZmmulCore(val cosimulate: Boolean = false) extends Module {
  val numThreads = 8
  val fetchWidth = 4
  val io = IO(new OctoNyteRV32IZmmulCoreIO(numThreads, fetchWidth, cosimulate))
  io.jtag_tdo := 0.U

  private val threadBits = log2Ceil(numThreads)

  // ===========================
  // DEBUG DEFAULTS
  // ===========================
  for (i <- 0 until 8) {
    io.debugStageThreads(i) := 0.U
    io.debugStageValids(i) := 0.U
  }

  for (t <- 0 until numThreads) {
    io.debugPC(t) := 0.U
    io.debugRegX1(t) := 0.U
    for (r <- 0 until 5) {
      io.debugRegs01234(t)(r) := 0.U
    }
  }

  io.debugCtrlValid    := 0.U
  io.debugCtrlInstr    := 0.U
  io.debugCtrlTaken    := 0.U
  io.debugCtrlThread   := 0.U
  io.debugCtrlFromPC   := 0.U
  io.debugCtrlTarget   := 0.U
  io.debugCtrlIsBranch := 0.U
  io.debugCtrlIsJal    := 0.U
  io.debugCtrlIsJalr   := 0.U

  io.debugExecValid        := 0.U
  io.debugExecThread       := 0.U
  io.debugExecPC           := 0.U
  io.debugExecInstr        := 0.U
  io.debugExecIsBranch     := 0.U
  io.debugExecIsJal        := 0.U
  io.debugExecIsJalr       := 0.U
  io.debugExecBranchOp     := 0.U
  io.debugExecRs1          := 0.U
  io.debugExecRs2          := 0.U
  io.debugExecCtrlTaken    := 0.U
  io.debugExecCtrlTarget   := 0.U

  // ================================================

  val threadCounter = RegInit(0.U(threadBits.W))

  val curThread = threadCounter
  val nextThread = Mux(curThread === (numThreads - 1).U, 0.U, curThread + 1.U)

  threadCounter := nextThread

  io.memAddr := 0.U
  io.memWrite := 0.U
  io.memMask := 0.U
  io.memValid := false.B
  io.memMisaligned := false.B

  val pcRegs = RegInit(VecInit(Seq.fill(numThreads)("h8000_0000".U(32.W))))
  val debugRegs1to4 = RegInit(VecInit(Seq.fill(numThreads)(VecInit(Seq.fill(4)(0.U(32.W))))))

  val regFile = Module(new RegFileMT2R1WMem(numThreads = numThreads))
  regFile.io.readThreadID := 0.U(threadBits.W)
  regFile.io.readAddrs := VecInit(Seq.fill(2)(0.U(5.W)))
  regFile.io.writeThreadID := 0.U(threadBits.W)
  regFile.io.writeAddrs := VecInit(Seq.fill(1)(0.U(5.W)))
  regFile.io.wens := VecInit(Seq.fill(1)(false.B))
  regFile.io.writeData := VecInit(Seq.fill(1)(0.U(32.W)))



  // Execution Units
  val resultPipe = Module(new OctoNyteResultPipe(threadBits))
  resultPipe.io.in := 0.U.asTypeOf(new ZmmulResultPipeIn(threadBits))
  val delayedWriteback = resultPipe.io.out
  val finalWBResult = delayedWriteback.result

  val loadUnit = Module(new LoadUnit)
  loadUnit.io.addr := 0.U
  loadUnit.io.dataIn := io.dataMemResp
  loadUnit.io.funct3 := 0.U

  val storeUnit = Module(new StoreUnit)
  storeUnit.io.addr := 0.U
  storeUnit.io.data := 0.U
  storeUnit.io.storeType := 0.U

// =============================
// Fetch stage
// =============================
  val pcSelectReg = RegInit(0.U.asTypeOf(new ZmmulPcSelectPipelineRegs(threadBits)))
  val selectedPc = pcRegs(curThread)
  when (io.threadEnable(curThread)) {
    pcSelectReg.valid    := true.B
    pcSelectReg.threadId := curThread
    pcSelectReg.pc       := selectedPc
  } .otherwise {
    pcSelectReg.valid := false.B
  }

  val fetchReg = RegInit(0.U.asTypeOf(new ZmmulFetchPipelineRegs(threadBits)))
  when (io.threadEnable(curThread)) {
    fetchReg.valid    := true.B
    fetchReg.threadId := curThread
    fetchReg.pc       := selectedPc
    fetchReg.instr    := io.instrMem(31, 0)
  } .otherwise {
    fetchReg.valid := false.B
  }

  val pcUpdateReg = RegInit(0.U.asTypeOf(new ZmmulPcUpdatePipelineRegs(threadBits)))
  when (io.threadEnable(curThread)) {
    val pcLowSum = Cat(0.U(1.W), selectedPc(15, 0)) + 4.U(17.W)
    pcUpdateReg.valid := true.B
    pcUpdateReg.threadId := curThread
    pcUpdateReg.pcHi := selectedPc(31, 16)
    pcUpdateReg.pcLow := pcLowSum(15, 0)
    pcUpdateReg.carry := pcLowSum(16)
  } .otherwise {
    pcUpdateReg.valid := false.B
  }

// =============================
// Decode stage
// =============================
val decodeReg = RegInit(0.U.asTypeOf(new ZmmulDecodePipelineRegs(threadBits)))

when (fetchReg.valid) {
  decodeReg.fetchSignals := fetchReg
  decodeReg.decodeSignals := RV32IDecode.decodeInstr(fetchReg.instr)
} .otherwise {
  decodeReg.fetchSignals.valid := false.B
}

// =============================
// Register read stage
// =============================
val regReadReg = RegInit(0.U.asTypeOf(new ZmmulRegisterReadPipelineRegs(threadBits)))

val regReadInput = Wire(new ZmmulDispatchPipelineRegs(threadBits))
regReadInput.decodePipelineSignals := decodeReg

when (decodeReg.fetchSignals.valid) {
  regReadReg.dispatchSignals := regReadInput
  val tid = decodeReg.fetchSignals.threadId
  regFile.io.readThreadID := tid
  regFile.io.readAddrs(0) := decodeReg.decodeSignals.rs1
  regFile.io.readAddrs(1) := decodeReg.decodeSignals.rs2
  val bypassValid = delayedWriteback.valid && delayedWriteback.doRegFileWrite &&
    delayedWriteback.threadId === tid && delayedWriteback.rd =/= 0.U
  regReadReg.rs1Data := Mux(bypassValid && delayedWriteback.rd === decodeReg.decodeSignals.rs1,
    finalWBResult, regFile.io.readData(0))
  regReadReg.rs2Data := Mux(bypassValid && delayedWriteback.rd === decodeReg.decodeSignals.rs2,
    finalWBResult, regFile.io.readData(1))
} .otherwise {
  regReadReg.dispatchSignals.decodePipelineSignals.fetchSignals.valid := false.B
}

// =============================
// Execute 1 stage
// =============================
  val exec1Reg = RegInit(0.U.asTypeOf(new ZmmulExec1PipelineRegs(threadBits)))

  when (regReadReg.dispatchSignals.decodePipelineSignals.fetchSignals.valid) {
    val decodeSignals = regReadReg.dispatchSignals.decodePipelineSignals.decodeSignals
    val fetchSignals = regReadReg.dispatchSignals.decodePipelineSignals.fetchSignals

    exec1Reg.regReadSignals := regReadReg
    exec1Reg.result := 0.U
    exec1Reg.doRegFileWrite := false.B
    exec1Reg.ctrlTaken := false.B
    exec1Reg.ctrlTarget := 0.U
    exec1Reg.ctrlIsBranch := false.B
    exec1Reg.ctrlBaseHi := 0.U
    exec1Reg.ctrlImmHi := 0.U
    exec1Reg.ctrlLow := 0.U
    exec1Reg.ctrlCarry := false.B
    exec1Reg.ctrlClearBit0 := false.B
    exec1Reg.ctrlClearBit1 := false.B

    resultPipe.io.in.valid := fetchSignals.valid
    resultPipe.io.in.threadId := fetchSignals.threadId
    resultPipe.io.in.pc := fetchSignals.pc
    resultPipe.io.in.instr := fetchSignals.instr
    resultPipe.io.in.dec := decodeSignals
    resultPipe.io.in.rs1Data := regReadReg.rs1Data
    resultPipe.io.in.rs2Data := regReadReg.rs2Data

    val ctrlActive = decodeSignals.isJAL || decodeSignals.isJALR || decodeSignals.isBranch
    val ctrlBase = Mux(decodeSignals.isJALR, regReadReg.rs1Data, fetchSignals.pc)
    val branchOffset = (decodeSignals.imm << 1)(31, 0)
    val ctrlOffset = Mux(decodeSignals.isBranch, branchOffset, decodeSignals.imm)
    val ctrlLowSum = Cat(0.U(1.W), ctrlBase(15, 0)) +& Cat(0.U(1.W), ctrlOffset(15, 0))
    val branchOp = fetchSignals.instr(14, 12)
    val branchTaken = MuxLookup(branchOp, false.B)(Seq(
      "b000".U -> (regReadReg.rs1Data === regReadReg.rs2Data),
      "b001".U -> (regReadReg.rs1Data =/= regReadReg.rs2Data),
      "b100".U -> (regReadReg.rs1Data.asSInt < regReadReg.rs2Data.asSInt),
      "b101".U -> (regReadReg.rs1Data.asSInt >= regReadReg.rs2Data.asSInt),
      "b110".U -> (regReadReg.rs1Data < regReadReg.rs2Data),
      "b111".U -> (regReadReg.rs1Data >= regReadReg.rs2Data)
    ))

    when (ctrlActive) {
      exec1Reg.ctrlTaken := (decodeSignals.isJAL || decodeSignals.isJALR) || branchTaken
      exec1Reg.ctrlIsBranch := decodeSignals.isBranch
      exec1Reg.ctrlBaseHi := ctrlBase(31, 16)
      exec1Reg.ctrlImmHi := ctrlOffset(31, 16)
      exec1Reg.ctrlLow := ctrlLowSum(15, 0)
      exec1Reg.ctrlCarry := ctrlLowSum(16)
      exec1Reg.ctrlClearBit0 := decodeSignals.isJALR || decodeSignals.isBranch
      exec1Reg.ctrlClearBit1 := decodeSignals.isBranch
    }
    when (decodeSignals.isLoad) {
      val address = regReadReg.rs1Data + decodeSignals.imm
      val loadActive = io.threadEnable(fetchSignals.threadId)
      io.memAddr := Cat(address(31, 2), 0.U(2.W))
      io.memValid := loadActive
      loadUnit.io.addr := address
      loadUnit.io.funct3 := fetchSignals.instr(14, 12)
      resultPipe.io.in.loadData := loadUnit.io.dataOut
    }
    when (decodeSignals.isStore) {
      val address = regReadReg.rs1Data + decodeSignals.imm
      val storeActive = io.threadEnable(fetchSignals.threadId) && !storeUnit.io.misaligned
      io.memAddr := Cat(address(31, 2), 0.U(2.W))
      storeUnit.io.addr := address
      storeUnit.io.data := regReadReg.rs2Data
      storeUnit.io.storeType := fetchSignals.instr(13, 12)

      io.memWrite := Mux(storeActive, storeUnit.io.memWrite, 0.U)
      io.memMask := Mux(storeActive, storeUnit.io.mask, 0.U)
      io.memValid := storeActive
      io.memMisaligned := io.threadEnable(fetchSignals.threadId) && storeUnit.io.misaligned
    }

  } .otherwise {
    exec1Reg.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid := false.B
  }

  // =============================
  // Execute 2 stage
  // =============================
 val exec2Reg = RegInit(0.U.asTypeOf(new ZmmulExec2PipelineRegs(threadBits)))
  when (exec1Reg.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid) {
    exec2Reg.exec1Signals := exec1Reg
    val ctrlHighSum = Cat(0.U(1.W), exec1Reg.ctrlBaseHi) +& Cat(0.U(1.W), exec1Reg.ctrlImmHi) + exec1Reg.ctrlCarry.asUInt
    val ctrlLowMasked = Cat(
      exec1Reg.ctrlLow(15, 2),
      Mux(exec1Reg.ctrlClearBit1, false.B, exec1Reg.ctrlLow(1)),
      Mux(exec1Reg.ctrlClearBit0, false.B, exec1Reg.ctrlLow(0))
    )
    val branchMisaligned = exec1Reg.ctrlIsBranch && (exec1Reg.ctrlLow(1, 0) =/= 0.U)
    exec2Reg.ctrlTarget := Cat(ctrlHighSum(15, 0), ctrlLowMasked)
    exec2Reg.ctrlTaken := exec1Reg.ctrlTaken && !branchMisaligned
  } .otherwise {
    exec2Reg.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid := false.B
    exec2Reg.ctrlTaken := false.B
    exec2Reg.ctrlTarget := 0.U
  }

  // =============================
  // Execute 3 stage
  // =============================
  val exec3Reg = RegInit(0.U.asTypeOf(new ZmmulExec3PipelineRegs(threadBits)))
    when (exec2Reg.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid) {
      exec3Reg.exec2Signals := exec2Reg
    } .otherwise {
      exec3Reg.exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid := false.B
    }

  // =============================
  // Writeback stage
  // =============================
val wbReg = RegInit(0.U.asTypeOf(new ZmmulWritebackPipelineRegs(threadBits)))
when (exec3Reg.exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid) {
  wbReg.exec3Signals := exec3Reg
} .otherwise {
  wbReg.exec3Signals.exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid := false.B
}

	val wbFetch = wbReg.exec3Signals.exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals
	val wbDecode = wbReg.exec3Signals.exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.decodeSignals
	val wbExec = wbReg.exec3Signals.exec2Signals.exec1Signals

	when (delayedWriteback.valid && delayedWriteback.doRegFileWrite && delayedWriteback.rd =/= 0.U) {
	  regFile.io.wens(0) := true.B
	  regFile.io.writeThreadID := delayedWriteback.threadId
	  regFile.io.writeAddrs(0) := delayedWriteback.rd
	  regFile.io.writeData(0) := finalWBResult
	}

	// Control-flow commit
	val ex2Fetch = exec2Reg.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals
	val ex2Redirect = ex2Fetch.valid && exec2Reg.ctrlTaken

	when (pcUpdateReg.valid) {
	  val pcHighSum = pcUpdateReg.pcHi + pcUpdateReg.carry.asUInt
	  pcRegs(pcUpdateReg.threadId) := Cat(pcHighSum, pcUpdateReg.pcLow)
	}

	// Resolve control flow in EX2; the barrel-thread gap keeps the redirect ahead of
	// that thread's next fetch slot without adding a throughput bubble.
	when (ex2Redirect) {
	  pcRegs(ex2Fetch.threadId) := exec2Reg.ctrlTarget
	}

	when (delayedWriteback.valid && delayedWriteback.doRegFileWrite && delayedWriteback.rd =/= 0.U) {
	  when (delayedWriteback.rd === 1.U) { debugRegs1to4(delayedWriteback.threadId)(0) := finalWBResult }
	    .elsewhen (delayedWriteback.rd === 2.U) { debugRegs1to4(delayedWriteback.threadId)(1) := finalWBResult }
	    .elsewhen (delayedWriteback.rd === 3.U) { debugRegs1to4(delayedWriteback.threadId)(2) := finalWBResult }
	    .elsewhen (delayedWriteback.rd === 4.U) { debugRegs1to4(delayedWriteback.threadId)(3) := finalWBResult }
	}

	// Keep writeback side-effect free for x0
	when (delayedWriteback.valid && delayedWriteback.doRegFileWrite && delayedWriteback.rd === 0.U) {
	  regFile.io.wens(0) := false.B
	}

// =====================================================
// Debug control
// =====================================================
val dbgFetch = wbReg.exec3Signals.exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals
val dbgDecode = wbReg.exec3Signals.exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.decodeSignals

io.debugStageThreads(0) := pcSelectReg.threadId
io.debugStageValids(0) := (pcSelectReg.valid).asUInt
io.debugStageThreads(1) := fetchReg.threadId
io.debugStageValids(1) := (fetchReg.valid).asUInt
io.debugStageThreads(2) := decodeReg.fetchSignals.threadId
io.debugStageValids(2) := (decodeReg.fetchSignals.valid).asUInt
io.debugStageThreads(3) := regReadReg.dispatchSignals.decodePipelineSignals.fetchSignals.threadId
io.debugStageValids(3) := (regReadReg.dispatchSignals.decodePipelineSignals.fetchSignals.valid).asUInt
io.debugStageThreads(4) := exec1Reg.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.threadId
io.debugStageValids(4) := (exec1Reg.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid).asUInt
io.debugStageThreads(5) := exec2Reg.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.threadId
io.debugStageValids(5) := (exec2Reg.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid).asUInt
io.debugStageThreads(6) := exec3Reg.exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.threadId
io.debugStageValids(6) := (exec3Reg.exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid).asUInt
io.debugStageThreads(7) := dbgFetch.threadId
io.debugStageValids(7) := (dbgFetch.valid).asUInt

io.debugCtrlValid := dbgFetch.valid
io.debugCtrlInstr := dbgFetch.instr
io.debugCtrlTaken := wbReg.exec3Signals.exec2Signals.ctrlTaken
io.debugCtrlThread := dbgFetch.threadId
io.debugCtrlFromPC := dbgFetch.pc
io.debugCtrlTarget := wbReg.exec3Signals.exec2Signals.ctrlTarget
io.debugCtrlIsBranch := dbgDecode.isBranch
io.debugCtrlIsJal := dbgDecode.isJAL
io.debugCtrlIsJalr := dbgDecode.isJALR

// =====================================================
// DEBUG VISIBILITY
// =====================================================
for (t <- 0 until numThreads) {
  io.debugRegs01234(t)(0) := 0.U
  io.debugRegs01234(t)(1) := debugRegs1to4(t)(0)
  io.debugRegs01234(t)(2) := debugRegs1to4(t)(1)
  io.debugRegs01234(t)(3) := debugRegs1to4(t)(2)
  io.debugRegs01234(t)(4) := debugRegs1to4(t)(3)
  io.debugRegX1(t) := debugRegs1to4(t)(0)
  io.debugPC(t)    := pcRegs(t)
}
}
