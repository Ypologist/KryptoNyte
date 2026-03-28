package TetraNyte

import chisel3._
import chisel3.util._

class ICacheConfig(val cacheBytes: Int, val blockBytes: Int, val ways: Int)

class ICacheIO extends Bundle {
  // CPU side
  val pc        = Input(UInt(32.W))
  val pc_valid  = Input(Bool())
  val instr     = Output(UInt(32.W))
  val instr_valid = Output(Bool())
  val stall     = Output(Bool())

  // Memory side
  val mem_addr  = Output(UInt(32.W))
  val mem_rdata = Input(UInt(32.W))
  val mem_rvalid= Input(Bool())
}

class ICache(cfg: ICacheConfig) extends Module {
  val io = IO(new ICacheIO)

  require(cfg.blockBytes >= 4 && (cfg.blockBytes & (cfg.blockBytes - 1)) == 0, "blockBytes must be power of two")
  require(cfg.cacheBytes % (cfg.blockBytes * cfg.ways) == 0, "cacheBytes must be divisible by blockBytes*ways")

  val sets = cfg.cacheBytes / (cfg.blockBytes * cfg.ways)
  val offBits = log2Ceil(cfg.blockBytes)
  val idxBits = if (sets > 1) log2Ceil(sets) else 0
  val wayBits = if (cfg.ways > 1) log2Ceil(cfg.ways) else 1
  val tagBits = 32 - offBits - idxBits
  val wordsPerLine = cfg.blockBytes / 4

  // storage: [sets][ways][words]
  val data = RegInit(VecInit(Seq.fill(sets)(VecInit(Seq.fill(cfg.ways)(VecInit(Seq.fill(wordsPerLine)(0.U(32.W))))))))

  val tagArray = RegInit(VecInit(Seq.fill(sets)(VecInit(Seq.fill(cfg.ways)(0.U(tagBits.W))))))
  val valid    = RegInit(VecInit(Seq.fill(sets)(VecInit(Seq.fill(cfg.ways)(false.B)))))
  val age      = RegInit(VecInit(Seq.fill(sets)(VecInit(Seq.fill(cfg.ways)(0.U(32.W))))))

  val globalTime = RegInit(0.U(32.W))
  globalTime := globalTime + 1.U

  // decode
  val blockAddr = io.pc >> offBits
  val idx = if (sets > 1) blockAddr(idxBits - 1, 0) else 0.U
  val tag = blockAddr >> idxBits
  val wordOffset = io.pc(offBits - 1, 2)

  val blockBase = Cat(io.pc(31, offBits), 0.U(offBits.W))
  val wordByteAddr = (blockBase + (wordOffset << 2))(31,0)

  // hit detection
  val hit = WireInit(false.B)
  val hitWay = WireInit(0.U(wayBits.W))
  for (w <- 0 until cfg.ways) {
    when(valid(idx)(w) && tagArray(idx)(w) === tag) {
      hit := true.B
      hitWay := w.U
    }
  }

  // victim selection: prefer invalid, otherwise LRU via age
  val invalidMask = Wire(Vec(cfg.ways, Bool()))
  for (w <- 0 until cfg.ways) invalidMask(w) := !valid(idx)(w)
  val anyInvalid = invalidMask.asUInt.orR
  val firstInvalid = PriorityEncoder(invalidMask.asUInt)

  val minIdxWire = Wire(UInt(wayBits.W))
  val minAgeWire = Wire(UInt(32.W))
  minIdxWire := 0.U
  minAgeWire := age(idx)(0)
  for (w <- 1 until cfg.ways) {
    when(age(idx)(w) < minAgeWire) {
      minAgeWire := age(idx)(w)
      minIdxWire := w.U
    }
  }
  val victim = Mux(anyInvalid, firstInvalid, minIdxWire)

  // FSM
  val sIdle :: sMiss :: sFill :: Nil = Enum(3)
  val state = RegInit(sIdle)
  val fillCnt = RegInit(0.U(log2Ceil(wordsPerLine + 1).W))

  // Latch critical block selection state so the FSM can tolerate changes on `io.pc` from other threads during a miss
  val latchedBlockBase = RegInit(0.U(32.W))
  val latchedIdx = RegInit(0.U(idxBits.max(1).W))
  val latchedTag = RegInit(0.U(tagBits.max(1).W))
  val latchedVictim = RegInit(0.U(wayBits.max(1).W))

  // defaults
  io.instr := 0.U
  io.instr_valid := false.B
  io.stall := (state =/= sIdle)
  io.mem_addr := wordByteAddr

  when(state === sIdle && io.pc_valid) {
    when(hit) {
      io.instr := data(idx)(hitWay)(wordOffset)
      io.instr_valid := true.B
      age(idx)(hitWay) := globalTime
      state := sIdle
    } .elsewhen(io.mem_rvalid) {
      // fast path combinational memory: install single word but don't mark whole line valid
      data(idx)(victim)(wordOffset) := io.mem_rdata
      io.instr := io.mem_rdata
      io.instr_valid := true.B
      state := sIdle
    } .otherwise {
      state := sMiss
      fillCnt := 0.U
      latchedBlockBase := blockBase
      // Fallbacks if single set or single way
      if (idxBits > 0) latchedIdx := idx else latchedIdx := 0.U
      if (tagBits > 0) latchedTag := tag else latchedTag := 0.U
      if (wayBits > 0) latchedVictim := victim else latchedVictim := 0.U
    }
  }

  when(state === sMiss) {
    io.mem_addr := latchedBlockBase
    state := sFill
    fillCnt := 0.U
  }

  when(state === sFill) {
    io.mem_addr := (latchedBlockBase + (fillCnt << 2))(31,0)
    when(io.mem_rvalid) {
      if (idxBits > 0 && wayBits > 0) data(latchedIdx)(latchedVictim)(fillCnt) := io.mem_rdata
      else if (idxBits > 0) data(latchedIdx)(0)(fillCnt) := io.mem_rdata
      else if (wayBits > 0) data(0)(latchedVictim)(fillCnt) := io.mem_rdata
      else data(0)(0)(fillCnt) := io.mem_rdata

      fillCnt := fillCnt + 1.U
      when(fillCnt === (wordsPerLine - 1).U) {
        if (idxBits > 0 && wayBits > 0) { valid(latchedIdx)(latchedVictim) := true.B; tagArray(latchedIdx)(latchedVictim) := latchedTag; age(latchedIdx)(latchedVictim) := globalTime }
        else if (idxBits > 0) { valid(latchedIdx)(0) := true.B; tagArray(latchedIdx)(0) := latchedTag; age(latchedIdx)(0) := globalTime }
        else if (wayBits > 0) { valid(0)(latchedVictim) := true.B; tagArray(0)(latchedVictim) := latchedTag; age(0)(latchedVictim) := globalTime }
        else { valid(0)(0) := true.B; tagArray(0)(0) := latchedTag; age(0)(0) := globalTime }

        state := sIdle
        fillCnt := 0.U
      }
    }
  }
}