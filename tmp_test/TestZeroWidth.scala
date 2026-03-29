import chisel3._
class TestZeroWidth(val enable: Boolean) extends Module {
  val io = IO(new Bundle {
    val in = Input(UInt(32.W))
    val out = Output(UInt(if(enable) 32.W else 0.W))
  })
  io.out := io.in
}
object Main extends App {
  import circt.stage.ChiselStage
  println(ChiselStage.emitSystemVerilog(new TestZeroWidth(false)))
}
