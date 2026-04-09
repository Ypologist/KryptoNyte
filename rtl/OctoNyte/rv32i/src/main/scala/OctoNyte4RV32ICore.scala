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
import RegFiles.RegFileMT8R4WMem

// *********************************************************
// 4-Issue Superscalar Core IO Definition
// *********************************************************
class OctoNyte4RV32ICoreIO(val numThreads: Int, val fetchWidth: Int, val cosimulate: Boolean = false) extends Bundle {
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
// Pipeline Register Definitions (4-issue superscalar)
// Pipeline registers are defined in outer scope so Verilog generation doesn't mangle names
// ****************************************************************************************
class FetchPipelineRegs4Issue(threadBits: Int) extends Bundle {
  val valid    = Bool()
  val threadId = UInt(threadBits.W)
  val pc       = UInt(32.W)
  val instr    = UInt(32.W)
}

class DecodePipelineRegs4Issue(threadBits: Int) extends Bundle {
  val fetchSignals = new FetchPipelineRegs4Issue(threadBits)
  val decodeSignals = new RV32IDecode.DecodeSignals
}

class DispatchPipelineRegs4Issue(threadBits: Int) extends Bundle {
  val decodePipelineSignals = new DecodePipelineRegs4Issue(threadBits)
}

class RegisterReadPipelineRegs4Issue(threadBits: Int) extends Bundle {
  val dispatchSignals = new DispatchPipelineRegs4Issue(threadBits)
  val rs1Data  = UInt(32.W)
  val rs2Data  = UInt(32.W) 
}

class Exec1PipelineRegs4Issue(threadBits: Int) extends Bundle {
  val regReadSignals = new RegisterReadPipelineRegs4Issue(threadBits)
  val result   = UInt(32.W)
  val doRegFileWrite = Bool()
  val ctrlTaken = Bool()
  val ctrlTarget = UInt(32.W)
} 

class Exec2PipelineRegs4Issue(threadBits: Int) extends Bundle {
  val exec1Signals = new Exec1PipelineRegs4Issue(threadBits)
} 

class Exec3PipelineRegs4Issue(threadBits: Int) extends Bundle {
  val exec2Signals = new Exec2PipelineRegs4Issue(threadBits)
}

class WritebackPipelineRegs4Issue(threadBits: Int) extends Bundle {
  val exec3Signals = new Exec3PipelineRegs4Issue(threadBits)
} 

// *********************************************************
// OctoNyte 4-Issue Superscalar RV32I Core Definition
// *********************************************************
class OctoNyte4RV32ICore(val cosimulate: Boolean = false) extends Module {
  val numThreads = 8
  // 4-issue fetch width: 128-bit per cycle (4 x 32-bit instructions)
  val fetchWidth = 4
  val numIssue = 4
  val io = IO(new OctoNyte4RV32ICoreIO(numThreads, fetchWidth, cosimulate))
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
  val nextThread =
    Mux(curThread === (numThreads - 1).U, 0.U, curThread + 1.U)

  // ALWAYS advance
  threadCounter := nextThread

  
  // Default IO outputs 
  io.memAddr := 0.U
  io.memWrite := 0.U
  io.memMask := 0.U
  io.memValid := false.B
  io.memMisaligned := false.B
 
 
  // ******************************************
  // Program counter registers for each thread
  // ******************************************
  val pcRegs = RegInit(VecInit(Seq.fill(numThreads)("h8000_0000".U(32.W))))

  // Debug shadow registers (synthesizable): track architectural x1-x4 per thread on writeback.
  // x0 is always 0 and is not stored.
  val debugRegs1to4 = RegInit(VecInit(Seq.fill(numThreads)(VecInit(Seq.fill(4)(0.U(32.W)))))) // (thread)(reg-1)


  // ***********************************************************************************
  // Multithreaded register file: 4 write ports, 8 read ports (for 4-issue superscalar)
  // ***********************************************************************************
  val regFile = Module(new RegFileMT8R4WMem(numThreads = numThreads))
  
  // All reads/writes in a cycle are from the same thread (round-robin)
  regFile.io.readThreadID := 0.U(threadBits.W)
  regFile.io.writeThreadID := 0.U(threadBits.W)
  
