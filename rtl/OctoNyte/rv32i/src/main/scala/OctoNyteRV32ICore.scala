package OctoNyte

import chisel3._
import chisel3.util._
import ALUs._
import BranchUnit._
import Decoders._
import LoadUnit._
import StoreUnit._
import RegFiles._
import RegFiles.RegFileMTMultiWVec
import Pipeline._
import java.nio.channels.Pipe


class FetchPipelineRegBundle(threadBits: Int, fetchWidth: Int) extends Bundle {
  val valid     = Bool()
  val pc        = UInt(32.W)
  val instr     = UInt((fetchWidth * 32).W)
}


class DecodePipelineRegBundle(threadBits: Int) extends Bundle {
  val fetchSignals = new FetchPipelineRegBundle(threadBits)
  val decodeSignals = new RV32IDecode.DecodeSignals
}


class DipatchPipelineRegBundle(threadBits: Int) extends Bundle {
  val decodeSignals = new DecodePipelineRegBundle(threadBits)  // includes fetch signals too
  // Additional dispatch-specific signals can be added here when multiple-issue is implemented
}

class RegisterReadPipelineRegBundle(threadBits: Int) extends Bundle {
  val dispatchSignals = new DispatchPipelineRegBundle(threadBits)  // include fetch and decode signals too
  val rs1Data   = UInt(32.W)
  val rs2Data   = UInt(32.W)
}

class Exec1PipelineRegBundle(threadBits: Int) extends Bundle {
  val registReadSignals = new RegisterReadPipelineRegBundle(threadBits)  // include fetch and decode signals too
  val result = UInt(32.W)
}

class Exec2PipelineRegBundle(threadBits: Int) extends Bundle {
  val exec1Signals = new Exec1PipelineRegBundle(threadBits)  // include fetch and decode signals too
}

class Exec3PipelineRegBundle(threadBits: Int) extends Bundle {
  val exec2Signals = new Exec2PipelineRegBundle(threadBits)  
  var memReadData = UInt(32.W)
}

class WritebackPipelineRegBundle(threadBits: Int) extends Bundle {
  val exec3Signals = new Exec3PipelineRegBundle(threadBits)  
}

class OctoNyteRV32ICoreIO(val numThreads: Int, val fetchWidth: Int) extends Bundle {
  val threadEnable = Input(Vec(numThreads, Bool()))
  val instrMem     = Input(UInt((fetchWidth * 32).W)) 
  val dataMemResp  = Input(UInt(32.W))
  val memAddr      = Output(UInt(32.W))
  val memWrite     = Output(UInt(32.W))
  val memMask      = Output(UInt(4.W))
  val memMisaligned= Output(Bool())
}

class OctoNyteRV32ICore extends Module {
  val numThreads = 8
  val fetchWidth = 1
  val io = IO(new OctoNyteRV32ICoreIO(numThreads, fetchWidth))

  private val threadBits = log2Ceil(numThreads)

  // *******************
  // Default IO outputs
  // *******************
  io.memAddr := 0.U
  io.memWrite := 0.U
  io.memMask := 0.U
  io.memMisaligned := false.B



  // *******************************
  // Per-pipeline barrel schedulers
  // *******************************
  val pcScheduler       = Module(new PipelineScheduler(numThreads = numThreads, defaultThread = 0))
  val decScheduler      = Module(new PipelineScheduler(numThreads = numThreads, defaultThread = 7))
  val disScheduler      = Module(new PipelineScheduler(numThreads = numThreads, defaultThread = 6))
  val regReadScheduler  = Module(new PipelineScheduler(numThreads = numThreads, defaultThread = 5))
  val ex1Scheduler      = Module(new PipelineScheduler(numThreads = numThreads, defaultThread = 4))
  val ex2Scheduler      = Module(new PipelineScheduler(numThreads = numThreads, defaultThread = 3))
  val ex3Scheduler      = Module(new PipelineScheduler(numThreads = numThreads, defaultThread = 2))
  val wbScheduler       = Module(new PipelineScheduler(numThreads = numThreads, defaultThread = 1))


  // *************************************************************************
  // Multithreaded register file with 1 write port and 2 read-port groups
  // *************************************************************************
  val regFile = Module(new RegFileMTMultiWVec(numThreads = numThreads, numWritePorts = 1, numReadPorts = 2))

  
  // *********************************************************************
  // Initialize pipeline stage registers and control signals
  // *********************************************************************

   val pcRegs = RegInit(VecInit(Seq.fill(numThreads, fetchWidth=1) {
    val init = WireDefault(0.U.asTypeOf(new FetchPipelineRegBundle(threadBits, fetchWidth)))
      init.valid    := false.B
      init.pc       := "h80000000".U
      init.instr    := 0.U
      init  //return the bundle
  }))


