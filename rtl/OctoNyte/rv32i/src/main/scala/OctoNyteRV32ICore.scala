package OctoNyte

import chisel3._
import chisel3.util._
import ALUs._
import BranchUnit._
import Decoders._
import LoadUnit._
import StoreUnit._
import RegFiles._
import RegFiles.RegFileMTMultiWVec
import Pipeline._

class PipelineRegBundle(threadBits: Int) extends Bundle {
  val valid     = Bool()
  val pc        = UInt(32.W)
  val instr     = UInt(32.W)
  val threadId  = UInt(threadBits.W)

  val rs1       = UInt(5.W)
  val rs2       = UInt(5.W)
  val rd        = UInt(5.W)
  val imm       = UInt(32.W)
  val aluOp     = UInt(5.W)
  val isALU     = Bool()
  val isLoad    = Bool()
  val isStore   = Bool()
  val isBranch  = Bool()
  val isJAL     = Bool()
  val isJALR    = Bool()
  val isLUI     = Bool()
  val isAUIPC   = Bool()
  val rs1Data   = UInt(32.W)
  val rs2Data   = UInt(32.W)
  val aluResult = UInt(32.W)
  val memRdata  = UInt(32.W)
}

class StagePacket(threadBits: Int, issueWidth: Int) extends Bundle {
  val valid    = Bool()
  val threadId = UInt(threadBits.W)
  val slots    = Vec(issueWidth, new PipelineRegBundle(threadBits))
}

class OctoNyteRV32ICoreIO(val numThreads: Int, val issueWidth: Int) extends Bundle {
  val threadEnable = Input(Vec(numThreads, Bool()))
  val instrMem     = Input(UInt(128.W)) // 4-wide fetch packet
  val dataMemResp  = Input(UInt(32.W))
  val memAddr      = Output(UInt(32.W))
  val memWrite     = Output(UInt(32.W))
  val memMask      = Output(UInt(4.W))
  val memMisaligned= Output(Bool())

  val fetchThread  = Output(UInt(log2Ceil(numThreads).W))
  val if_pc        = Output(Vec(numThreads, UInt(32.W)))
  val if_instr     = Output(Vec(numThreads, UInt(32.W)))
  val id_rs1Data   = Output(Vec(numThreads, UInt(32.W)))
  val id_rs2Data   = Output(Vec(numThreads, UInt(32.W)))
  val ex_aluResult = Output(Vec(numThreads, UInt(32.W)))
  val mem_loadData = Output(Vec(numThreads, UInt(32.W)))

  // Debug/control visibility
  val ctrlTaken    = Output(Bool())
  val ctrlThread   = Output(UInt(log2Ceil(numThreads).W))
  val ctrlFromPC   = Output(UInt(32.W))
  val ctrlTarget   = Output(UInt(32.W))
  val ctrlIsJal    = Output(Bool())
  val ctrlIsJalr   = Output(Bool())
  val ctrlIsBranch = Output(Bool())
  val debugRegX1   = Output(Vec(numThreads, UInt(32.W))) // per-thread x1 view
  val debugRegs01234 = Output(Vec(numThreads, Vec(5, UInt(32.W)))) // small debug window x0..x4
  val debugPC      = Output(Vec(numThreads, UInt(32.W)))

  // Debug pipeline summary
  val debugIbCount   = Output(UInt(log2Ceil(9).W)) // ibDepth is 8; width 4 bits is enough
  val debugIbThread  = Output(UInt(log2Ceil(numThreads).W))
  val debugIbValid   = Output(Bool())
  val debugPipeValid = Output(Vec(6, Bool()))  // id_disp, disp_rr, rr_ex1, ex1_ex2, ex2_ex3, ex3_wb
  val debugPipeThread= Output(Vec(6, UInt(log2Ceil(numThreads).W)))
  val debugStageThreads = Output(Vec(8, UInt(log2Ceil(numThreads).W)))
  val debugStageValids  = Output(Vec(8, Bool()))
}

class OctoNyteRV32ICore extends Module {
  val numThreads = 8
  val issueWidth = 4
  val io = IO(new OctoNyteRV32ICoreIO(numThreads, issueWidth))