  // Initialize read and write addresses to 0
  for (i <- 0 until 8) {
    regFile.io.readAddrs(i) := 0.U(5.W)
  }
  for (i <- 0 until 4) {
    regFile.io.writeAddrs(i) := 0.U(5.W)
    regFile.io.wens(i) := false.B
    regFile.io.writeData(i) := 0.U(32.W)
  }


  // ***************************************************************************
  // Execution Units (4 parallel lanes)
  // ***************************************************************************
  // ALUs (one per lane)
  val alus = Array.fill(numIssue)(Module(new ALU32))
  for (i <- 0 until numIssue) {
    alus(i).io.a := 0.U
    alus(i).io.b := 0.U
    alus(i).io.opcode := ALU32.Opcode.ADD
  }

  // Branch Units (one per lane)
  val branchUnits = Array.fill(numIssue)(Module(new BranchUnit))
  for (i <- 0 until numIssue) {
    branchUnits(i).io.rs1 := 0.U
    branchUnits(i).io.rs2 := 0.U
    branchUnits(i).io.pc := 0.U
    branchUnits(i).io.imm := 0.S(32.W)
    branchUnits(i).io.branchOp := 0.U
    branchUnits(i).io.valid := false.B
    val unusedBranchNextPc = Wire(UInt(32.W))
    val unusedBranchMisaligned = Wire(Bool())
    unusedBranchNextPc := branchUnits(i).io.nextPc
    unusedBranchMisaligned := branchUnits(i).io.misaligned
    dontTouch(unusedBranchNextPc)
    dontTouch(unusedBranchMisaligned)
  }

  // Load Units (one per lane)
  val loadUnits = Array.fill(numIssue)(Module(new LoadUnit))
  for (i <- 0 until numIssue) {
    loadUnits(i).io.addr := 0.U
    loadUnits(i).io.dataIn := io.dataMemResp
    loadUnits(i).io.funct3 := 0.U
  }

  // Store Units (one per lane)
  val storeUnits = Array.fill(numIssue)(Module(new StoreUnit))
  for (i <- 0 until numIssue) {
    storeUnits(i).io.addr := 0.U
    storeUnits(i).io.data := 0.U
    storeUnits(i).io.storeType := 0.U
  }


// =============================
// Fetch stage (4-issue)
// =============================

// 4-wide fetch pipeline registers
  val fetchReg = Array.fill(numIssue)(RegInit(0.U.asTypeOf(new FetchPipelineRegs4Issue(threadBits))))
  
  when (io.threadEnable(curThread)) {
    for (i <- 0 until numIssue) {
      fetchReg(i).valid    := true.B
      fetchReg(i).threadId := curThread
      fetchReg(i).pc       := pcRegs(curThread) + (i * 4).U
      fetchReg(i).instr    := io.instrMem((i+1)*32 - 1, i*32)
    }
    pcRegs(curThread) := pcRegs(curThread) + (numIssue * 4).U
  } .otherwise {
    for (i <- 0 until numIssue) {
      fetchReg(i).valid := false.B   // bubble
    }
  }

// =============================
// Decode stage (4-issue)
// =============================

val decodeReg = Array.fill(numIssue)(RegInit(0.U.asTypeOf(new DecodePipelineRegs4Issue(threadBits))))

for (i <- 0 until numIssue) {
  when (fetchReg(i).valid) {
    decodeReg(i).fetchSignals := fetchReg(i)
    decodeReg(i).decodeSignals := RV32IDecode.decodeInstr(fetchReg(i).instr)
  } .otherwise {
    decodeReg(i).fetchSignals.valid := false.B
  }
}

 // =============================
// Dispatch stage (4-issue)
// =============================

val dispatchReg = Array.fill(numIssue)(RegInit(0.U.asTypeOf(new DispatchPipelineRegs4Issue(threadBits))))

for (i <- 0 until numIssue) {
  when (decodeReg(i).fetchSignals.valid) {
    dispatchReg(i).decodePipelineSignals := decodeReg(i)
  } .otherwise {
    dispatchReg(i).decodePipelineSignals.fetchSignals.valid := false.B
  }
}


