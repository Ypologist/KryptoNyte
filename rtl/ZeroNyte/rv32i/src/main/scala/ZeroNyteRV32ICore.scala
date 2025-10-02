package ZeroNyte

import chisel3._
import chisel3.util._
import Decoders.RV32IDecode
import ALUs.ALU32


class ZeroNyteRV32ICore extends Module {
  val io = IO(new Bundle {
    // Instruction Memory Interface
    val imem_addr = Output(UInt(32.W))
    val imem_rdata = Input(UInt(32.W))

    // Data Memory Interface
    val dmem_addr = Output(UInt(32.W))
    val dmem_rdata = Input(UInt(32.W))
    val dmem_wdata = Output(UInt(32.W))
    val dmem_wen = Output(Bool())

    // Debug Outputs
    val pc_out    = Output(UInt(32.W))
    val instr_out = Output(UInt(32.W))
    val result    = Output(UInt(32.W))
  })

  // ---------- Program Counter ----------
  val pc = RegInit("h80000000".U(32.W))  // Start at RISC-V reset vector
  io.pc_out := pc

  // ---------- Instruction Memory ----------
  io.imem_addr := pc
  val instr = io.imem_rdata
  io.instr_out := instr

  // ---------- Register File ----------
  val regFile = RegInit(VecInit(Seq.fill(32)(0.U(32.W))))

  // ---------- Decode ----------
  val dec = RV32IDecode.decodeInstr(instr)
  val rd  = instr(11,7)
  val rs1 = instr(19,15)
  val rs2 = instr(24,20)

  val r1 = regFile(rs1)
  val r2Reg = regFile(rs2)
  val useImmForB = (instr(6,0) === RV32IDecode.OP_I) || dec.isLoad || dec.isStore || dec.isJALR || dec.isLUI || dec.isAUIPC
  val operandB = Mux(useImmForB, dec.imm, r2Reg)
  val operandA = Mux(dec.isLUI, 0.U, r1)

  // ---------- ALU ----------
  val alu = Module(new ALU32)
  alu.io.a := operandA
  alu.io.b := operandB
  alu.io.opcode := dec.aluOp

  // ---------- Data Memory Access ----------
  io.dmem_addr := alu.io.result
  io.dmem_wdata := r2Reg
  io.dmem_wen := dec.isStore

  // ---------- Write Back ----------
  val pcPlus4 = pc + 4.U
  val auipcValue = pc + dec.imm
  val jalrTarget = ((r1.asSInt + dec.imm.asSInt).asUInt) & ~1.U(32.W)

  val write_data = Wire(UInt(32.W))
  val doWrite = Wire(Bool())
  write_data := alu.io.result
  doWrite := dec.isALU

  when(dec.isLoad) {
    write_data := io.dmem_rdata
    doWrite := true.B
  }

  when(dec.isLUI) {
    write_data := dec.imm
    doWrite := true.B
  }

  when(dec.isAUIPC) {
    write_data := auipcValue
    doWrite := true.B
  }

  when(dec.isJAL || dec.isJALR) {
    write_data := pcPlus4
    doWrite := true.B
  }

  when(doWrite && rd =/= 0.U) {
    regFile(rd) := write_data
  }
  io.result := write_data

  // ---------- PC Update ----------
  val branchEq  = r1 === r2Reg
  val branchLT  = r1.asSInt < r2Reg.asSInt
  val branchLTU = r1 < r2Reg

  val branchTaken = WireDefault(false.B)
  when(dec.isBranch) {
    switch(instr(14,12)) {
      is("b000".U) { branchTaken := branchEq }         // BEQ
      is("b001".U) { branchTaken := !branchEq }        // BNE
      is("b100".U) { branchTaken := branchLT }         // BLT
      is("b101".U) { branchTaken := !branchLT }        // BGE
      is("b110".U) { branchTaken := branchLTU }        // BLTU
      is("b111".U) { branchTaken := !branchLTU }       // BGEU
    }
  }

  val branchOffset = (dec.imm.asSInt << 1).asUInt
  val branchTarget = (pc.asSInt + branchOffset.asSInt).asUInt
  val jalTarget = (pc.asSInt + dec.imm.asSInt).asUInt

  val nextPC = WireDefault(pcPlus4)
  when(dec.isBranch && branchTaken) {
    nextPC := branchTarget
  }
  when(dec.isJAL) {
    nextPC := jalTarget
  }
  when(dec.isJALR) {
    nextPC := jalrTarget
  }

  pc := nextPC
}
