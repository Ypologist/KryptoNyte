package PipeNyte

import chisel3._
import chisel3.util._
import ALUs._
import BranchUnits._
import Decoders._
import RegisterFiles._
import LoadUnits._
import StoreUnits._

// Pipeline bundles between stages
class IF_ID_Bundle extends Bundle {
  val pc = UInt(32.W)
  val instr = UInt(32.W)
  val valid = Bool()
}

class ID_EX_Bundle extends PipelineRegBundle 
class EX_MEM_Bundle extends PipelineRegBundle
class MEM_WB_Bundle extends PipelineRegBundle

class PipeNyteTop extends Module {
  val io = IO(new Bundle {
    // Instruction/data memory interfaces
    val instrMem = Input(UInt(32.W)) 
    val dataMemResp = Input(UInt(32.W)) 
    val memWrite = Output(UInt(32.W))
    val memAddr = Output(UInt(32.W))
    val memMask = Output(UInt(4.W))
    val memMisaligned = Output(Bool())
  })

  // Program Counter
  val pcReg = RegInit(0.U(32.W))

  // IF/ID pipeline register
  val if_id = RegInit(0.U.asTypeOf(new IF_ID_Bundle))
  // ID/EX pipeline register
  val id_ex = RegInit(0.U.asTypeOf(new ID_EX_Bundle))
  // EX/MEM pipeline register
  val ex_mem = RegInit(0.U.asTypeOf(new EX_MEM_Bundle))
  // MEM/WB pipeline register
  val mem_wb = RegInit(0.U.asTypeOf(new MEM_WB_Bundle))

  // Fetch instruction
  val instr = io.instrMem

  // IF stage
  if_id.pc := pcReg
  if_id.instr := instr
  if_id.valid := true.B

  // ID stage: decode
  val decodeSignals = RV32IDecode.decodeInstr(if_id.instr)
  // Register File (multithreaded, use threadID:=0 for single)
  val regFile = Module(new RegFileMT2R1WVec())
  regFile.io.threadID := 0.U
  regFile.io.src1 := if_id.instr(19,15)
  regFile.io.src2 := if_id.instr(24,20)
  regFile.io.dst1 := if_id.instr(11,7)
  regFile.io.wen := false.B // will be true after WB
  regFile.io.dst1data := 0.U // placeholder

  id_ex.pc := if_id.pc
  id_ex.instr := if_id.instr
  id_ex.imm := decodeSignals.imm
  id_ex.aluOp := decodeSignals.aluOp
  id_ex.isALU := decodeSignals.isALU
  id_ex.isLoad := decodeSignals.isLoad
  id_ex.isStore := decodeSignals.isStore
  id_ex.isBranch := decodeSignals.isBranch
  id_ex.isJAL := decodeSignals.isJAL
  id_ex.isJALR := decodeSignals.isJALR
  id_ex.isLUI := decodeSignals.isLUI
  id_ex.isAUIPC := decodeSignals.isAUIPC
  id_ex.isFence := decodeSignals.isFence
  id_ex.isSystem := decodeSignals.isSystem
  id_ex.rs1 := if_id.instr(19,15)
  id_ex.rs2 := if_id.instr(24,20)
  id_ex.rd := if_id.instr(11,7)
  id_ex.rs1Data := regFile.io.src1data
  id_ex.rs2Data := regFile.io.src2data
  id_ex.valid := if_id.valid

  // Hazard detection: simple load-use stall
  val exIsLoad = id_ex.isLoad
  val exRd = id_ex.rd
  val idRs1 = id_ex.rs1
  val idRs2 = id_ex.rs2
  val stall = exIsLoad && ((exRd =/= 0.U) && ((exRd === idRs1) || (exRd === idRs2)))

  // ALU
  val alu = Module(new ALU32)
  alu.io.a := id_ex.rs1Data
  alu.io.b := id_ex.rs2Data
  alu.io.opcode := id_ex.aluOp
  ex_mem.aluResult := alu.io.result

  // Branch
  val branch = Module(new BranchUnit)
  branch.io.rs1 := id_ex.rs1Data
  branch.io.rs2 := id_ex.rs2Data
  branch.io.pc := id_ex.pc
  branch.io.imm := id_ex.imm.asSInt
  branch.io.branchOp := id_ex.aluOp(2,0)
  branch.io.valid := id_ex.isBranch

  ex_mem.pc := id_ex.pc
  ex_mem.instr := id_ex.instr
  ex_mem.valid := id_ex.valid
  ex_mem.isALU := id_ex.isALU
  ex_mem.isLoad := id_ex.isLoad
  ex_mem.isStore := id_ex.isStore
  ex_mem.isBranch := id_ex.isBranch
  ex_mem.aluResult := alu.io.result
  ex_mem.rd := id_ex.rd
  ex_mem.memAddr := alu.io.result // ALU result used as address
  ex_mem.rs2Data := id_ex.rs2Data

  // Load and Store Units
  val loadUnit = Module(new LoadUnit)
  loadUnit.io.addr := ex_mem.memAddr
  loadUnit.io.dataIn := io.dataMemResp
  loadUnit.io.funct3 := ex_mem.instr(14,12)
  val loadResult = loadUnit.io.dataOut

  val storeUnit = Module(new StoreUnit)
  storeUnit.io.addr := ex_mem.memAddr
  storeUnit.io.data := ex_mem.rs2Data
  storeUnit.io.storeType := ex_mem.instr(13,12)
  io.memWrite := storeUnit.io.memWrite
  io.memAddr := ex_mem.memAddr
  io.memMask := storeUnit.io.mask
  io.memMisaligned := storeUnit.io.misaligned

  // MEM/WB register
  mem_wb.pc := ex_mem.pc
  mem_wb.instr := ex_mem.instr
  mem_wb.valid := ex_mem.valid
  mem_wb.isALU := ex_mem.isALU
  mem_wb.isLoad := ex_mem.isLoad
  mem_wb.aluResult := ex_mem.aluResult
  mem_wb.rd := ex_mem.rd
  mem_wb.rs2Data := ex_mem.rs2Data
  mem_wb.memRdata := loadResult

  // Writeback to register file (WB)
  val wbData = Mux(mem_wb.isLoad, mem_wb.memRdata, mem_wb.aluResult)
  regFile.io.wen := mem_wb.valid && (mem_wb.rd =/= 0.U)
  regFile.io.dst1 := mem_wb.rd
  regFile.io.dst1data := wbData

  // Pipeline update logic
  when (stall) {
    // Stall pipeline, insert bubble in ID/EX, PC stalls
    id_ex := id_ex
    if_id := if_id
  } .otherwise {
    if_id := if_id // next instruction
    id_ex := id_ex
    ex_mem := ex_mem
    mem_wb := mem_wb
    pcReg := Mux(branch.io.taken, branch.io.target, pcReg + 4.U)
  }
}
