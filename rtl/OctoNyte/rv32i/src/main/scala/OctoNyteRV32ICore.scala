package OctoNyte

import chisel3._
import chisel3.util._
import chisel3.dontTouch
import ALUs.ALU32
import Decoders.RV32IDecode
import Pipeline.ThreadScheduler
import BranchUnit.BranchUnit
import LoadUnit.LoadUnit
import StoreUnit.StoreUnit
import RegFiles.RegFileMTMultiWVec


// *********************************************************
// Core IO Definition
// *********************************************************
class OctoNyteRV32ICoreIO(val numThreads: Int, val fetchWidth: Int) extends Bundle {
  private val threadBits = log2Ceil(numThreads)

  val threadEnable = Input(Vec(numThreads, Bool()))
  val instrMem     = Input(UInt((fetchWidth * 32).W))
  val dataMemResp  = Input(UInt(32.W))
  val memAddr      = Output(UInt(32.W))
  val memWrite     = Output(UInt(32.W))
  val memMask      = Output(UInt(4.W))
  val memMisaligned= Output(Bool())

  val debugStageThreads = Output(Vec(8, UInt(threadBits.W)))
  val debugStageValids  = Output(Vec(8, Bool()))
  val debugPC           = Output(Vec(numThreads, UInt(32.W)))
  val debugRegs01234    = Output(Vec(numThreads, Vec(5, UInt(32.W))))
  val debugRegX1        = Output(Vec(numThreads, UInt(32.W)))
  val debugCtrlValid    = Output(Bool())
  val debugCtrlInstr    = Output(UInt(32.W))
  val debugCtrlTaken    = Output(Bool())
  val debugCtrlThread   = Output(UInt(threadBits.W))
  val debugCtrlFromPC   = Output(UInt(32.W))
  val debugCtrlTarget   = Output(UInt(32.W))
  val debugCtrlIsBranch = Output(Bool())
  val debugCtrlIsJal    = Output(Bool())
  val debugCtrlIsJalr   = Output(Bool())
  val debugExecValid    = Output(Bool())
  val debugExecThread   = Output(UInt(threadBits.W))
  val debugExecPC       = Output(UInt(32.W))
  val debugExecInstr    = Output(UInt(32.W))
  val debugExecIsBranch = Output(Bool())
  val debugExecIsJal    = Output(Bool())
  val debugExecIsJalr   = Output(Bool())
  val debugExecBranchOp = Output(UInt(3.W))
  val debugExecRs1      = Output(UInt(32.W))
  val debugExecRs2      = Output(UInt(32.W))
  val debugExecCtrlTaken = Output(Bool())
  val debugExecCtrlTarget = Output(UInt(32.W))
}

// ****************************************************************************************
// Pipeline Register Definitions
// Pipeline registers are defined in outer scope so Verilog generation doesn't mangle names
// ****************************************************************************************
class FetchPipelineRegs(threadBits: Int) extends Bundle {
  val valid    = Bool()
  val threadId = UInt(threadBits.W)
  val pc       = UInt(32.W)
  val instr    = UInt(32.W)
}


class DecodePipelineRegs(threadBits: Int) extends Bundle {
  val fetchSignals = new FetchPipelineRegs(threadBits)
  val decodeSignals = new RV32IDecode.DecodeSignals
}

class DispatchPipelineRegs(threadBits: Int) extends Bundle {
  val decodePipelineSignals = new DecodePipelineRegs(threadBits)
  // Additional dispatch-specific signals can be added here when multiple-issue is implemented
}

class RegisterReadPipelineRegs(threadBits: Int) extends Bundle {
  val dispatchSignals = new DispatchPipelineRegs(threadBits)
  val rs1Data  = UInt(32.W)
  val rs2Data  = UInt(32.W) 
}

class Exec1PipelineRegs(threadBits: Int) extends Bundle {
  val regReadSignals = new RegisterReadPipelineRegs(threadBits)
  val result   = UInt(32.W)
  val doRegFileWrite = Bool()
  val ctrlTaken = Bool()
  val ctrlTarget = UInt(32.W)
} 

