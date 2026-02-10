package OctoNyte

import chisel3._
import chisel3.util._

case class CacheParams(
  capacityBytes: Int = 4096,
  blockBytes: Int = 64,
  dataWidth: Int = 32,
  addrWidth: Int = 32
) {
  def indexBits = log2Ceil(capacityBytes / blockBytes)
  def offsetBits = log2Ceil(blockBytes)
  def tagBits = addrWidth - indexBits - offsetBits
  def lines = capacityBytes / blockBytes
}

class ICacheReq(val addrWidth: Int) extends Bundle {
  val addr = UInt(addrWidth.W)
}

class ICacheResp(val dataWidth: Int) extends Bundle {
  val data = UInt(dataWidth.W)
}

class MemReq(val addrWidth: Int) extends Bundle {
  val addr = UInt(addrWidth.W)
  val burst = Bool()
}

class MemResp(val blockBytes: Int) extends Bundle {
  val data = UInt((blockBytes * 8).W)
}

class ICacheIO(val params: CacheParams) extends Bundle {
  val cpu = new Bundle {
    val req = Flipped(Decoupled(new ICacheReq(params.addrWidth)))
    val resp = Valid(new ICacheResp(params.dataWidth))
  }
  
  val mem = new Bundle {
    val req = Decoupled(new MemReq(params.addrWidth))
    val resp = Flipped(Decoupled(new MemResp(params.blockBytes)))
  }
}

class ICache(val params: CacheParams) extends Module {
  val io = IO(new ICacheIO(params))

  val tagArray = SyncReadMem(params.lines, UInt(params.tagBits.W))
  val validArray = RegInit(VecInit(Seq.fill(params.lines)(false.B)))
  val dataArray = SyncReadMem(params.lines, UInt((params.blockBytes * 8).W))

  val sIdle :: sCompare :: sRefill :: sWaitResp :: sReplay :: Nil = Enum(5)
  val state = RegInit(sIdle)

  // Request registers
  val reqAddrReg = Reg(UInt(params.addrWidth.W))
  val reqValidReg = RegInit(false.B)

  def getTag(addr: UInt) = addr(params.addrWidth - 1, params.addrWidth - params.tagBits)
  def getIndex(addr: UInt) = addr(params.addrWidth - params.tagBits - 1, params.offsetBits)
  def getOffset(addr: UInt) = addr(params.offsetBits - 1, 0)

  // Pipeline registers for readout
  val tagRead = Wire(UInt(params.tagBits.W))
  val dataRead = Wire(UInt((params.blockBytes * 8).W))
  
  val indexReg = Reg(UInt(params.indexBits.W))
  val tagReg = Reg(UInt(params.tagBits.W))
  val offsetReg = Reg(UInt(params.offsetBits.W))

  // Determine if we should read
  val doRead = Wire(Bool())
  val readIndex = Wire(UInt(params.indexBits.W))

  // Default assignments
  doRead := false.B
  readIndex := 0.U
  
  // CPU Ready
  val isHitInCompare = (state === sCompare) && (validArray(indexReg)) && (tagRead === tagReg)
  val canAcceptCpu = (state === sIdle) || (state === sCompare && isHitInCompare)

  io.cpu.req.ready := canAcceptCpu

  // Logic to fire read
  when (canAcceptCpu && io.cpu.req.valid) {
    doRead := true.B
    readIndex := getIndex(io.cpu.req.bits.addr)
    // Latch request
    reqAddrReg := io.cpu.req.bits.addr
    reqValidReg := true.B
    
    // For next stage
    indexReg := getIndex(io.cpu.req.bits.addr)
    tagReg := getTag(io.cpu.req.bits.addr)
    offsetReg := getOffset(io.cpu.req.bits.addr)
    
    state := sCompare
  } .elsewhen (state === sReplay) {
    // Replay after refill
    doRead := true.B
    readIndex := getIndex(reqAddrReg)
    
    indexReg := getIndex(reqAddrReg)
    tagReg := getTag(reqAddrReg)
    offsetReg := getOffset(reqAddrReg)
    
    state := sCompare
  }

  // Memory Read
  val memReadAddr = Mux(state === sReplay, getIndex(reqAddrReg), getIndex(io.cpu.req.bits.addr))
  // SyncReadMem read logic
  tagRead := tagArray.read(memReadAddr, doRead)
  dataRead := dataArray.read(memReadAddr, doRead)

  // Compare Logic
  val isHit  = (validArray(indexReg)) && (tagRead === tagReg)
  val isMiss = !isHit

  // Data Select
  val wordOffsetInBits = Cat(offsetReg(params.offsetBits - 1, 2), 0.U(5.W))
  io.cpu.resp.bits.data := (dataRead >> wordOffsetInBits)(params.dataWidth-1, 0)
  
  // Output Valid
  io.cpu.resp.valid := (state === sCompare) && isHit && reqValidReg

  // Refill Logic
  io.mem.req.valid := false.B
  io.mem.req.bits.addr := 0.U
  io.mem.req.bits.burst := false.B
  io.mem.resp.ready := false.B

  switch(state) {
    is(sIdle) {
       when(!canAcceptCpu && !io.cpu.req.valid) {
         reqValidReg := false.B
       }
    }
    is(sCompare) {
       when(reqValidReg) {
         when(isMiss) {
           state := sRefill
         } .otherwise {
           // Hit. 
           when(!io.cpu.req.valid) {
             state := sIdle
             reqValidReg := false.B
           }
         }
       }
    }
    is(sRefill) {
       val blockAddr = Cat(tagReg, indexReg, 0.U(params.offsetBits.W))
       io.mem.req.valid := true.B
       io.mem.req.bits.addr := blockAddr
       io.mem.req.bits.burst := true.B
       
       when(io.mem.req.fire) {
         state := sWaitResp
       }
    }
    is(sWaitResp) {
       io.mem.resp.ready := true.B
       when(io.mem.resp.fire) {
         tagArray.write(indexReg, tagReg)
         dataArray.write(indexReg, io.mem.resp.bits.data)
         validArray(indexReg) := true.B
         state := sReplay
       }
    }
    is(sReplay) {
      // Transitions to sCompare via doRead block
    }
  }
}
