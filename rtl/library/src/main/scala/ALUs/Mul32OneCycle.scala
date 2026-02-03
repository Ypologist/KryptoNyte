package ALUs

import chisel3._

class Mul32OneCycle extends Module {
  val io = IO(new Bundle {
    val a = Input(UInt(32.W))
    val b = Input(UInt(32.W))
    val signedA = Input(Bool())
    val signedB = Input(Bool())
    val product = Output(UInt(64.W))
    val lo = Output(UInt(32.W))
    val hi = Output(UInt(32.W))
  })

  val aExt = Wire(SInt(64.W))
  val bExt = Wire(SInt(64.W))
  aExt := Mux(io.signedA, io.a.asSInt, io.a.zext)
  bExt := Mux(io.signedB, io.b.asSInt, io.b.zext)

  val prod = (aExt * bExt).asUInt
  val prod64 = prod(63, 0)

  io.product := prod64
  io.lo := prod64(31, 0)
  io.hi := prod64(63, 32)
}