class Exec2PipelineRegs(threadBits: Int) extends Bundle {
  val exec1Signals = new Exec1PipelineRegs(threadBits)
} 

class Exec3PipelineRegs(threadBits: Int) extends Bundle {
  val exec2Signals = new Exec2PipelineRegs(threadBits)
}

class WritebackPipelineRegs(threadBits: Int) extends Bundle {
  val exec3Signals = new Exec3PipelineRegs(threadBits)
} 

// *********************************************************
// OctoNyte RV32I Core Definition
// *********************************************************
class OctoNyteRV32ICore extends Module {
  val numThreads = 8
  // Keep this aligned with OctoNyte tests, which drive a 4-wide (128b) instruction packet.
  // The core currently only consumes slot 0 (`instrMem(31,0)`), so the extra slots are ignored.
  val fetchWidth = 4
  val regFileReadPorts = 2 * fetchWidth
  val regFileWritePorts = fetchWidth
  val io = IO(new OctoNyteRV32ICoreIO(numThreads, fetchWidth))
  

  private val threadBits = log2Ceil(numThreads)


  // ===========================
  // DEBUG DEFAULTS 
  // ===========================
  for (i <- 0 until 8) {
    io.debugStageThreads(i) := 0.U
    io.debugStageValids(i)  := false.B
  }

  for (t <- 0 until numThreads) {
    io.debugPC(t) := 0.U
    io.debugRegX1(t) := 0.U
    for (r <- 0 until 5) {
      io.debugRegs01234(t)(r) := 0.U
    }
  }

  io.debugCtrlValid    := false.B
  io.debugCtrlInstr    := 0.U
  io.debugCtrlTaken    := false.B
  io.debugCtrlThread   := 0.U
  io.debugCtrlFromPC   := 0.U
  io.debugCtrlTarget   := 0.U
  io.debugCtrlIsBranch := false.B
  io.debugCtrlIsJal    := false.B
  io.debugCtrlIsJalr   := false.B

  io.debugExecValid        := false.B
  io.debugExecThread       := 0.U
  io.debugExecPC           := 0.U
  io.debugExecInstr        := 0.U
  io.debugExecIsBranch     := false.B
  io.debugExecIsJal        := false.B
  io.debugExecIsJalr       := false.B
  io.debugExecBranchOp     := 0.U
  io.debugExecRs1          := 0.U
  io.debugExecRs2          := 0.U
  io.debugExecCtrlTaken    := false.B
  io.debugExecCtrlTarget   := 0.U

  // ================================================

  
  val threadCounter = RegInit(0.U(threadBits.W))

  val curThread = threadCounter
  val nextThread =
    Mux(curThread === (numThreads - 1).U, 0.U, curThread + 1.U)

  // ALWAYS advance
  threadCounter := nextThread

  
  // Default IO outputs 
  io.memAddr := 0.U
  io.memWrite := 0.U
  io.memMask := 0.U
  io.memMisaligned := false.B
 
 
  // ******************************************
  // Program counter registers for each thread
  // ******************************************
  val pcRegs = RegInit(VecInit(Seq.fill(numThreads)("h8000_0000".U(32.W))))

  // Debug shadow registers (synthesizable): track architectural x1-x4 per thread on writeback.
  // x0 is always 0 and is not stored.
  val debugRegs1to4 = RegInit(VecInit(Seq.fill(numThreads)(VecInit(Seq.fill(4)(0.U(32.W)))))) // (thread)(reg-1)


