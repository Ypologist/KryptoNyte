package ZeroNyte

import chisel3._
import chisel3.util._
import ALUs.{ALU32, Float32ALUPipelined, Float32DivSqrtUnit, Float32Ops}
import BranchUnit.BranchUnit
import Decoders.RV32IDecode
import LoadUnit.LoadUnit

object ZeroNyteExtensionClass {
  val width = 4

  val none = 0.U(width.W)
  val rvvOp = 1.U(width.W)
  val rvvLoad = 2.U(width.W)
  val rvvStore = 3.U(width.W)
  val matrix = 4.U(width.W)
  val tensor = 5.U(width.W)
  val custom = 15.U(width.W)
}

class ZeroNyteExtensionIssue extends Bundle {
  val pc = UInt(32.W)
  val instr = UInt(32.W)
  val opClass = UInt(ZeroNyteExtensionClass.width.W)
  val rd = UInt(5.W)
  val rs1 = UInt(5.W)
  val rs2 = UInt(5.W)
  val rs3 = UInt(5.W)
  val funct3 = UInt(3.W)
  val funct7 = UInt(7.W)
  val scalarRs1 = UInt(32.W)
  val scalarRs2 = UInt(32.W)
  val imm = UInt(32.W)
  val vl = UInt(32.W)
  val vtype = UInt(32.W)
  val vstart = UInt(32.W)
  val vxrm = UInt(2.W)
  val vxsat = Bool()
  val isMemory = Bool()
  val isStore = Bool()
  val memWidth = UInt(3.W)
  val memMode = UInt(2.W)
  val memMasked = Bool()
  val memSegments = UInt(3.W)
}

class ZeroNyteExtensionCompletion extends Bundle {
  val fault = Bool()
  val cause = UInt(8.W)
  val writeRd = Bool()
  val rd = UInt(5.W)
  val rdData = UInt(32.W)
  val writeVl = Bool()
  val vl = UInt(32.W)
  val writeVtype = Bool()
  val vtype = UInt(32.W)
  val writeVstart = Bool()
  val vstart = UInt(32.W)
  val writeVxsat = Bool()
  val vxsat = Bool()
}

class ZeroNytePendingExtension extends Bundle {
  val pc = UInt(32.W)
  val instr = UInt(32.W)
  val isVectorConfig = Bool()
}

class ZeroNyteRV32IFRVVCoreIO(val cosimulate: Boolean = false) extends Bundle {
  val imem_addr = Output(UInt(32.W))
  val imem_rdata = Input(UInt(32.W))

  val dmem_addr = Output(UInt(32.W))
  val dmem_rdata = Input(UInt(32.W))
  val dmem_wdata = Output(UInt(32.W))
  val dmem_wmask = Output(UInt(4.W))
  val dmem_valid = Output(Bool())
  val dmem_misaligned = Output(Bool())

  val extIssue = Decoupled(new ZeroNyteExtensionIssue)
  val extComplete = Flipped(Decoupled(new ZeroNyteExtensionCompletion))

  val replay_enable = Input(Bool())
  val replay_valid = Input(Bool())
  val replay_pc = Input(UInt(32.W))
  val replay_finish = Input(Bool())
  val replay_finish_pc = Input(UInt(32.W))
  val replay_step = Output(Bool())

  val interruptVector = Input(UInt(32.W))
  val interruptPending = Input(Bool())
  val interruptTaken = Output(Bool())

  val pc_out = Output(UInt((if (cosimulate) 32 else 0).W))
  val instr_out = Output(UInt((if (cosimulate) 32 else 0).W))
  val result = Output(UInt((if (cosimulate) 32 else 0).W))
  val trap_valid = Output(UInt((if (cosimulate) 1 else 0).W))
  val trap_cause = Output(UInt((if (cosimulate) 8 else 0).W))
  val ext_pending = Output(UInt((if (cosimulate) 1 else 0).W))
  val stall_reason = Output(UInt((if (cosimulate) 8 else 0).W))
  val retire_valid = Output(UInt((if (cosimulate) 1 else 0).W))
  val retire_pc = Output(UInt((if (cosimulate) 32 else 0).W))
  val retire_instr = Output(UInt((if (cosimulate) 32 else 0).W))
  val retire_write_rd = Output(UInt((if (cosimulate) 1 else 0).W))
  val retire_rd = Output(UInt((if (cosimulate) 5 else 0).W))
  val retire_wdata = Output(UInt((if (cosimulate) 32 else 0).W))
  val retire_write_fp = Output(UInt((if (cosimulate) 1 else 0).W))
  val retire_fp_rd = Output(UInt((if (cosimulate) 5 else 0).W))
  val retire_fp_wdata = Output(UInt((if (cosimulate) 32 else 0).W))
  val csr_fflags = Output(UInt((if (cosimulate) 5 else 0).W))
  val csr_frm = Output(UInt((if (cosimulate) 3 else 0).W))
  val csr_vl = Output(UInt((if (cosimulate) 32 else 0).W))
  val csr_vtype = Output(UInt((if (cosimulate) 32 else 0).W))
  val csr_vstart = Output(UInt((if (cosimulate) 32 else 0).W))

  val jtag_tck = Input(UInt((if (!cosimulate) 1 else 0).W))
  val jtag_tms = Input(UInt((if (!cosimulate) 1 else 0).W))
  val jtag_tdi = Input(UInt((if (!cosimulate) 1 else 0).W))
  val jtag_tdo = Output(UInt((if (!cosimulate) 1 else 0).W))
  val jtag_trst_n = Input(UInt((if (!cosimulate) 1 else 0).W))
}

class ZeroNyteIFRVVFetchRegs extends Bundle {
  val valid = Bool()
  val pc = UInt(32.W)
  val instr = UInt(32.W)
  val replay = Bool()
}

class ZeroNyteIFRVVDecodeRegs extends Bundle {
  val valid = Bool()
  val pc = UInt(32.W)
  val instr = UInt(32.W)
  val dec = new RV32IDecode.DecodeSignals
  val replay = Bool()
  val isExt = Bool()
  val isFpLoad = Bool()
  val isFpStore = Bool()
  val isFpOp = Bool()
  val isFpMAdd = Bool()
  val intPendingMask = UInt(32.W)
  val fpPendingMask = UInt(32.W)
  val fpFlagPending = Bool()
  val fpCsrPending = Bool()
  val usesIntRs1Flag = Bool()
  val usesIntRs2Flag = Bool()
  val usesFpRs1Flag = Bool()
  val usesFpRs2Flag = Bool()
  val usesFpRs3Flag = Bool()
  val writesFpFlag = Bool()
  val isFpComputeFlag = Bool()
  val isVectorConfigFlag = Bool()
}

class ZeroNyteIFRVVRegReadRegs extends Bundle {
  val decRegs = new ZeroNyteIFRVVDecodeRegs
  val rs1Data = UInt(32.W)
  val rs2Data = UInt(32.W)
  val frs1Data = UInt(32.W)
  val frs2Data = UInt(32.W)
  val frs3Data = UInt(32.W)
}

class ZeroNyteIFRVVExecRegs extends Bundle {
  val regReadRegs = new ZeroNyteIFRVVRegReadRegs
  val result = UInt(32.W)
  val fpResult = UInt(32.W)
  val rd = UInt(5.W)
  val fpRd = UInt(5.W)
  val intWriteMask = UInt(32.W)
  val writeInt = Bool()
  val writeFp = Bool()
  val scoreboardInt = Bool()
  val scoreboardFp = Bool()
  val usesScalarPipeIntResult = Bool()
  val isMul = Bool()
  val mulFunct3 = UInt(3.W)
  val isFpCompute = Bool()
  val fpUsesPipedResult = Bool()
  val fpUsesPipedIntResult = Bool()
  val fpDirectResult = UInt(32.W)
  val fpIntDirectResult = UInt(32.W)
  val fpFlags = UInt(5.W)
  val fpFlagsFromScalarPipe = Bool()
  val csrWrite = Bool()
  val csrAddr = UInt(12.W)
  val csrWdata = UInt(32.W)
  val branchTaken = Bool()
  val branchTarget = UInt(32.W)
  val trap = Bool()
  val trapCause = UInt(8.W)
}

class ZeroNyteFpDivSqrtRequest extends Bundle {
  val sqrt = Bool()
  val a = UInt(32.W)
  val b = UInt(32.W)
  val fpRd = UInt(5.W)
  val exec = new ZeroNyteIFRVVExecRegs
}

class ZeroNyteIFRVVPreExecRegs extends Bundle {
  val regReadRegs = new ZeroNyteIFRVVRegReadRegs
  val rd = UInt(5.W)
  val fpRd = UInt(5.W)
  val opcode = UInt(7.W)
  val funct3 = UInt(3.W)
  val fpFunct7 = UInt(7.W)
  val fpRs2 = UInt(5.W)
  val scoreboardsInt = Bool()
  val scoreboardsFp = Bool()
  val isMul = Bool()
  val mulSignedA = Bool()
  val mulSignedB = Bool()
  val isFpCompute = Bool()
  val fpAdd = Bool()
  val fpSub = Bool()
  val fpMul = Bool()
  val fpSgnj = Bool()
  val fpMinMax = Bool()
  val fpCompare = Bool()
  val fpToInt = Bool()
  val intToFp = Bool()
  val fpMoveClass = Bool()
  val intMoveToFp = Bool()
  val fpIllegal = Bool()
  val isIllegal = Bool()
  val fpuOpcode = UInt(Float32Ops.Opcode.WIDTH.W)
  val fpuA = UInt(32.W)
  val fpuB = UInt(32.W)
  val fpuC = UInt(32.W)
  val csrAddr = UInt(12.W)
  val csrOp = UInt(3.W)
  val csrSrc = UInt(32.W)
  val isAluLike = Bool()
  val isJal = Bool()
  val isJalr = Bool()
  val isBranch = Bool()
  val isLoad = Bool()
  val isStore = Bool()
  val isSystem = Bool()
  val isFence = Bool()
  val isFpLoad = Bool()
  val isFpStore = Bool()
  val isFpMAdd = Bool()
  val isFpOp = Bool()
  val jalTarget = UInt(32.W)
  val jalrTarget = UInt(32.W)
  val branchTaken = Bool()
  val branchTarget = UInt(32.W)
  val branchMisaligned = Bool()
}

class ZeroNyteScalarResultPipeIn extends Bundle {
  val valid = Bool()
  val pc = UInt(32.W)
  val instr = UInt(32.W)
  val dec = new RV32IDecode.DecodeSignals
  val isFpStore = Bool()
  val isFpOp = Bool()
  val isFpMAdd = Bool()
  val rs1Data = UInt(32.W)
  val rs2Data = UInt(32.W)
  val frs1Data = UInt(32.W)
  val frs2Data = UInt(32.W)
  val frs3Data = UInt(32.W)
}

class ZeroNyteScalarResultPipeOut extends Bundle {
  val intResult = UInt(32.W)
  val fpDirectResult = UInt(32.W)
  val fpIntDirectResult = UInt(32.W)
  val fpFlags = UInt(5.W)
}

class ZeroNyteScalarRegFile extends Module {
  val io = IO(new Bundle {
    val readAddrs = Input(Vec(2, UInt(5.W)))
    val readData = Output(Vec(2, UInt(32.W)))
    val writeMask = Input(UInt(32.W))
    val writeData = Input(UInt(32.W))
  })