  // =============================
// Register read stage (4-issue)
// =============================

val regReadReg = Array.fill(numIssue)(RegInit(0.U.asTypeOf(new RegisterReadPipelineRegs4Issue(threadBits))))

// All lanes read from the same thread in this cycle (round-robin scheduling)
// Find the thread ID from the first valid dispatch lane
val validThreadId = Mux(dispatchReg(0).decodePipelineSignals.fetchSignals.valid, 
  dispatchReg(0).decodePipelineSignals.fetchSignals.threadId,
  Mux(dispatchReg(1).decodePipelineSignals.fetchSignals.valid,
    dispatchReg(1).decodePipelineSignals.fetchSignals.threadId,
    Mux(dispatchReg(2).decodePipelineSignals.fetchSignals.valid,
      dispatchReg(2).decodePipelineSignals.fetchSignals.threadId,
      dispatchReg(3).decodePipelineSignals.fetchSignals.threadId)))

regFile.io.readThreadID := validThreadId

for (lane <- 0 until numIssue) {
  when (dispatchReg(lane).decodePipelineSignals.fetchSignals.valid) {
    regReadReg(lane).dispatchSignals := dispatchReg(lane)

    // Register file read: lane i uses read ports 2*i and 2*i+1
    regFile.io.readAddrs(lane*2)     := dispatchReg(lane).decodePipelineSignals.decodeSignals.rs1
    regFile.io.readAddrs(lane*2 + 1) := dispatchReg(lane).decodePipelineSignals.decodeSignals.rs2

    regReadReg(lane).rs1Data := regFile.io.readData(lane*2)
    regReadReg(lane).rs2Data := regFile.io.readData(lane*2 + 1)
  } .otherwise {
    regReadReg(lane).dispatchSignals.decodePipelineSignals.fetchSignals.valid := false.B
  }
}


 // =============================
// Execute 1 stage (4-issue)
// =============================

  val exec1Reg = Array.fill(numIssue)(RegInit(0.U.asTypeOf(new Exec1PipelineRegs4Issue(threadBits))))

  for (lane <- 0 until numIssue) {
    when (regReadReg(lane).dispatchSignals.decodePipelineSignals.fetchSignals.valid) {

    val decodeSignals =
      regReadReg(lane).dispatchSignals.decodePipelineSignals.decodeSignals
    val fetchSignals =
      regReadReg(lane).dispatchSignals.decodePipelineSignals.fetchSignals

    exec1Reg(lane).regReadSignals := regReadReg(lane)
    exec1Reg(lane).doRegFileWrite := false.B
    exec1Reg(lane).ctrlTaken := false.B
    exec1Reg(lane).ctrlTarget := 0.U

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
        Mux(decodeSignals.isLUI, 0.U, regReadReg(lane).rs1Data))

      val opB = Mux(useImm,
        decodeSignals.imm,
        regReadReg(lane).rs2Data)

      alus(lane).io.a := opA
      alus(lane).io.b := opB
      alus(lane).io.opcode := decodeSignals.aluOp

      val result = Mux(decodeSignals.isAUIPC,
        fetchSignals.pc + decodeSignals.imm,
        Mux(decodeSignals.isLUI,
          decodeSignals.imm,
          alus(lane).io.result))

      exec1Reg(lane).result := result
      exec1Reg(lane).doRegFileWrite := true.B
    }

    // ---- JAL ----
    .elsewhen (decodeSignals.isJAL) {
      exec1Reg(lane).result := fetchSignals.pc + 4.U
      exec1Reg(lane).doRegFileWrite := true.B
      exec1Reg(lane).ctrlTaken := true.B
      exec1Reg(lane).ctrlTarget := (fetchSignals.pc.asSInt + decodeSignals.imm.asSInt).asUInt
    }

    // ---- JALR ----
    .elsewhen (decodeSignals.isJALR) {
      val target =
        ((regReadReg(lane).rs1Data.asSInt + decodeSignals.imm.asSInt).asUInt & ~1.U(32.W))
      exec1Reg(lane).result := fetchSignals.pc + 4.U
      exec1Reg(lane).doRegFileWrite := true.B
      exec1Reg(lane).ctrlTaken := true.B
      exec1Reg(lane).ctrlTarget := target
    }

    // ---- BRANCH ----
    .elsewhen (decodeSignals.isBranch) {
      branchUnits(lane).io.rs1 := regReadReg(lane).rs1Data
      branchUnits(lane).io.rs2 := regReadReg(lane).rs2Data
      branchUnits(lane).io.pc  := fetchSignals.pc
      branchUnits(lane).io.imm := (decodeSignals.imm << 1).asSInt
      branchUnits(lane).io.branchOp := fetchSignals.instr(14, 12)
      branchUnits(lane).io.valid := true.B

      exec1Reg(lane).ctrlTaken := branchUnits(lane).io.taken
      exec1Reg(lane).ctrlTarget := branchUnits(lane).io.target
    }