  // ***********************************************************************************
  // Multithreaded register file: 1 write port, 2 read groups (only port0 used for now)
  // ***********************************************************************************
  val regFile = Module(new RegFileMTMultiWVec(numThreads = numThreads, numWritePorts = regFileWritePorts, numReadPorts = regFileReadPorts))
  regFile.io.readThreadID := VecInit(Seq.fill(regFileReadPorts)(0.U(threadBits.W)))
  regFile.io.src1 := VecInit(Seq.fill(regFileReadPorts)(0.U(5.W)))
  regFile.io.src2 := VecInit(Seq.fill(regFileReadPorts)(0.U(5.W)))
  regFile.io.writeThreadID := VecInit(Seq.fill(regFileWritePorts)(0.U(threadBits.W)))
  regFile.io.dst := VecInit(Seq.fill(regFileWritePorts)(0.U(5.W)))
  regFile.io.wen := VecInit(Seq.fill(regFileWritePorts)(false.B))
  regFile.io.dstData := VecInit(Seq.fill(regFileWritePorts)(0.U(32.W)))

  val unusedRegDebugX1 = Wire(Vec(numThreads, UInt(32.W)))
  val unusedRegDebugRegs = Wire(Vec(numThreads, Vec(5, UInt(32.W))))
  unusedRegDebugX1 := regFile.io.debugX1
  unusedRegDebugRegs := regFile.io.debugRegs01234
  dontTouch(unusedRegDebugX1)
  dontTouch(unusedRegDebugRegs)

  // ***************************************************************************
  // Execution Units
  // ***************************************************************************
  // ALU 
  val alu = Module(new ALU32)
  alu.io.a := 0.U
  alu.io.b := 0.U
  alu.io.opcode := ALU32.Opcode.ADD

  // Branch Unit
  val branchUnit = Module(new BranchUnit)
  branchUnit.io.rs1 := 0.U    // TODO: This is really rs1data not rs1
  branchUnit.io.rs2 := 0.U    // TODO: This is really rs2data not rs2
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

  // Load Unit
  val loadUnit = Module(new LoadUnit)
  loadUnit.io.addr := 0.U
  loadUnit.io.dataIn := io.dataMemResp
  loadUnit.io.funct3 := 0.U

  // Store Unit
  val storeUnit = Module(new StoreUnit)
  storeUnit.io.addr := 0.U
  storeUnit.io.data := 0.U
  storeUnit.io.storeType := 0.U


// =============================
// Fetch stage
// =============================

// Single fetch pipeline register
  val fetchReg = RegInit(0.U.asTypeOf(new FetchPipelineRegs(threadBits)))
  when (io.threadEnable(curThread)) {
    fetchReg.valid    := true.B
    fetchReg.threadId := curThread
    fetchReg.pc       := pcRegs(curThread)
    fetchReg.instr    := io.instrMem(31, 0)

    pcRegs(curThread) := pcRegs(curThread) + 4.U
  } .otherwise {
    fetchReg.valid := false.B   // bubble
  }

// =============================
// Decode stage
// =============================

val decodeReg = RegInit(0.U.asTypeOf(new DecodePipelineRegs(threadBits)))

when (fetchReg.valid) {
  decodeReg.fetchSignals := fetchReg
  decodeReg.decodeSignals := RV32IDecode.decodeInstr(fetchReg.instr)
} .otherwise {
  decodeReg.fetchSignals.valid := false.B
}

 // =============================
// Dispatch stage
// =============================

val dispatchReg = RegInit(0.U.asTypeOf(new DispatchPipelineRegs(threadBits)))

when (decodeReg.fetchSignals.valid) {
  dispatchReg.decodePipelineSignals := decodeReg
} .otherwise {
  dispatchReg.decodePipelineSignals.fetchSignals.valid := false.B
}


  // =============================
// Register read stage (single-lane)
// =============================

val regReadReg = RegInit(0.U.asTypeOf(new RegisterReadPipelineRegs(threadBits)))

when (dispatchReg.decodePipelineSignals.fetchSignals.valid) {
  regReadReg.dispatchSignals := dispatchReg

  // Register file read
  val tid = dispatchReg.decodePipelineSignals.fetchSignals.threadId

  regFile.io.readThreadID(0) := tid
  regFile.io.src1(0) := dispatchReg.decodePipelineSignals.decodeSignals.rs1
  regFile.io.src2(0) := dispatchReg.decodePipelineSignals.decodeSignals.rs2

  regReadReg.rs1Data := regFile.io.src1data(0)
  regReadReg.rs2Data := regFile.io.src2data(0)
} .otherwise {
  regReadReg.dispatchSignals.decodePipelineSignals.fetchSignals.valid := false.B
}