  val decodeRegs = RegInit(VecInit(Seq.fill(numThreads) {
    val init = WireDefault(0.U.asTypeOf(new DecodePipelineRegBundle(threadBits)))
      init.fetchSignals := 0.U.asTypeOf(new FetchPipelineRegBundle(threadBits))
      init.decodeSignals := 0.U.asTypeOf(new RV32IDecode.DecodeSignals)
      init
  }))

  val dispatchRegs = RegInit(VecInit(Seq.fill(numThreads) {
    val init = WireDefault(0.U.asTypeOf(new DispatchPipelineRegBundle(threadBits)))
      init.decodeSignals := 0.U.asTypeOf(new DecodePipelineRegBundle(threadBits))
      init
  }))


  val registerReadRegs = RegInit(VecInit(Seq.fill(numThreads) {
    val init = WireDefault(0.U.asTypeOf(new RegisterReadPipelineRegBundle(threadBits)))
      init.dispatchSignals := 0.U.asTypeOf(new DispatchPipelineRegBundle(threadBits))
      init
  }))

  val exec1Regs = RegInit(VecInit(Seq.fill(numThreads) {
    val init = WireDefault(0.U.asTypeOf(new Exec1PipelineRegBundle(threadBits)))
      init.registReadSignals := 0.U.asTypeOf(new RegisterReadPipelineRegBundle(threadBits))
      init.result := 0.U
      init
  }))

  val exec2Regs = RegInit(VecInit(Seq.fill(numThreads) {
    val init = WireDefault(0.U.asTypeOf(new Exec2PipelineRegBundle(threadBits)))
      init.exec1Signals := 0.U.asTypeOf(new Exec1PipelineRegBundle(threadBits))
      init
  }))

  val exec3Regs = RegInit(VecInit(Seq.fill(numThreads) {
    val init = WireDefault(0.U.asTypeOf(new Exec3PipelineRegBundle(threadBits)))
      init.exec2Signals := 0.U.asTypeOf(new Exec2PipelineRegBundle(threadBits))
      init
  }))

  val writebackRegs = RegInit(VecInit(Seq.fill(numThreads) {
    val init = WireDefault(0.U.asTypeOf(new WritebackPipelineRegBundle(threadBits)))
      init.exec3Signals := 0.U.asTypeOf(new Exec3PipelineRegBundle(threadBits))
      init
  }))

  // =============================================================
  // ===================== Instruction Fetch =====================
  // =============================================================

  val FetchThreadSel = pcScheduler.io.threadSelect
  val fetchEntry     = pcRegs(FetchThreadSel)

  // Update the PC for that thread
  when(io.threadEnable(FetchThreadSel)) {
     
    // Capture the incoming packet
    decodeRegs(FetchThreadSel).pc    := pcRegs(FetchThreadSel).pc
    decodeRegs(FetchThreadSel).instr := io.instrMem
    decodeRegs(FetchThreadSel).valid := true.B 
  
    pcRegs(FetchThreadSel).pc := pcRegs(FetchThreadSel).pc + (fetchWidth * 4).U  // advance PC

  } .otherwise {
    fetchEntry.valid := false.B
  } 

  // ==============================================================
  // ===================== Decode  ================================
  // ==============================================================
  val decodeThreadSel = decScheduler.io.threadSelect
  val fetchEntry      = decodeRegs(decodeThreadSel).fetchSignals
  val decEntry        = decodeRegs(decodeThreadSel).decodeSignals

  when(fetchEntry.valid && io.threadEnable(decodeThreadSel)) {
    val instrWord = fetchEntry.instr(31, 0)                   // single-issue: use low 32 bits
    val dec       = RV32IDecode.decodeInstr(instrWord)

    decEntry.fetch    := fetchEntry                          // copy pc, instr, threadId, valid
    decEntry.decodeSignals := dec                            // assign the whole bundle

  }.otherwise {
    fetchEntry.valid := false.B
  }

  // ===============================================================
  // ===================== Dispatch ================================
  // ===============================================================

  // Passthru for now. Update when multiple-issue dispatch is added.
  val dispatchThreadSel = disScheduler.io.threadSelect
  val decEntry        = decodeRegs(dispatchThreadSel).decodeSignals

  when(decEntry.valid && io.threadEnable(dispatchThreadSel)) {
    dispatchEntry.dispatchSignals := decEntry

  } .otherwise {
    dispatchEntry.dispatchSignals.fetch.valid := false.B
  }
  


  // =========================================================
  // ===================== Register Read =====================
  // =========================================================
  val registerReadThreadSel = regReadScheduler.io.threadSelect
  val dispatchEntry   = dispatchRegs(registerReadThreadSel)
  val registerReadEntry = dispatchRegs(registerReadThreadSel)