  val regs = Reg(Vec(32, UInt(32.W)))

  for (idx <- 1 until 32) {
    when(io.writeMask(idx)) {
      regs(idx) := io.writeData
    }
  }

  private def readPort(addr: UInt): UInt = {
    val hits = (1 until 32).map(idx => addr === idx.U)
    val words = (1 until 32).map(idx => regs(idx))
    Mux(addr === 0.U, 0.U, Mux1H(hits, words))
  }

  for (port <- 0 until 2) {
    io.readData(port) := readPort(io.readAddrs(port))
  }
}

class ZeroNyteScalarIntPre extends Bundle {
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

class ZeroNyteScalarIntStage1 extends Bundle {
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

class ZeroNyteScalarIntStage2 extends Bundle {
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

class ZeroNyteScalarIntStage3 extends Bundle {
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

class ZeroNyteScalarIntPipe extends Module {
  val io = IO(new Bundle {
    val in = Input(new ZeroNyteScalarResultPipeIn)
    val result = Output(UInt(32.W))
  })

  private def shiftStep(value: UInt, enable: Bool, amount: Int, right: Bool, arithmetic: Bool): UInt = {
    val shiftedRight = Cat(Fill(amount, arithmetic && value(31)), value(31, amount))
    val shiftedLeft = Cat(value(31 - amount, 0), 0.U(amount.W))
    Mux(enable, Mux(right, shiftedRight, shiftedLeft), value)
  }

