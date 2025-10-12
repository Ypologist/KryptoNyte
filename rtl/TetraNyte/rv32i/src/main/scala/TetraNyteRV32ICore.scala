package TetraNyte

import chisel3._
import chisel3.util._
import ALUs._
import BranchUnit._
import Decoders._
import LoadUnit._
import StoreUnit._
import RegFiles._

// Pipeline registers for each stage and thread
class PipelineRegBundle extends Bundle {
  val valid = Bool()
  val pc = UInt(32.W)
  val instr = UInt(32.W)
  val threadId = UInt(2.W)

  val rs1 = UInt(5.W)
  val rs2 = UInt(5.W)
  val rd = UInt(5.W)
  val imm = UInt(32.W)
  val aluOp = UInt(5.W)
  val isALU = Bool()
  val isLoad = Bool()
  val isStore = Bool()
  val isBranch = Bool()
  val rs1Data = UInt(32.W)
  val rs2Data = UInt(32.W)
  val aluResult = UInt(32.W)
  val memRdata = UInt(32.W)
}

class TetraNyteRV32ICoreIO(val numThreads: Int) extends Bundle {
  val instrMem = Input(Vec(numThreads, UInt(32.W)))
  val dataMemResp = Input(UInt(32.W))
  val memAddr = Output(UInt(32.W))
  val memWrite = Output(UInt(32.W))
  val memMask = Output(UInt(4.W))
  val memMisaligned = Output(Bool())

  val if_pc = Output(Vec(numThreads, UInt(32.W)))
  val if_instr = Output(Vec(numThreads, UInt(32.W)))
  val id_rs1Data = Output(Vec(numThreads, UInt(32.W)))
  val id_rs2Data = Output(Vec(numThreads, UInt(32.W)))
  val ex_aluResult = Output(Vec(numThreads, UInt(32.W)))
  val mem_loadData = Output(Vec(numThreads, UInt(32.W)))
}

class TetraNyteRV32ICore extends Module {
  val numThreads = 4
  val io = IO(new TetraNyteRV32ICoreIO(numThreads))

  // Per-thread PC registers
  val pcRegs = RegInit(VecInit(Seq.fill(numThreads)(0.U(32.W))))

  // Pipeline registers per thread
  val if_id = RegInit(VecInit(Seq.fill(numThreads)(0.U.asTypeOf(new PipelineRegBundle))))
  val id_ex = RegInit(VecInit(Seq.fill(numThreads)(0.U.asTypeOf(new PipelineRegBundle))))
  val ex_mem = RegInit(VecInit(Seq.fill(numThreads)(0.U.asTypeOf(new PipelineRegBundle))))
  val mem_wb = RegInit(VecInit(Seq.fill(numThreads)(0.U.asTypeOf(new PipelineRegBundle))))

  // One Register file per thread
  val regFiles = Seq.fill(numThreads)(Module(new RegFileMT2R1WVec(numThreads = 1)))

  // Default IO outputs for preventing uninitialized errors
  io.memAddr := 0.U
  io.memWrite := 0.U
  io.memMask := 0.U
  io.memMisaligned := false.B

  // Wires for forwarding paths
  val rs1DataVec = Wire(Vec(numThreads, UInt(32.W)))
  val rs2DataVec = Wire(Vec(numThreads, UInt(32.W)))
  rs1DataVec := VecInit(Seq.fill(numThreads)(0.U))
  rs2DataVec := VecInit(Seq.fill(numThreads)(0.U))

  // ===================== Instruction Fetch (IF) =====================
  for (t <- 0 until numThreads) {
    if_id(t).pc := pcRegs(t)
    if_id(t).instr := io.instrMem(t)
    if_id(t).valid := true.B
    if_id(t).threadId := t.U
    if_id(t).rs1 := io.instrMem(t)(19, 15)
    if_id(t).rs2 := io.instrMem(t)(24, 20)
    if_id(t).rd := io.instrMem(t)(11, 7)
  }

