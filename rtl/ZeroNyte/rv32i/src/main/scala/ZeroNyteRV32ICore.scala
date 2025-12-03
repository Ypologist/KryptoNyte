package ZeroNyte

import chisel3._
import chisel3.util._
import Decoders.RV32IDecode
import ALUs.{ALU32, Div32Radix4, Mul32OneCycle}


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
  val funct3 = instr(14, 12)

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

  // ---------- M Extension (Mul/Div) ----------
  val isMExt = (instr(6,0) === RV32IDecode.OP_R) && (instr(31,25) === "b0000001".U)
  val isMulInstr = isMExt && (funct3 <= "b011".U)
  val isDivInstr = isMExt && (funct3 >= "b100".U)

  val mulUnit = Module(new Mul32OneCycle)
  val mulSignedA = WireDefault(true.B)
  val mulSignedB = WireDefault(true.B)
  when(funct3 === "b011".U) { // MULHU
    mulSignedA := false.B; mulSignedB := false.B
  }.elsewhen(funct3 === "b010".U) { // MULHSU
    mulSignedA := true.B; mulSignedB := false.B
  }
  mulUnit.io.a := r1
  mulUnit.io.b := r2Reg
  mulUnit.io.signedA := mulSignedA
  mulUnit.io.signedB := mulSignedB

  val mulResult = MuxLookup(funct3, mulUnit.io.lo)(Seq(
    "b000".U -> mulUnit.io.lo, // MUL
    "b001".U -> mulUnit.io.hi, // MULH
    "b010".U -> mulUnit.io.hi, // MULHSU
    "b011".U -> mulUnit.io.hi  // MULHU
  ))

  val divider = Module(new Div32Radix4)
  val divActive = RegInit(false.B)
  val divRd = Reg(UInt(5.W))
  val divFunct3 = Reg(UInt(3.W))
  val divDividend = Reg(UInt(32.W))
  val divDivisor = Reg(UInt(32.W))

  val divSigned = Mux(divActive, divFunct3 === "b100".U || divFunct3 === "b110".U,
    isDivInstr && (funct3 === "b100".U || funct3 === "b110".U))
  divider.io.signed := divSigned
  divider.io.dividend := Mux(divActive, divDividend, r1)
  divider.io.divisor := Mux(divActive, divDivisor, r2Reg)
  divider.io.start := false.B

  when(!divActive && isDivInstr) {
    divider.io.start := true.B
    divActive := true.B
    divRd := rd
    divFunct3 := funct3
    divDividend := r1
    divDivisor := r2Reg
  }.elsewhen(divActive && divider.io.done) {
    divActive := false.B
  }

  val divResult = Mux(divFunct3 === "b100".U || divFunct3 === "b101".U,
    divider.io.quotient,
    divider.io.remainder)
  val divDone = divActive && divider.io.done

  // ---------- Data Memory Access ----------
  val effAddr    = alu.io.result
  val addrBase   = Cat(effAddr(31, 2), 0.U(2.W))
  val byteOffset = effAddr(1, 0)
  val halfOffset = effAddr(1)
  val storeFunct3 = instr(14, 12)

  val dmemReadWord = io.dmem_rdata

  val storeData = WireDefault(r2Reg)
  when(dec.isStore) {
    switch(storeFunct3) {
      is("b000".U) { // SB
        val byteVal = r2Reg(7, 0)
        val byteMask = (0xff.U(32.W)) << (byteOffset << 3)
        val byteShifted = (byteVal & 0xff.U) << (byteOffset << 3)
        storeData := (dmemReadWord & ~byteMask) | byteShifted
      }
      is("b001".U) { // SH
        val halfVal = r2Reg(15, 0)
        val halfMask = (0xffff.U(32.W)) << (halfOffset << 4)
        val halfShifted = (halfVal & 0xffff.U) << (halfOffset << 4)
        storeData := (dmemReadWord & ~halfMask) | halfShifted
      }
      is("b010".U) { // SW
        storeData := r2Reg
      }
    }
  }

  io.dmem_addr := addrBase
  io.dmem_wdata := storeData
  io.dmem_wen := dec.isStore

  // ---------- Write Back ----------
  val pcPlus4 = pc + 4.U
  val auipcValue = pc + dec.imm
  val jalrTarget = ((r1.asSInt + dec.imm.asSInt).asUInt) & ~1.U(32.W)

  val write_data = Wire(UInt(32.W))
  val doWrite = Wire(Bool())
  val targetRd = WireDefault(rd)
  write_data := alu.io.result
  doWrite := dec.isALU

  when(dec.isLoad) {
    val loadWord = io.dmem_rdata
    val byteVec = VecInit(
      loadWord(7, 0),
      loadWord(15, 8),
      loadWord(23, 16),
      loadWord(31, 24)
    )
    val halfVec = VecInit(
      loadWord(15, 0),
      loadWord(31, 16)
    )
    val shiftedByte = byteVec(byteOffset)
    val shiftedHalf = halfVec(halfOffset)
    val loadFunct3 = instr(14, 12)

    write_data := loadWord
    doWrite := true.B

    switch(loadFunct3) {
      is("b000".U) { // LB
        write_data := Cat(Fill(24, shiftedByte(7)), shiftedByte)
      }
      is("b001".U) { // LH
        write_data := Cat(Fill(16, shiftedHalf(15)), shiftedHalf)
      }
      is("b010".U) { // LW
        write_data := loadWord
      }
      is("b100".U) { // LBU
        write_data := Cat(0.U(24.W), shiftedByte)
      }
      is("b101".U) { // LHU
        write_data := Cat(0.U(16.W), shiftedHalf)
      }
    }
  }

  when(isMulInstr) {
    write_data := mulResult
    doWrite := true.B
  }

  when(isDivInstr) {
    doWrite := false.B
    when(divDone) {
      write_data := divResult
      doWrite := true.B
      targetRd := divRd
    }
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

  when(doWrite && targetRd =/= 0.U) {
    regFile(targetRd) := write_data
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
  val divStall = divActive && !divider.io.done
  when(dec.isBranch && branchTaken) {
    nextPC := branchTarget
  }
  when(dec.isJAL) {
    nextPC := jalTarget
  }
  when(dec.isJALR) {
    nextPC := jalrTarget
  }
  when(divStall) {
    nextPC := pc
  }

  pc := nextPC
}