  private val threadBits = log2Ceil(numThreads)

  // Per-thread PC registers and flush tracking
  val pcRegs = RegInit(VecInit(Seq.fill(numThreads)("h80000000".U(32.W))))
  val flushThread = RegInit(VecInit(Seq.fill(numThreads)(false.B)))

  // Round-robin pipeline scheduler (one thread per pipeline stage)
  val threadSched = Module(new Pipeline.PipelineScheduler(numThreads, stageCount = 8))
  threadSched.io.threadEnable := io.threadEnable
  threadSched.io.advance := true.B
  val stageThreads = threadSched.io.stageThreads
  io.debugStageThreads := stageThreads
  io.debugStageValids  := threadSched.io.stageValids
  val threadSel = stageThreads(0)
  io.fetchThread := threadSel

  // Pipeline stage packets are tracked per thread; the thread scheduler selects which
  // thread's state feeds each stage in the barrel pipeline on a given cycle.
  def emptyPacket: StagePacket = 0.U.asTypeOf(new StagePacket(threadBits, issueWidth))
  val if_id     = RegInit(VecInit(Seq.fill(numThreads)(emptyPacket)))
  val id_disp   = RegInit(VecInit(Seq.fill(numThreads)(emptyPacket)))
  val disp_rr   = RegInit(VecInit(Seq.fill(numThreads)(emptyPacket)))
  val rr_ex1    = RegInit(VecInit(Seq.fill(numThreads)(emptyPacket)))
  val ex1_ex2   = RegInit(VecInit(Seq.fill(numThreads)(emptyPacket)))
  val ex2_ex3   = RegInit(VecInit(Seq.fill(numThreads)(emptyPacket)))
  val ex3_wb    = RegInit(VecInit(Seq.fill(numThreads)(emptyPacket)))

  // Per-thread instruction buffers (simple circular queues)
  val ibDepth = 8
  val ibSlots = RegInit(VecInit(Seq.fill(numThreads)(VecInit(Seq.fill(ibDepth)(0.U.asTypeOf(new PipelineRegBundle(threadBits)))))))
  val ibHead  = RegInit(VecInit(Seq.fill(numThreads)(0.U(log2Ceil(ibDepth).W))))
  val ibTail  = RegInit(VecInit(Seq.fill(numThreads)(0.U(log2Ceil(ibDepth).W))))
  val ibCount = RegInit(VecInit(Seq.fill(numThreads)(0.U(log2Ceil(ibDepth + 1).W))))

  // Shared multithreaded register file with 4 write ports and 4 read-port groups
  val regFile = Module(new RegFileMTMultiWVec(numThreads = numThreads, numWritePorts = issueWidth, numReadPorts = issueWidth))

  // Debug mirrors to expose last-seen per-thread stage values
  val debugIfInstr = RegInit(VecInit(Seq.fill(numThreads)(0.U(32.W))))
  val debugIdRs1   = RegInit(VecInit(Seq.fill(numThreads)(0.U(32.W))))
  val debugIdRs2   = RegInit(VecInit(Seq.fill(numThreads)(0.U(32.W))))
  val debugExAlu   = RegInit(VecInit(Seq.fill(numThreads)(0.U(32.W))))
  val debugMemLoad = RegInit(VecInit(Seq.fill(numThreads)(0.U(32.W))))
  val debugRegsSmall = RegInit(VecInit(Seq.fill(numThreads)(VecInit(Seq.fill(5)(0.U(32.W))))))
  io.debugPC := pcRegs

  // Default IO outputs
  io.memAddr := 0.U
  io.memWrite := 0.U
  io.memMask := 0.U
  io.memMisaligned := false.B
  io.ctrlTaken := false.B
  io.ctrlThread := 0.U
  io.ctrlFromPC := 0.U
  io.ctrlTarget := 0.U
  io.ctrlIsBranch := false.B
  io.ctrlIsJal := false.B
  io.ctrlIsJalr := false.B

