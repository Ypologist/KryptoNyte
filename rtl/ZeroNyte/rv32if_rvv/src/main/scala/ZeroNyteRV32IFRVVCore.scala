package ZeroNyte

import chisel3._
import chisel3.util._
import ALUs.{ALU32, Float32ALUPipelined, Float32Ops, Mul32Pipelined}
import BranchUnit.BranchUnit
import Decoders.RV32IDecode
import LoadUnit.LoadUnit
import RegFiles.RegFile2R1WMem
import StoreUnit.StoreUnit

object ZeroNyteExtensionClass {
  val width = 4

  val none = 0.U(width.W)
  val rvvOp = 1.U(width.W)
  val rvvLoad = 2.U(width.W)
  val rvvStore = 3.U(width.W)
  val matrix = 4.U(width.W)
  val tensor = 5.U(width.W)
  val custom = 15.U(width.W)
}

class ZeroNyteExtensionIssue extends Bundle {
  val pc = UInt(32.W)
  val instr = UInt(32.W)
  val opClass = UInt(ZeroNyteExtensionClass.width.W)
  val rd = UInt(5.W)
  val rs1 = UInt(5.W)
  val rs2 = UInt(5.W)
  val rs3 = UInt(5.W)
  val funct3 = UInt(3.W)
  val funct7 = UInt(7.W)
  val scalarRs1 = UInt(32.W)
  val scalarRs2 = UInt(32.W)
  val imm = UInt(32.W)
  val vl = UInt(32.W)
  val vtype = UInt(32.W)
  val vstart = UInt(32.W)
  val vxrm = UInt(2.W)
  val vxsat = Bool()
  val isMemory = Bool()
  val isStore = Bool()
  val memWidth = UInt(3.W)
  val memMode = UInt(2.W)
  val memMasked = Bool()
  val memSegments = UInt(3.W)
}

class ZeroNyteExtensionCompletion extends Bundle {
  val fault = Bool()
  val cause = UInt(8.W)
  val writeRd = Bool()
  val rd = UInt(5.W)
  val rdData = UInt(32.W)
  val writeVl = Bool()
  val vl = UInt(32.W)
  val writeVtype = Bool()
  val vtype = UInt(32.W)
  val writeVstart = Bool()
  val vstart = UInt(32.W)
  val writeVxsat = Bool()
  val vxsat = Bool()
}

class ZeroNyteRV32IFRVVCoreIO(val cosimulate: Boolean = false) extends Bundle {
  val imem_addr = Output(UInt(32.W))
  val imem_rdata = Input(UInt(32.W))

  val dmem_addr = Output(UInt(32.W))
  val dmem_rdata = Input(UInt(32.W))
  val dmem_wdata = Output(UInt(32.W))
  val dmem_wmask = Output(UInt(4.W))
  val dmem_valid = Output(Bool())
  val dmem_misaligned = Output(Bool())

  val extIssue = Decoupled(new ZeroNyteExtensionIssue)
  val extComplete = Flipped(Decoupled(new ZeroNyteExtensionCompletion))

  val interruptVector = Input(UInt(32.W))
  val interruptPending = Input(Bool())
  val interruptTaken = Output(Bool())

  val pc_out = Output(UInt((if (cosimulate) 32 else 0).W))
  val instr_out = Output(UInt((if (cosimulate) 32 else 0).W))
  val result = Output(UInt((if (cosimulate) 32 else 0).W))
  val trap_valid = Output(UInt((if (cosimulate) 1 else 0).W))
  val trap_cause = Output(UInt((if (cosimulate) 8 else 0).W))
  val ext_pending = Output(UInt((if (cosimulate) 1 else 0).W))
  val stall_reason = Output(UInt((if (cosimulate) 8 else 0).W))

  val jtag_tck = Input(UInt((if (!cosimulate) 1 else 0).W))
  val jtag_tms = Input(UInt((if (!cosimulate) 1 else 0).W))
  val jtag_tdi = Input(UInt((if (!cosimulate) 1 else 0).W))
  val jtag_tdo = Output(UInt((if (!cosimulate) 1 else 0).W))
  val jtag_trst_n = Input(UInt((if (!cosimulate) 1 else 0).W))
}

class ZeroNyteIFRVVFetchRegs extends Bundle {
  val valid = Bool()
  val pc = UInt(32.W)
  val instr = UInt(32.W)
}

class ZeroNyteIFRVVDecodeRegs extends Bundle {
  val valid = Bool()
  val pc = UInt(32.W)
  val instr = UInt(32.W)
  val dec = new RV32IDecode.DecodeSignals
  val isExt = Bool()
  val isFpLoad = Bool()
  val isFpStore = Bool()
  val isFpOp = Bool()
  val isFpMAdd = Bool()
}

class ZeroNyteIFRVVRegReadRegs extends Bundle {
  val decRegs = new ZeroNyteIFRVVDecodeRegs
  val rs1Data = UInt(32.W)
  val rs2Data = UInt(32.W)
  val frs1Data = UInt(32.W)
  val frs2Data = UInt(32.W)
  val frs3Data = UInt(32.W)
}

