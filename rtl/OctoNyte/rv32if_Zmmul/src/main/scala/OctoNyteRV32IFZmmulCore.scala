package OctoNyte

import chisel3._
import chisel3.util._
import chisel3.dontTouch
import ALUs.ALU32
import ALUs.Float32ALUPipelined
import ALUs.Float32Ops
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
class OctoNyteRV32IFZmmulCoreIO(val numThreads: Int, val fetchWidth: Int, val cosimulate: Boolean = false) extends Bundle {
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
class IFZmmulFetchPipelineRegs(threadBits: Int) extends Bundle {
  val valid    = Bool()
  val threadId = UInt(threadBits.W)
  val pc       = UInt(32.W)
  val instr    = UInt(32.W)
}

class IFZmmulDecodePipelineRegs(threadBits: Int) extends Bundle {
  val fetchSignals = new IFZmmulFetchPipelineRegs(threadBits)
  val decodeSignals = new RV32IDecode.DecodeSignals
}

class IFZmmulDispatchPipelineRegs(threadBits: Int) extends Bundle {
  val decodePipelineSignals = new IFZmmulDecodePipelineRegs(threadBits)
}

class IFZmmulRegisterReadPipelineRegs(threadBits: Int) extends Bundle {
  val dispatchSignals = new IFZmmulDispatchPipelineRegs(threadBits)
  val rs1Data  = UInt(32.W)
  val rs2Data  = UInt(32.W) 
  val frs1Data = UInt(32.W)
  val frs2Data = UInt(32.W)
  val frs3Data = UInt(32.W)
}

class IFZmmulExec1PipelineRegs(threadBits: Int) extends Bundle {
  val regReadSignals = new IFZmmulRegisterReadPipelineRegs(threadBits)
  val result   = UInt(32.W)
  val fpResult = UInt(32.W)
  val doRegFileWrite = Bool()
  val doFpRegFileWrite = Bool()
  val ctrlTaken = Bool()
  val ctrlTarget = UInt(32.W)
} 

class IFZmmulExec2PipelineRegs(threadBits: Int) extends Bundle {
  val exec1Signals = new IFZmmulExec1PipelineRegs(threadBits)
} 

class IFZmmulExec3PipelineRegs(threadBits: Int) extends Bundle {
  val exec2Signals = new IFZmmulExec2PipelineRegs(threadBits)
}

class IFZmmulWritebackPipelineRegs(threadBits: Int) extends Bundle {
  val exec3Signals = new IFZmmulExec3PipelineRegs(threadBits)
} 

// *********************************************************
// OctoNyte RV32IF Zmmul Core Definition
// *********************************************************
class OctoNyteRV32IFZmmulCore(val cosimulate: Boolean = false) extends Module {
  val numThreads = 8
  val fetchWidth = 4
  val io = IO(new OctoNyteRV32IFZmmulCoreIO(numThreads, fetchWidth, cosimulate))
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

  val fpRegFile = Mem(numThreads * 32, UInt(32.W))
  val fpReadThreadID = WireDefault(0.U(threadBits.W))
  val fpReadAddrs = WireDefault(VecInit(Seq.fill(3)(0.U(5.W))))
  val fpWriteThreadID = WireDefault(0.U(threadBits.W))
  val fpWriteAddr = WireDefault(0.U(5.W))
  val fpWriteData = WireDefault(0.U(32.W))
  val fpWriteEnable = WireDefault(false.B)
  val fpReadData = Wire(Vec(3, UInt(32.W)))

  for (i <- 0 until 3) {
    fpReadData(i) := fpRegFile.read(Cat(fpReadThreadID, fpReadAddrs(i)))
  }
  when (fpWriteEnable) {
    fpRegFile.write(Cat(fpWriteThreadID, fpWriteAddr), fpWriteData)
  }



  // Execution Units
  val alu = Module(new ALU32)
  alu.io.a := 0.U
  alu.io.b := 0.U
  alu.io.opcode := ALU32.Opcode.ADD

  val mulUnit = Module(new Mul32Pipelined(4))
  mulUnit.io.a := 0.U
  mulUnit.io.b := 0.U
  mulUnit.io.signedA := false.B
  mulUnit.io.signedB := false.B

  val fpu = Module(new Float32ALUPipelined(4))
  fpu.io.a := 0.U
  fpu.io.b := 0.U
  fpu.io.c := 0.U
  fpu.io.opcode := Float32Ops.Opcode.ADD
  val fpRegDirectResultEX = WireDefault(0.U(32.W))
  val fpIntResultEX = WireDefault(0.U(32.W))
  val fpRegDirectResultWB = ShiftRegister(fpRegDirectResultEX, 4)
  val fpIntResultWB = ShiftRegister(fpIntResultEX, 4)