  // ===================== Instruction Fetch into buffer =====================
  val currentThread    = threadSel(threadBits - 1, 0)
  val threadEnabled    = io.threadEnable(currentThread)
  val flushThisThread  = flushThread(currentThread)
  val bufferFree       = (ibDepth.U - ibCount(currentThread))
  val bufferEmpty      = ibCount(currentThread) === 0.U
  val canFetch         = (bufferFree >= issueWidth.U) && threadEnabled && !flushThisThread

  when(canFetch) {
    // Calculate next head/tail/count locally to avoid last-assignment-wins bugs.
    var nextTail  = ibTail(currentThread)
    var nextCount = ibCount(currentThread)
    for (i <- 0 until issueWidth) {
      val instr = io.instrMem((32 * (i + 1) - 1), 32 * i)
      val slot  = WireDefault(0.U.asTypeOf(new PipelineRegBundle(threadBits)))
      slot.valid := true.B
      slot.pc    := pcRegs(currentThread) + (i.U << 2)
      slot.instr := instr
      slot.threadId := currentThread
      slot.rs1 := instr(19, 15)
      slot.rs2 := instr(24, 20)
      slot.rd  := instr(11, 7)
      val dec = RV32IDecode.decodeInstr(instr)
      slot.imm := dec.imm
      slot.aluOp := dec.aluOp
      slot.isALU := dec.isALU
      slot.isLoad := dec.isLoad
      slot.isStore := dec.isStore
      slot.isBranch := dec.isBranch
      slot.isJAL := dec.isJAL
      slot.isJALR := dec.isJALR
      slot.isLUI := dec.isLUI
      slot.isAUIPC := dec.isAUIPC
      ibSlots(currentThread)(nextTail) := slot
      nextTail = Mux(nextTail === (ibDepth - 1).U, 0.U, nextTail + 1.U)
      nextCount = nextCount + 1.U
    }
    ibTail(currentThread) := nextTail
    ibCount(currentThread) := nextCount
    pcRegs(currentThread) := pcRegs(currentThread) + 16.U
    // Latch fetch packet into if_id for this thread (visible to decode scheduling)
    val fetchPkt = WireDefault(emptyPacket)
    fetchPkt.valid := true.B
    fetchPkt.threadId := currentThread
    for (i <- 0 until issueWidth) {
      val instr = io.instrMem((32 * (i + 1) - 1), 32 * i)
      fetchPkt.slots(i).valid := true.B
      fetchPkt.slots(i).pc    := pcRegs(currentThread) + (i.U << 2)
      fetchPkt.slots(i).instr := instr
      fetchPkt.slots(i).threadId := currentThread
      val dec = RV32IDecode.decodeInstr(instr)
      fetchPkt.slots(i).rs1 := instr(19,15)
      fetchPkt.slots(i).rs2 := instr(24,20)
      fetchPkt.slots(i).rd  := instr(11,7)
      fetchPkt.slots(i).imm := dec.imm
      fetchPkt.slots(i).aluOp := dec.aluOp
      fetchPkt.slots(i).isALU := dec.isALU
      fetchPkt.slots(i).isLoad := dec.isLoad
      fetchPkt.slots(i).isStore:= dec.isStore
      fetchPkt.slots(i).isBranch:= dec.isBranch
      fetchPkt.slots(i).isJAL := dec.isJAL
      fetchPkt.slots(i).isJALR:= dec.isJALR
      fetchPkt.slots(i).isLUI := dec.isLUI
      fetchPkt.slots(i).isAUIPC:= dec.isAUIPC
    }
    if_id(currentThread) := fetchPkt
  }