class ZeroNyteIFRVVExecRegs extends Bundle {
  val regReadRegs = new ZeroNyteIFRVVRegReadRegs
  val result = UInt(32.W)
  val fpResult = UInt(32.W)
  val rd = UInt(5.W)
  val fpRd = UInt(5.W)
  val writeInt = Bool()
  val writeFp = Bool()
  val isMul = Bool()
  val mulFunct3 = UInt(3.W)
  val isFpCompute = Bool()
  val fpUsesPipedResult = Bool()
  val fpUsesPipedIntResult = Bool()
  val fpDirectResult = UInt(32.W)
  val fpIntDirectResult = UInt(32.W)
  val branchTaken = Bool()
  val branchTarget = UInt(32.W)
  val trap = Bool()
  val trapCause = UInt(8.W)
}

class ZeroNyteRV32IFRVVCore(val cosimulate: Boolean = false, val vlenbBytes: Int = 256)
    extends Module {
  val io = IO(new ZeroNyteRV32IFRVVCoreIO(cosimulate))

  private val resetPc = "h80000000".U(32.W)

  private val opFpLoad = "b0000111".U(7.W)
  private val opFpStore = "b0100111".U(7.W)
  private val opFp = "b1010011".U(7.W)
  private val opFmadd = "b1000011".U(7.W)
  private val opFmsub = "b1000111".U(7.W)
  private val opFnmsub = "b1001011".U(7.W)
  private val opFnmadd = "b1001111".U(7.W)
  private val opVector = "b1010111".U(7.W)
  private val opCustom0 = "b0001011".U(7.W)
  private val opCustom1 = "b0101011".U(7.W)
  private val opCustom2 = "b1011011".U(7.W)
  private val opCustom3 = "b1111011".U(7.W)

  private val csrFflags = "h001".U(12.W)
  private val csrFrm = "h002".U(12.W)
  private val csrFcsr = "h003".U(12.W)
  private val csrVstart = "h008".U(12.W)
  private val csrVxrm = "h009".U(12.W)
  private val csrVxsat = "h00a".U(12.W)
  private val csrVcsr = "h00f".U(12.W)
  private val csrVl = "hc20".U(12.W)
  private val csrVtype = "hc21".U(12.W)
  private val csrVlenb = "hc22".U(12.W)
  private val csrMstatus = "h300".U(12.W)
  private val csrMtvec = "h305".U(12.W)
  private val csrMepc = "h341".U(12.W)
  private val csrMcause = "h342".U(12.W)

  private def signExt12(value: UInt): UInt = Cat(Fill(20, value(11)), value)
  private def fStoreImm(instr: UInt): UInt = signExt12(Cat(instr(31, 25), instr(11, 7)))

  private def isFloatLoad(instr: UInt): Bool =
    instr(6, 0) === opFpLoad && instr(14, 12) === "b010".U
  private def isFloatStore(instr: UInt): Bool =
    instr(6, 0) === opFpStore && instr(14, 12) === "b010".U
  private def isFloatOp(instr: UInt): Bool = instr(6, 0) === opFp
  private def isFloatMAdd(instr: UInt): Bool =
    instr(6, 0) === opFmadd || instr(6, 0) === opFmsub ||
      instr(6, 0) === opFnmsub || instr(6, 0) === opFnmadd

  private def isExtension(instr: UInt): Bool = {
    val opcode = instr(6, 0)
    val vectorLoad = opcode === opFpLoad && instr(14, 12) =/= "b010".U
    val vectorStore = opcode === opFpStore && instr(14, 12) =/= "b010".U
    opcode === opVector || vectorLoad || vectorStore ||
      opcode === opCustom0 || opcode === opCustom1 ||
      opcode === opCustom2 || opcode === opCustom3
  }

  private def extensionClass(instr: UInt): UInt = {
    val opcode = instr(6, 0)
    Mux(opcode === opVector, ZeroNyteExtensionClass.rvvOp,
      Mux(opcode === opFpLoad, ZeroNyteExtensionClass.rvvLoad,
      Mux(opcode === opFpStore, ZeroNyteExtensionClass.rvvStore,
      Mux(opcode === opCustom1, ZeroNyteExtensionClass.matrix,
      Mux(opcode === opCustom2, ZeroNyteExtensionClass.tensor,
      Mux(opcode === opCustom0 || opcode === opCustom3,
        ZeroNyteExtensionClass.custom,
        ZeroNyteExtensionClass.none))))))
  }

  private def usesIntRs1(regs: ZeroNyteIFRVVDecodeRegs): Bool = {
    val opcode = regs.instr(6, 0)
    (regs.dec.isALU && opcode =/= RV32IDecode.LUI && opcode =/= RV32IDecode.AUIPC) ||
      regs.dec.isLoad || regs.dec.isStore || regs.dec.isBranch || regs.dec.isJALR ||
      regs.isFpLoad || regs.isFpStore || regs.isExt ||
      (regs.dec.isSystem && regs.instr(14, 12)(2) === 0.U && regs.instr(14, 12) =/= 0.U)
  }

  private def usesIntRs2(regs: ZeroNyteIFRVVDecodeRegs): Bool = {
    val opcode = regs.instr(6, 0)
    (regs.dec.isALU && opcode === RV32IDecode.OP_R) ||
      regs.dec.isStore || regs.dec.isBranch || regs.isExt
  }

  private def writesInt(regs: ZeroNyteIFRVVDecodeRegs): Bool = {
    regs.dec.isALU || regs.dec.isLoad || regs.dec.isLUI || regs.dec.isAUIPC ||
      regs.dec.isJAL || regs.dec.isJALR ||
      (regs.dec.isSystem && regs.instr(14, 12) =/= 0.U) ||
      (regs.isFpOp && (regs.instr(31, 25) === "b1010000".U ||
        regs.instr(31, 25) === "b1100000".U ||
        regs.instr(31, 25) === "b1110000".U))
  }

  private def usesFpRs1(regs: ZeroNyteIFRVVDecodeRegs): Bool =
    regs.isFpOp || regs.isFpMAdd
  private def usesFpRs2(regs: ZeroNyteIFRVVDecodeRegs): Bool =
    regs.isFpOp || regs.isFpMAdd || regs.isFpStore
  private def usesFpRs3(regs: ZeroNyteIFRVVDecodeRegs): Bool =
    regs.isFpMAdd
  private def writesFp(regs: ZeroNyteIFRVVDecodeRegs): Bool =
    regs.isFpLoad || regs.isFpMAdd || (regs.isFpOp && (
      regs.instr(31, 25) === "b0000000".U ||
      regs.instr(31, 25) === "b0000100".U ||
      regs.instr(31, 25) === "b0001000".U ||
      regs.instr(31, 25) === "b0010000".U ||
      regs.instr(31, 25) === "b0010100".U ||
      regs.instr(31, 25) === "b1101000".U ||
      regs.instr(31, 25) === "b1111000".U))

  private def emptyFetch: ZeroNyteIFRVVFetchRegs = 0.U.asTypeOf(new ZeroNyteIFRVVFetchRegs)
  private def emptyDecode: ZeroNyteIFRVVDecodeRegs = 0.U.asTypeOf(new ZeroNyteIFRVVDecodeRegs)
  private def emptyRegRead: ZeroNyteIFRVVRegReadRegs = 0.U.asTypeOf(new ZeroNyteIFRVVRegReadRegs)
  private def emptyExec: ZeroNyteIFRVVExecRegs = 0.U.asTypeOf(new ZeroNyteIFRVVExecRegs)

  io.jtag_tdo := 0.U
  io.interruptTaken := false.B
  io.imem_addr := 0.U
  io.dmem_addr := 0.U
  io.dmem_wdata := 0.U
  io.dmem_wmask := 0.U
  io.dmem_valid := false.B
  io.dmem_misaligned := false.B
  io.extIssue.valid := false.B
  io.extIssue.bits := 0.U.asTypeOf(new ZeroNyteExtensionIssue)
  io.extComplete.ready := false.B

  val pc = RegInit(resetPc)
  val trapValid = RegInit(false.B)
  val trapCause = RegInit(0.U(8.W))
  val extPending = RegInit(false.B)
  val extPendingPc = RegInit(0.U(32.W))
  val extPendingInstr = RegInit(0.U(32.W))
  io.extComplete.ready := extPending

  val fflags = RegInit(0.U(5.W))
  val frm = RegInit(0.U(3.W))
  val vstart = RegInit(0.U(32.W))
  val vxrm = RegInit(0.U(2.W))
  val vxsat = RegInit(false.B)
  val vl = RegInit(0.U(32.W))
  val vtype = RegInit(0.U(32.W))
  val mstatus = RegInit(0.U(32.W))
  val mtvec = RegInit(0.U(32.W))
  val mepc = RegInit(0.U(32.W))
  val mcause = RegInit(0.U(32.W))

  val fetchReg = RegInit(emptyFetch)
  val decodeReg = RegInit(emptyDecode)
  val dispatchReg = RegInit(emptyDecode)
  val regReadReg = RegInit(emptyRegRead)
  val exec1Reg = RegInit(emptyExec)
  val exec2Reg = RegInit(emptyExec)
  val exec3Reg = RegInit(emptyExec)
  val wbReg = RegInit(emptyExec)

  val regFile = Module(new RegFile2R1WMem(width = 32, depth = 32))
  regFile.io.readThreadID := 0.U
  regFile.io.writeThreadID := 0.U
  regFile.io.readAddrs := VecInit(Seq.fill(2)(0.U(5.W)))
  regFile.io.writeAddrs := VecInit(Seq.fill(1)(0.U(5.W)))
  regFile.io.wens := VecInit(Seq.fill(1)(false.B))
  regFile.io.writeData := VecInit(Seq.fill(1)(0.U(32.W)))

  val fpRegFile = Mem(32, UInt(32.W))
  val fpReadAddrs = WireDefault(VecInit(Seq.fill(3)(0.U(5.W))))
  val fpReadData = Wire(Vec(3, UInt(32.W)))
  for (idx <- 0 until 3) {
    fpReadData(idx) := fpRegFile.read(fpReadAddrs(idx))
  }

  val alu = Module(new ALU32)
  alu.io.a := 0.U
  alu.io.b := 0.U
  alu.io.opcode := ALU32.Opcode.ADD

  val mulUnit = Module(new Mul32Pipelined(4))
  mulUnit.io.a := 0.U
  mulUnit.io.b := 0.U
  mulUnit.io.signedA := false.B
  mulUnit.io.signedB := false.B

  val fpu = Module(new Float32ALUPipelined(4))
  fpu.io.a := 0.U
  fpu.io.b := 0.U
  fpu.io.c := 0.U
  fpu.io.opcode := Float32Ops.Opcode.ADD

  val branchUnit = Module(new BranchUnit)
  branchUnit.io.rs1 := 0.U
  branchUnit.io.rs2 := 0.U
  branchUnit.io.pc := 0.U
  branchUnit.io.imm := 0.S(32.W)
  branchUnit.io.branchOp := 0.U
  branchUnit.io.valid := false.B

  val loadUnit = Module(new LoadUnit)
  loadUnit.io.addr := 0.U
  loadUnit.io.dataIn := io.dmem_rdata
  loadUnit.io.funct3 := 0.U

  val storeUnit = Module(new StoreUnit)
  storeUnit.io.addr := 0.U
  storeUnit.io.data := 0.U
  storeUnit.io.storeType := 0.U

  val fpPipedResult = fpu.io.result

  val wbValid = wbReg.regReadRegs.decRegs.valid
  val wbInstr = wbReg.regReadRegs.decRegs.instr
  val wbMulResult = MuxLookup(wbReg.mulFunct3, mulUnit.io.lo)(Seq(
    "b000".U -> mulUnit.io.lo,
    "b001".U -> mulUnit.io.hi,
    "b010".U -> mulUnit.io.hi,
    "b011".U -> mulUnit.io.hi
  ))
  val wbIntResult = Mux(wbReg.isMul, wbMulResult,
    Mux(wbReg.fpUsesPipedIntResult, wbReg.fpIntDirectResult, wbReg.result))
  val wbFpResult = Mux(wbReg.fpUsesPipedResult, fpPipedResult,
    Mux(wbReg.fpDirectResult =/= 0.U || wbInstr(31, 25) === "b1101000".U ||
      wbInstr(31, 25) === "b1111000".U, wbReg.fpDirectResult, wbReg.fpResult))

  when(wbValid && wbReg.writeInt && wbReg.rd =/= 0.U) {
    regFile.io.writeAddrs(0) := wbReg.rd
    regFile.io.writeData(0) := wbIntResult
    regFile.io.wens(0) := true.B
  }
  when(wbValid && wbReg.writeFp && wbReg.fpRd =/= 0.U) {
    fpRegFile.write(wbReg.fpRd, wbFpResult)
  }
  when(wbValid && wbReg.trap) {
    trapValid := true.B
    trapCause := wbReg.trapCause
    mepc := wbReg.regReadRegs.decRegs.pc
    mcause := wbReg.trapCause
  }

  when(io.extComplete.fire && extPending) {
    extPending := false.B
    when(io.extComplete.bits.fault) {
      trapValid := true.B
      trapCause := io.extComplete.bits.cause
      mepc := extPendingPc
      mcause := io.extComplete.bits.cause
    }
    when(io.extComplete.bits.writeRd && io.extComplete.bits.rd =/= 0.U) {
      regFile.io.writeAddrs(0) := io.extComplete.bits.rd
      regFile.io.writeData(0) := io.extComplete.bits.rdData
      regFile.io.wens(0) := true.B
    }
    when(io.extComplete.bits.writeVl) { vl := io.extComplete.bits.vl }
    when(io.extComplete.bits.writeVtype) { vtype := io.extComplete.bits.vtype }
    when(io.extComplete.bits.writeVstart) { vstart := io.extComplete.bits.vstart }
    when(io.extComplete.bits.writeVxsat) { vxsat := io.extComplete.bits.vxsat }
  }

  val pendingIntDests = Seq(
    regReadReg.decRegs.valid && writesInt(regReadReg.decRegs) && regReadReg.decRegs.dec.rd =/= 0.U,
    exec1Reg.regReadRegs.decRegs.valid && exec1Reg.writeInt && exec1Reg.rd =/= 0.U,
    exec2Reg.regReadRegs.decRegs.valid && exec2Reg.writeInt && exec2Reg.rd =/= 0.U,
    exec3Reg.regReadRegs.decRegs.valid && exec3Reg.writeInt && exec3Reg.rd =/= 0.U,
    wbReg.regReadRegs.decRegs.valid && wbReg.writeInt && wbReg.rd =/= 0.U
  )
  val pendingIntRds = Seq(
    regReadReg.decRegs.dec.rd,
    exec1Reg.rd,
    exec2Reg.rd,
    exec3Reg.rd,
    wbReg.rd
  )
  val pendingFpDests = Seq(
    regReadReg.decRegs.valid && writesFp(regReadReg.decRegs) && regReadReg.decRegs.instr(11, 7) =/= 0.U,
    exec1Reg.regReadRegs.decRegs.valid && exec1Reg.writeFp && exec1Reg.fpRd =/= 0.U,
    exec2Reg.regReadRegs.decRegs.valid && exec2Reg.writeFp && exec2Reg.fpRd =/= 0.U,
    exec3Reg.regReadRegs.decRegs.valid && exec3Reg.writeFp && exec3Reg.fpRd =/= 0.U,
    wbReg.regReadRegs.decRegs.valid && wbReg.writeFp && wbReg.fpRd =/= 0.U
  )
  val pendingFpRds = Seq(
    regReadReg.decRegs.instr(11, 7),
    exec1Reg.fpRd,
    exec2Reg.fpRd,
    exec3Reg.fpRd,
    wbReg.fpRd
  )

  val dispatchValid = dispatchReg.valid
  val dispatchRs1 = dispatchReg.dec.rs1
  val dispatchRs2 = dispatchReg.dec.rs2
  val dispatchRd = dispatchReg.dec.rd
  val dispatchFrs1 = dispatchReg.instr(19, 15)
  val dispatchFrs2 = dispatchReg.instr(24, 20)
  val dispatchFrs3 = dispatchReg.instr(31, 27)
  val dispatchFpRd = dispatchReg.instr(11, 7)

  val intRawHazard = dispatchValid && (
    (usesIntRs1(dispatchReg) && pendingIntDests.zip(pendingIntRds).map {
      case (valid, rd) => valid && rd === dispatchRs1
    }.reduce(_ || _)) ||
    (usesIntRs2(dispatchReg) && pendingIntDests.zip(pendingIntRds).map {
      case (valid, rd) => valid && rd === dispatchRs2
    }.reduce(_ || _))
  )
  val fpRawHazard = dispatchValid && (
    (usesFpRs1(dispatchReg) && pendingFpDests.zip(pendingFpRds).map {
      case (valid, rd) => valid && rd === dispatchFrs1
    }.reduce(_ || _)) ||
    (usesFpRs2(dispatchReg) && pendingFpDests.zip(pendingFpRds).map {
      case (valid, rd) => valid && rd === dispatchFrs2
    }.reduce(_ || _)) ||
    (usesFpRs3(dispatchReg) && pendingFpDests.zip(pendingFpRds).map {
      case (valid, rd) => valid && rd === dispatchFrs3
    }.reduce(_ || _))
  )
  val fpWawHazard = dispatchValid && writesFp(dispatchReg) &&
    pendingFpDests.zip(pendingFpRds).map { case (valid, rd) => valid && rd === dispatchFpRd }.reduce(_ || _)
  val olderPipeBusy = regReadReg.decRegs.valid || exec1Reg.regReadRegs.decRegs.valid ||
    exec2Reg.regReadRegs.decRegs.valid || exec3Reg.regReadRegs.decRegs.valid || wbReg.regReadRegs.decRegs.valid
  val extNeedsIssue = dispatchValid && dispatchReg.isExt
  val extCanIssue = extNeedsIssue && !intRawHazard && !fpRawHazard && !fpWawHazard &&
    !extPending && !olderPipeBusy && !trapValid
  val extBlocked = extPending || (extNeedsIssue && (olderPipeBusy || !io.extIssue.ready))
  val interruptBlocked = io.interruptPending && (dispatchValid || olderPipeBusy || extPending)
  val stallFront = intRawHazard || fpRawHazard || fpWawHazard || extBlocked || interruptBlocked || trapValid

  val stallReason = WireDefault(0.U(8.W))
  when(intRawHazard) { stallReason := 1.U }
  when(fpRawHazard) { stallReason := 2.U }
  when(fpWawHazard) { stallReason := 3.U }
  when(extBlocked) { stallReason := 4.U }
  when(interruptBlocked) { stallReason := 5.U }
  when(trapValid) { stallReason := 6.U }

  regFile.io.readAddrs(0) := dispatchRs1
  regFile.io.readAddrs(1) := dispatchRs2
  fpReadAddrs(0) := dispatchFrs1
  fpReadAddrs(1) := dispatchFrs2
  fpReadAddrs(2) := dispatchFrs3

  val extHandshake = extCanIssue && io.extIssue.ready

  val extIssueBits = WireDefault(0.U.asTypeOf(new ZeroNyteExtensionIssue))
  extIssueBits.pc := dispatchReg.pc
  extIssueBits.instr := dispatchReg.instr
  extIssueBits.opClass := extensionClass(dispatchReg.instr)
  extIssueBits.rd := dispatchReg.instr(11, 7)
  extIssueBits.rs1 := dispatchReg.instr(19, 15)
  extIssueBits.rs2 := dispatchReg.instr(24, 20)
  extIssueBits.rs3 := dispatchReg.instr(31, 27)
  extIssueBits.funct3 := dispatchReg.instr(14, 12)
  extIssueBits.funct7 := dispatchReg.instr(31, 25)
  extIssueBits.scalarRs1 := regFile.io.readData(0)
  extIssueBits.scalarRs2 := regFile.io.readData(1)
  extIssueBits.imm := dispatchReg.dec.imm
  extIssueBits.vl := vl
  extIssueBits.vtype := vtype
  extIssueBits.vstart := vstart
  extIssueBits.vxrm := vxrm
  extIssueBits.vxsat := vxsat
  extIssueBits.isMemory := dispatchReg.instr(6, 0) === opFpLoad || dispatchReg.instr(6, 0) === opFpStore
  extIssueBits.isStore := dispatchReg.instr(6, 0) === opFpStore
  extIssueBits.memWidth := dispatchReg.instr(14, 12)
  extIssueBits.memMode := dispatchReg.instr(27, 26)
  extIssueBits.memMasked := dispatchReg.instr(25)
  extIssueBits.memSegments := dispatchReg.instr(31, 29)
  io.extIssue.valid := extCanIssue
  io.extIssue.bits := extIssueBits

  val redirect = WireDefault(false.B)
  val redirectTarget = WireDefault(0.U(32.W))

  val nextExec = WireDefault(emptyExec)
  when(regReadReg.decRegs.valid) {
    val regs = regReadReg.decRegs
    val instr = regs.instr
    val funct3 = instr(14, 12)
    val fpFunct7 = instr(31, 25)
    val fpRs2 = instr(24, 20)
    val isMExt = instr(6, 0) === RV32IDecode.OP_R && instr(31, 25) === "b0000001".U
    val isMulInstr = isMExt && funct3 <= "b011".U

    nextExec.regReadRegs := regReadReg
    nextExec.rd := regs.dec.rd
    nextExec.fpRd := instr(11, 7)
    nextExec.writeInt := false.B
    nextExec.writeFp := false.B
    nextExec.isMul := false.B
    nextExec.mulFunct3 := funct3
    nextExec.isFpCompute := regs.isFpOp || regs.isFpMAdd
    nextExec.fpUsesPipedResult := false.B
    nextExec.fpUsesPipedIntResult := false.B
    nextExec.branchTaken := false.B
    nextExec.branchTarget := 0.U
    nextExec.trap := false.B
    nextExec.trapCause := 0.U

    mulUnit.io.a := regReadReg.rs1Data
    mulUnit.io.b := regReadReg.rs2Data
    mulUnit.io.signedA := funct3 =/= "b011".U
    mulUnit.io.signedB := funct3 =/= "b011".U && funct3 =/= "b010".U

    fpu.io.a := regReadReg.frs1Data
    fpu.io.b := regReadReg.frs2Data
    fpu.io.c := regReadReg.frs3Data

    when((regs.dec.isALU && !isMulInstr) || regs.dec.isLUI || regs.dec.isAUIPC) {
      val opcode = instr(6, 0)
      val useImm = opcode === RV32IDecode.OP_I || regs.dec.isLUI || regs.dec.isAUIPC
      val opA = Mux(regs.dec.isAUIPC, regs.pc, Mux(regs.dec.isLUI, 0.U, regReadReg.rs1Data))
      val opB = Mux(useImm, regs.dec.imm, regReadReg.rs2Data)
      alu.io.a := opA
      alu.io.b := opB
      alu.io.opcode := regs.dec.aluOp
      nextExec.result := Mux(regs.dec.isAUIPC, regs.pc + regs.dec.imm,
        Mux(regs.dec.isLUI, regs.dec.imm, alu.io.result))
      nextExec.writeInt := true.B
    }.elsewhen(isMulInstr) {
      nextExec.isMul := true.B
      nextExec.writeInt := true.B
    }.elsewhen(regs.isFpLoad) {
      val address = regReadReg.rs1Data + signExt12(instr(31, 20))
      io.dmem_addr := Cat(address(31, 2), 0.U(2.W))
      io.dmem_valid := true.B
      loadUnit.io.addr := address
      loadUnit.io.funct3 := "b010".U
      nextExec.fpResult := loadUnit.io.dataOut
      nextExec.writeFp := true.B
    }.elsewhen(regs.isFpStore) {
      val address = regReadReg.rs1Data + fStoreImm(instr)
      storeUnit.io.addr := address
      storeUnit.io.data := regReadReg.frs2Data
      storeUnit.io.storeType := "b10".U
      io.dmem_addr := Cat(address(31, 2), 0.U(2.W))
      io.dmem_wdata := Mux(storeUnit.io.misaligned, 0.U, storeUnit.io.memWrite)
      io.dmem_wmask := Mux(storeUnit.io.misaligned, 0.U, storeUnit.io.mask)
      io.dmem_valid := !storeUnit.io.misaligned
      io.dmem_misaligned := storeUnit.io.misaligned
      nextExec.trap := storeUnit.io.misaligned
      nextExec.trapCause := 6.U
    }.elsewhen(regs.isFpMAdd) {
      val opcode = instr(6, 0)
      val negateProduct = opcode === opFnmsub || opcode === opFnmadd
      val negateAddend = opcode === opFmsub || opcode === opFnmadd
      fpu.io.a := Mux(negateProduct, Float32Ops.negate(regReadReg.frs1Data), regReadReg.frs1Data)
      fpu.io.b := regReadReg.frs2Data
      fpu.io.c := Mux(negateAddend, Float32Ops.negate(regReadReg.frs3Data), regReadReg.frs3Data)
      fpu.io.opcode := Float32Ops.Opcode.MADD
      nextExec.fpUsesPipedResult := true.B
      nextExec.writeFp := true.B
    }.elsewhen(regs.isFpOp) {
      val fpCompareResult = MuxLookup(funct3, 0.U(32.W))(Seq(
        "b010".U -> (regReadReg.frs1Data === regReadReg.frs2Data).asUInt,
        "b001".U -> Float32Ops.lessThan(regReadReg.frs1Data, regReadReg.frs2Data).asUInt,
        "b000".U -> Float32Ops.lessOrEqual(regReadReg.frs1Data, regReadReg.frs2Data).asUInt
      ))
      val fpClass = Cat(
        0.U(23.W),
        0.U(5.W),
        (!regReadReg.frs1Data(31) && regReadReg.frs1Data(30, 0) === 0.U).asUInt,
        (regReadReg.frs1Data(31) && regReadReg.frs1Data(30, 0) === 0.U).asUInt,
        (!regReadReg.frs1Data(31) && regReadReg.frs1Data(30, 23) =/= 0.U).asUInt,
        (regReadReg.frs1Data(31) && regReadReg.frs1Data(30, 23) =/= 0.U).asUInt
      )
      when(fpFunct7 === "b0000000".U) {
        fpu.io.opcode := Float32Ops.Opcode.ADD
        nextExec.fpUsesPipedResult := true.B
        nextExec.writeFp := true.B
      }.elsewhen(fpFunct7 === "b0000100".U) {
        fpu.io.opcode := Float32Ops.Opcode.SUB
        nextExec.fpUsesPipedResult := true.B
        nextExec.writeFp := true.B
      }.elsewhen(fpFunct7 === "b0001000".U) {
        fpu.io.opcode := Float32Ops.Opcode.MUL
        nextExec.fpUsesPipedResult := true.B
        nextExec.writeFp := true.B
      }.elsewhen(fpFunct7 === "b0010000".U) {
        fpu.io.opcode := MuxLookup(funct3, Float32Ops.Opcode.SGNJ)(Seq(
          "b000".U -> Float32Ops.Opcode.SGNJ,
          "b001".U -> Float32Ops.Opcode.SGNJN,
          "b010".U -> Float32Ops.Opcode.SGNJX
        ))
        nextExec.fpUsesPipedResult := true.B
        nextExec.writeFp := true.B
      }.elsewhen(fpFunct7 === "b0010100".U) {
        fpu.io.opcode := Mux(funct3(0), Float32Ops.Opcode.MAX, Float32Ops.Opcode.MIN)
        nextExec.fpUsesPipedResult := true.B
        nextExec.writeFp := true.B
      }.elsewhen(fpFunct7 === "b1010000".U) {
        nextExec.fpIntDirectResult := fpCompareResult
        nextExec.fpUsesPipedIntResult := true.B
        nextExec.writeInt := true.B
      }.elsewhen(fpFunct7 === "b1100000".U) {
        nextExec.fpIntDirectResult := Float32Ops.floatToInt(regReadReg.frs1Data, fpRs2 === 0.U)
        nextExec.fpUsesPipedIntResult := true.B
        nextExec.writeInt := true.B
      }.elsewhen(fpFunct7 === "b1101000".U) {
        nextExec.fpDirectResult := Float32Ops.intToFloat(regReadReg.rs1Data, fpRs2 === 0.U)
        nextExec.writeFp := true.B
      }.elsewhen(fpFunct7 === "b1110000".U) {
        nextExec.fpIntDirectResult := Mux(funct3 === "b001".U, fpClass, regReadReg.frs1Data)
        nextExec.fpUsesPipedIntResult := true.B
        nextExec.writeInt := true.B
      }.elsewhen(fpFunct7 === "b1111000".U) {
        nextExec.fpDirectResult := regReadReg.rs1Data
        nextExec.writeFp := true.B
      }.otherwise {
        nextExec.trap := true.B
        nextExec.trapCause := 2.U
      }
    }.elsewhen(regs.dec.isJAL) {
      nextExec.result := regs.pc + 4.U
      nextExec.writeInt := true.B
      nextExec.branchTaken := true.B
      nextExec.branchTarget := (regs.pc.asSInt + regs.dec.imm.asSInt).asUInt
    }.elsewhen(regs.dec.isJALR) {
      val target = ((regReadReg.rs1Data.asSInt + regs.dec.imm.asSInt).asUInt & ~1.U(32.W))
      nextExec.result := regs.pc + 4.U
      nextExec.writeInt := true.B
      nextExec.branchTaken := true.B
      nextExec.branchTarget := target
    }.elsewhen(regs.dec.isBranch) {
      branchUnit.io.rs1 := regReadReg.rs1Data
      branchUnit.io.rs2 := regReadReg.rs2Data
      branchUnit.io.pc := regs.pc
      branchUnit.io.imm := (regs.dec.imm << 1).asSInt
      branchUnit.io.branchOp := funct3
      branchUnit.io.valid := true.B
      nextExec.branchTaken := branchUnit.io.taken
      nextExec.branchTarget := branchUnit.io.target
      nextExec.trap := branchUnit.io.misaligned
      nextExec.trapCause := 0.U
    }.elsewhen(regs.dec.isLoad) {
      val address = regReadReg.rs1Data + regs.dec.imm
      io.dmem_addr := Cat(address(31, 2), 0.U(2.W))
      io.dmem_valid := true.B
      loadUnit.io.addr := address
      loadUnit.io.funct3 := funct3
      nextExec.result := loadUnit.io.dataOut
      nextExec.writeInt := true.B
    }.elsewhen(regs.dec.isStore) {
      val address = regReadReg.rs1Data + regs.dec.imm
      storeUnit.io.addr := address
      storeUnit.io.data := regReadReg.rs2Data
      storeUnit.io.storeType := funct3(1, 0)
      io.dmem_addr := Cat(address(31, 2), 0.U(2.W))
      io.dmem_wdata := Mux(storeUnit.io.misaligned, 0.U, storeUnit.io.memWrite)
      io.dmem_wmask := Mux(storeUnit.io.misaligned, 0.U, storeUnit.io.mask)
      io.dmem_valid := !storeUnit.io.misaligned
      io.dmem_misaligned := storeUnit.io.misaligned
      nextExec.trap := storeUnit.io.misaligned
      nextExec.trapCause := 6.U
    }.elsewhen(regs.dec.isSystem) {
      val csrAddr = instr(31, 20)
      val csrOp = funct3
      val csrOld = WireDefault(0.U(32.W))
      val zimm = Cat(0.U(27.W), instr(19, 15))
      val csrSrc = Mux(csrOp(2), zimm, regReadReg.rs1Data)
      switch(csrAddr) {
        is(csrFflags) { csrOld := Cat(0.U(27.W), fflags) }
        is(csrFrm) { csrOld := Cat(0.U(29.W), frm) }
        is(csrFcsr) { csrOld := Cat(0.U(24.W), frm, fflags) }
        is(csrVstart) { csrOld := vstart }
        is(csrVxrm) { csrOld := Cat(0.U(30.W), vxrm) }
        is(csrVxsat) { csrOld := vxsat.asUInt }
        is(csrVcsr) { csrOld := Cat(0.U(29.W), vxrm, vxsat.asUInt) }
        is(csrVl) { csrOld := vl }
        is(csrVtype) { csrOld := vtype }
        is(csrVlenb) { csrOld := vlenbBytes.U(32.W) }
        is(csrMstatus) { csrOld := mstatus }
        is(csrMtvec) { csrOld := mtvec }
        is(csrMepc) { csrOld := mepc }
        is(csrMcause) { csrOld := mcause }
      }
      val csrNew = MuxLookup(csrOp, csrOld)(Seq(
        "b001".U -> csrSrc,
        "b010".U -> (csrOld | csrSrc),
        "b011".U -> (csrOld & ~csrSrc),
        "b101".U -> csrSrc,
        "b110".U -> (csrOld | csrSrc),
        "b111".U -> (csrOld & ~csrSrc)
      ))
      val csrWrite = csrOp =/= 0.U && !(csrAddr === csrVl || csrAddr === csrVtype || csrAddr === csrVlenb)
      when(csrWrite) {
        switch(csrAddr) {
          is(csrFflags) { fflags := csrNew(4, 0) }
          is(csrFrm) { frm := csrNew(2, 0) }
          is(csrFcsr) {
            frm := csrNew(7, 5)
            fflags := csrNew(4, 0)
          }
          is(csrVstart) { vstart := csrNew }
          is(csrVxrm) { vxrm := csrNew(1, 0) }
          is(csrVxsat) { vxsat := csrNew(0) }
          is(csrVcsr) {
            vxrm := csrNew(2, 1)
            vxsat := csrNew(0)
          }
          is(csrMstatus) { mstatus := csrNew }
          is(csrMtvec) { mtvec := csrNew }
          is(csrMepc) { mepc := csrNew }
          is(csrMcause) { mcause := csrNew }
        }
      }
      nextExec.result := csrOld
      nextExec.writeInt := csrOp =/= 0.U
    }.elsewhen(regs.dec.isFence) {
      nextExec.result := 0.U
    }.otherwise {
      nextExec.trap := true.B
      nextExec.trapCause := 2.U
    }
  }

  redirect := exec1Reg.branchTaken && exec1Reg.regReadRegs.decRegs.valid && !exec1Reg.trap
  redirectTarget := exec1Reg.branchTarget

  when(extHandshake) {
    extPending := true.B
    extPendingPc := dispatchReg.pc
    extPendingInstr := dispatchReg.instr
  }

  when(io.interruptPending && !interruptBlocked && !trapValid) {
    io.interruptTaken := true.B
    mepc := pc
    mcause := 11.U
    pc := io.interruptVector
    fetchReg := emptyFetch
    decodeReg := emptyDecode
    dispatchReg := emptyDecode
  }.elsewhen(redirect) {
    pc := redirectTarget
    fetchReg := emptyFetch
    decodeReg := emptyDecode
    dispatchReg := emptyDecode
    regReadReg := emptyRegRead
  }.otherwise {
    when(!stallFront) {
      fetchReg.valid := true.B
      fetchReg.pc := pc
      fetchReg.instr := io.imem_rdata
      pc := pc + 4.U

      decodeReg.valid := fetchReg.valid
      decodeReg.pc := fetchReg.pc
      decodeReg.instr := fetchReg.instr
      decodeReg.dec := RV32IDecode.decodeInstr(fetchReg.instr)
      decodeReg.isExt := isExtension(fetchReg.instr)
      decodeReg.isFpLoad := isFloatLoad(fetchReg.instr)
      decodeReg.isFpStore := isFloatStore(fetchReg.instr)
      decodeReg.isFpOp := isFloatOp(fetchReg.instr)
      decodeReg.isFpMAdd := isFloatMAdd(fetchReg.instr)

      dispatchReg := decodeReg

      regReadReg.decRegs := Mux(extHandshake, emptyDecode, dispatchReg)
      regReadReg.rs1Data := regFile.io.readData(0)
      regReadReg.rs2Data := regFile.io.readData(1)
      regReadReg.frs1Data := fpReadData(0)
      regReadReg.frs2Data := fpReadData(1)
      regReadReg.frs3Data := fpReadData(2)
    }.otherwise {
      regReadReg := emptyRegRead
    }
  }

  exec1Reg := Mux(redirect, emptyExec, nextExec)
  exec2Reg := exec1Reg
  exec3Reg := exec2Reg
  wbReg := exec3Reg

  io.imem_addr := pc
  io.pc_out := pc
  io.instr_out := fetchReg.instr
  io.result := wbIntResult
  io.trap_valid := trapValid.asUInt
  io.trap_cause := trapCause
  io.ext_pending := extPending.asUInt
  io.stall_reason := stallReason

  val unusedExtInstr = WireDefault(extPendingInstr)
  dontTouch(unusedExtInstr)
}