  val branchUnit = Module(new BranchUnit)
  branchUnit.io.rs1 := 0.U
  branchUnit.io.rs2 := 0.U
  branchUnit.io.pc := 0.U
  branchUnit.io.imm := 0.S(32.W)
  branchUnit.io.branchOp := 0.U
  branchUnit.io.valid := false.B
  val unusedBranchNextPc = Wire(UInt(32.W))
  val unusedBranchMisaligned = Wire(Bool())
  unusedBranchNextPc := branchUnit.io.nextPc
  unusedBranchMisaligned := branchUnit.io.misaligned
  dontTouch(unusedBranchNextPc)
  dontTouch(unusedBranchMisaligned)

  val loadUnit = Module(new LoadUnit)
  loadUnit.io.addr := 0.U
  loadUnit.io.dataIn := io.dataMemResp
  loadUnit.io.funct3 := 0.U

  val storeUnit = Module(new StoreUnit)
  storeUnit.io.addr := 0.U
  storeUnit.io.data := 0.U
  storeUnit.io.storeType := 0.U

  val OP_FP_LOAD = "b0000111".U(7.W)
  val OP_FP_STORE = "b0100111".U(7.W)
  val OP_FP = "b1010011".U(7.W)
  val OP_FMADD = "b1000011".U(7.W)
  val OP_FMSUB = "b1000111".U(7.W)
  val OP_FNMSUB = "b1001011".U(7.W)
  val OP_FNMADD = "b1001111".U(7.W)

  def signExt12Local(value: UInt): UInt = Cat(Fill(20, value(11)), value)
  def fStoreImm(instr: UInt): UInt = signExt12Local(Cat(instr(31, 25), instr(11, 7)))
  def isFloatLoad(instr: UInt): Bool =
    instr(6, 0) === OP_FP_LOAD && instr(14, 12) === "b010".U
  def isFloatStore(instr: UInt): Bool =
    instr(6, 0) === OP_FP_STORE && instr(14, 12) === "b010".U
  def isFloatOp(instr: UInt): Bool = instr(6, 0) === OP_FP
  def isFloatMAdd(instr: UInt): Bool =
    instr(6, 0) === OP_FMADD || instr(6, 0) === OP_FMSUB ||
      instr(6, 0) === OP_FNMSUB || instr(6, 0) === OP_FNMADD

// =============================
// Fetch stage
// =============================
  val fetchReg = RegInit(0.U.asTypeOf(new IFZmmulFetchPipelineRegs(threadBits)))
  when (io.threadEnable(curThread)) {
    fetchReg.valid    := true.B
    fetchReg.threadId := curThread
    fetchReg.pc       := pcRegs(curThread)
    fetchReg.instr    := io.instrMem(31, 0)
    pcRegs(curThread) := pcRegs(curThread) + 4.U
  } .otherwise {
    fetchReg.valid := false.B
  }

// =============================
// Decode stage
// =============================
val decodeReg = RegInit(0.U.asTypeOf(new IFZmmulDecodePipelineRegs(threadBits)))

when (fetchReg.valid) {
  decodeReg.fetchSignals := fetchReg
  decodeReg.decodeSignals := RV32IDecode.decodeInstr(fetchReg.instr)
} .otherwise {
  decodeReg.fetchSignals.valid := false.B
}

// =============================
// Dispatch stage
// =============================
val dispatchReg = RegInit(0.U.asTypeOf(new IFZmmulDispatchPipelineRegs(threadBits)))

when (decodeReg.fetchSignals.valid) {
  dispatchReg.decodePipelineSignals := decodeReg
} .otherwise {
  dispatchReg.decodePipelineSignals.fetchSignals.valid := false.B
}

// =============================
// Register read stage
// =============================
val regReadReg = RegInit(0.U.asTypeOf(new IFZmmulRegisterReadPipelineRegs(threadBits)))

when (dispatchReg.decodePipelineSignals.fetchSignals.valid) {
  regReadReg.dispatchSignals := dispatchReg
  val tid = dispatchReg.decodePipelineSignals.fetchSignals.threadId
  regFile.io.readThreadID := tid
  regFile.io.readAddrs(0) := dispatchReg.decodePipelineSignals.decodeSignals.rs1
  regFile.io.readAddrs(1) := dispatchReg.decodePipelineSignals.decodeSignals.rs2
  fpReadThreadID := tid
  fpReadAddrs(0) := dispatchReg.decodePipelineSignals.fetchSignals.instr(19, 15)
  fpReadAddrs(1) := dispatchReg.decodePipelineSignals.fetchSignals.instr(24, 20)
  fpReadAddrs(2) := dispatchReg.decodePipelineSignals.fetchSignals.instr(31, 27)
  regReadReg.rs1Data := regFile.io.readData(0)
  regReadReg.rs2Data := regFile.io.readData(1)
  regReadReg.frs1Data := fpReadData(0)
  regReadReg.frs2Data := fpReadData(1)
  regReadReg.frs3Data := fpReadData(2)
} .otherwise {
  regReadReg.dispatchSignals.decodePipelineSignals.fetchSignals.valid := false.B
}

// =============================
// Execute 1 stage
// =============================
  val exec1Reg = RegInit(0.U.asTypeOf(new IFZmmulExec1PipelineRegs(threadBits)))