  // Thread assignment for each pipeline stage (barrel).
  val decThread  = stageThreads(1)
  val dispThread = stageThreads(2)
  val rrThread   = stageThreads(3)
  val ex1Thread  = stageThreads(4)
  val ex2Thread  = stageThreads(5)
  val ex3Thread  = stageThreads(6)
  val wbThread   = stageThreads(7)
  // ===================== Decode / Hazard Check (buffer -> ID/DISP) =====================
  when(!id_disp(decThread).valid && ibCount(decThread) =/= 0.U && io.threadEnable(decThread) && !flushThread(decThread)) {
    val dispatch = Module(new DispatchUnit(issueWidth = issueWidth, maxALU = 2, maxLoad = 1, maxStore = 1, maxBranch = 1))
    dispatch.io.threadEnable := io.threadEnable(decThread)
    dispatch.io.flushThread := flushThread(decThread)

    // in-flight busy regs for this thread
    for (r <- 0 until 32) {
      val busy = disp_rr(decThread).slots.map(s => s.valid && s.rd === r.U).reduce(_||_) ||
        rr_ex1(decThread).slots.map(s => s.valid && s.rd === r.U).reduce(_||_) ||
        ex1_ex2(decThread).slots.map(s => s.valid && s.rd === r.U).reduce(_||_) ||
        ex2_ex3(decThread).slots.map(s => s.valid && s.rd === r.U).reduce(_||_) ||
        ex3_wb(decThread).slots.map(s => s.valid && s.rd === r.U &&
          (s.isALU || s.isLoad || s.isLUI || s.isAUIPC || s.isJAL || s.isJALR)).reduce(_||_)
      dispatch.io.inFlightBusy(r) := busy
    }

    val maxTake = Mux(ibCount(decThread) > issueWidth.U, issueWidth.U, ibCount(decThread))
    for (i <- 0 until issueWidth) {
      val idx = (ibHead(decThread) + i.U)(log2Ceil(ibDepth)-1,0)
      val in = ibSlots(decThread)(idx)
      val slot = Wire(new DispatchSlot)
      slot.valid := in.valid && (i.U < maxTake)
      slot.rs1 := in.rs1; slot.rs2 := in.rs2; slot.rd := in.rd
      slot.isALU := in.isALU; slot.isLoad := in.isLoad; slot.isStore := in.isStore
      slot.isBranch := in.isBranch; slot.isJAL := in.isJAL; slot.isJALR := in.isJALR
      slot.isLUI := in.isLUI; slot.isAUIPC := in.isAUIPC
      dispatch.io.inSlots(i) := slot
    }

    val pkt = WireDefault(0.U.asTypeOf(new StagePacket(threadBits, issueWidth)))
    pkt.valid := dispatch.io.issuedCount =/= 0.U
    pkt.threadId := decThread
    for (i <- 0 until issueWidth) {
      val idx = (ibHead(decThread) + i.U)(log2Ceil(ibDepth)-1,0)
      pkt.slots(i) := ibSlots(decThread)(idx)
      pkt.slots(i).valid := dispatch.io.issueMask(i) && dispatch.io.inSlots(i).valid
    }

    when(dispatch.io.issuedCount =/= 0.U) {
      id_disp(decThread) := pkt
      val newHead = Mux(ibHead(decThread) + dispatch.io.issuedCount >= ibDepth.U,
        ibHead(decThread) + dispatch.io.issuedCount - ibDepth.U,
        ibHead(decThread) + dispatch.io.issuedCount)
      ibHead(decThread) := newHead
      ibCount(decThread) := ibCount(decThread) - dispatch.io.issuedCount
    }
  }

  // Thread assignment for each pipeline stage (barrel).
  // ===================== Dispatch alignment (ID/DISP -> DISP/RR) =====================
  when(id_disp(dispThread).valid && !disp_rr(dispThread).valid) {
    disp_rr(dispThread) := id_disp(dispThread)
    id_disp(dispThread) := emptyPacket
  }

  // ===================== Register Read (DISP/RR -> RR/EX1) =====================
  regFile.io.writeThreadID := VecInit(Seq.fill(issueWidth)(0.U(threadBits.W)))
  regFile.io.dst := VecInit(Seq.fill(issueWidth)(0.U(5.W)))
  regFile.io.wen := VecInit(Seq.fill(issueWidth)(false.B))
  regFile.io.dstData := VecInit(Seq.fill(issueWidth)(0.U(32.W)))