 // =============================
// Execute 1 stage (single-lane)
// =============================

  val exec1Reg = RegInit(0.U.asTypeOf(new Exec1PipelineRegs(threadBits)))

  when (regReadReg.dispatchSignals.decodePipelineSignals.fetchSignals.valid) {

  val decodeSignals =
    regReadReg.dispatchSignals.decodePipelineSignals.decodeSignals
  val fetchSignals =
    regReadReg.dispatchSignals.decodePipelineSignals.fetchSignals

  exec1Reg.regReadSignals := regReadReg
  exec1Reg.doRegFileWrite := false.B
  exec1Reg.ctrlTaken := false.B
  exec1Reg.ctrlTarget := 0.U

  // -----------------
  // ALU / LUI / AUIPC
  // -----------------
  when (decodeSignals.isALU ||
        decodeSignals.isLUI ||
        decodeSignals.isAUIPC) {

    val opcode = fetchSignals.instr(6, 0)
    val useImm =
      (opcode === RV32IDecode.OP_I) ||
      decodeSignals.isLUI ||
      decodeSignals.isAUIPC


    val opA = Mux(decodeSignals.isAUIPC,
      fetchSignals.pc,
      Mux(decodeSignals.isLUI, 0.U, regReadReg.rs1Data))

    val opB = Mux(useImm,
      decodeSignals.imm,
      regReadReg.rs2Data)

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

  // ---- JAL ----
  .elsewhen (decodeSignals.isJAL) {
    exec1Reg.result := fetchSignals.pc + 4.U
    exec1Reg.doRegFileWrite := true.B
    exec1Reg.ctrlTaken := true.B
    exec1Reg.ctrlTarget := (fetchSignals.pc.asSInt + decodeSignals.imm.asSInt).asUInt
  }

  // ---- JALR ----
  .elsewhen (decodeSignals.isJALR) {
    val target =
      ((regReadReg.rs1Data.asSInt + decodeSignals.imm.asSInt).asUInt & ~1.U)
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
    io.memAddr := Cat(address(31, 2), 0.U(2.W))
    loadUnit.io.addr := address
    loadUnit.io.funct3 := fetchSignals.instr(14, 12)

    exec1Reg.result := loadUnit.io.dataOut
    exec1Reg.doRegFileWrite := true.B
  }

  // ---- STORE ----
  .elsewhen (decodeSignals.isStore) {
    val address = regReadReg.rs1Data + decodeSignals.imm
    io.memAddr := Cat(address(31, 2), 0.U(2.W))
    storeUnit.io.addr := address
    storeUnit.io.data := regReadReg.rs2Data
    storeUnit.io.storeType := fetchSignals.instr(13, 12)

    io.memWrite := storeUnit.io.memWrite
    io.memMask := storeUnit.io.mask
    io.memMisaligned := storeUnit.io.misaligned
  }

  } .otherwise {
    exec1Reg
      .regReadSignals
      .dispatchSignals
      .decodePipelineSignals
      .fetchSignals
      .valid := false.B
  }

  // =============================
  // Execute 2 stage (pass-through)
  // =============================

 val exec2Reg = RegInit(0.U.asTypeOf(new Exec2PipelineRegs(threadBits)))

  when (exec1Reg.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid) {
    exec2Reg.exec1Signals := exec1Reg
  } .otherwise {
    exec2Reg.exec1Signals
      .regReadSignals
      .dispatchSignals
      .decodePipelineSignals
      .fetchSignals
      .valid := false.B
  }
  
  


  // =============================
  // Execute 3 stage (pass-through)
  // =============================

  val exec3Reg = RegInit(0.U.asTypeOf(new Exec3PipelineRegs(threadBits)))

    when (exec2Reg.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid) {
      exec3Reg.exec2Signals := exec2Reg
    } .otherwise {
      exec3Reg.exec2Signals
        .exec1Signals
        .regReadSignals
        .dispatchSignals
        .decodePipelineSignals
        .fetchSignals
        .valid := false.B
    }

  // =============================
  // Writeback stage
  // =============================

  
val wbReg = RegInit(0.U.asTypeOf(new WritebackPipelineRegs(threadBits)))

when (exec3Reg.exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid) {
  wbReg.exec3Signals := exec3Reg
} .otherwise {
  wbReg.exec3Signals
    .exec2Signals
    .exec1Signals
    .regReadSignals
    .dispatchSignals
    .decodePipelineSignals
    .fetchSignals
    .valid := false.B
}
// -----------------------------
// Writeback signal extraction
// -----------------------------
val wbFetch =
  wbReg.exec3Signals.exec2Signals.exec1Signals
    .regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals

val wbDecode =
  wbReg.exec3Signals.exec2Signals.exec1Signals
    .regReadSignals.dispatchSignals.decodePipelineSignals.decodeSignals

val wbExec =
  wbReg.exec3Signals.exec2Signals.exec1Signals

  // -----------------------------
// Architectural register writeback
// -----------------------------
when (wbFetch.valid &&
      wbExec.doRegFileWrite &&
      wbDecode.rd =/= 0.U) {

  regFile.io.wen(0) := true.B
  regFile.io.writeThreadID(0) := wbFetch.threadId
  regFile.io.dst(0) := wbDecode.rd
  regFile.io.dstData(0) := wbExec.result
}
// -----------------------------
// Control-flow commit
// -----------------------------
when (wbFetch.valid && wbExec.ctrlTaken) {
  pcRegs(wbFetch.threadId) := wbExec.ctrlTarget
}

when (wbFetch.valid &&
      wbExec.doRegFileWrite &&
      wbDecode.rd =/= 0.U) {

  when (wbDecode.rd === 1.U) { debugRegs1to4(wbFetch.threadId)(0) := wbExec.result }
    .elsewhen (wbDecode.rd === 2.U) { debugRegs1to4(wbFetch.threadId)(1) := wbExec.result }
    .elsewhen (wbDecode.rd === 3.U) { debugRegs1to4(wbFetch.threadId)(2) := wbExec.result }
    .elsewhen (wbDecode.rd === 4.U) { debugRegs1to4(wbFetch.threadId)(3) := wbExec.result }
}

when (wbFetch.valid && wbExec.doRegFileWrite) {
  assert(wbDecode.rd =/= 0.U, "Writeback attempted to x0")
}

// -----------------
// Debug control (single-lane)
// -----------------

val dbgFetch =
  wbReg.exec3Signals.exec2Signals.exec1Signals
    .regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals

val dbgDecode =
  wbReg.exec3Signals.exec2Signals.exec1Signals
    .regReadSignals.dispatchSignals.decodePipelineSignals.decodeSignals

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
// DEBUG VISIBILITY (MUST MIRROR ARCH STATE)
// =====================================================
for (t <- 0 until numThreads) {
  // x0 is always 0
  io.debugRegs01234(t)(0) := 0.U

  // x1–x4 from shadow regs
  io.debugRegs01234(t)(1) := debugRegs1to4(t)(0)
  io.debugRegs01234(t)(2) := debugRegs1to4(t)(1)
  io.debugRegs01234(t)(3) := debugRegs1to4(t)(2)
  io.debugRegs01234(t)(4) := debugRegs1to4(t)(3)

  io.debugRegX1(t) := debugRegs1to4(t)(0)
  io.debugPC(t)    := pcRegs(t)
}
}
