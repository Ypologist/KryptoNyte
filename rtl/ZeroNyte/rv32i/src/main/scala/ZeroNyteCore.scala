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
  val r2 = Mux(dec.isALU && dec.imm =/= 0.U && dec.aluOp =/= 0.U, dec.imm, regFile(rs2))

  // ---------- ALU ----------
  val alu = Module(new ALU32)
  alu.io.a := r1
  alu.io.b := r2
  alu.io.opcode := dec.aluOp

  // ---------- Data Memory Access ----------
  io.dmem_addr := alu.io.result
  io.dmem_wdata := r2
  io.dmem_wen := dec.isStore

  // ---------- Write Back ----------
  val write_data = Mux(dec.isLoad, io.dmem_rdata, alu.io.result)
  when((dec.isALU || dec.isLoad) && rd =/= 0.U) {
    regFile(rd) := write_data
  }
  io.result := write_data

  // ---------- PC Update ----------
  pc := pc + 4.U
}