  // ===================== Instruction Decode (ID) with Forwarding =====================
  for (t <- 0 until numThreads) {
    val decodeSignals = RV32IDecode.decodeInstr(if_id(t).instr)

    id_ex(t).pc := if_id(t).pc
    id_ex(t).instr := if_id(t).instr
    id_ex(t).threadId := if_id(t).threadId
    id_ex(t).rs1 := if_id(t).rs1
    id_ex(t).rs2 := if_id(t).rs2
    id_ex(t).rd := if_id(t).rd
    id_ex(t).imm := decodeSignals.imm
    id_ex(t).aluOp := decodeSignals.aluOp
    id_ex(t).isALU := decodeSignals.isALU
    id_ex(t).isLoad := decodeSignals.isLoad
    id_ex(t).isStore := decodeSignals.isStore
    id_ex(t).isBranch := decodeSignals.isBranch

    // Read from Registers with forwarding paths
    val rf = regFiles(t)
    rf.io.threadID := 0.U // single-thread regfile per instance
    rf.io.src1 := id_ex(t).rs1
    rf.io.src2 := id_ex(t).rs2

    val rs1Raw = rf.io.src1data
    val rs2Raw = rf.io.src2data

    // Forward ALU results from EX or MEM stage
    val rs1Fwd = Wire(UInt(32.W))
    when(ex_mem(t).valid && ex_mem(t).rd =/= 0.U && ex_mem(t).rd === id_ex(t).rs1) {
      rs1Fwd := ex_mem(t).aluResult
    }.elsewhen(mem_wb(t).valid && mem_wb(t).rd =/= 0.U && mem_wb(t).rd === id_ex(t).rs1) {
      rs1Fwd := Mux(mem_wb(t).isLoad, mem_wb(t).memRdata, mem_wb(t).aluResult)
    }.otherwise {
      rs1Fwd := rs1Raw
    }

    val rs2Fwd = Wire(UInt(32.W))
    when(ex_mem(t).valid && ex_mem(t).rd =/= 0.U && ex_mem(t).rd === id_ex(t).rs2) {
      rs2Fwd := ex_mem(t).aluResult
    }.elsewhen(mem_wb(t).valid && mem_wb(t).rd =/= 0.U && mem_wb(t).rd === id_ex(t).rs2) {
      rs2Fwd := Mux(mem_wb(t).isLoad, mem_wb(t).memRdata, mem_wb(t).aluResult)
    }.otherwise {
      rs2Fwd := rs2Raw
    }

    rs1DataVec(t) := rs1Fwd
    rs2DataVec(t) := rs2Fwd

    id_ex(t).rs1Data := rs1Fwd
    id_ex(t).rs2Data := rs2Fwd
  }

  // ===================== Execute (EX) Stage =====================
  for (t <- 0 until numThreads) {
    val alu = Module(new ALU32)
    alu.io.a := id_ex(t).rs1Data
    alu.io.b := id_ex(t).rs2Data
    alu.io.opcode := id_ex(t).aluOp
    ex_mem(t).aluResult := alu.io.result
    ex_mem(t).rd := id_ex(t).rd
    ex_mem(t).isALU := id_ex(t).isALU
    ex_mem(t).isLoad := id_ex(t).isLoad
    ex_mem(t).isStore := id_ex(t).isStore
    ex_mem(t).valid := id_ex(t).valid
    ex_mem(t).rs2Data := id_ex(t).rs2Data
  }

  // ===================== Memory (MEM) Stage =====================
  for (t <- 0 until numThreads) {
    val loadUnit = Module(new LoadUnit)
    loadUnit.io.addr := ex_mem(t).aluResult
    loadUnit.io.dataIn := io.dataMemResp
    loadUnit.io.funct3 := ex_mem(t).instr(14, 12)
    val loadData = loadUnit.io.dataOut

    val storeUnit = Module(new StoreUnit)
    storeUnit.io.addr := ex_mem(t).aluResult
    storeUnit.io.data := ex_mem(t).rs2Data
    storeUnit.io.storeType := ex_mem(t).instr(13, 12)

    // Drive shared memory signals from thread 0 for illustration:
    if (t == 0) {
      io.memAddr := ex_mem(t).aluResult
      io.memWrite := storeUnit.io.memWrite
      io.memMask := storeUnit.io.mask
      io.memMisaligned := storeUnit.io.misaligned
    }

    mem_wb(t).aluResult := ex_mem(t).aluResult
    mem_wb(t).memRdata := loadData
    mem_wb(t).rd := ex_mem(t).rd
    mem_wb(t).isALU := ex_mem(t).isALU
    mem_wb(t).isLoad := ex_mem(t).isLoad
    mem_wb(t).valid := ex_mem(t).valid
  }

  // ===================== Writeback (WB) Stage =====================
  for (t <- 0 until numThreads) {
    when(mem_wb(t).valid && mem_wb(t).rd =/= 0.U) {
      regFiles(t).io.wen := true.B
      regFiles(t).io.dst1 := mem_wb(t).rd
      regFiles(t).io.dst1data := Mux(mem_wb(t).isLoad, mem_wb(t).memRdata, mem_wb(t).aluResult)
    }.otherwise {
      regFiles(t).io.wen := false.B
      regFiles(t).io.dst1 := 0.U
      regFiles(t).io.dst1data := 0.U
    }
  }

  // ===================== PC Update =====================
  for (t <- 0 until numThreads) {
    pcRegs(t) := pcRegs(t) + 4.U
  }

  // ===================== Expose Pipeline State =====================
  io.if_pc := VecInit(if_id.map(_.pc))
  io.if_instr := VecInit(if_id.map(_.instr))
  io.id_rs1Data := rs1DataVec
  io.id_rs2Data := rs2DataVec
  io.ex_aluResult := VecInit(ex_mem.map(_.aluResult))
  io.mem_loadData := VecInit(mem_wb.map(_.memRdata))

}