  when (regReadReg.dispatchSignals.decodePipelineSignals.fetchSignals.valid) {

  val decodeSignals = regReadReg.dispatchSignals.decodePipelineSignals.decodeSignals
  val fetchSignals = regReadReg.dispatchSignals.decodePipelineSignals.fetchSignals

  exec1Reg.regReadSignals := regReadReg
  exec1Reg.result := 0.U
  exec1Reg.fpResult := 0.U
  exec1Reg.doRegFileWrite := false.B
  exec1Reg.doFpRegFileWrite := false.B
  exec1Reg.ctrlTaken := false.B
  exec1Reg.ctrlTarget := 0.U

  // -----------------
  // M-Extension Logic
  // -----------------
  val isMExt = fetchSignals.instr(6, 0) === RV32IDecode.OP_R && fetchSignals.instr(31, 25) === "b0000001".U(7.W)
  val funct3 = fetchSignals.instr(14, 12)
  val isMulInstr = isMExt && (funct3 <= "b011".U)
  val fpFunct7 = fetchSignals.instr(31, 25)
  val fpRs2 = fetchSignals.instr(24, 20)

  mulUnit.io.a := regReadReg.rs1Data
  mulUnit.io.b := regReadReg.rs2Data
  mulUnit.io.signedA := (funct3 =/= "b011".U)
  mulUnit.io.signedB := (funct3 =/= "b011".U) && (funct3 =/= "b010".U)
  fpu.io.a := regReadReg.frs1Data
  fpu.io.b := regReadReg.frs2Data
  fpu.io.c := regReadReg.frs3Data
  fpu.io.opcode := Float32Ops.Opcode.ADD


  // -----------------
  // ALU / LUI / AUIPC
  // -----------------
  when ((decodeSignals.isALU && !isMulInstr) || decodeSignals.isLUI || decodeSignals.isAUIPC) {
    val opcode = fetchSignals.instr(6, 0)
    val useImm = (opcode === RV32IDecode.OP_I) || decodeSignals.isLUI || decodeSignals.isAUIPC

    val opA = Mux(decodeSignals.isAUIPC,
      fetchSignals.pc,
      Mux(decodeSignals.isLUI, 0.U, regReadReg.rs1Data))

    val opB = Mux(useImm, decodeSignals.imm, regReadReg.rs2Data)

    alu.io.a := opA
    alu.io.b := opB
    alu.io.opcode := decodeSignals.aluOp

    val result = Mux(decodeSignals.isAUIPC,
      fetchSignals.pc + decodeSignals.imm,
      Mux(decodeSignals.isLUI,
        decodeSignals.imm,
        alu.io.result))

    exec1Reg.result := result
    exec1Reg.doRegFileWrite := true.B
  }
  // ---- MULTIPLIER (Zmmul / M-Extension) ----
  .elsewhen (isMulInstr) {
    exec1Reg.result := 0.U
    exec1Reg.doRegFileWrite := true.B
  }
  // ---- RV32F single-precision subset for inference scalar math ----
  .elsewhen (isFloatLoad(fetchSignals.instr)) {
    val address = regReadReg.rs1Data + signExt12Local(fetchSignals.instr(31, 20))
    val loadActive = io.threadEnable(fetchSignals.threadId)
    io.memAddr := Cat(address(31, 2), 0.U(2.W))
    io.memValid := loadActive
    loadUnit.io.addr := address
    loadUnit.io.funct3 := "b010".U

    exec1Reg.fpResult := loadUnit.io.dataOut
    exec1Reg.doFpRegFileWrite := true.B
  }
  .elsewhen (isFloatStore(fetchSignals.instr)) {
    val address = regReadReg.rs1Data + fStoreImm(fetchSignals.instr)
    val storeActive = io.threadEnable(fetchSignals.threadId) && !storeUnit.io.misaligned
    io.memAddr := Cat(address(31, 2), 0.U(2.W))
    storeUnit.io.addr := address
    storeUnit.io.data := regReadReg.frs2Data
    storeUnit.io.storeType := "b10".U

    io.memWrite := Mux(storeActive, storeUnit.io.memWrite, 0.U)
    io.memMask := Mux(storeActive, storeUnit.io.mask, 0.U)
    io.memValid := storeActive
    io.memMisaligned := io.threadEnable(fetchSignals.threadId) && storeUnit.io.misaligned
  }
  .elsewhen (isFloatMAdd(fetchSignals.instr)) {
    val opcode = fetchSignals.instr(6, 0)
    val negateProduct = opcode === OP_FNMSUB || opcode === OP_FNMADD
    val negateAddend = opcode === OP_FMSUB || opcode === OP_FNMADD
    fpu.io.a := Mux(negateProduct, Float32Ops.negate(regReadReg.frs1Data),
                    regReadReg.frs1Data)
    fpu.io.b := regReadReg.frs2Data
    fpu.io.c := Mux(negateAddend, Float32Ops.negate(regReadReg.frs3Data),
                    regReadReg.frs3Data)
    fpu.io.opcode := Float32Ops.Opcode.MADD
    exec1Reg.fpResult := 0.U
    exec1Reg.doFpRegFileWrite := true.B
  }
  .elsewhen (isFloatOp(fetchSignals.instr)) {
    val fpCompareResult = MuxLookup(funct3, 0.U(32.W))(Seq(
      "b010".U -> (regReadReg.frs1Data === regReadReg.frs2Data).asUInt,
      "b001".U -> Float32Ops.lessThan(regReadReg.frs1Data, regReadReg.frs2Data).asUInt,
      "b000".U -> Float32Ops.lessOrEqual(regReadReg.frs1Data, regReadReg.frs2Data).asUInt
    ))
    val fpClass = Cat(
      0.U(23.W),
      0.U(5.W),
      (!regReadReg.frs1Data(31) && regReadReg.frs1Data(30, 0) === 0.U).asUInt,
      (regReadReg.frs1Data(31) && regReadReg.frs1Data(30, 0) === 0.U).asUInt,
      (!regReadReg.frs1Data(31) && regReadReg.frs1Data(30, 23) =/= 0.U).asUInt,
      (regReadReg.frs1Data(31) && regReadReg.frs1Data(30, 23) =/= 0.U).asUInt
    )

    when (fpFunct7 === "b0000000".U) {
      fpu.io.opcode := Float32Ops.Opcode.ADD
      exec1Reg.fpResult := 0.U
      exec1Reg.doFpRegFileWrite := true.B
    } .elsewhen (fpFunct7 === "b0000100".U) {
      fpu.io.opcode := Float32Ops.Opcode.SUB
      exec1Reg.fpResult := 0.U
      exec1Reg.doFpRegFileWrite := true.B
    } .elsewhen (fpFunct7 === "b0001000".U) {
      fpu.io.opcode := Float32Ops.Opcode.MUL
      exec1Reg.fpResult := 0.U
      exec1Reg.doFpRegFileWrite := true.B
    } .elsewhen (fpFunct7 === "b0010000".U) {
      fpu.io.opcode := MuxLookup(funct3, Float32Ops.Opcode.SGNJ)(Seq(
        "b000".U -> Float32Ops.Opcode.SGNJ,
        "b001".U -> Float32Ops.Opcode.SGNJN,
        "b010".U -> Float32Ops.Opcode.SGNJX
      ))
      exec1Reg.fpResult := 0.U
      exec1Reg.doFpRegFileWrite := true.B
    } .elsewhen (fpFunct7 === "b0010100".U) {
      fpu.io.opcode := Mux(funct3(0), Float32Ops.Opcode.MAX, Float32Ops.Opcode.MIN)
      exec1Reg.fpResult := 0.U
      exec1Reg.doFpRegFileWrite := true.B
    } .elsewhen (fpFunct7 === "b1010000".U) {
      fpIntResultEX := fpCompareResult
      exec1Reg.result := 0.U
      exec1Reg.doRegFileWrite := true.B
    } .elsewhen (fpFunct7 === "b1100000".U) {
      fpIntResultEX := Float32Ops.floatToInt(regReadReg.frs1Data, fpRs2 === 0.U)
      exec1Reg.result := 0.U
      exec1Reg.doRegFileWrite := true.B
    } .elsewhen (fpFunct7 === "b1101000".U) {
      fpRegDirectResultEX := Float32Ops.intToFloat(regReadReg.rs1Data, fpRs2 === 0.U)
      exec1Reg.fpResult := 0.U
      exec1Reg.doFpRegFileWrite := true.B
    } .elsewhen (fpFunct7 === "b1110000".U) {
      fpIntResultEX := Mux(funct3 === "b001".U, fpClass, regReadReg.frs1Data)
      exec1Reg.result := 0.U
      exec1Reg.doRegFileWrite := true.B
    } .elsewhen (fpFunct7 === "b1111000".U) {
      fpRegDirectResultEX := regReadReg.rs1Data
      exec1Reg.fpResult := 0.U
      exec1Reg.doFpRegFileWrite := true.B
    }
  }
  // ---- JAL ----
  .elsewhen (decodeSignals.isJAL) {
    exec1Reg.result := fetchSignals.pc + 4.U
    exec1Reg.doRegFileWrite := true.B
    exec1Reg.ctrlTaken := true.B
    exec1Reg.ctrlTarget := (fetchSignals.pc.asSInt + decodeSignals.imm.asSInt).asUInt
  }
  // ---- JALR ----
  .elsewhen (decodeSignals.isJALR) {
    val target = ((regReadReg.rs1Data.asSInt + decodeSignals.imm.asSInt).asUInt & ~1.U(32.W))
    exec1Reg.result := fetchSignals.pc + 4.U
    exec1Reg.doRegFileWrite := true.B
    exec1Reg.ctrlTaken := true.B
    exec1Reg.ctrlTarget := target
  }
  // ---- BRANCH ----
  .elsewhen (decodeSignals.isBranch) {
    branchUnit.io.rs1 := regReadReg.rs1Data
    branchUnit.io.rs2 := regReadReg.rs2Data
    branchUnit.io.pc  := fetchSignals.pc
    branchUnit.io.imm := (decodeSignals.imm << 1).asSInt
    branchUnit.io.branchOp := fetchSignals.instr(14, 12)
    branchUnit.io.valid := true.B

    exec1Reg.ctrlTaken := branchUnit.io.taken
    exec1Reg.ctrlTarget := branchUnit.io.target
  }
  // ---- LOAD ----
  .elsewhen (decodeSignals.isLoad) {
    val address = regReadReg.rs1Data + decodeSignals.imm
    val loadActive = io.threadEnable(fetchSignals.threadId)
    io.memAddr := Cat(address(31, 2), 0.U(2.W))
    io.memValid := loadActive
    loadUnit.io.addr := address
    loadUnit.io.funct3 := fetchSignals.instr(14, 12)

    exec1Reg.result := loadUnit.io.dataOut
    exec1Reg.doRegFileWrite := true.B
  }
  // ---- STORE ----
  .elsewhen (decodeSignals.isStore) {
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
 val exec2Reg = RegInit(0.U.asTypeOf(new IFZmmulExec2PipelineRegs(threadBits)))
  when (exec1Reg.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid) {
    exec2Reg.exec1Signals := exec1Reg
  } .otherwise {
    exec2Reg.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid := false.B
  }

  // =============================
  // Execute 3 stage
  // =============================
  val exec3Reg = RegInit(0.U.asTypeOf(new IFZmmulExec3PipelineRegs(threadBits)))
    when (exec2Reg.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid) {
      exec3Reg.exec2Signals := exec2Reg
    } .otherwise {
      exec3Reg.exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid := false.B
    }

  // =============================
  // Writeback stage
  // =============================
val wbReg = RegInit(0.U.asTypeOf(new IFZmmulWritebackPipelineRegs(threadBits)))
when (exec3Reg.exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid) {
  wbReg.exec3Signals := exec3Reg
} .otherwise {
  wbReg.exec3Signals.exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid := false.B
}

val wbFetch = wbReg.exec3Signals.exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals
val wbDecode = wbReg.exec3Signals.exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.decodeSignals
val wbExec = wbReg.exec3Signals.exec2Signals.exec1Signals

val wbIsMExt = wbFetch.instr(6, 0) === RV32IDecode.OP_R && wbFetch.instr(31, 25) === "b0000001".U(7.W)
val wbFunct3 = wbFetch.instr(14, 12)
val wbIsMulInstr = wbIsMExt && (wbFunct3 <= "b011".U)
val wbIsFloatCompute = isFloatOp(wbFetch.instr) || isFloatMAdd(wbFetch.instr)
val wbUseFpRegPipeline = wbIsFloatCompute && wbExec.doFpRegFileWrite
val wbUseFpIntPipeline = wbIsFloatCompute && wbExec.doRegFileWrite
val wbFpFunct7 = wbFetch.instr(31, 25)
val wbUseFpAluPipeline = isFloatMAdd(wbFetch.instr) ||
  (isFloatOp(wbFetch.instr) && (
    wbFpFunct7 === "b0000000".U ||
    wbFpFunct7 === "b0000100".U ||
    wbFpFunct7 === "b0001000".U ||
    wbFpFunct7 === "b0010000".U ||
    wbFpFunct7 === "b0010100".U
  ))

val mulResult_WB = MuxLookup(wbFunct3, mulUnit.io.lo)(Seq(
  "b000".U -> mulUnit.io.lo,
  "b001".U -> mulUnit.io.hi,
  "b010".U -> mulUnit.io.hi,
  "b011".U -> mulUnit.io.hi
))

val finalWBResult = Mux(wbIsMulInstr, mulResult_WB,
  Mux(wbUseFpIntPipeline, fpIntResultWB, wbExec.result))

when (wbFetch.valid && wbExec.doRegFileWrite && wbDecode.rd =/= 0.U) {
  regFile.io.wens(0) := true.B
  regFile.io.writeThreadID := wbFetch.threadId
  regFile.io.writeAddrs(0) := wbDecode.rd
  regFile.io.writeData(0) := finalWBResult
}

when (wbFetch.valid && wbExec.doFpRegFileWrite) {
  fpWriteEnable := true.B
  fpWriteThreadID := wbFetch.threadId
  fpWriteAddr := wbDecode.rd
  fpWriteData := Mux(wbUseFpRegPipeline,
    Mux(wbUseFpAluPipeline, fpu.io.result, fpRegDirectResultWB),
    wbExec.fpResult)
}

// Control-flow commit
val ex1Fetch = exec1Reg.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals
val ex1Redirect = ex1Fetch.valid && exec1Reg.ctrlTaken

// Resolve control flow in EX1 and squash younger work so taken redirects do not replay.
when (ex1Redirect) {
  pcRegs(ex1Fetch.threadId) := exec1Reg.ctrlTarget
}

when (wbFetch.valid && wbExec.doRegFileWrite && wbDecode.rd =/= 0.U) {
  when (wbDecode.rd === 1.U) { debugRegs1to4(wbFetch.threadId)(0) := finalWBResult }
    .elsewhen (wbDecode.rd === 2.U) { debugRegs1to4(wbFetch.threadId)(1) := finalWBResult }
    .elsewhen (wbDecode.rd === 3.U) { debugRegs1to4(wbFetch.threadId)(2) := finalWBResult }
    .elsewhen (wbDecode.rd === 4.U) { debugRegs1to4(wbFetch.threadId)(3) := finalWBResult }
}

// Keep writeback side-effect free for x0
when (wbFetch.valid && wbExec.doRegFileWrite && wbDecode.rd === 0.U) {
  regFile.io.wens(0) := false.B
}

// =====================================================
// Debug control
// =====================================================
val dbgFetch = wbReg.exec3Signals.exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals
val dbgDecode = wbReg.exec3Signals.exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.decodeSignals

io.debugStageThreads(0) := fetchReg.threadId
io.debugStageValids(0) := (fetchReg.valid).asUInt
io.debugStageThreads(1) := decodeReg.fetchSignals.threadId
io.debugStageValids(1) := (decodeReg.fetchSignals.valid).asUInt
io.debugStageThreads(2) := dispatchReg.decodePipelineSignals.fetchSignals.threadId
io.debugStageValids(2) := (dispatchReg.decodePipelineSignals.fetchSignals.valid).asUInt
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
io.debugCtrlTaken := wbReg.exec3Signals.exec2Signals.exec1Signals.ctrlTaken
io.debugCtrlThread := dbgFetch.threadId
io.debugCtrlFromPC := dbgFetch.pc
io.debugCtrlTarget := wbReg.exec3Signals.exec2Signals.exec1Signals.ctrlTarget
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
