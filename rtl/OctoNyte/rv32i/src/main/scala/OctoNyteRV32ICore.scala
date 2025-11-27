package OctoNyte

import chisel3._
import chisel3.util._
import ALUs.ALU32
import Decoders.RV32IDecode
import Pipeline.PipelineScheduler
import RegFiles.RegFileMTMultiWVec


// *********************************************************
// Core IO Definition
// *********************************************************
class OctoNyteRV32ICoreIO(val numThreads: Int, val fetchWidth: Int) extends Bundle {
  val threadEnable = Input(Vec(numThreads, Bool()))
  val instrMem     = Input(UInt((fetchWidth * 32).W))
  val dataMemResp  = Input(UInt(32.W))
  val memAddr      = Output(UInt(32.W))
  val memWrite     = Output(UInt(32.W))
  val memMask      = Output(UInt(4.W))
  val memMisaligned= Output(Bool())

}

// ****************************************************************************************
// Pipeline Register Definitions
// Pipeline registers are defined in outer scope so Verilog generation doesn't mangle names
// ****************************************************************************************
class FetchPipelineRegs(threadBits: Int) extends Bundle {
  val valid    = Bool()
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
  val fetchWidth = 1
  val regFileReadPorts = 2 * fetchWidth
  val regFileWritePorts = fetchWidth
  val io = IO(new OctoNyteRV32ICoreIO(numThreads, fetchWidth))

  private val threadBits = log2Ceil(numThreads)

  // Default IO outputs 
  io.memAddr := 0.U
  io.memWrite := 0.U
  io.memMask := 0.U
  io.memMisaligned := false.B


  // ******************************************
  // Program counter registers for each thread
  // ******************************************
  val pcRegs = RegInit(VecInit(Seq.fill(numThreads)("h8000_0000".U(32.W))))


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
  branchUnit.io.imm := 0.S(12.W)
  branchUnit.io.branchOp := 0.U
  branchUnit.io.valid := false.B

  // Load Unit
  val loadUnit = Module(new LoadUnit)
  loadUnit.io.address := 0.U
  loadUnit.io.mask := 0.U
  loadUnit.io.loadOp := 0.U
  loadUnit.io.dataIn := io.dataMemResp
  loadUnit.io.valid := false.B

  // Store Unit
  val storeUnit = Module(new StoreUnit)
  storeUnit.io.address := 0.U
  storeUnit.io.dataOut := 0.U
  storeUnit.io.storeOp := 0.U
  storeUnit.io.valid := false.B


  // =============================
  // Fetch stage
  // =============================

  // Thread scheduler for Fetch stage
  val fetchScheduler = Module(new ThreadScheduler(numThreads = numThreads, startingThread = 0))
  
  //pipeline regs
  val fetchRegs = RegInit(VecInit(Seq.fill(numThreads) {
    val init = WireDefault(0.U.asTypeOf(new FetchPipelineRegs(threadBits)))
    init.valid := false.B
    init.pc    := "h80000000".U
    init.instr := 0.U
    init // return the bundle
  }))

  val fetchThreadSel = fetchScheduler.io.currentThread  // Get current fetch thread

  val fetchEntry = fetchRegs(fetchThreadSel)
  when(io.threadEnable(fetchThreadSel)) {
    val instrWord = io.instrMem(31, 0)
    fetchEntry.valid := true.B
    fetchEntry.pc := pcRegs(fetchThreadSel)
    fetchEntry.instr := instrWord
  }.otherwise {
    fetchEntry.valid := false.B
  }

  // =============================
  // Decode stage
  // =============================

  // Thread scheduler for Decode stage
  val decodeScheduler = Module(new ThreadScheduler(numThreads = numThreads, startingThread = 7))

  // pipeline regs
  val decodeRegs = RegInit(VecInit(Seq.fill(numThreads) {
    val init = WireDefault(0.U.asTypeOf(new DecodePipelineRegs(threadBits)))
    init.fetchSignals := 0.U.asTypeOf(new FetchPipelineRegs(threadBits))
    init.decodeSignals := 0.U.asTypeOf(new RV32IDecode.DecodeSignals)
    init // return the bundle
  })) 


