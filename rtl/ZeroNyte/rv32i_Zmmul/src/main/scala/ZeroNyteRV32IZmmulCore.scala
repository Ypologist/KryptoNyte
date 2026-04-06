package ZeroNyte

import chisel3._
import chisel3.util._
import chisel3.dontTouch
import Decoders.RV32IDecode
import ALUs.{ALU32, Mul32OneCycle}
import StoreUnit._
import TileLink._


class ZeroNyteRV32IZmmulCore(val cosimulate: Boolean = false) extends Module {
  val io = IO(new Bundle {
    // Instruction Memory Interface
    val imem_addr = Output(UInt(32.W))
    val imem_rdata = Input(UInt(32.W))

    // Data Memory Interface
    val dmem_addr = Output(UInt(32.W))
    val dmem_rdata = Input(UInt(32.W))
    val dmem_wdata = Output(UInt(32.W))
    val dmem_wmask = Output(UInt(4.W))
    val dmem_wen = Output(Bool())

    // TileLink master port for data memory (optional; legacy path still works)
    val tl = new TLBundleUL(TLParams())

     // Interrupt controller interface.
    val irqSources = Input(UInt(8.W))
    val irqEnableMask = Input(UInt(8.W))
    val irqComplete = Input(Bool())
    val interruptVector = Input(UInt(32.W))
    val interruptTaken = Output(Bool())
    val irqPending = Output(UInt(8.W))
    val irqClaimId = Output(UInt(4.W))
   
    // Debug Outputs
    val pc_out    = Output(UInt((if(cosimulate) 32 else 0).W))
    val instr_out = Output(UInt((if(cosimulate) 32 else 0).W))
    val result    = Output(UInt((if(cosimulate) 32 else 0).W))

    // JTAG Interface
    val jtag_tck    = Input(UInt((if(!cosimulate) 1 else 0).W))
    val jtag_tms    = Input(UInt((if(!cosimulate) 1 else 0).W))
    val jtag_tdi    = Input(UInt((if(!cosimulate) 1 else 0).W))
    val jtag_tdo    = Output(UInt((if(!cosimulate) 1 else 0).W))
    val jtag_trst_n = Input(UInt((if(!cosimulate) 1 else 0).W))
  })

  io.jtag_tdo := 0.U

  // ---------- Program Counter ----------
  val pc = RegInit("h80000000".U(32.W))  // Start at RISC-V reset vector
  io.pc_out := pc

  // ---------- Instruction Memory ----------
  io.imem_addr := pc
  val instr = io.imem_rdata
  io.instr_out := instr

  // ---------- Register File ----------
  val regFile = Module(new RegFiles.RegFile2R1WMem(width = 32, depth = 32))
  regFile.io.readThreadID := 0.U
  regFile.io.writeThreadID := 0.U

  // ---------- Decode ----------
  val dec = RV32IDecode.decodeInstr(instr)
  val rd  = instr(11,7)
  val rs1 = instr(19,15)
  val rs2 = instr(24,20)
  val funct3 = instr(14, 12)

  regFile.io.readAddrs(0) := rs1
  regFile.io.readAddrs(1) := rs2

  val r1 = regFile.io.readData(0)
  val r2Reg = regFile.io.readData(1)
  val useImmForB = (instr(6,0) === RV32IDecode.OP_I) || dec.isLoad || dec.isStore || dec.isJALR || dec.isLUI || dec.isAUIPC
  val operandB = Mux(useImmForB, dec.imm, r2Reg)
  val operandA = Mux(dec.isLUI, 0.U, r1)

  // ---------- ALU ----------
  val alu = Module(new ALU32)
  alu.io.a := operandA
  alu.io.b := operandB
  alu.io.opcode := dec.aluOp

  // ---------- M Extension (Mul Only) ----------
  val isMExt = (instr(6,0) === RV32IDecode.OP_R) && (instr(31,25) === "b0000001".U)
  val isMulInstr = isMExt && (funct3 <= "b011".U)

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
  val mulProductSink = Wire(UInt(64.W))
  mulProductSink := mulUnit.io.product
  dontTouch(mulProductSink)

  val mulResult = MuxLookup(funct3, mulUnit.io.lo)(Seq(
    "b000".U -> mulUnit.io.lo, // MUL
    "b001".U -> mulUnit.io.hi, // MULH
    "b010".U -> mulUnit.io.hi, // MULHSU
    "b011".U -> mulUnit.io.hi  // MULHU
  ))

  val memPort = Module(new ZeroNyteMemPort())
  // ---------- Data Memory Access ----------
  val effAddr    = alu.io.result
  val addrBase   = Cat(effAddr(31, 2), 0.U(2.W))
  val storeFunct3 = instr(14, 12)

  val storeUnit = Module(new StoreUnit)
  storeUnit.io.addr := effAddr
  storeUnit.io.data := r2Reg
  storeUnit.io.storeType := storeFunct3(1, 0)
  
  val unusedStoreMisaligned = WireDefault(storeUnit.io.misaligned)
  dontTouch(unusedStoreMisaligned)

  // Legacy outputs still exposed for compatibility.
  memPort.io.legacy.valid := dec.isLoad || dec.isStore
  memPort.io.legacy.addr := addrBase
  memPort.io.legacy.writeData := storeUnit.io.memWrite
  memPort.io.legacy.writeMask := Mux(dec.isStore, storeUnit.io.mask, 0.U)

  val unusedReadData = WireDefault(memPort.io.legacy.readData)
  dontTouch(unusedReadData)

  memPort.io.passthroughMem.readData := io.dmem_rdata
  io.dmem_addr := memPort.io.passthroughMem.addr
  io.dmem_wdata := memPort.io.passthroughMem.writeData
  io.dmem_wmask := memPort.io.passthroughMem.writeMask
  
  io.dmem_wen := dec.isStore
  io.tl <> memPort.io.tl

  // ---------- Write Back ----------
  val pcPlus4 = pc + 4.U
  val auipcValue = pc + dec.imm
  val jalrTarget = ((r1.asSInt + dec.imm.asSInt).asUInt) & ~1.U(32.W)

  val write_data = Wire(UInt(32.W))
  val doWrite = Wire(Bool())
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
    val byteOffset = alu.io.result(1, 0)
    val halfOffset = alu.io.result(1)
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

  regFile.io.writeAddrs(0) := rd
  regFile.io.writeData(0) := write_data
  regFile.io.wens(0) := doWrite && rd =/= 0.U
  io.result := write_data

    // ---------- Interrupt Controller ----------
  val interruptController = Module(new ZeroNyteInterruptController(8))
  interruptController.io.irqSources := io.irqSources
  interruptController.io.enableMask := io.irqEnableMask
  interruptController.io.complete := io.irqComplete
  io.irqPending := interruptController.io.pending
  io.irqClaimId := interruptController.io.claimId


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
  val stall = false.B
  val interruptTaken = interruptController.io.hasInterrupt && !stall
  io.interruptTaken := interruptTaken

  when(dec.isBranch && branchTaken) {
    nextPC := branchTarget
  }
  when(dec.isJAL) {
    nextPC := jalTarget
  }
  when(dec.isJALR) {
    nextPC := jalrTarget
  }
  when(stall) {
    nextPC := pc
  }
  when(interruptTaken) {
    nextPC := io.interruptVector
 }
  pc := nextPC
}