    // ---- LOAD ----
    .elsewhen (decodeSignals.isLoad) {
      val address = regReadReg(lane).rs1Data + decodeSignals.imm
      val loadActive = io.threadEnable(fetchSignals.threadId)
      io.memAddr := Cat(address(31, 2), 0.U(2.W))
      io.memValid := loadActive
      loadUnits(lane).io.addr := address
      loadUnits(lane).io.funct3 := fetchSignals.instr(14, 12)

      exec1Reg(lane).result := loadUnits(lane).io.dataOut
      exec1Reg(lane).doRegFileWrite := true.B
    }

    // ---- STORE ----
    .elsewhen (decodeSignals.isStore) {
      val address = regReadReg(lane).rs1Data + decodeSignals.imm
      val storeActive = io.threadEnable(fetchSignals.threadId) && !storeUnits(lane).io.misaligned
      io.memAddr := Cat(address(31, 2), 0.U(2.W))
      storeUnits(lane).io.addr := address
      storeUnits(lane).io.data := regReadReg(lane).rs2Data
      storeUnits(lane).io.storeType := fetchSignals.instr(13, 12)

      io.memWrite := Mux(storeActive, storeUnits(lane).io.memWrite, 0.U)
      io.memMask := Mux(storeActive, storeUnits(lane).io.mask, 0.U)
      io.memValid := storeActive
      io.memMisaligned := io.threadEnable(fetchSignals.threadId) && storeUnits(lane).io.misaligned
    }

    } .otherwise {
      exec1Reg(lane)
        .regReadSignals
        .dispatchSignals
        .decodePipelineSignals
        .fetchSignals
        .valid := false.B
    }
  }

  // =============================
  // Execute 2 stage (pass-through)
  // =============================

  val exec2Reg = Array.fill(numIssue)(RegInit(0.U.asTypeOf(new Exec2PipelineRegs4Issue(threadBits))))

  for (i <- 0 until numIssue) {
    when (exec1Reg(i).regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid) {
      exec2Reg(i).exec1Signals := exec1Reg(i)
    } .otherwise {
      exec2Reg(i).exec1Signals
        .regReadSignals
        .dispatchSignals
        .decodePipelineSignals
        .fetchSignals
        .valid := false.B
    }
  }

  // =============================
  // Execute 3 stage (pass-through)
  // =============================

  val exec3Reg = Array.fill(numIssue)(RegInit(0.U.asTypeOf(new Exec3PipelineRegs4Issue(threadBits))))

  for (i <- 0 until numIssue) {
    when (exec2Reg(i).exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid) {
      exec3Reg(i).exec2Signals := exec2Reg(i)
    } .otherwise {
      exec3Reg(i).exec2Signals
        .exec1Signals
        .regReadSignals
        .dispatchSignals
        .decodePipelineSignals
        .fetchSignals
        .valid := false.B
    }
  }

  // =============================
  // Writeback stage (4 lanes)
  // =============================

  val wbReg = Array.fill(numIssue)(RegInit(0.U.asTypeOf(new WritebackPipelineRegs4Issue(threadBits))))

  for (i <- 0 until numIssue) {
    when (exec3Reg(i).exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid) {
      wbReg(i).exec3Signals := exec3Reg(i)
    } .otherwise {
      wbReg(i).exec3Signals
        .exec2Signals
        .exec1Signals
        .regReadSignals
        .dispatchSignals
        .decodePipelineSignals
        .fetchSignals
        .valid := false.B
    }
  }

  // =============================
  // Writeback signal extraction & commit (4 lanes)
  // =============================

  // Set write thread ID - use first valid lane's thread ID (all lanes from same thread)
  val wbValidThreadId = Mux(wbReg(0).exec3Signals.exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid,
    wbReg(0).exec3Signals.exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.threadId,
    Mux(wbReg(1).exec3Signals.exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid,
      wbReg(1).exec3Signals.exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.threadId,
      Mux(wbReg(2).exec3Signals.exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid,
        wbReg(2).exec3Signals.exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.threadId,
        wbReg(3).exec3Signals.exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.threadId)))

  regFile.io.writeThreadID := wbValidThreadId

  for (lane <- 0 until numIssue) {
    val wbFetch =
      wbReg(lane).exec3Signals.exec2Signals.exec1Signals
        .regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals

    val wbDecode =
      wbReg(lane).exec3Signals.exec2Signals.exec1Signals
        .regReadSignals.dispatchSignals.decodePipelineSignals.decodeSignals

    val wbExec =
      wbReg(lane).exec3Signals.exec2Signals.exec1Signals

    // Architectural register writeback
    when (wbFetch.valid &&
          wbExec.doRegFileWrite &&
          wbDecode.rd =/= 0.U) {
      regFile.io.wens(lane) := true.B
      regFile.io.writeAddrs(lane) := wbDecode.rd
      regFile.io.writeData(lane) := wbExec.result
    }

    // Debug register tracking (x1-x4 per thread)
    when (wbFetch.valid &&
          wbExec.doRegFileWrite &&
          wbDecode.rd =/= 0.U) {
      when (wbDecode.rd === 1.U) { debugRegs1to4(wbFetch.threadId)(0) := wbExec.result }
        .elsewhen (wbDecode.rd === 2.U) { debugRegs1to4(wbFetch.threadId)(1) := wbExec.result }
        .elsewhen (wbDecode.rd === 3.U) { debugRegs1to4(wbFetch.threadId)(2) := wbExec.result }
        .elsewhen (wbDecode.rd === 4.U) { debugRegs1to4(wbFetch.threadId)(3) := wbExec.result }
    }

    // Keep writeback side-effect free for x0
    when (wbFetch.valid && wbExec.doRegFileWrite && wbDecode.rd === 0.U) {
      regFile.io.wens(lane) := false.B
    }
  }

  // Control-flow commit (from earliest lane with redirect)
  for (lane <- 0 until numIssue) {
    val ex1Fetch =
      exec1Reg(lane).regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals
    val ex1Redirect = ex1Fetch.valid && exec1Reg(lane).ctrlTaken

    when (ex1Redirect) {
      pcRegs(ex1Fetch.threadId) := exec1Reg(lane).ctrlTarget
    }
  }

  // -----------------
  // Debug signals (report first valid lane)
  // -----------------

  val dbgFetch =
    wbReg(0).exec3Signals.exec2Signals.exec1Signals
      .regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals

  val dbgDecode =
    wbReg(0).exec3Signals.exec2Signals.exec1Signals
      .regReadSignals.dispatchSignals.decodePipelineSignals.decodeSignals

  io.debugStageThreads(0) := fetchReg(0).threadId
  io.debugStageValids(0) := (fetchReg(0).valid).asUInt
  io.debugStageThreads(1) := decodeReg(0).fetchSignals.threadId
  io.debugStageValids(1) := (decodeReg(0).fetchSignals.valid).asUInt
  io.debugStageThreads(2) := dispatchReg(0).decodePipelineSignals.fetchSignals.threadId
  io.debugStageValids(2) := (dispatchReg(0).decodePipelineSignals.fetchSignals.valid).asUInt
  io.debugStageThreads(3) := regReadReg(0).dispatchSignals.decodePipelineSignals.fetchSignals.threadId
  io.debugStageValids(3) := (regReadReg(0).dispatchSignals.decodePipelineSignals.fetchSignals.valid).asUInt
  io.debugStageThreads(4) := exec1Reg(0).regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.threadId
  io.debugStageValids(4) := (exec1Reg(0).regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid).asUInt
  io.debugStageThreads(5) := exec2Reg(0).exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.threadId
  io.debugStageValids(5) := (exec2Reg(0).exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid).asUInt
  io.debugStageThreads(6) := exec3Reg(0).exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.threadId
  io.debugStageValids(6) := (exec3Reg(0).exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid).asUInt
  io.debugStageThreads(7) := dbgFetch.threadId
  io.debugStageValids(7) := (dbgFetch.valid).asUInt

  io.debugCtrlValid := dbgFetch.valid
  io.debugCtrlInstr := dbgFetch.instr
  io.debugCtrlTaken := wbReg(0).exec3Signals.exec2Signals.exec1Signals.ctrlTaken
  io.debugCtrlThread := dbgFetch.threadId
  io.debugCtrlFromPC := dbgFetch.pc
  io.debugCtrlTarget := wbReg(0).exec3Signals.exec2Signals.exec1Signals.ctrlTarget
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