  when(disp_rr(rrThread).valid && !rr_ex1(rrThread).valid) {
    for (i <- 0 until issueWidth) {
      val s = disp_rr(rrThread).slots(i)
      regFile.io.readThreadID(i) := disp_rr(rrThread).threadId
      regFile.io.src1(i) := s.rs1
      regFile.io.src2(i) := s.rs2
    }
    val pkt = WireDefault(0.U.asTypeOf(new StagePacket(threadBits, issueWidth)))
    pkt.valid := disp_rr(rrThread).valid
    pkt.threadId := disp_rr(rrThread).threadId
    for (i <- 0 until issueWidth) {
      val s = disp_rr(rrThread).slots(i)
      pkt.slots(i) := s
      pkt.slots(i).rs1Data := regFile.io.src1data(i)
      pkt.slots(i).rs2Data := regFile.io.src2data(i)
      when(s.valid) {
        debugIdRs1(disp_rr(rrThread).threadId) := regFile.io.src1data(i)
        debugIdRs2(disp_rr(rrThread).threadId) := regFile.io.src2data(i)
      }
    }
    rr_ex1(rrThread) := pkt
    disp_rr(rrThread) := emptyPacket
  } .otherwise {
    for (i <- 0 until issueWidth) {
      regFile.io.readThreadID(i) := 0.U
      regFile.io.src1(i) := 0.U
      regFile.io.src2(i) := 0.U
    }
  }

  // ===================== Execute 1 (RR/EX1 -> EX1/EX2) =====================
  val alus = Seq.fill(issueWidth)(Module(new ALU32))
  val branchUnit = Module(new BranchUnit)
  val loadUnit = Module(new LoadUnit()) // default 32b for data
  val storeUnit = Module(new StoreUnit)
  alus.foreach { a => a.io.a := 0.U; a.io.b := 0.U; a.io.opcode := 0.U }
  private val slotIdxBits = log2Ceil(issueWidth)

  val ex1ToNext = WireDefault(rr_ex1(ex1Thread))
  ex1ToNext.valid := rr_ex1(ex1Thread).valid

  val aluOutputs = Wire(Vec(issueWidth, UInt(32.W)))
  for (i <- 0 until issueWidth) {
    val s = rr_ex1(ex1Thread).slots(i)
    val useImm = s.isLoad || s.isStore || s.isJALR || (s.instr(6,0) === RV32IDecode.OP_I)
    val opA = Mux(s.isAUIPC, s.pc, Mux(s.isLUI, 0.U, s.rs1Data))
    val opB = Mux(s.isLUI, s.imm, Mux(useImm, s.imm, s.rs2Data))
    val eligible = s.valid && (s.isALU || s.isLoad || s.isStore || s.isAUIPC || s.isLUI || s.isJAL || s.isJALR)
    alus(i).io.a := opA
    alus(i).io.b := opB
    alus(i).io.opcode := s.aluOp
    aluOutputs(i) := Mux(eligible, alus(i).io.result, 0.U)
  }

  // First branch
  val branchVec = VecInit((0 until issueWidth).map(i => rr_ex1(ex1Thread).slots(i).valid && rr_ex1(ex1Thread).slots(i).isBranch))
  val hasBranch = branchVec.asUInt.orR
  val branchIdxN = PriorityEncoder(branchVec.asUInt)
  when(hasBranch) {
    val s = rr_ex1(ex1Thread).slots(branchIdxN)
    branchUnit.io.rs1 := s.rs1Data
    branchUnit.io.rs2 := s.rs2Data
    branchUnit.io.pc  := s.pc
    branchUnit.io.imm := s.imm.asSInt
    branchUnit.io.branchOp := s.instr(14,12)
    branchUnit.io.valid := s.valid
  } .otherwise {
    branchUnit.io.rs1 := 0.U; branchUnit.io.rs2 := 0.U; branchUnit.io.pc := 0.U
    branchUnit.io.imm := 0.S; branchUnit.io.branchOp := 0.U; branchUnit.io.valid := false.B
  }

