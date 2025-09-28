package ZeroNyte

import chisel3._
import chisel3.util._
import Decoders.RV32IDecode
import ALUs.ALU32


class ZeroNyteRV32ICore extends Module {
  val io = IO(new Bundle {
    val pc_out    = Output(UInt(32.W))
    val instr_out = Output(UInt(32.W))
    val result    = Output(UInt(32.W))
  })

  // ---------- Program Counter ----------
  val pc = RegInit(0.U(32.W))
  io.pc_out := pc

  // ---------- Instruction Memory ----------
  val initInstrs = VecInit(
    0x00000013.U(32.W), // NOP
    0x00100093.U(32.W), // ADDI
    0x00208133.U(32.W)  // ADD
  )
  //val instr = initInstrs(pc >> 2)
  val instr = initInstrs(pc(log2Ceil(initInstrs.length) + 1, 2))
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

  // ---------- Write Back ----------
  when(dec.isALU && rd =/= 0.U) {
    regFile(rd) := alu.io.result
  }
  io.result := alu.io.result

  // ---------- PC Update ----------
  pc := pc + 4.U
}