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
  val isJAL = Bool()
  val isJALR = Bool()
  val isLUI = Bool()
  val isAUIPC = Bool()
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
  val pcRegs = RegInit(VecInit(Seq.fill(numThreads)("h80000000".U(32.W))))

  // Pipeline registers per thread
  val if_id = RegInit(VecInit(Seq.fill(numThreads)(0.U.asTypeOf(new PipelineRegBundle))))
  val id_ex = RegInit(VecInit(Seq.fill(numThreads)(0.U.asTypeOf(new PipelineRegBundle))))
  val ex_mem = RegInit(VecInit(Seq.fill(numThreads)(0.U.asTypeOf(new PipelineRegBundle))))
  val mem_wb = RegInit(VecInit(Seq.fill(numThreads)(0.U.asTypeOf(new PipelineRegBundle))))

  val flushThread = Wire(Vec(numThreads, Bool()))
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
    if_id(t).valid := !flushThread(t)
    if_id(t).threadId := t.U
    if_id(t).rs1 := io.instrMem(t)(19, 15)
    if_id(t).rs2 := io.instrMem(t)(24, 20)
    if_id(t).rd := io.instrMem(t)(11, 7)
  }

  // ===================== Instruction Decode (ID) with Forwarding =====================
  for (t <- 0 until numThreads) {
    val decodeSignals = RV32IDecode.decodeInstr(if_id(t).instr)
    val rs1 = if_id(t).rs1
    val rs2 = if_id(t).rs2

    id_ex(t).pc := if_id(t).pc
    id_ex(t).instr := if_id(t).instr
    id_ex(t).threadId := if_id(t).threadId
    id_ex(t).valid := Mux(flushThread(t), false.B, if_id(t).valid)
    id_ex(t).rs1 := rs1
    id_ex(t).rs2 := rs2
    id_ex(t).rd := if_id(t).rd
    id_ex(t).imm := decodeSignals.imm
    id_ex(t).aluOp := decodeSignals.aluOp
    id_ex(t).isALU := decodeSignals.isALU
    id_ex(t).isLoad := decodeSignals.isLoad
    id_ex(t).isStore := decodeSignals.isStore
    id_ex(t).isBranch := decodeSignals.isBranch
    id_ex(t).isJAL := decodeSignals.isJAL
    id_ex(t).isJALR := decodeSignals.isJALR
    id_ex(t).isLUI := decodeSignals.isLUI
    id_ex(t).isAUIPC := decodeSignals.isAUIPC

    // Read from Registers with forwarding paths
    val rf = regFiles(t)
    rf.io.threadID := 0.U // single-thread regfile per instance
    rf.io.src1 := rs1
    rf.io.src2 := rs2

    val rs1Raw = rf.io.src1data
    val rs2Raw = rf.io.src2data

    // Forward ALU results from EX or MEM stage
    val rs1Fwd = Wire(UInt(32.W))
    when(ex_mem(t).valid && ex_mem(t).rd =/= 0.U && ex_mem(t).rd === rs1) {
      rs1Fwd := ex_mem(t).aluResult
    }.elsewhen(mem_wb(t).valid && mem_wb(t).rd =/= 0.U && mem_wb(t).rd === rs1) {
      rs1Fwd := Mux(mem_wb(t).isLoad, mem_wb(t).memRdata, mem_wb(t).aluResult)
    }.otherwise {
      rs1Fwd := rs1Raw
    }

    val rs2Fwd = Wire(UInt(32.W))
    when(ex_mem(t).valid && ex_mem(t).rd =/= 0.U && ex_mem(t).rd === rs2) {
      rs2Fwd := ex_mem(t).aluResult
    }.elsewhen(mem_wb(t).valid && mem_wb(t).rd =/= 0.U && mem_wb(t).rd === rs2) {
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
    val instr = id_ex(t).instr
    val opcode = instr(6, 0)
    val operandA = WireDefault(id_ex(t).rs1Data)
    val operandB = WireDefault(id_ex(t).rs2Data)

    when(opcode === RV32IDecode.OP_I || opcode === RV32IDecode.LOAD || opcode === RV32IDecode.STORE || opcode === RV32IDecode.JALR) {
      operandB := id_ex(t).imm
    }
    when(opcode === RV32IDecode.LOAD || opcode === RV32IDecode.STORE || opcode === RV32IDecode.JALR) {
      operandA := id_ex(t).rs1Data
    }
    when(opcode === RV32IDecode.LUI) {
      operandA := 0.U
      operandB := id_ex(t).imm
    }
    when(opcode === RV32IDecode.AUIPC) {
      operandA := id_ex(t).pc
      operandB := id_ex(t).imm
    }

    alu.io.a := operandA
    alu.io.b := operandB
    alu.io.opcode := id_ex(t).aluOp
    ex_mem(t).aluResult := alu.io.result
    ex_mem(t).instr := id_ex(t).instr
    ex_mem(t).rd := id_ex(t).rd
    ex_mem(t).isALU := id_ex(t).isALU
    ex_mem(t).isLoad := id_ex(t).isLoad
    ex_mem(t).isStore := id_ex(t).isStore
    ex_mem(t).isBranch := id_ex(t).isBranch
    ex_mem(t).isJAL := id_ex(t).isJAL
    ex_mem(t).isJALR := id_ex(t).isJALR
    ex_mem(t).isLUI := id_ex(t).isLUI
    ex_mem(t).isAUIPC := id_ex(t).isAUIPC
    ex_mem(t).valid := Mux(flushThread(t), false.B, id_ex(t).valid)
    ex_mem(t).rs1Data := id_ex(t).rs1Data
    ex_mem(t).rs2Data := id_ex(t).rs2Data
    ex_mem(t).pc := id_ex(t).pc
    ex_mem(t).imm := id_ex(t).imm
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
    storeUnit.io.storeType := ex_mem(t).instr(14, 12)

    // Drive shared memory signals from thread 0 for illustration:
    val addrBase = Cat(ex_mem(t).aluResult(31, 2), 0.U(2.W))
    if (t == 0) {
      io.memAddr := addrBase
      io.memWrite := Mux(ex_mem(t).isStore && !storeUnit.io.misaligned, storeUnit.io.memWrite, 0.U)
      io.memMask := Mux(ex_mem(t).isStore && !storeUnit.io.misaligned, storeUnit.io.mask, 0.U)
      io.memMisaligned := storeUnit.io.misaligned
    }

    mem_wb(t).aluResult := ex_mem(t).aluResult
    mem_wb(t).memRdata := loadData
    mem_wb(t).instr := ex_mem(t).instr
    mem_wb(t).rd := ex_mem(t).rd
    mem_wb(t).isALU := ex_mem(t).isALU
    mem_wb(t).isLoad := ex_mem(t).isLoad
    mem_wb(t).isStore := ex_mem(t).isStore
    mem_wb(t).isBranch := ex_mem(t).isBranch
    mem_wb(t).isJAL := ex_mem(t).isJAL
    mem_wb(t).isJALR := ex_mem(t).isJALR
    mem_wb(t).isLUI := ex_mem(t).isLUI
    mem_wb(t).isAUIPC := ex_mem(t).isAUIPC
    mem_wb(t).valid := ex_mem(t).valid
    mem_wb(t).pc := ex_mem(t).pc
    mem_wb(t).imm := ex_mem(t).imm
    mem_wb(t).rs1Data := ex_mem(t).rs1Data
    mem_wb(t).rs2Data := ex_mem(t).rs2Data
  }

  // ===================== Writeback (WB) Stage =====================
  for (t <- 0 until numThreads) {
    val pcPlus4 = mem_wb(t).pc + 4.U
    val auipcValue = mem_wb(t).pc + mem_wb(t).imm
    val wbData = Wire(UInt(32.W))
    wbData := mem_wb(t).aluResult
    when(mem_wb(t).isLoad) {
      wbData := mem_wb(t).memRdata
    }.elsewhen(mem_wb(t).isLUI) {
      wbData := mem_wb(t).imm
    }.elsewhen(mem_wb(t).isAUIPC) {
      wbData := auipcValue
    }.elsewhen(mem_wb(t).isJAL || mem_wb(t).isJALR) {
      wbData := pcPlus4
    }

    val writeEnable = mem_wb(t).valid && mem_wb(t).rd =/= 0.U &&
      (mem_wb(t).isALU || mem_wb(t).isLoad || mem_wb(t).isLUI ||
        mem_wb(t).isAUIPC || mem_wb(t).isJAL || mem_wb(t).isJALR)

    regFiles(t).io.wen := writeEnable
    regFiles(t).io.dst1 := Mux(writeEnable, mem_wb(t).rd, 0.U)
    regFiles(t).io.dst1data := wbData

  }

  // ===================== PC Update =====================
  for (t <- 0 until numThreads) {
    val pcPlus4 = pcRegs(t) + 4.U
    val branchOffset = (mem_wb(t).imm.asSInt << 1).asUInt
    val branchTarget = (mem_wb(t).pc.asSInt + branchOffset.asSInt).asUInt
    val jalTarget = (mem_wb(t).pc.asSInt + mem_wb(t).imm.asSInt).asUInt
    val jalrTarget = ((mem_wb(t).rs1Data.asSInt + mem_wb(t).imm.asSInt).asUInt & ~1.U(32.W))

    val rs1 = mem_wb(t).rs1Data
    val rs2 = mem_wb(t).rs2Data
    val funct3 = mem_wb(t).instr(14, 12)

    val branchEq = rs1 === rs2
    val branchLT = rs1.asSInt < rs2.asSInt
    val branchLTU = rs1 < rs2

    val branchCond = WireDefault(false.B)
    switch(funct3) {
      is("b000".U) { branchCond := branchEq }
      is("b001".U) { branchCond := !branchEq }
      is("b100".U) { branchCond := branchLT }
      is("b101".U) { branchCond := !branchLT }
      is("b110".U) { branchCond := branchLTU }
      is("b111".U) { branchCond := !branchLTU }
    }
    val branchTaken = mem_wb(t).isBranch && branchCond
    val jalTaken = mem_wb(t).isJAL
    val jalrTaken = mem_wb(t).isJALR

    val nextPC = WireDefault(pcPlus4)
    when(mem_wb(t).valid) {
      when(branchTaken) {
        nextPC := branchTarget
      }.elsewhen(jalTaken) {
        nextPC := jalTarget
      }.elsewhen(jalrTaken) {
        nextPC := jalrTarget
      }
    }

    pcRegs(t) := nextPC
    flushThread(t) := mem_wb(t).valid && (branchTaken || jalTaken || jalrTaken)
  }

  // ===================== Expose Pipeline State =====================
  io.if_pc := pcRegs
  io.if_instr := VecInit(if_id.map(_.instr))
  io.id_rs1Data := rs1DataVec
  io.id_rs2Data := rs2DataVec
  io.ex_aluResult := VecInit(ex_mem.map(_.aluResult))
  io.mem_loadData := VecInit(mem_wb.map(_.memRdata))

}