  // Load/Store pick
  val loadVec  = VecInit((0 until issueWidth).map(i => rr_ex1(ex1Thread).slots(i).valid && rr_ex1(ex1Thread).slots(i).isLoad))
  val storeVec = VecInit((0 until issueWidth).map(i => rr_ex1(ex1Thread).slots(i).valid && rr_ex1(ex1Thread).slots(i).isStore))
  val hasLoad  = loadVec.asUInt.orR
  val hasStore = storeVec.asUInt.orR
  val loadIdxN  = PriorityEncoder(loadVec.asUInt)
  val storeIdxN = PriorityEncoder(storeVec.asUInt)
  when(hasLoad) {
    val s = rr_ex1(ex1Thread).slots(loadIdxN)
    loadUnit.io.addr := aluOutputs(loadIdxN)
    loadUnit.io.dataIn := io.dataMemResp
    loadUnit.io.funct3 := s.instr(14,12)
  } .otherwise {
    loadUnit.io.addr := 0.U; loadUnit.io.dataIn := 0.U; loadUnit.io.funct3 := 0.U
  }
  when(hasStore) {
    val s = rr_ex1(ex1Thread).slots(storeIdxN)
    storeUnit.io.addr := aluOutputs(storeIdxN)
    storeUnit.io.data := s.rs2Data
    storeUnit.io.storeType := s.instr(13,12)
  } .otherwise {
    storeUnit.io.addr := 0.U; storeUnit.io.data := 0.U; storeUnit.io.storeType := 0.U
  }

  // Branch/jump control
  for (i <- 0 until issueWidth) {
    val s = rr_ex1(ex1Thread).slots(i)
    val jalTaken  = s.valid && s.isJAL
    val jalrTaken = s.valid && s.isJALR
    val brTaken   = s.valid && s.isBranch && branchUnit.io.taken && hasBranch && (branchIdxN === i.U(slotIdxBits.W))
    val brTarget  = branchUnit.io.target
    val jalTarget = (s.pc.asSInt + s.imm.asSInt).asUInt
    val jalrTarget= ((s.rs1Data.asSInt + s.imm.asSInt).asUInt & ~1.U(32.W))
    val taken     = brTaken || jalTaken || jalrTaken
    val target    = Mux(brTaken, brTarget, Mux(jalTaken, jalTarget, jalrTarget))
    when(taken && io.threadEnable(rr_ex1(ex1Thread).threadId)) {
      pcRegs(rr_ex1(ex1Thread).threadId) := target
      flushThread(rr_ex1(ex1Thread).threadId) := true.B
      io.ctrlTaken := true.B
      io.ctrlThread := rr_ex1(ex1Thread).threadId
      io.ctrlFromPC := s.pc
      io.ctrlTarget := target
      io.ctrlIsBranch := brTaken
      io.ctrlIsJal := jalTaken
      io.ctrlIsJalr := jalrTaken
    }
  }

  when(rr_ex1(ex1Thread).valid && !ex1_ex2(ex1Thread).valid) {
    for (i <- 0 until issueWidth) {
      ex1ToNext.slots(i).aluResult := aluOutputs(i)
    }
    ex1_ex2(ex1Thread) := ex1ToNext
    rr_ex1(ex1Thread) := emptyPacket
  }

  // ===================== Execute2 (EX1/EX2 -> EX2/EX3) =====================
  when(ex1_ex2(ex2Thread).valid && !ex2_ex3(ex2Thread).valid) {
    ex2_ex3(ex2Thread) := ex1_ex2(ex2Thread)
    ex1_ex2(ex2Thread) := emptyPacket
  }

  // ===================== Execute3 (EX2/EX3 -> EX3/WB) =====================
  when(ex2_ex3(ex3Thread).valid && !ex3_wb(ex3Thread).valid) {
    val pkt = Wire(new StagePacket(threadBits, issueWidth))
    pkt := ex2_ex3(ex3Thread)
    pkt.valid := ex2_ex3(ex3Thread).valid
    for (i <- 0 until issueWidth) {
      val s = ex2_ex3(ex3Thread).slots(i)
      pkt.slots(i).memRdata := Mux(s.valid && s.isLoad, loadUnit.io.dataOut, s.memRdata)
      when(s.valid) { debugExAlu(ex2_ex3(ex3Thread).threadId) := s.aluResult }
      when(s.valid && s.isLoad) { debugMemLoad(ex2_ex3(ex3Thread).threadId) := pkt.slots(i).memRdata }
    }
    ex3_wb(ex3Thread) := pkt
    ex2_ex3(ex3Thread) := emptyPacket
  }