  val raw = RegNext(io.in)
  val s0 = RegNext({
    val pre = Wire(new ZeroNyteScalarIntPre)
    val opcode = raw.instr(6, 0)
    val useImm = opcode === RV32IDecode.OP_I || raw.dec.isLUI || raw.dec.isAUIPC
    val linkResult = raw.dec.isJAL || raw.dec.isJALR
    val forceAdd = raw.dec.isLUI || raw.dec.isAUIPC || linkResult
    val aluOp = Mux(forceAdd, ALU32.Opcode.ADD, raw.dec.aluOp)
    pre.aluOp := aluOp
    pre.opA := Mux(linkResult || raw.dec.isAUIPC, raw.pc,
      Mux(raw.dec.isLUI, 0.U, raw.rs1Data))
    pre.opB := Mux(linkResult, 4.U(32.W), Mux(useImm, raw.dec.imm, raw.rs2Data))
    pre.isSubLike := aluOp === ALU32.Opcode.SUB ||
      aluOp === ALU32.Opcode.SLT ||
      aluOp === ALU32.Opcode.SLTU
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
    val stage = Wire(new ZeroNyteScalarIntStage1)
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
    val stage = Wire(new ZeroNyteScalarIntStage2)
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
    val stage = Wire(new ZeroNyteScalarIntStage3)
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
  val s4 = RegNext(MuxLookup(s3.aluOp, sum)(Seq(
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

  io.result := s4
}

class ZeroNyteScalarFpPrep extends Bundle {
  val intResult = UInt(32.W)
  val funct3 = UInt(3.W)
  val fpFunct7 = UInt(7.W)
  val fpRs2 = UInt(5.W)
  val isFpMAdd = Bool()
  val maddOpcode = UInt(7.W)
  val rs1Data = UInt(32.W)
  val frs1Data = UInt(32.W)
  val aSign = Bool()
  val bSign = Bool()
  val cSign = Bool()
  val aExp = UInt(8.W)
  val bExp = UInt(8.W)
  val aFrac = UInt(23.W)
  val bFrac = UInt(23.W)
  val aMag = UInt(31.W)
  val bMag = UInt(31.W)
  val aZero = Bool()
  val bZero = Bool()
  val aInf = Bool()
  val bInf = Bool()
  val cInf = Bool()
  val aNaN = Bool()
  val bNaN = Bool()
  val aSNaN = Bool()
  val bSNaN = Bool()
  val cSNaN = Bool()
  val aQNaN = Bool()
  val aSubnormal = Bool()
  val aNormal = Bool()
  val f2iShift = SInt(10.W)
  val itofNegative = Bool()
  val itofAbs = UInt(32.W)
  val itofZero = Bool()
}

class ZeroNyteScalarFpMid extends Bundle {
  val intResult = UInt(32.W)
  val funct3 = UInt(3.W)
  val fpFunct7 = UInt(7.W)
  val fpRs2 = UInt(5.W)
  val rs1Data = UInt(32.W)
  val frs1Data = UInt(32.W)
  val fpCompareResult = UInt(32.W)
  val fpClass = UInt(32.W)
  val fpFlags = UInt(5.W)
  val f2iSign = Bool()
  val f2iSigned = Bool()
  val f2iOverRange = Bool()
  val f2iUnderRange = Bool()
  val f2iUnsignedValue = UInt(32.W)
  val itofNegative = Bool()
  val itofAbs = UInt(32.W)
  val itofZero = Bool()
  val itofLeadingZeros = UInt(5.W)
}

class ZeroNyteScalarFpFinish extends Bundle {
  val intResult = UInt(32.W)
  val fpFunct7 = UInt(7.W)
  val funct3 = UInt(3.W)
  val rs1Data = UInt(32.W)
  val frs1Data = UInt(32.W)
  val fpCompareResult = UInt(32.W)
  val fpClass = UInt(32.W)
  val fpFlags = UInt(5.W)
  val f2iResult = UInt(32.W)
  val itofResult = UInt(32.W)
}

class ZeroNyteScalarResultPipe extends Module {
  val io = IO(new Bundle {
    val in = Input(new ZeroNyteScalarResultPipeIn)
    val out = Output(new ZeroNyteScalarResultPipeOut)
  })

  private def signExt12(value: UInt): UInt = Cat(Fill(20, value(11)), value)
  private def fStoreImm(instr: UInt): UInt = signExt12(Cat(instr(31, 25), instr(11, 7)))

  val intPipe = Module(new ZeroNyteScalarIntPipe)
  intPipe.io.in := io.in

  val s0 = RegNext(io.in)

  val funct3 = s0.instr(14, 12)
  val fpFunct7 = s0.instr(31, 25)
  val fpRs2 = s0.instr(24, 20)

  val s1 = RegNext({
    val prep = Wire(new ZeroNyteScalarFpPrep)
    prep.intResult := 0.U
    prep.funct3 := funct3
    prep.fpFunct7 := fpFunct7
    prep.fpRs2 := fpRs2
    prep.isFpMAdd := s0.isFpMAdd
    prep.maddOpcode := s0.instr(6, 0)
    prep.rs1Data := s0.rs1Data
    prep.frs1Data := s0.frs1Data
    prep.aSign := s0.frs1Data(31)
    prep.bSign := s0.frs2Data(31)
    prep.cSign := s0.frs3Data(31)
    prep.aExp := s0.frs1Data(30, 23)
    prep.bExp := s0.frs2Data(30, 23)
    prep.aFrac := s0.frs1Data(22, 0)
    prep.bFrac := s0.frs2Data(22, 0)
    prep.aMag := s0.frs1Data(30, 0)
    prep.bMag := s0.frs2Data(30, 0)
    prep.aZero := s0.frs1Data(30, 0) === 0.U
    prep.bZero := s0.frs2Data(30, 0) === 0.U
    prep.aInf := s0.frs1Data(30, 23) === "hff".U && s0.frs1Data(22, 0) === 0.U
    prep.bInf := s0.frs2Data(30, 23) === "hff".U && s0.frs2Data(22, 0) === 0.U
    prep.cInf := s0.frs3Data(30, 23) === "hff".U && s0.frs3Data(22, 0) === 0.U
    prep.aNaN := s0.frs1Data(30, 23) === "hff".U && s0.frs1Data(22, 0) =/= 0.U
    prep.bNaN := s0.frs2Data(30, 23) === "hff".U && s0.frs2Data(22, 0) =/= 0.U
    prep.aSNaN := s0.frs1Data(30, 23) === "hff".U && s0.frs1Data(22, 0) =/= 0.U && !s0.frs1Data(22)
    prep.bSNaN := s0.frs2Data(30, 23) === "hff".U && s0.frs2Data(22, 0) =/= 0.U && !s0.frs2Data(22)
    prep.cSNaN := s0.frs3Data(30, 23) === "hff".U && s0.frs3Data(22, 0) =/= 0.U && !s0.frs3Data(22)
    prep.aQNaN := s0.frs1Data(30, 23) === "hff".U && s0.frs1Data(22, 0) =/= 0.U && s0.frs1Data(22)
    prep.aSubnormal := s0.frs1Data(30, 23) === 0.U && s0.frs1Data(22, 0) =/= 0.U
    prep.aNormal := s0.frs1Data(30, 23) =/= 0.U && s0.frs1Data(30, 23) =/= "hff".U
    prep.f2iShift := s0.frs1Data(30, 23).zext - 127.S
    val itofSigned = fpRs2 === 0.U
    prep.itofNegative := itofSigned && s0.rs1Data(31)
    prep.itofAbs := s0.rs1Data
    prep.itofZero := s0.rs1Data === 0.U
    prep
  })

  val s2 = RegNext({
    val mid = Wire(new ZeroNyteScalarFpMid)
    mid.intResult := s1.intResult
    mid.funct3 := s1.funct3
    mid.fpFunct7 := s1.fpFunct7
    mid.fpRs2 := s1.fpRs2
    mid.rs1Data := s1.rs1Data
    mid.frs1Data := s1.frs1Data

    val signsDiffer = s1.aSign =/= s1.bSign
    val fpLessThan = Mux(s1.aZero && s1.bZero, false.B,
      Mux(signsDiffer, s1.aSign,
        Mux(s1.aSign, s1.aMag > s1.bMag, s1.aMag < s1.bMag)))
    val fpEqual = (s1.aSign === s1.bSign && s1.aMag === s1.bMag) || (s1.aZero && s1.bZero)
    val fpAnyNaN2 = s1.aNaN || s1.bNaN
    mid.fpCompareResult := MuxLookup(s1.funct3, 0.U(32.W))(Seq(
      "b010".U -> (!fpAnyNaN2 && fpEqual).asUInt,
      "b001".U -> (!fpAnyNaN2 && fpLessThan).asUInt,
      "b000".U -> (!fpAnyNaN2 && (fpLessThan || fpEqual)).asUInt
    ))
    mid.fpClass := Cat(
      0.U(22.W),
      s1.aQNaN.asUInt,
      s1.aSNaN.asUInt,
      (!s1.aSign && s1.aInf).asUInt,
      (!s1.aSign && s1.aNormal).asUInt,
      (!s1.aSign && s1.aSubnormal).asUInt,
      (!s1.aSign && s1.aZero).asUInt,
      (s1.aSign && s1.aZero).asUInt,
      (s1.aSign && s1.aSubnormal).asUInt,
      (s1.aSign && s1.aNormal).asUInt,
      (s1.aSign && s1.aInf).asUInt)

    val maddProductInvalid = s1.aSNaN || s1.bSNaN ||
      ((s1.aInf && s1.bZero) || (s1.aZero && s1.bInf))
    val negateProduct = s1.maddOpcode === "b1001011".U || s1.maddOpcode === "b1001111".U
    val negateAddend = s1.maddOpcode === "b1000111".U || s1.maddOpcode === "b1001111".U
    val maddASign = s1.aSign ^ negateProduct
    val maddCSign = s1.cSign ^ negateAddend
    val maddProductInf = !maddProductInvalid && !s1.aNaN && !s1.bNaN &&
      ((s1.aInf && !s1.bZero) || (!s1.aZero && s1.bInf))
    val maddInvalid = maddProductInvalid || s1.cSNaN ||
      (maddProductInf && s1.cInf && (maddASign ^ s1.bSign) =/= maddCSign)
    val fpAddInvalid = s1.aSNaN || s1.bSNaN || (s1.aInf && s1.bInf && s1.aSign =/= s1.bSign)
    val fpSubInvalid = s1.aSNaN || s1.bSNaN || (s1.aInf && s1.bInf && s1.aSign === s1.bSign)
    val fpMulInvalid = s1.aSNaN || s1.bSNaN || ((s1.aInf && s1.bZero) || (s1.aZero && s1.bInf))
    val fpCompareInvalid = Mux(s1.funct3 === "b010".U, s1.aSNaN || s1.bSNaN, fpAnyNaN2)
    val fpFlags = Mux(s1.isFpMAdd,
      Mux(maddInvalid, Float32Ops.Flags.NV, 0.U),
      MuxLookup(s1.fpFunct7, 0.U(5.W))(Seq(
        "b0000000".U -> Mux(fpAddInvalid, Float32Ops.Flags.NV, 0.U),
        "b0000100".U -> Mux(fpSubInvalid, Float32Ops.Flags.NV, 0.U),
        "b0001000".U -> Mux(fpMulInvalid, Float32Ops.Flags.NV, 0.U),
        "b0010100".U -> Mux(s1.aSNaN || s1.bSNaN, Float32Ops.Flags.NV, 0.U),
        "b1010000".U -> Mux(fpCompareInvalid, Float32Ops.Flags.NV, 0.U),
        "b1100000".U -> Mux(s1.aNaN || s1.aInf, Float32Ops.Flags.NV, 0.U)
      )))
    mid.fpFlags := fpFlags

    val f2iMant = Cat(1.U(1.W), s1.aFrac)
    val f2iMantWide = Cat(0.U(8.W), f2iMant)
    val f2iLeftShift = (s1.f2iShift.asUInt - 23.U)(4, 0)
    val f2iRightShift = (23.U - s1.f2iShift.asUInt)(4, 0)
    mid.f2iSign := s1.aSign
    mid.f2iSigned := s1.fpRs2 === 0.U
    mid.f2iOverRange := s1.f2iShift > 31.S
    mid.f2iUnderRange := s1.f2iShift < 0.S
    mid.f2iUnsignedValue := Mux(s1.f2iShift >= 23.S,
      (f2iMantWide << f2iLeftShift)(31, 0),
      (f2iMantWide >> f2iRightShift)(31, 0))
    mid.itofNegative := s1.itofNegative
    val itofAbs = Mux(s1.itofNegative, (~s1.rs1Data).asUInt + 1.U, s1.rs1Data)
    mid.itofAbs := itofAbs
    mid.itofZero := s1.itofZero
    mid.itofLeadingZeros := PriorityEncoder(Reverse(itofAbs))
    mid
  })

  val s3 = RegNext({
    val fin = Wire(new ZeroNyteScalarFpFinish)
    fin.intResult := s2.intResult
    fin.fpFunct7 := s2.fpFunct7
    fin.funct3 := s2.funct3
    fin.rs1Data := s2.rs1Data
    fin.frs1Data := s2.frs1Data
    fin.fpCompareResult := s2.fpCompareResult
    fin.fpClass := s2.fpClass
    fin.fpFlags := s2.fpFlags

    val f2iSignedValue = Mux(s2.f2iSign, (~s2.f2iUnsignedValue).asUInt + 1.U, s2.f2iUnsignedValue)
    val f2iSaturated = Mux(s2.f2iSigned,
      Mux(s2.f2iSign, "h80000000".U(32.W), "h7fffffff".U(32.W)),
      Mux(s2.f2iSign, 0.U(32.W), "hffffffff".U(32.W)))
    fin.f2iResult := Mux(s2.f2iUnderRange, 0.U(32.W),
      Mux(s2.f2iOverRange, f2iSaturated,
        Mux(s2.f2iSigned, f2iSignedValue, s2.f2iUnsignedValue)))

    val itofNormalized = (s2.itofAbs << s2.itofLeadingZeros)(31, 0)
    val itofExp = 158.U - s2.itofLeadingZeros
    fin.itofResult := Cat(s2.itofNegative, itofExp(7, 0), itofNormalized(30, 8)) &
      Fill(32, !s2.itofZero)
    fin
  })

  val s4 = RegNext({
    val out = Wire(new ZeroNyteScalarResultPipeOut)
    out.intResult := s3.intResult
    out.fpDirectResult := Mux(s3.fpFunct7 === "b1101000".U, s3.itofResult, s3.rs1Data)
    out.fpIntDirectResult := MuxLookup(s3.fpFunct7, 0.U(32.W))(Seq(
      "b1010000".U -> s3.fpCompareResult,
      "b1100000".U -> s3.f2iResult,
      "b1110000".U -> Mux(s3.funct3 === "b001".U, s3.fpClass, s3.frs1Data)
    ))
    out.fpFlags := s3.fpFlags
    out
  })
  val s5 = RegNext(s4)
  val s6 = RegNext(s5)
  val s7 = RegNext(s6)
  val s8 = RegNext(s7)
  val s9 = RegNext(s8)
  val s10 = RegNext(s9)
  val s11 = RegNext(s10)

  io.out := s11
  io.out.intResult := ShiftRegister(intPipe.io.result, 6)
}

class ZeroNyteRV32IFRVVCore(val cosimulate: Boolean = false, val vlenbBytes: Int = 256)
    extends Module {
  val io = IO(new ZeroNyteRV32IFRVVCoreIO(cosimulate))

  private val resetPc = "h80000000".U(32.W)

  private val opFpLoad = "b0000111".U(7.W)
  private val opFpStore = "b0100111".U(7.W)
  private val opFp = "b1010011".U(7.W)
  private val opFmadd = "b1000011".U(7.W)
  private val opFmsub = "b1000111".U(7.W)
  private val opFnmsub = "b1001011".U(7.W)
  private val opFnmadd = "b1001111".U(7.W)
  private val opVector = "b1010111".U(7.W)
  private val opCustom0 = "b0001011".U(7.W)
  private val opCustom1 = "b0101011".U(7.W)
  private val opCustom2 = "b1011011".U(7.W)
  private val opCustom3 = "b1111011".U(7.W)

  private val csrFflags = "h001".U(12.W)
  private val csrFrm = "h002".U(12.W)
  private val csrFcsr = "h003".U(12.W)
  private val csrVstart = "h008".U(12.W)
  private val csrVxrm = "h009".U(12.W)
  private val csrVxsat = "h00a".U(12.W)
  private val csrVcsr = "h00f".U(12.W)
  private val csrVl = "hc20".U(12.W)
  private val csrVtype = "hc21".U(12.W)
  private val csrVlenb = "hc22".U(12.W)
  private val csrMstatus = "h300".U(12.W)
  private val csrMtvec = "h305".U(12.W)
  private val csrMepc = "h341".U(12.W)
  private val csrMcause = "h342".U(12.W)

  private def signExt12(value: UInt): UInt = Cat(Fill(20, value(11)), value)
  private def fStoreImm(instr: UInt): UInt = signExt12(Cat(instr(31, 25), instr(11, 7)))
  private def storeMisaligned(addr: UInt, storeType: UInt): Bool =
    Mux(storeType === 1.U, addr(0),
      Mux(storeType === 2.U, addr(1, 0) =/= 0.U, false.B))
  private def storeMask(addr: UInt, storeType: UInt): UInt =
    Mux(storeType === 0.U, (1.U(4.W) << addr(1, 0)),
      Mux(storeType === 1.U, (3.U(4.W) << addr(1, 0)),
        Mux(storeType === 2.U, 15.U(4.W), 0.U(4.W))))
  private def storeData(addr: UInt, data: UInt, storeType: UInt): UInt =
    Mux(storeType === 0.U, (data(7, 0) << (addr(1, 0) * 8.U))(31, 0),
      Mux(storeType === 1.U, (data(15, 0) << (addr(1) * 16.U))(31, 0),
        Mux(storeType === 2.U, data, 0.U(32.W))))

  private def isFloatLoad(instr: UInt): Bool =
    instr(6, 0) === opFpLoad && instr(14, 12) === "b010".U
  private def isFloatStore(instr: UInt): Bool =
    instr(6, 0) === opFpStore && instr(14, 12) === "b010".U
  private def isFloatOp(instr: UInt): Bool = instr(6, 0) === opFp
  private def isFloatMAdd(instr: UInt): Bool =
    instr(6, 0) === opFmadd || instr(6, 0) === opFmsub ||
      instr(6, 0) === opFnmsub || instr(6, 0) === opFnmadd

  private def isExtension(instr: UInt): Bool = {
    val opcode = instr(6, 0)
    val vectorLoad = opcode === opFpLoad && instr(14, 12) =/= "b010".U
    val vectorStore = opcode === opFpStore && instr(14, 12) =/= "b010".U
    opcode === opVector || vectorLoad || vectorStore ||
      opcode === opCustom0 || opcode === opCustom1 ||
      opcode === opCustom2 || opcode === opCustom3
  }

  private def extensionClass(instr: UInt): UInt = {
    val opcode = instr(6, 0)
    Mux(opcode === opVector, ZeroNyteExtensionClass.rvvOp,
      Mux(opcode === opFpLoad, ZeroNyteExtensionClass.rvvLoad,
      Mux(opcode === opFpStore, ZeroNyteExtensionClass.rvvStore,
      Mux(opcode === opCustom1, ZeroNyteExtensionClass.matrix,
      Mux(opcode === opCustom2, ZeroNyteExtensionClass.tensor,
      Mux(opcode === opCustom0 || opcode === opCustom3,
        ZeroNyteExtensionClass.custom,
        ZeroNyteExtensionClass.none))))))
  }

  private def usesIntRs1(regs: ZeroNyteIFRVVDecodeRegs): Bool = {
    val opcode = regs.instr(6, 0)
    val fpFunct7 = regs.instr(31, 25)
    (regs.dec.isALU && opcode =/= RV32IDecode.LUI && opcode =/= RV32IDecode.AUIPC) ||
      regs.dec.isLoad || regs.dec.isStore || regs.dec.isBranch || regs.dec.isJALR ||
      regs.isFpLoad || regs.isFpStore || regs.isExt ||
      (regs.isFpOp && (fpFunct7 === "b1101000".U || fpFunct7 === "b1111000".U)) ||
      (regs.dec.isSystem && regs.instr(14, 12)(2) === 0.U && regs.instr(14, 12) =/= 0.U)
  }

  private def usesIntRs2(regs: ZeroNyteIFRVVDecodeRegs): Bool = {
    val opcode = regs.instr(6, 0)
    (regs.dec.isALU && opcode === RV32IDecode.OP_R) ||
      regs.dec.isStore || regs.dec.isBranch || regs.isExt
  }

  private def writesInt(regs: ZeroNyteIFRVVDecodeRegs): Bool = {
    regs.dec.isALU || regs.dec.isLoad || regs.dec.isLUI || regs.dec.isAUIPC ||
      regs.dec.isJAL || regs.dec.isJALR ||
      (regs.dec.isSystem && regs.instr(14, 12) =/= 0.U) ||
      (regs.isFpOp && (regs.instr(31, 25) === "b1010000".U ||
        regs.instr(31, 25) === "b1100000".U ||
        regs.instr(31, 25) === "b1110000".U))
  }

  private def usesFpRs1(regs: ZeroNyteIFRVVDecodeRegs): Bool =
    regs.isFpOp || regs.isFpMAdd
  private def usesFpRs2(regs: ZeroNyteIFRVVDecodeRegs): Bool =
    regs.isFpOp || regs.isFpMAdd || regs.isFpStore
  private def usesFpRs3(regs: ZeroNyteIFRVVDecodeRegs): Bool =
    regs.isFpMAdd
  private def writesFp(regs: ZeroNyteIFRVVDecodeRegs): Bool =
    regs.isFpLoad || regs.isFpMAdd || (regs.isFpOp && (
      regs.instr(31, 25) === "b0000000".U ||
      regs.instr(31, 25) === "b0000100".U ||
      regs.instr(31, 25) === "b0001000".U ||
      regs.instr(31, 25) === "b0001100".U ||
      regs.instr(31, 25) === "b0010000".U ||
      regs.instr(31, 25) === "b0010100".U ||
      regs.instr(31, 25) === "b0101100".U ||
      regs.instr(31, 25) === "b1101000".U ||
      regs.instr(31, 25) === "b1111000".U))

  private def decodeOneHot32(addr: UInt): UInt = UIntToOH(addr, 32)
  private def predecodeIntPendingMask(regs: ZeroNyteIFRVVDecodeRegs): UInt =
    Mux(regs.valid && writesInt(regs) && regs.dec.rd =/= 0.U,
      decodeOneHot32(regs.dec.rd), 0.U(32.W))
  private def predecodeFpPendingMask(regs: ZeroNyteIFRVVDecodeRegs): UInt =
    Mux(regs.valid && writesFp(regs), decodeOneHot32(regs.instr(11, 7)), 0.U(32.W))
  private def predecodeFpFlagPending(regs: ZeroNyteIFRVVDecodeRegs): Bool =
    regs.valid && (regs.isFpOp || regs.isFpMAdd)
  private def predecodeFpCsrPending(regs: ZeroNyteIFRVVDecodeRegs): Bool =
    regs.valid && regs.dec.isSystem && regs.instr(14, 12) =/= 0.U && {
      val csrAddr = regs.instr(31, 20)
      csrAddr === csrFflags || csrAddr === csrFrm || csrAddr === csrFcsr
    }
  private def predecodeIsVectorConfig(regs: ZeroNyteIFRVVDecodeRegs): Bool =
    regs.instr(6, 0) === opVector && regs.instr(14, 12) === "b111".U

  private def emptyFetch: ZeroNyteIFRVVFetchRegs = 0.U.asTypeOf(new ZeroNyteIFRVVFetchRegs)
  private def emptyDecode: ZeroNyteIFRVVDecodeRegs = 0.U.asTypeOf(new ZeroNyteIFRVVDecodeRegs)
  private def emptyRegRead: ZeroNyteIFRVVRegReadRegs = 0.U.asTypeOf(new ZeroNyteIFRVVRegReadRegs)
  private def emptyPreExec: ZeroNyteIFRVVPreExecRegs = 0.U.asTypeOf(new ZeroNyteIFRVVPreExecRegs)
  private def emptyExec: ZeroNyteIFRVVExecRegs = 0.U.asTypeOf(new ZeroNyteIFRVVExecRegs)

  io.jtag_tdo := 0.U
  io.interruptTaken := false.B
  io.imem_addr := 0.U
  io.dmem_addr := 0.U
  io.dmem_wdata := 0.U
  io.dmem_wmask := 0.U
  io.dmem_valid := false.B
  io.dmem_misaligned := false.B
  io.extIssue.valid := false.B
  io.extIssue.bits := 0.U.asTypeOf(new ZeroNyteExtensionIssue)
  io.extComplete.ready := false.B
  io.replay_step := false.B

  val pc = RegInit(resetPc)
  val trapValid = RegInit(false.B)
  val trapCause = RegInit(0.U(8.W))

  val fflags = RegInit(0.U(5.W))
  val frm = RegInit(0.U(3.W))
  val vstart = RegInit(0.U(32.W))
  val vxrm = RegInit(0.U(2.W))
  val vxsat = RegInit(false.B)
  val vl = RegInit(0.U(32.W))
  val vtype = RegInit(0.U(32.W))
  val mstatus = RegInit(0.U(32.W))
  val mtvec = RegInit(0.U(32.W))
  val mepc = RegInit(0.U(32.W))
  val mcause = RegInit(0.U(32.W))
  val replayFinishPending = RegInit(false.B)

  val fetchPayloadReg = Reg(new ZeroNyteIFRVVFetchRegs)
  val decodePayloadReg = Reg(new ZeroNyteIFRVVDecodeRegs)
  val readAddrPayloadReg = Reg(new ZeroNyteIFRVVDecodeRegs)
  val dispatchPayloadReg = Reg(new ZeroNyteIFRVVDecodeRegs)
  val fetchValidReg = RegInit(false.B)
  val decodeValidReg = RegInit(false.B)
  val readAddrValidReg = RegInit(false.B)
  val dispatchValidReg = RegInit(false.B)
  val fetchReg = Wire(new ZeroNyteIFRVVFetchRegs)
  fetchReg := fetchPayloadReg
  fetchReg.valid := fetchValidReg
  val decodeReg = Wire(new ZeroNyteIFRVVDecodeRegs)
  decodeReg := decodePayloadReg
  decodeReg.valid := decodeValidReg
  val readAddrReg = Wire(new ZeroNyteIFRVVDecodeRegs)
  readAddrReg := readAddrPayloadReg
  readAddrReg.valid := readAddrValidReg
  val dispatchReg = Wire(new ZeroNyteIFRVVDecodeRegs)
  dispatchReg := dispatchPayloadReg
  dispatchReg.valid := dispatchValidReg
  val regReadPayloadReg = Reg(new ZeroNyteIFRVVRegReadRegs)
  val regReadValidReg = RegInit(false.B)
  val regReadReg = Wire(new ZeroNyteIFRVVRegReadRegs)
  regReadReg := regReadPayloadReg
  regReadReg.decRegs.valid := regReadValidReg
  val preExecPayloadReg = Reg(new ZeroNyteIFRVVPreExecRegs)
  val preExecValidReg = RegInit(false.B)
  val preExecReg = Wire(new ZeroNyteIFRVVPreExecRegs)
  preExecReg := preExecPayloadReg
  preExecReg.regReadRegs.decRegs.valid := preExecValidReg
  val exec1Reg = RegInit(emptyExec)
  val exec2Reg = RegInit(emptyExec)
  val exec3Reg = RegInit(emptyExec)
  val exec4Reg = RegInit(emptyExec)
  val exec5Reg = RegInit(emptyExec)
  val exec6Reg = RegInit(emptyExec)
  val exec7Reg = RegInit(emptyExec)
  val exec8Reg = RegInit(emptyExec)
  val exec9Reg = RegInit(emptyExec)
  val exec10Reg = RegInit(emptyExec)
  val exec11Reg = RegInit(emptyExec)
  val wbReg = RegInit(emptyExec)
  val fpDivSqrtPending = RegInit(false.B)
  val fpDivSqrtPendingExec = RegInit(emptyExec)
  val fpDivSqrtReqValid = RegInit(false.B)
  val fpDivSqrtReq = RegInit(0.U.asTypeOf(new ZeroNyteFpDivSqrtRequest))

  val regFile = Module(new ZeroNyteScalarRegFile)
  regFile.io.readAddrs := VecInit(Seq.fill(2)(0.U(5.W)))
  regFile.io.writeMask := 0.U
  regFile.io.writeData := 0.U

  val fpRegFile = Mem(32, UInt(32.W))
  val fpReadAddrs = WireDefault(VecInit(Seq.fill(3)(0.U(5.W))))
  val fpReadData = Wire(Vec(3, UInt(32.W)))
  for (idx <- 0 until 3) {
    fpReadData(idx) := fpRegFile.read(fpReadAddrs(idx))
  }

  val fpu = Module(new Float32ALUPipelined(12))
  fpu.io.a := 0.U
  fpu.io.b := 0.U
  fpu.io.c := 0.U
  fpu.io.opcode := Float32Ops.Opcode.ADD

  val fpDivSqrt = Module(new Float32DivSqrtUnit)
  fpDivSqrt.io.start := false.B
  fpDivSqrt.io.sqrt := false.B
  fpDivSqrt.io.a := 0.U
  fpDivSqrt.io.b := 0.U

  val branchUnit = Module(new BranchUnit)
  branchUnit.io.rs1 := 0.U
  branchUnit.io.rs2 := 0.U
  branchUnit.io.pc := 0.U
  branchUnit.io.imm := 0.S(32.W)
  branchUnit.io.branchOp := 0.U
  branchUnit.io.valid := false.B

  val loadUnit = Module(new LoadUnit)
  loadUnit.io.addr := 0.U
  loadUnit.io.dataIn := io.dmem_rdata
  loadUnit.io.funct3 := 0.U

  val scalarPipe = Module(new ZeroNyteScalarResultPipe)
  scalarPipe.io.in := 0.U.asTypeOf(new ZeroNyteScalarResultPipeIn)
  scalarPipe.io.in.valid := preExecReg.regReadRegs.decRegs.valid
  scalarPipe.io.in.pc := preExecReg.regReadRegs.decRegs.pc
  scalarPipe.io.in.instr := preExecReg.regReadRegs.decRegs.instr
  scalarPipe.io.in.dec := preExecReg.regReadRegs.decRegs.dec
  scalarPipe.io.in.isFpStore := preExecReg.regReadRegs.decRegs.isFpStore
  scalarPipe.io.in.isFpOp := preExecReg.regReadRegs.decRegs.isFpOp
  scalarPipe.io.in.isFpMAdd := preExecReg.regReadRegs.decRegs.isFpMAdd
  scalarPipe.io.in.rs1Data := preExecReg.regReadRegs.rs1Data
  scalarPipe.io.in.rs2Data := preExecReg.regReadRegs.rs2Data
  scalarPipe.io.in.frs1Data := preExecReg.regReadRegs.frs1Data
  scalarPipe.io.in.frs2Data := preExecReg.regReadRegs.frs2Data
  scalarPipe.io.in.frs3Data := preExecReg.regReadRegs.frs3Data

  val extRetireQueue = Module(new Queue(new ZeroNytePendingExtension, 16))
  extRetireQueue.io.enq.valid := false.B
  extRetireQueue.io.enq.bits := 0.U.asTypeOf(new ZeroNytePendingExtension)
  extRetireQueue.io.deq.ready := false.B
  val extPendingCount = RegInit(0.U(5.W))
  val extPendingBusy = extPendingCount =/= 0.U
  val extRetireCreditAvailable = extPendingCount =/= 16.U
  val extCompleteQueue = Module(new Queue(new ZeroNyteExtensionCompletion, 2))
  extCompleteQueue.io.enq.valid := io.extComplete.valid && extPendingBusy
  extCompleteQueue.io.enq.bits := io.extComplete.bits
  extCompleteQueue.io.deq.ready := false.B
  io.extComplete.ready := extPendingBusy && extCompleteQueue.io.enq.ready
  val extRetireStageValid = RegInit(false.B)
  val extRetireStageComplete = RegInit(0.U.asTypeOf(new ZeroNyteExtensionCompletion))
  val extRetireStagePending = RegInit(0.U.asTypeOf(new ZeroNytePendingExtension))
  val extRetireStageIntWriteMask = RegInit(0.U(32.W))
  val extRetireBusy = extPendingBusy
  val extVectorConfigPending = RegInit(false.B)
  val intPendingMask = RegInit(0.U(32.W))
  val fpPendingMask = RegInit(0.U(32.W))
  val fpFlagPending = RegInit(false.B)
  val fpCsrPending = RegInit(false.B)
  val scalarPipeBusy = RegInit(false.B)

  val fpPipedResult = fpu.io.result
  val regReadFpFunct7 = regReadReg.decRegs.instr(31, 25)
  val regReadIsFpDiv = regReadReg.decRegs.valid && regReadReg.decRegs.isFpOp &&
    regReadFpFunct7 === "b0001100".U
  val regReadIsFpSqrt = regReadReg.decRegs.valid && regReadReg.decRegs.isFpOp &&
    regReadFpFunct7 === "b0101100".U
  val regReadIsFpDivSqrt = regReadIsFpDiv || regReadIsFpSqrt
  val fpDivSqrtCanCapture = regReadIsFpDivSqrt && !fpDivSqrtReqValid &&
    !fpDivSqrtPending && !fpDivSqrt.io.busy
  val fpDivSqrtCanStart = fpDivSqrtReqValid && !fpDivSqrtPending && !fpDivSqrt.io.busy
  val fpDivSqrtComplete = fpDivSqrtPending && fpDivSqrt.io.done
  fpDivSqrt.io.start := fpDivSqrtCanStart
  fpDivSqrt.io.sqrt := fpDivSqrtReq.sqrt
  fpDivSqrt.io.a := fpDivSqrtReq.a
  fpDivSqrt.io.b := fpDivSqrtReq.b
  val fpDivSqrtFrontStall = regReadIsFpDivSqrt || fpDivSqrtReqValid ||
    (fpDivSqrtPending && !fpDivSqrt.io.done)

  val wbValid = wbReg.regReadRegs.decRegs.valid
  val wbInstr = wbReg.regReadRegs.decRegs.instr
  val wbIntResult = Mux(wbReg.usesScalarPipeIntResult, scalarPipe.io.out.intResult,
    Mux(wbReg.fpUsesPipedIntResult, scalarPipe.io.out.fpIntDirectResult, wbReg.result))
  val wbUsesFpDirectResult = wbReg.regReadRegs.decRegs.isFpOp &&
    (wbInstr(31, 25) === "b1101000".U || wbInstr(31, 25) === "b1111000".U)
  val wbFpResult = Mux(wbReg.fpUsesPipedResult, fpPipedResult,
    Mux(wbUsesFpDirectResult, scalarPipe.io.out.fpDirectResult, wbReg.fpResult))
  val wbFpFlags = Mux(wbReg.fpFlagsFromScalarPipe, scalarPipe.io.out.fpFlags, wbReg.fpFlags)

  when(wbValid && wbReg.writeFp) {
    fpRegFile.write(wbReg.fpRd, wbFpResult)
  }
  when(wbValid && wbFpFlags =/= 0.U) {
    fflags := fflags | wbFpFlags
  }
  when(wbValid && wbReg.csrWrite) {
    switch(wbReg.csrAddr) {
      is(csrFflags) { fflags := wbReg.csrWdata(4, 0) }
      is(csrFrm) { frm := wbReg.csrWdata(2, 0) }
      is(csrFcsr) {
        frm := wbReg.csrWdata(7, 5)
        fflags := wbReg.csrWdata(4, 0)
      }
      is(csrVstart) { vstart := wbReg.csrWdata }
      is(csrVxrm) { vxrm := wbReg.csrWdata(1, 0) }
      is(csrVxsat) { vxsat := wbReg.csrWdata(0) }
      is(csrVcsr) {
        vxrm := wbReg.csrWdata(2, 1)
        vxsat := wbReg.csrWdata(0)
      }
      is(csrMstatus) { mstatus := wbReg.csrWdata }
      is(csrMtvec) { mtvec := wbReg.csrWdata }
      is(csrMepc) { mepc := wbReg.csrWdata }
      is(csrMcause) { mcause := wbReg.csrWdata }
    }
  }
  when(wbValid && wbReg.trap) {
    trapValid := true.B
    trapCause := wbReg.trapCause
    mepc := wbReg.regReadRegs.decRegs.pc
    mcause := wbReg.trapCause
  }

  val wbIntWriteMaskReg = RegNext(Mux(exec11Reg.regReadRegs.decRegs.valid, exec11Reg.intWriteMask, 0.U(32.W)), 0.U(32.W))
  val wbIntWriteAddrReg = RegNext(Mux(exec11Reg.regReadRegs.decRegs.valid && exec11Reg.intWriteMask.orR, exec11Reg.rd, 0.U(5.W)), 0.U(5.W))
  val wbIntWrite = wbIntWriteMaskReg.orR
  val extCompleteHead = extRetireStageComplete
  val extRetireHead = extRetireStagePending
  val extCompleteWouldWriteInt = extRetireStageValid && extRetireStageIntWriteMask.orR
  val extCompleteWriteConflict = wbIntWrite && extCompleteWouldWriteInt
  val extCompleteFire = extRetireStageValid && !extCompleteWriteConflict
  val extRetireStageReady = !extRetireStageValid || extCompleteFire
  val extRetireStageLoad = extRetireStageReady && extRetireQueue.io.deq.valid && extCompleteQueue.io.deq.valid
  extRetireQueue.io.deq.ready := extRetireStageLoad
  extCompleteQueue.io.deq.ready := extRetireStageLoad
  when(extCompleteFire && !extRetireStageLoad) {
    extRetireStageValid := false.B
    extRetireStageIntWriteMask := 0.U
  }.elsewhen(extRetireStageLoad) {
    extRetireStageValid := true.B
    extRetireStageComplete := extCompleteQueue.io.deq.bits
    extRetireStagePending := extRetireQueue.io.deq.bits
    extRetireStageIntWriteMask := Mux(
      extCompleteQueue.io.deq.bits.writeRd && extCompleteQueue.io.deq.bits.rd =/= 0.U,
      UIntToOH(extCompleteQueue.io.deq.bits.rd, 32),
      0.U(32.W))
  }

  val extIntWrite = extCompleteFire && extRetireStageIntWriteMask.orR
  val extIntWriteMask = Mux(extIntWrite, extRetireStageIntWriteMask, 0.U(32.W))
  val retireIntWrite = wbIntWrite || extIntWrite
  val retireIntAddr = Mux(extIntWrite, extCompleteHead.rd, wbIntWriteAddrReg)
  val retireIntData = Mux(extIntWrite, extCompleteHead.rdData, wbIntResult)
  val lastIntWriteValid = RegNext(retireIntWrite, false.B)
  val lastIntWriteAddr = RegEnable(retireIntAddr, 0.U(5.W), retireIntWrite)
  val lastIntWriteData = RegEnable(retireIntData, 0.U(32.W), retireIntWrite)
  val rfWriteMask = RegNext(Mux(extIntWrite, extIntWriteMask, wbIntWriteMaskReg), 0.U(32.W))
  val rfWriteData = RegEnable(retireIntData, 0.U(32.W), retireIntWrite)
  regFile.io.writeMask := rfWriteMask
  regFile.io.writeData := rfWriteData

  val wbFpWrite = wbValid && wbReg.writeFp
  val lastFpWriteValid = RegNext(wbFpWrite, false.B)
  val lastFpWriteAddr = RegEnable(wbReg.fpRd, 0.U(5.W), wbFpWrite)
  val lastFpWriteData = RegEnable(wbFpResult, 0.U(32.W), wbFpWrite)

  def bypassIntRead(addr: UInt, raw: UInt): UInt =
    Mux(addr === 0.U, 0.U,
      Mux(lastIntWriteValid && lastIntWriteAddr === addr, lastIntWriteData, raw))

  def bypassFpRead(addr: UInt, raw: UInt): UInt =
    Mux(lastFpWriteValid && lastFpWriteAddr === addr, lastFpWriteData, raw)

  when(extCompleteFire) {
    when(extRetireHead.isVectorConfig) {
      extVectorConfigPending := false.B
    }
    when(extCompleteHead.fault) {
      trapValid := true.B
      trapCause := extCompleteHead.cause
      mepc := extRetireHead.pc
      mcause := extCompleteHead.cause
    }
    when(extCompleteHead.writeVl) { vl := extCompleteHead.vl }
    when(extCompleteHead.writeVtype) { vtype := extCompleteHead.vtype }
    when(extCompleteHead.writeVstart) { vstart := extCompleteHead.vstart }
    when(extCompleteHead.writeVxsat) { vxsat := extCompleteHead.vxsat }
  }

  val dispatchValid = dispatchReg.valid
  val dispatchRs1 = dispatchReg.dec.rs1
  val dispatchRs2 = dispatchReg.dec.rs2
  val dispatchRd = dispatchReg.dec.rd
  val dispatchFrs1 = dispatchReg.instr(19, 15)
  val dispatchFrs2 = dispatchReg.instr(24, 20)
  val dispatchFrs3 = dispatchReg.instr(31, 27)
  val dispatchFpRd = dispatchReg.instr(11, 7)

  def oh32(addr: UInt): UInt = UIntToOH(addr, 32)
  def maskHit(mask: UInt, addr: UInt): Bool = mask(addr)

  val dispatchIntHazardMask = intPendingMask
  val dispatchFpHazardMask = fpPendingMask

  val intRawHazard = dispatchValid && (
    (dispatchReg.usesIntRs1Flag && dispatchRs1 =/= 0.U && maskHit(dispatchIntHazardMask, dispatchRs1)) ||
    (dispatchReg.usesIntRs2Flag && dispatchRs2 =/= 0.U && maskHit(dispatchIntHazardMask, dispatchRs2))
  )
  val fpRawHazard = dispatchValid && (
    (dispatchReg.usesFpRs1Flag && maskHit(dispatchFpHazardMask, dispatchFrs1)) ||
    (dispatchReg.usesFpRs2Flag && maskHit(dispatchFpHazardMask, dispatchFrs2)) ||
    (dispatchReg.usesFpRs3Flag && maskHit(dispatchFpHazardMask, dispatchFrs3))
  )
  val fpWawHazard = dispatchValid && dispatchReg.writesFpFlag &&
    maskHit(dispatchFpHazardMask, dispatchFpRd)
  val dispatchTouchesFpCsr = dispatchValid && dispatchReg.fpCsrPending
  val pendingFpFlagWrite = fpFlagPending
  def writesFpCsr(regs: ZeroNyteIFRVVExecRegs): Bool =
    regs.regReadRegs.decRegs.valid && regs.csrWrite &&
      (regs.csrAddr === csrFflags || regs.csrAddr === csrFrm || regs.csrAddr === csrFcsr)
  val pendingFpCsrWrite = fpCsrPending
  val dispatchIsFpCompute = dispatchValid && dispatchReg.isFpComputeFlag
  val csrFpHazard = (dispatchTouchesFpCsr && (pendingFpFlagWrite || pendingFpCsrWrite)) ||
    (dispatchIsFpCompute && pendingFpCsrWrite)
  val olderScalarPipeBusy = scalarPipeBusy || regReadReg.decRegs.valid ||
    fpDivSqrtReqValid || fpDivSqrtPending
  val olderPipeBusy = olderScalarPipeBusy
  val extNeedsIssue = dispatchValid && dispatchReg.isExt
  val dispatchIsVectorConfig = extNeedsIssue && dispatchReg.isVectorConfigFlag
  val extSerializeBlocked =
    (dispatchIsVectorConfig && extRetireBusy) ||
      (!dispatchIsVectorConfig && extVectorConfigPending)
  val extCanRequest = extNeedsIssue &&
    !olderScalarPipeBusy && !trapValid && !extSerializeBlocked &&
    extRetireCreditAvailable && !intRawHazard && !fpRawHazard &&
    !fpWawHazard && !csrFpHazard
  io.extIssue.valid := extCanRequest && extRetireQueue.io.enq.ready
  val extIssueFire = io.extIssue.valid && io.extIssue.ready
  val scalarBlockedByExt =
    dispatchValid && !dispatchReg.isExt && (extRetireBusy || extIssueFire)
  val extBlocked = scalarBlockedByExt || (extNeedsIssue && !extIssueFire)
  val replayFetchActive = io.replay_enable && io.replay_valid && !trapValid
  val replayFinishRequested = io.replay_enable && (io.replay_finish || replayFinishPending)
  val replayFinishActive = replayFinishRequested && !replayFetchActive && !trapValid
  val interruptBlocked = io.interruptPending && (decodeReg.valid || readAddrReg.valid || dispatchValid ||
    olderPipeBusy || extRetireBusy || replayFetchActive || replayFinishRequested)
  val stallFront = intRawHazard || fpRawHazard || fpWawHazard || csrFpHazard || fpDivSqrtFrontStall ||
    extBlocked || interruptBlocked

  val stallReason = WireDefault(0.U(8.W))
  when(intRawHazard) { stallReason := 1.U }
  when(fpRawHazard) { stallReason := 2.U }
  when(fpWawHazard) { stallReason := 3.U }
  when(csrFpHazard) { stallReason := 4.U }
  when(fpDivSqrtFrontStall) { stallReason := 5.U }
  when(extBlocked) { stallReason := 6.U }
  when(interruptBlocked) { stallReason := 7.U }
  when(trapValid) { stallReason := 8.U }

  regFile.io.readAddrs(0) := dispatchRs1
  regFile.io.readAddrs(1) := dispatchRs2
  fpReadAddrs(0) := dispatchFrs1
  fpReadAddrs(1) := dispatchFrs2
  fpReadAddrs(2) := dispatchFrs3

  val dispatchFire = dispatchValid && !stallFront
  val frontAdvance = !stallFront
  val nextRegReadDecode = WireDefault(dispatchReg)
  nextRegReadDecode.valid := dispatchFire && !dispatchReg.isExt

  val extIssueBits = WireDefault(0.U.asTypeOf(new ZeroNyteExtensionIssue))
  extIssueBits.pc := dispatchReg.pc
  extIssueBits.instr := dispatchReg.instr
  extIssueBits.opClass := extensionClass(dispatchReg.instr)
  extIssueBits.rd := dispatchReg.instr(11, 7)
  extIssueBits.rs1 := dispatchReg.instr(19, 15)
  extIssueBits.rs2 := dispatchReg.instr(24, 20)
  extIssueBits.rs3 := dispatchReg.instr(31, 27)
  extIssueBits.funct3 := dispatchReg.instr(14, 12)
  extIssueBits.funct7 := dispatchReg.instr(31, 25)
  extIssueBits.scalarRs1 := bypassIntRead(dispatchRs1, regFile.io.readData(0))
  extIssueBits.scalarRs2 := bypassIntRead(dispatchRs2, regFile.io.readData(1))
  extIssueBits.imm := dispatchReg.dec.imm
  extIssueBits.vl := vl
  extIssueBits.vtype := vtype
  extIssueBits.vstart := vstart
  extIssueBits.vxrm := vxrm
  extIssueBits.vxsat := vxsat
  extIssueBits.isMemory := dispatchReg.instr(6, 0) === opFpLoad || dispatchReg.instr(6, 0) === opFpStore
  extIssueBits.isStore := dispatchReg.instr(6, 0) === opFpStore
  extIssueBits.memWidth := dispatchReg.instr(14, 12)
  extIssueBits.memMode := dispatchReg.instr(27, 26)
  extIssueBits.memMasked := !dispatchReg.instr(25)
  extIssueBits.memSegments := dispatchReg.instr(31, 29)

  val extPendingBits = WireDefault(0.U.asTypeOf(new ZeroNytePendingExtension))
  extPendingBits.pc := dispatchReg.pc
  extPendingBits.instr := dispatchReg.instr
  extPendingBits.isVectorConfig := dispatchIsVectorConfig
  io.extIssue.bits := extIssueBits
  extRetireQueue.io.enq.valid := extIssueFire
  extRetireQueue.io.enq.bits := extPendingBits

  when(extIssueFire && !extCompleteFire) {
    extPendingCount := extPendingCount + 1.U
  }.elsewhen(!extIssueFire && extCompleteFire) {
    extPendingCount := extPendingCount - 1.U
  }

  val redirect = WireDefault(false.B)
  val redirectTarget = WireDefault(0.U(32.W))

  val nextPreExec = WireDefault(emptyPreExec)
  nextPreExec.regReadRegs := regReadReg
  val nextPreExecValid = regReadReg.decRegs.valid && !regReadIsFpDivSqrt
  nextPreExec.regReadRegs.decRegs.valid := nextPreExecValid
  locally {
    val regs = regReadReg.decRegs
    val instr = regs.instr
    val opcode = instr(6, 0)
    val funct3 = instr(14, 12)
    val fpFunct7 = instr(31, 25)
    val fpRs2 = instr(24, 20)
    val isMExt = opcode === RV32IDecode.OP_R && fpFunct7 === "b0000001".U
    val jalTarget = (regs.pc.asSInt + regs.dec.imm.asSInt).asUInt
    val jalrTarget = ((regReadReg.rs1Data.asSInt + regs.dec.imm.asSInt).asUInt & ~1.U(32.W))

    branchUnit.io.rs1 := regReadReg.rs1Data
    branchUnit.io.rs2 := regReadReg.rs2Data
    branchUnit.io.pc := regs.pc
    branchUnit.io.imm := (regs.dec.imm << 1).asSInt
    branchUnit.io.branchOp := funct3
    branchUnit.io.valid := regs.dec.isBranch

    nextPreExec.rd := regs.dec.rd
    nextPreExec.fpRd := instr(11, 7)
    nextPreExec.opcode := opcode
    nextPreExec.funct3 := funct3
    nextPreExec.fpFunct7 := fpFunct7
    nextPreExec.fpRs2 := fpRs2
    nextPreExec.scoreboardsInt := writesInt(regs) && regs.dec.rd =/= 0.U
    nextPreExec.scoreboardsFp := writesFp(regs)
    nextPreExec.isMul := false.B
    nextPreExec.mulSignedA := false.B
    nextPreExec.mulSignedB := false.B
    nextPreExec.isFpCompute := regs.isFpOp || regs.isFpMAdd
    nextPreExec.isAluLike := (regs.dec.isALU && !isMExt) || regs.dec.isLUI || regs.dec.isAUIPC
    nextPreExec.isIllegal := isMExt
    nextPreExec.isJal := regs.dec.isJAL
    nextPreExec.isJalr := regs.dec.isJALR
    nextPreExec.isBranch := regs.dec.isBranch
    nextPreExec.isLoad := regs.dec.isLoad
    nextPreExec.isStore := regs.dec.isStore
    nextPreExec.isSystem := regs.dec.isSystem
    nextPreExec.isFence := regs.dec.isFence
    nextPreExec.isFpLoad := regs.isFpLoad
    nextPreExec.isFpStore := regs.isFpStore
    nextPreExec.isFpMAdd := regs.isFpMAdd
    nextPreExec.isFpOp := regs.isFpOp
    nextPreExec.fpAdd := regs.isFpOp && fpFunct7 === "b0000000".U
    nextPreExec.fpSub := regs.isFpOp && fpFunct7 === "b0000100".U
    nextPreExec.fpMul := regs.isFpOp && fpFunct7 === "b0001000".U
    nextPreExec.fpSgnj := regs.isFpOp && fpFunct7 === "b0010000".U
    nextPreExec.fpMinMax := regs.isFpOp && fpFunct7 === "b0010100".U
    nextPreExec.fpCompare := regs.isFpOp && fpFunct7 === "b1010000".U
    nextPreExec.fpToInt := regs.isFpOp && fpFunct7 === "b1100000".U
    nextPreExec.intToFp := regs.isFpOp && fpFunct7 === "b1101000".U
    nextPreExec.fpMoveClass := regs.isFpOp && fpFunct7 === "b1110000".U
    nextPreExec.intMoveToFp := regs.isFpOp && fpFunct7 === "b1111000".U
    val fpKnown = nextPreExec.fpAdd || nextPreExec.fpSub || nextPreExec.fpMul ||
      nextPreExec.fpSgnj || nextPreExec.fpMinMax || nextPreExec.fpCompare ||
      nextPreExec.fpToInt || nextPreExec.intToFp || nextPreExec.fpMoveClass ||
      nextPreExec.intMoveToFp
    nextPreExec.fpIllegal := regs.isFpOp && !fpKnown

    val negateProduct = opcode === opFnmsub || opcode === opFnmadd
    val negateAddend = opcode === opFmsub || opcode === opFnmadd
    nextPreExec.fpuA := Mux(regs.isFpMAdd && negateProduct,
      Float32Ops.negate(regReadReg.frs1Data), regReadReg.frs1Data)
    nextPreExec.fpuB := regReadReg.frs2Data
    nextPreExec.fpuC := Mux(regs.isFpMAdd && negateAddend,
      Float32Ops.negate(regReadReg.frs3Data), regReadReg.frs3Data)
    nextPreExec.fpuOpcode := Mux(regs.isFpMAdd, Float32Ops.Opcode.MADD,
      Mux(nextPreExec.fpSub, Float32Ops.Opcode.SUB,
      Mux(nextPreExec.fpMul, Float32Ops.Opcode.MUL,
      Mux(nextPreExec.fpSgnj,
        MuxLookup(funct3, Float32Ops.Opcode.SGNJ)(Seq(
          "b000".U -> Float32Ops.Opcode.SGNJ,
          "b001".U -> Float32Ops.Opcode.SGNJN,
          "b010".U -> Float32Ops.Opcode.SGNJX)),
      Mux(nextPreExec.fpMinMax,
        Mux(funct3(0), Float32Ops.Opcode.MAX, Float32Ops.Opcode.MIN),
        Float32Ops.Opcode.ADD)))))

    nextPreExec.csrAddr := instr(31, 20)
    nextPreExec.csrOp := funct3
    nextPreExec.csrSrc := Mux(funct3(2), Cat(0.U(27.W), instr(19, 15)), regReadReg.rs1Data)

    nextPreExec.jalTarget := jalTarget
    nextPreExec.jalrTarget := jalrTarget
    nextPreExec.branchTaken := regs.dec.isJAL || regs.dec.isJALR ||
      (regs.dec.isBranch && branchUnit.io.taken)
    nextPreExec.branchTarget := Mux(regs.dec.isJAL, jalTarget,
      Mux(regs.dec.isJALR, jalrTarget, branchUnit.io.target))
    nextPreExec.branchMisaligned := branchUnit.io.misaligned
  }

  val nextExec = WireDefault(emptyExec)
  val preExecValid = preExecReg.regReadRegs.decRegs.valid
  val regs = preExecReg.regReadRegs.decRegs
  val instr = regs.instr
  val funct3 = preExecReg.funct3
  val fpFunct7 = preExecReg.fpFunct7
  val fpRs2 = preExecReg.fpRs2

  val preExecFpLoadAddr = preExecReg.regReadRegs.rs1Data + signExt12(instr(31, 20))
  val preExecFpStoreAddr = preExecReg.regReadRegs.rs1Data + fStoreImm(instr)
  val preExecIntMemAddr = preExecReg.regReadRegs.rs1Data + regs.dec.imm
  val preExecSelectedStoreAddr = Mux(preExecReg.isFpStore, preExecFpStoreAddr, preExecIntMemAddr)
  val preExecSelectedStoreData = Mux(preExecReg.isFpStore, preExecReg.regReadRegs.frs2Data, preExecReg.regReadRegs.rs2Data)
  val preExecSelectedStoreType = Mux(preExecReg.isFpStore, 2.U(2.W), funct3(1, 0))
  val preExecSelectedStoreMisaligned = storeMisaligned(preExecSelectedStoreAddr, preExecSelectedStoreType)
  val preExecSelectedLoadAddr = Mux(preExecReg.isFpLoad, preExecFpLoadAddr, preExecIntMemAddr)
  val preExecSelectedMemAddr = Mux(preExecReg.isFpLoad || preExecReg.isLoad,
    preExecSelectedLoadAddr, preExecSelectedStoreAddr)
  val preExecSelectedMemIsStore = preExecReg.isFpStore || preExecReg.isStore
  val preExecMemMisaligned = preExecSelectedMemIsStore && preExecSelectedStoreMisaligned
  val preExecMemValid = preExecValid && ((preExecReg.isFpLoad || preExecReg.isLoad) ||
    (preExecSelectedMemIsStore && !preExecSelectedStoreMisaligned))
  val preExecStoreActive = preExecValid && preExecSelectedMemIsStore && !preExecSelectedStoreMisaligned

  io.dmem_addr := Cat(preExecSelectedMemAddr(31, 2), 0.U(2.W))
  io.dmem_wdata := Mux(preExecStoreActive,
    storeData(preExecSelectedStoreAddr, preExecSelectedStoreData, preExecSelectedStoreType), 0.U)
  io.dmem_wmask := Mux(preExecStoreActive,
    storeMask(preExecSelectedStoreAddr, preExecSelectedStoreType), 0.U)
  io.dmem_valid := preExecMemValid
  io.dmem_misaligned := preExecValid && preExecMemMisaligned
  loadUnit.io.addr := preExecSelectedMemAddr
  loadUnit.io.funct3 := Mux(preExecReg.isFpLoad, "b010".U, funct3)

  nextExec.regReadRegs := preExecReg.regReadRegs
  nextExec.rd := preExecReg.rd
  nextExec.fpRd := preExecReg.fpRd
  nextExec.scoreboardInt := preExecReg.scoreboardsInt
  nextExec.scoreboardFp := preExecReg.scoreboardsFp
  nextExec.mulFunct3 := funct3
  nextExec.isFpCompute := preExecReg.isFpCompute
  nextExec.branchTaken := preExecReg.branchTaken && preExecValid
  nextExec.branchTarget := preExecReg.branchTarget

  fpu.io.a := preExecReg.fpuA
  fpu.io.b := preExecReg.fpuB
  fpu.io.c := preExecReg.fpuC
  fpu.io.opcode := preExecReg.fpuOpcode

  when(preExecValid) {
    when(preExecReg.isIllegal) {
      nextExec.trap := true.B
      nextExec.trapCause := 2.U
    }.elsewhen(preExecReg.isAluLike) {
      nextExec.usesScalarPipeIntResult := true.B
      nextExec.writeInt := true.B
    }.elsewhen(preExecReg.isFpLoad) {
      nextExec.fpResult := loadUnit.io.dataOut
      nextExec.writeFp := true.B
    }.elsewhen(preExecReg.isFpStore) {
      nextExec.trap := preExecMemMisaligned
      nextExec.trapCause := 6.U
    }.elsewhen(preExecReg.isFpMAdd) {
      nextExec.fpUsesPipedResult := true.B
      nextExec.writeFp := true.B
      nextExec.fpFlagsFromScalarPipe := true.B
    }.elsewhen(preExecReg.isFpOp) {
      when(preExecReg.fpAdd) {
        nextExec.fpUsesPipedResult := true.B
        nextExec.writeFp := true.B
        nextExec.fpFlagsFromScalarPipe := true.B
      }.elsewhen(preExecReg.fpSub) {
        nextExec.fpUsesPipedResult := true.B
        nextExec.writeFp := true.B
        nextExec.fpFlagsFromScalarPipe := true.B
      }.elsewhen(preExecReg.fpMul) {
        nextExec.fpUsesPipedResult := true.B
        nextExec.writeFp := true.B
        nextExec.fpFlagsFromScalarPipe := true.B
      }.elsewhen(fpFunct7 === "b0001100".U || fpFunct7 === "b0101100".U) {
        nextExec := emptyExec
      }.elsewhen(preExecReg.fpSgnj) {
        nextExec.fpUsesPipedResult := true.B
        nextExec.writeFp := true.B
      }.elsewhen(preExecReg.fpMinMax) {
        nextExec.fpUsesPipedResult := true.B
        nextExec.writeFp := true.B
        nextExec.fpFlagsFromScalarPipe := true.B
      }.elsewhen(preExecReg.fpCompare) {
        nextExec.fpUsesPipedIntResult := true.B
        nextExec.writeInt := true.B
        nextExec.fpFlagsFromScalarPipe := true.B
      }.elsewhen(preExecReg.fpToInt) {
        nextExec.fpUsesPipedIntResult := true.B
        nextExec.writeInt := true.B
        nextExec.fpFlagsFromScalarPipe := true.B
      }.elsewhen(preExecReg.intToFp) {
        nextExec.writeFp := true.B
        nextExec.fpFlagsFromScalarPipe := true.B
      }.elsewhen(preExecReg.fpMoveClass) {
        nextExec.fpUsesPipedIntResult := true.B
        nextExec.writeInt := true.B
        nextExec.fpFlagsFromScalarPipe := true.B
      }.elsewhen(preExecReg.intMoveToFp) {
        nextExec.writeFp := true.B
        nextExec.fpFlagsFromScalarPipe := true.B
      }.otherwise {
        nextExec.trap := true.B
        nextExec.trapCause := 2.U
      }
    }.elsewhen(preExecReg.isJal) {
      nextExec.usesScalarPipeIntResult := true.B
      nextExec.writeInt := true.B
    }.elsewhen(preExecReg.isJalr) {
      nextExec.usesScalarPipeIntResult := true.B
      nextExec.writeInt := true.B
    }.elsewhen(preExecReg.isBranch) {
      nextExec.trap := preExecReg.branchMisaligned
      nextExec.trapCause := 0.U
    }.elsewhen(preExecReg.isLoad) {
      nextExec.result := loadUnit.io.dataOut
      nextExec.writeInt := true.B
    }.elsewhen(preExecReg.isStore) {
      nextExec.trap := preExecMemMisaligned
      nextExec.trapCause := 6.U
    }.elsewhen(preExecReg.isSystem) {
      val csrAddr = preExecReg.csrAddr
      val csrOp = preExecReg.csrOp
      val csrOld = WireDefault(0.U(32.W))
      val csrSrc = preExecReg.csrSrc
      switch(csrAddr) {
        is(csrFflags) { csrOld := Cat(0.U(27.W), fflags) }
        is(csrFrm) { csrOld := Cat(0.U(29.W), frm) }
        is(csrFcsr) { csrOld := Cat(0.U(24.W), frm, fflags) }
        is(csrVstart) { csrOld := vstart }
        is(csrVxrm) { csrOld := Cat(0.U(30.W), vxrm) }
        is(csrVxsat) { csrOld := vxsat.asUInt }
        is(csrVcsr) { csrOld := Cat(0.U(29.W), vxrm, vxsat.asUInt) }
        is(csrVl) { csrOld := vl }
        is(csrVtype) { csrOld := vtype }
        is(csrVlenb) { csrOld := vlenbBytes.U(32.W) }
        is(csrMstatus) { csrOld := mstatus }
        is(csrMtvec) { csrOld := mtvec }
        is(csrMepc) { csrOld := mepc }
        is(csrMcause) { csrOld := mcause }
      }
      val csrNew = MuxLookup(csrOp, csrOld)(Seq(
        "b001".U -> csrSrc,
        "b010".U -> (csrOld | csrSrc),
        "b011".U -> (csrOld & ~csrSrc),
        "b101".U -> csrSrc,
        "b110".U -> (csrOld | csrSrc),
        "b111".U -> (csrOld & ~csrSrc)
      ))
      val csrWrite = csrOp =/= 0.U && !(csrAddr === csrVl || csrAddr === csrVtype || csrAddr === csrVlenb)
      nextExec.csrWrite := csrWrite
      nextExec.csrAddr := csrAddr
      nextExec.csrWdata := csrNew
      nextExec.result := csrOld
      nextExec.writeInt := csrOp =/= 0.U
    }.elsewhen(preExecReg.isFence) {
      nextExec.result := 0.U
    }.otherwise {
      nextExec.trap := true.B
      nextExec.trapCause := 2.U
    }
  }

  when(fpDivSqrtCanCapture) {
    val reqExec = WireDefault(emptyExec)
    reqExec.regReadRegs := regReadReg
    reqExec.fpRd := regReadReg.decRegs.instr(11, 7)
    reqExec.writeFp := true.B
    reqExec.scoreboardFp := true.B
    reqExec.isFpCompute := true.B
    fpDivSqrtReqValid := true.B
    fpDivSqrtReq.sqrt := regReadIsFpSqrt
    fpDivSqrtReq.a := regReadReg.frs1Data
    fpDivSqrtReq.b := regReadReg.frs2Data
    fpDivSqrtReq.fpRd := regReadReg.decRegs.instr(11, 7)
    fpDivSqrtReq.exec := reqExec
  }

  when(fpDivSqrtCanStart) {
    fpDivSqrtPendingExec := fpDivSqrtReq.exec
    fpDivSqrtPending := true.B
    fpDivSqrtReqValid := false.B
  }.elsewhen(fpDivSqrtComplete) {
    fpDivSqrtPending := false.B
  }

  when(fpDivSqrtComplete) {
    nextExec := fpDivSqrtPendingExec
    nextExec.fpResult := fpDivSqrt.io.result
    nextExec.writeFp := true.B
    nextExec.fpFlags := fpDivSqrt.io.flags
  }
  nextExec.intWriteMask := Mux(
    nextExec.regReadRegs.decRegs.valid && nextExec.writeInt && nextExec.rd =/= 0.U,
    UIntToOH(nextExec.rd, 32),
    0.U(32.W))

  def preExecIntPending(regs: ZeroNyteIFRVVPreExecRegs): UInt =
    Mux(regs.regReadRegs.decRegs.valid && regs.scoreboardsInt, oh32(regs.rd), 0.U(32.W))
  def preExecFpPending(regs: ZeroNyteIFRVVPreExecRegs): UInt =
    Mux(regs.regReadRegs.decRegs.valid && regs.scoreboardsFp, oh32(regs.fpRd), 0.U(32.W))
  def execIntPending(regs: ZeroNyteIFRVVExecRegs): UInt =
    Mux(regs.scoreboardInt, oh32(regs.rd), 0.U(32.W))
  def execFpPending(regs: ZeroNyteIFRVVExecRegs): UInt =
    Mux(regs.scoreboardFp, oh32(regs.fpRd), 0.U(32.W))
  def execHasFpFlagWrite(regs: ZeroNyteIFRVVExecRegs): Bool =
    regs.regReadRegs.decRegs.valid && (regs.fpFlags =/= 0.U || regs.fpFlagsFromScalarPipe)

  val shiftedExecRegs = Seq(exec1Reg, exec2Reg, exec3Reg, exec4Reg, exec5Reg,
    exec6Reg, exec7Reg, exec8Reg, exec9Reg, exec10Reg)
  val shiftedIntPendingMask = shiftedExecRegs.map(execIntPending).reduce(_ | _)
  val shiftedFpPendingMask = shiftedExecRegs.map(execFpPending).reduce(_ | _)
  val fpDivSqrtReqMask = Mux(fpDivSqrtCanCapture, oh32(regReadReg.decRegs.instr(11, 7)),
    Mux(fpDivSqrtReqValid, oh32(fpDivSqrtReq.fpRd), 0.U(32.W)))
  val fpDivSqrtPendingMask = fpDivSqrtReqMask |
    Mux(fpDivSqrtCanStart, oh32(fpDivSqrtReq.fpRd),
      Mux(fpDivSqrtPending && !fpDivSqrtComplete, oh32(fpDivSqrtPendingExec.fpRd), 0.U(32.W)))

  val normalIntPendingMask =
    preExecIntPending(nextPreExec) | execIntPending(nextExec) | shiftedIntPendingMask
  val normalFpPendingMask =
    preExecFpPending(nextPreExec) | execFpPending(nextExec) |
      shiftedFpPendingMask | fpDivSqrtPendingMask
  val shiftedFpFlagPending =
    shiftedExecRegs.map(execHasFpFlagWrite).reduce(_ || _) ||
      (fpDivSqrtPending && !fpDivSqrtComplete)
  val fpDivSqrtFlagBusy = fpDivSqrtCanCapture || fpDivSqrtReqValid || fpDivSqrtCanStart
  val normalFpFlagPending =
    (nextPreExec.regReadRegs.decRegs.valid && nextPreExec.isFpCompute) ||
      execHasFpFlagWrite(nextExec) || shiftedFpFlagPending || fpDivSqrtFlagBusy
  val shiftedFpCsrPending = shiftedExecRegs.map(writesFpCsr).reduce(_ || _)
  val normalFpCsrPending =
    (nextPreExec.regReadRegs.decRegs.valid && nextPreExec.regReadRegs.decRegs.fpCsrPending) ||
      writesFpCsr(nextExec) || shiftedFpCsrPending
  val shiftedScalarBusy = shiftedExecRegs.map(_.regReadRegs.decRegs.valid).reduce(_ || _)
  val normalScalarBusy =
    (dispatchFire && !dispatchReg.isExt) || nextPreExec.regReadRegs.decRegs.valid ||
      nextExec.regReadRegs.decRegs.valid || shiftedScalarBusy

  when(redirect) {
    intPendingMask := shiftedIntPendingMask
    fpPendingMask := shiftedFpPendingMask | fpDivSqrtPendingMask
    fpFlagPending := shiftedFpFlagPending
    fpCsrPending := shiftedFpCsrPending
    scalarPipeBusy := shiftedScalarBusy
  }.otherwise {
    intPendingMask := normalIntPendingMask
    fpPendingMask := normalFpPendingMask
    fpFlagPending := normalFpFlagPending
    fpCsrPending := normalFpCsrPending
    scalarPipeBusy := normalScalarBusy
  }

  redirect := exec1Reg.branchTaken && exec1Reg.regReadRegs.decRegs.valid &&
    !exec1Reg.trap && !exec1Reg.regReadRegs.decRegs.replay
  redirectTarget := exec1Reg.branchTarget

  when(extIssueFire) {
    when(dispatchIsVectorConfig) {
      extVectorConfigPending := true.B
    }
  }

  val fetchAddress = Mux(replayFetchActive, io.replay_pc, Mux(replayFinishActive, io.replay_finish_pc, pc))
  val fetchFromReplay = replayFetchActive
  val fetchFromReplayFinish = replayFinishActive
  val interruptFire = io.interruptPending && !interruptBlocked && !trapValid
  val fetchAccepted = frontAdvance && !interruptFire && !redirect && !trapValid
  val fetchedDecodePayload = WireDefault(emptyDecode)
  fetchedDecodePayload.valid := fetchValidReg
  fetchedDecodePayload.pc := fetchReg.pc
  fetchedDecodePayload.instr := fetchReg.instr
  fetchedDecodePayload.dec := RV32IDecode.decodeInstr(fetchReg.instr)
  fetchedDecodePayload.replay := fetchReg.replay
  fetchedDecodePayload.isExt := isExtension(fetchReg.instr)
  fetchedDecodePayload.isFpLoad := isFloatLoad(fetchReg.instr)
  fetchedDecodePayload.isFpStore := isFloatStore(fetchReg.instr)
  fetchedDecodePayload.isFpOp := isFloatOp(fetchReg.instr)
  fetchedDecodePayload.isFpMAdd := isFloatMAdd(fetchReg.instr)
  fetchedDecodePayload.intPendingMask := predecodeIntPendingMask(fetchedDecodePayload)
  fetchedDecodePayload.fpPendingMask := predecodeFpPendingMask(fetchedDecodePayload)
  fetchedDecodePayload.fpFlagPending := predecodeFpFlagPending(fetchedDecodePayload)
  fetchedDecodePayload.fpCsrPending := predecodeFpCsrPending(fetchedDecodePayload)
  fetchedDecodePayload.usesIntRs1Flag := usesIntRs1(fetchedDecodePayload)
  fetchedDecodePayload.usesIntRs2Flag := usesIntRs2(fetchedDecodePayload)
  fetchedDecodePayload.usesFpRs1Flag := usesFpRs1(fetchedDecodePayload)
  fetchedDecodePayload.usesFpRs2Flag := usesFpRs2(fetchedDecodePayload)
  fetchedDecodePayload.usesFpRs3Flag := usesFpRs3(fetchedDecodePayload)
  fetchedDecodePayload.writesFpFlag := writesFp(fetchedDecodePayload)
  fetchedDecodePayload.isFpComputeFlag := fetchedDecodePayload.isFpOp || fetchedDecodePayload.isFpMAdd
  fetchedDecodePayload.isVectorConfigFlag := predecodeIsVectorConfig(fetchedDecodePayload)
  io.replay_step := fetchAccepted && fetchFromReplay
  when(io.replay_enable && io.replay_finish && !(fetchAccepted && replayFinishActive)) {
    replayFinishPending := true.B
  }

  when(interruptFire) {
    io.interruptTaken := true.B
    mepc := pc
    mcause := 11.U
    pc := io.interruptVector
    fetchValidReg := false.B
    decodeValidReg := false.B
    readAddrValidReg := false.B
    dispatchValidReg := false.B
    regReadValidReg := false.B
    preExecValidReg := false.B
  }.elsewhen(redirect) {
    pc := redirectTarget
    fetchValidReg := false.B
    decodeValidReg := false.B
    readAddrValidReg := false.B
    dispatchValidReg := false.B
    regReadValidReg := false.B
    preExecValidReg := false.B
  }.otherwise {
    when(frontAdvance) {
      fetchValidReg := true.B
      fetchPayloadReg.pc := fetchAddress
      fetchPayloadReg.instr := io.imem_rdata
      fetchPayloadReg.replay := fetchFromReplay
      pc := Mux(fetchFromReplay, pc, fetchAddress + 4.U)
      when(fetchFromReplayFinish) {
        replayFinishPending := false.B
      }

      decodeValidReg := fetchValidReg
      decodePayloadReg := fetchedDecodePayload

      readAddrValidReg := decodeValidReg
      readAddrPayloadReg := decodeReg
      dispatchValidReg := readAddrValidReg
      dispatchPayloadReg := readAddrReg
    }

    when(nextRegReadDecode.valid) {
      regReadPayloadReg.decRegs := nextRegReadDecode
      regReadPayloadReg.rs1Data := bypassIntRead(dispatchRs1, regFile.io.readData(0))
      regReadPayloadReg.rs2Data := bypassIntRead(dispatchRs2, regFile.io.readData(1))
      regReadPayloadReg.frs1Data := bypassFpRead(dispatchFrs1, fpReadData(0))
      regReadPayloadReg.frs2Data := bypassFpRead(dispatchFrs2, fpReadData(1))
      regReadPayloadReg.frs3Data := bypassFpRead(dispatchFrs3, fpReadData(2))
    }
    regReadValidReg := nextRegReadDecode.valid

    when(nextPreExecValid) {
      preExecPayloadReg := nextPreExec
    }
    preExecValidReg := nextPreExecValid

    when(trapValid) {
      fetchValidReg := false.B
      decodeValidReg := false.B
      readAddrValidReg := false.B
      dispatchValidReg := false.B
      regReadValidReg := false.B
      preExecValidReg := false.B
    }
  }

  exec1Reg := Mux(redirect, emptyExec, nextExec)
  exec2Reg := exec1Reg
  exec3Reg := exec2Reg
  exec4Reg := exec3Reg
  exec5Reg := exec4Reg
  exec6Reg := exec5Reg
  exec7Reg := exec6Reg
  exec8Reg := exec7Reg
  exec9Reg := exec8Reg
  exec10Reg := exec9Reg
  exec11Reg := exec10Reg
  wbReg := exec11Reg

  io.imem_addr := fetchAddress
  io.pc_out := pc
  io.instr_out := fetchReg.instr
  io.result := wbIntResult
  io.trap_valid := trapValid.asUInt
  io.trap_cause := trapCause
  io.ext_pending := extRetireBusy.asUInt
  io.stall_reason := stallReason
  io.retire_valid := (wbValid || extCompleteFire).asUInt
  io.retire_pc := Mux(extCompleteFire, extRetireHead.pc, wbReg.regReadRegs.decRegs.pc)
  io.retire_instr := Mux(extCompleteFire, extRetireHead.instr, wbInstr)
  io.retire_write_rd := Mux(extCompleteFire, extCompleteHead.writeRd, wbReg.writeInt).asUInt
  io.retire_rd := Mux(extCompleteFire, extCompleteHead.rd, wbReg.rd)
  io.retire_wdata := Mux(extCompleteFire, extCompleteHead.rdData, wbIntResult)
  io.retire_write_fp := (!extCompleteFire && wbReg.writeFp).asUInt
  io.retire_fp_rd := wbReg.fpRd
  io.retire_fp_wdata := wbFpResult
  io.csr_fflags := fflags
  io.csr_frm := frm
  io.csr_vl := vl
  io.csr_vtype := vtype
  io.csr_vstart := vstart
}

class ZeroNyteRV32IFRVVCoreCosim(vlenbBytes: Int = 256)
    extends ZeroNyteRV32IFRVVCore(cosimulate = true, vlenbBytes = vlenbBytes) {
  override def desiredName: String = "ZeroNyteRV32IFRVVCoreCosim"
}