  val decodeThreadSel = decodeScheduler.io.currentThread // Get current decode thread
  val fetchToDecodeEntry = fetchRegs(decodeThreadSel)
  
  when(fetchToDecodeEntry.valid && io.threadEnable(decodeThreadSel)) {
    val decodeEntry = decodeRegs(decodeThreadSel)
    val dec = RV32IDecode.decodeInstr(fetchToDecodeEntry.instr)
    decodeEntry.fetchSignals := fetchToDecodeEntry  // propagate fetch signals
    decodeEntry.decodeSignals := dec
  }

  // =============================
  // Dispatch stage
  // =============================

  // Thread scheduler for Dispatch stage
  val dispatchScheduler = Module(new ThreadScheduler(numThreads = numThreads, startingThread = 6))

  // pipeline regs
  val dispatchRegs = RegInit(VecInit(Seq.fill(numThreads) {
    val init = WireDefault(0.U.asTypeOf(new DispatchPipelineRegs(threadBits)))
    init.decodePipelineSignals := 0.U.asTypeOf(new DecodePipelineRegs(threadBits))
    init // return the bundle
  }))

  val dispatchThreadSel = dispatchScheduler.io.currentThread // Get current dispatch thread
  val decodeToDispatchEntry = decodeRegs(dispatchThreadSel)
  when(decodeToDispatchEntry.fetchSignals.valid && io.threadEnable(dispatchThreadSel)) {
    dispatchRegs(dispatchThreadSel) := decodeToDispatchEntry
  }


  // =============================
  // Register read stage
  // =============================

  // Thread scheduler for Register Read stage
  val regReadScheduler = Module(new ThreadScheduler(numThreads = numThreads, startingThread = 5))

  // pipeline regs
  val regReadRegs = RegInit(VecInit(Seq.fill(numThreads) {
    val init = WireDefault(0.U.asTypeOf(new RegisterReadPipelineRegs(threadBits)))
    init.dispatchSignals := 0.U.asTypeOf(new DispatchPipelineRegs(threadBits))
    init.rs1Data := 0.U
    init.rs2Data := 0.U
    init // return the bundle
  }))

  val regReadThreadSel = regReadScheduler.io.currentThread // Get current register read thread
  val dispatchToRegReadEntry = dispatchRegs(regReadThreadSel)
  when(dispatchToRegReadEntry.decodePipelineSignals.fetchSignals.valid && io.threadEnable(regReadThreadSel)) {
    val regReadEntry = regReadRegs(regReadThreadSel)
    regReadEntry.dispatchSignals := dispatchToRegReadEntry
    // Read register file
    regFile.io.readThreadID(0) := regReadThreadSel
    regFile.io.src1(0) := dispatchToRegReadEntry.decodePipelineSignals.decodeSignals.rs1
    regFile.io.src2(0) := dispatchToRegReadEntry.decodePipelineSignals.decodeSignals.rs2
    regReadEntry.rs1Data := regFile.io.src1data(0)
    regReadEntry.rs2Data := regFile.io.src2data(0)
  } 


  // =============================
  // Execute 1 stage (ALU)
  // =============================

  // Thread scheduler for Execute 1 stage
  val exec1Scheduler = Module(new ThreadScheduler(numThreads = numThreads, startingThread = 4))
  
  // pipeline regs
  val exec1Regs = RegInit(VecInit(Seq.fill(numThreads) {
    val init = WireDefault(0.U.asTypeOf(new Exec1PipelineRegs(threadBits)))
    init.regReadSignals := 0.U.asTypeOf(new RegisterReadPipelineRegs(threadBits))
    init.result := 0.U

    init // return the bundle
  }))

  
  val exec1ThreadSel = exec1Scheduler.io.currentThread // Get current execute 1 thread
  val regReadToExec1Entry = regReadRegs(exec1ThreadSel)

  