  // ===================== Memory interface =====================
  val storeActive = hasStore && rr_ex1(ex1Thread).slots(storeIdxN).valid && io.threadEnable(rr_ex1(ex1Thread).threadId)
  val loadActive  = hasLoad  && rr_ex1(ex1Thread).slots(loadIdxN).valid  && io.threadEnable(rr_ex1(ex1Thread).threadId)
  io.memAddr := Mux(storeActive, storeUnit.io.addr, Mux(loadActive, loadUnit.io.addr, 0.U))
  io.memWrite := Mux(storeActive, storeUnit.io.memWrite, 0.U)
  io.memMask := Mux(storeActive, storeUnit.io.mask, 0.U)
  io.memMisaligned := storeActive && storeUnit.io.misaligned

  // ===================== Writeback (EX3/WB -> RF) =====================
  val wbUnit = Module(new WritebackUnit(threadBits = threadBits, issueWidth = issueWidth, maxWrites = issueWidth))
  val wbSlots = Wire(Vec(issueWidth, new WritebackSlot(threadBits)))
  for (i <- 0 until issueWidth) {
    val s = ex3_wb(wbThread).slots(i)
    val pcPlus4 = s.pc + 4.U
    val auipcVal= s.pc + s.imm
    val data = WireDefault(s.aluResult)
    when(s.isLoad)     { data := s.memRdata }
    .elsewhen(s.isLUI) { data := s.imm }
    .elsewhen(s.isAUIPC){ data := auipcVal }
    .elsewhen(s.isJAL || s.isJALR) { data := pcPlus4 }
    wbSlots(i).valid := ex3_wb(wbThread).valid && s.valid
    wbSlots(i).rd := s.rd
    wbSlots(i).data := data
    wbSlots(i).threadId := ex3_wb(wbThread).threadId
    wbSlots(i).writeEn := (s.isALU || s.isLoad || s.isLUI || s.isAUIPC || s.isJAL || s.isJALR) && s.rd =/= 0.U
    when(ex3_wb(wbThread).valid && s.valid && io.threadEnable(ex3_wb(wbThread).threadId) && s.rd <= 4.U && wbSlots(i).writeEn) {
      debugRegsSmall(ex3_wb(wbThread).threadId)(s.rd(2,0)) := data
    }
  }
  wbUnit.io.inSlots := wbSlots
  wbUnit.io.threadEnable := VecInit(Seq.fill(issueWidth)(io.threadEnable(ex3_wb(wbThread).threadId)))
  regFile.io.writeThreadID := wbUnit.io.threadId
  regFile.io.dst := wbUnit.io.dst
  regFile.io.wen := wbUnit.io.wen
  regFile.io.dstData := wbUnit.io.data

  when(ex3_wb(wbThread).valid) {
    ex3_wb(wbThread) := emptyPacket
  }

  // Clear flush flag when the flushed thread reaches writeback
  when(ex3_wb(wbThread).valid && flushThread(ex3_wb(wbThread).threadId)) {
    flushThread(ex3_wb(wbThread).threadId) := false.B
  }

  // ===================== Expose Pipeline State =====================
  io.if_pc := pcRegs
  io.if_instr := debugIfInstr
  io.id_rs1Data := debugIdRs1
  io.id_rs2Data := debugIdRs2
  io.ex_aluResult := debugExAlu
  io.mem_loadData := debugMemLoad
  io.debugRegX1 := regFile.io.debugX1
  io.debugRegs01234 := debugRegsSmall
  io.debugPC := pcRegs

  io.debugIbCount := ibCount(threadSel)
  io.debugIbThread := threadSel
  io.debugIbValid := ibCount(threadSel) =/= 0.U
  io.debugPipeValid := VecInit(Seq(id_disp(decThread).valid, disp_rr(dispThread).valid, rr_ex1(rrThread).valid, ex1_ex2(ex2Thread).valid, ex2_ex3(ex3Thread).valid, ex3_wb(wbThread).valid))
  io.debugPipeThread := VecInit(Seq(decThread, dispThread, rrThread, ex2Thread, ex3Thread, wbThread))
}