  //Read the register file here
  regFile.io.writeThreadID := registerReadThreadSel
  regFile.io.rs1 := dispatchEntry.decodeSignals.rs1
  regFile.io.rs2 := dispatchEntry.decodeSignals.rs2
  
  when(dispatchEntry.valid && io.threadEnable(registerReadThreadSel)) {
    regFile.io.readThreadID := registerReadThreadSel
    regFile.io.src1(0) := dispatchEntry.decodeSignals.rs1
    regFile.io.src2(0) := dispatchEntry.decodeSignals.rs2

    dispatchEntry.rs1Data := regFile.io.src1data(0)
    dispatchEntry.rs2Data := regFile.io.src2data(0)

    // mark dispatch entry consumed, so it doesn’t get re-used next cycle
    dispatchEntry.fetch.valid := false.B


  } .otherwise {
    registerReadEntry.dispatchSignals.fetch.valid := false.B
  }

  // =============================================================
  // ===================== Execute 1  ============================
  // =============================================================
  val ex1ThreadSel = ex1Scheduler.io.threadSelect
  val regReadEntry = registerReadRegs(ex1ThreadSel)
  val ex1Entry     = exec1Regs(ex1ThreadSel)

  val alu = Module(new ALU32)
  val branchUnit = Module(new BranchUnit)
  val loadUnit = Module(new LoadUnit()) // default 32b for data
  val storeUnit = Module(new StoreUnit)


  when(regReadEntry.isALU && io.threadEnable(ex1ThreadSel)) {
    alu.io.a := regReadEntry.rs1Data
    alu.io.b := regReadEntry.rs2Data
    alu.io.opcode := regReadEntry.aluOp
    ex1Entry.result := alu.io.result
  }

  when(regReadEntry.isBranch && io.threadEnable(ex1ThreadSel)) {
    branchUnit.io.rs1 := regReadEntry.rs1Data
    branchUnit.io.rs2 := regReadEntry.rs2Data
    branchUnit.io.pc  := regReadEntry.fetch.pc
    branchUnit.io.imm := regReadEntry.imm.asSInt
    branchUnit.io.branchOp := regReadEntry.instr(14,12)
    branchUnit.io.valid := regReadEntry.valid
  }

  when(regReadEntry.isLoad && io.threadEnable(ex1ThreadSel)) {
    loadUnit.io.addr := alu.io.result
    loadUnit.io.dataIn := io.dataMemResp
    loadUnit.io.funct3 := regReadEntry.instr(14,12)
  }

  when(regReadEntry.isStore && io.threadEnable(ex1ThreadSel)) {
    storeUnit.io.addr := alu.io.result
    storeUnit.io.data := regReadEntry.rs2Data
    storeUnit.io.storeType := regReadEntry.instr(13,12)
  }

  // ==============================================================
  // ===================== Execute2 ===============================
  // ==============================================================
  val ex2ThreadSel = ex2Scheduler.io.threadSelect
  val ex1Entry     = exec1Regs(ex2ThreadSel)
  val ex2Entry     = exec2Regs(ex2ThreadSel)


  // Fill in Execute2 logic when needed and copy data from ex1Entry to ex2Entry
  when(ex1Entry.valid && io.threadEnable(ex2ThreadSel)) {
    ex2Entry.exec1Signals := ex1Entry
  } .otherwise {
    ex2Entry.exec1Signals.registReadSignals.fetch.valid := false.B
  }

  // ==============================================================
  // ===================== Execute3 ===============================
  // ==============================================================
  val ex3ThreadSel = ex3Scheduler.io.threadSelect
  val ex2Entry     = exec2Regs(ex3ThreadSel)
  val ex3Entry     = exec3Regs(ex3ThreadSel)  

  // Fill in Execute3 logic when needed and copy data from ex2Entry to ex3Entry
  when(ex2Entry.valid && io.threadEnable(ex3ThreadSel)) {
    ex3Entry.exec2Signals := ex2Entry
  } .otherwise {
    ex3Entry.exec2Signals.exec1Signals.registReadSignals.fetch.valid := false.B
  } 



  // =============================================================
  // ===================== Writeback  ============================
  // =============================================================
  val wbThreadSel = wbScheduler.io.threadSelect
  val ex3Entry    = exec3Regs(wbThreadSel)
  val wbEntry     = writebackRegs(wbThreadSel)


  when(ex3Entry.valid && io.threadEnable(wbThreadSel)) {
    wbEntry.exec3Signals := ex3Entry

    regFile.io.writeThreadID := wbThreadSel
    regFile.io.dst := ex3Entry.rd
    regFile.io.wen := true.B
    regFile.io.dstData := ex3Entry.result


  } 
 