  when(regReadToExec1Entry.dispatchSignals.decodePipelineSignals.fetchSignals.valid && io.threadEnable(exec1ThreadSel)) {
    val exec1RegsEntry = exec1Regs(exec1ThreadSel) // propagate pipeline regs
    exec1RegsEntry.regReadSignals := regReadToExec1Entry

    // ALU
    when(regReadToExec1Entry.dispatchSignals.decodePipelineSignals.decodeSignals.isALU ||
         regReadToExec1Entry.dispatchSignals.decodePipelineSignals.decodeSignals.isLUI ||
         regReadToExec1Entry.dispatchSignals.decodePipelineSignals.decodeSignals.isAUIPC) {
      val opcode = regReadEntry.dispatchSignals.decodePipelineSignals.decodeSignals.instr(6, 0)
      val useImm = (opcode === RV32IDecode.OP_I) || regReadEntry.dispatchSignals.decodePipelineSignals.decodeSignals.isLUI || 
        regReadEntry.dispatchSignals.decodePipelineSignals.decodeSignals.isAUIPC
      val opA = Mux(regReadEntry.dispatchSignals.decodePipelineSignals.decodeSignals.isAUIPC, 
        regReadEntry.dispatchSignals.decodePipelineSignals.fetchSignals.pc,
        Mux(regReadEntry.dispatchSignals.decodePipelineSignals.decodeSignals.isLUI, 
          0.U, 
          regReadEntry.rs1Data))
      val opB = Mux(useImm, 
        regReadEntry.dispatchSignals.decodePipelineSignals.decodeSignals.imm, 
        regReadEntry.rs2Data)

      alu.io.a := opA
      alu.io.b := opB
      alu.io.opcode := regReadEntry.dispatchSignals.decodePipelineSignals.decodeSignals.aluOp

      val result = Mux(regReadEntry.dispatchSignals.decodePipelineSignals.decodeSignals.isAUIPC, 
        regReadEntry.dispatchSignals.decodePipelineSignals.fetchSignals.pc + regReadEntry.dispatchSignals.decodePipelineSignals.decodeSignals.imm,
        Mux(regReadEntry.dispatchSignals.decodePipelineSignals.decodeSignals.isLUI, 
          regReadEntry.dispatchSignals.decodePipelineSignals.decodeSignals.imm, 
          alu.io.result))

      exec1RegsEntry.result := result
      exec1RegsEntry.doRegFileWrite := true.B

    
    // Branch
    } .elsewhen (regReadToExec1Entry.dispatchSignals.decodePipelineSignals.decodeSignals.isBranch) {
      val regReadEntry = regReadRegs(exec1ThreadSel)
      branchUnit.io.rs1 := regReadEntry.rs1Data
      branchUnit.io.rs2 := regReadEntry.rs2Data
      branchUnit.io.pc := regReadEntry.dispatchSignals.decodePipelineSignals.fetchSignals.pc
      branchUnit.io.imm := regReadEntry.dispatchSignals.decodePipelineSignals.decodeSignals.imm.asSInt
      branchUnit.io.branchOp := regReadEntry.dispatchSignals.decodePipelineSignals.decodeSignals.funct3
      branchUnit.io.valid := true.B
      val nextPc = branchUnit.io.nextPc
      when(branchUnit.io.taken) {
        pcRegs(exec1ThreadSel) := nextPc
      } .otherwise {
        pcRegs(exec1ThreadSel) := regReadEntry.dispatchSignals.decodePipelineSignals.fetchSignals.pc + 4.U
      }
      exec1RegsEntry.result := 0.U // Branches do not produce a result to write back
      exec1RegsEntry.doRegFileWrite := false.B

      // Load
    } .elsewhen (regReadToExec1Entry.dispatchSignals.decodePipelineSignals.decodeSignals.isLoad) {
      val regReadEntry = regReadRegs(exec1ThreadSel)
      val address = regReadEntry.rs1Data + regReadEntry.dispatchSignals.decodePipelineSignals.decodeSignals.imm
      loadUnit.io.address := address
      loadUnit.io.mask := 0.U // TODO: Set appropriate mask based on load type
      loadUnit.io.loadOp := regReadEntry.dispatchSignals.decodePipelineSignals.decodeSignals.funct3
      loadUnit.io.valid := true.B
      val loadData = loadUnit.io.dataOut
      exec1RegsEntry.result := loadData
      exec1RegsEntry.doRegFileWrite := true.B

      // Store
    } .elsewhen (regReadToExec1Entry.dispatchSignals.decodePipelineSignals.decodeSignals.isStore) {
      val regReadEntry = regReadRegs(exec1ThreadSel)
      val address = regReadEntry.rs1Data + regReadEntry.dispatchSignals.decodePipelineSignals.decodeSignals.imm
      storeUnit.io.address := address
      storeUnit.io.dataOut := regReadEntry.rs2Data
      storeUnit.io.storeOp := regReadEntry.dispatchSignals.decodePipelineSignals.decodeSignals.funct3
      storeUnit.io.valid := true.B
      io.memAddr := address
      io.memWrite := regReadEntry.rs2Data 
      exec1RegsEntry.doRegFileWrite := false.B

  } 

  

  // =============================
  // Execute 2 stage (pass-through)
  // =============================

  // Thread scheduler for Execute 2 stage
  val exec2Scheduler = Module(new ThreadScheduler(numThreads = numThreads, startingThread = 3))
  
  // pipeline regs
  val exec2Regs = RegInit(VecInit(Seq.fill(numThreads) {
    val init = WireDefault(0.U.asTypeOf(new Exec2PipelineRegs(threadBits)))
    init.exec1Signals := 0.U.asTypeOf(new Exec1PipelineRegs(threadBits))
    init // return the bundle
  }))

  
  val exec2ThreadSel = exec2Scheduler.io.currentThread // Get current execute 2 thread
  val exec1ToExec2Entry = exec1Regs(exec2ThreadSel)
  when(exec1ToExec2Entry.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid && io.threadEnable(exec2ThreadSel)) {
    exec2Regs(exec2ThreadSel) := exec1ToExec2Entry
  } 


  // =============================
  // Execute 3 stage (pass-through)
  // =============================

  // Thread scheduler for Execute 3 stage
  val exec3Scheduler = Module(new ThreadScheduler(numThreads = numThreads, startingThread = 2))
  // pipeline regs
  val exec3Regs = RegInit(VecInit(Seq.fill(numThreads) {
    val init = WireDefault(0.U.asTypeOf(new Exec3PipelineRegs(threadBits)))
    init.exec2Signals := 0.U.asTypeOf(new Exec2PipelineRegs(threadBits))
    init // return the bundle
  }))

  val exec3ThreadSel = exec3Scheduler.io.currentThread // Get current execute 3 thread
  val exec2ToExec3Entry = exec2Regs(exec3ThreadSel)
  when(exec2ToExec3Entry.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid && io.threadEnable(exec3ThreadSel)) {
    exec3Regs(exec3ThreadSel) := exec2ToExec3Entry
  }



  // =============================
  // Writeback stage
  // =============================

  // Thread scheduler for Writeback stage
  val wbScheduler = Module(new ThreadScheduler(numThreads = numThreads, startingThread = 1))
  // pipeline regs
  val wbRegs = RegInit(VecInit(Seq.fill(numThreads) {
    val init = WireDefault(0.U.asTypeOf(new WritebackPipelineRegs(threadBits)))
    init.exec3Signals := 0.U.asTypeOf(new Exec3PipelineRegs(threadBits))
    init // return the bundle
  }))

  val wbThreadSel = wbScheduler.io.currentThread // Get current writeback thread
  val exec3ToWbEntry = exec3Regs(wbThreadSel)
  when(exec3ToWbEntry.exec2Signals.exec1Signals.regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid && io.threadEnable(wbThreadSel)) {
    when(exec3ToWbEntry.exec2Signals.exec1Signals.doRegFileWrite) {

      // Register File Writeback
      regFile.io.writeThreadID(0) := wbThreadSel
      regFile.io.dst(0) := wbEntry.decode.rd
      regFile.io.wen(0) := true.B
      regFile.io.dstData(0) := wbEntry.result

    // TODO: Move Branch PC update here for better timing
  }

}
