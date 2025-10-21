package zeronyte.rv32i

import chisel3._
import chiseltest._
import org.scalatest.freespec.AnyFreeSpec
import org.scalatest.matchers.should.Matchers

// Replace this stub with your actual ALU import.
// For example: import zeronyte.core.ALU32
class ALU32 extends Module {
  val io = IO(new Bundle {
    val op  = Input(UInt(4.W))   // Adjust width based on your ALU control signal
    val a   = Input(UInt(32.W))
    val b   = Input(UInt(32.W))
    val out = Output(UInt(32.W))
  })
  io.out := 0.U
}

// Replace these opcodes with your real ALU control encoding
object ALUOps {
  val ADD = "b0000".U
  val SUB = "b0001".U
}

// Reference (Golden Model) for arithmetic operations
object Ref32 {
  @inline private def toU32(x: Long) = x & 0xFFFFFFFFL
  @inline private def toS32(x: Long) = x.toInt
  def add(a: Long, b: Long): Long = toU32(toS32(a) + toS32(b))
  def sub(a: Long, b: Long): Long = toU32(toS32(a) - toS32(b))
  def sext12(i: Int): Int = (i << 20) >> 20 // 12-bit sign extension (for ADDI)
}

final case class Pair(a: Long, b: Long)

class ZeroNyteArithmeticSpec extends AnyFreeSpec with ChiselScalatestTester with Matchers {

  private def runWith(dut: ALU32)(op: UInt, a: Long, b: Long, expected: Long): Unit = {
    dut.io.op.poke(op)
    dut.io.a.poke((a & 0xFFFFFFFFL).U)
    dut.io.b.poke((b & 0xFFFFFFFFL).U)
    dut.clock.step()
    dut.io.out.expect((expected & 0xFFFFFFFFL).U)
  }

  "ADD and SUB arithmetic tests" in {
    test(new ALU32).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      val edgeCases = Seq(
        Pair(0x00000000L, 0x00000000L), // 0 + 0
        Pair(0x00000001L, 0xFFFFFFFFL), // 1 + (-1)
        Pair(0x7FFFFFFFL, 0x00000001L), // overflow wrap
        Pair(0x80000000L, 0xFFFFFFFFL), // negative addition
        Pair(0x12345678L, 0x11111111L), // random
        Pair(0xFFFFFFFFL, 0xFFFFFFFFL)  // (-1) + (-1)
      )

      for (p <- edgeCases) {
        runWith(dut)(ALUOps.ADD, p.a, p.b, Ref32.add(p.a, p.b))
        runWith(dut)(ALUOps.SUB, p.a, p.b, Ref32.sub(p.a, p.b))
      }

      // Randomized arithmetic test
      val rand = new scala.util.Random(0xCAFEBABE)
      for (_ <- 0 until 100) {
        val a = rand.nextInt()
        val b = rand.nextInt()
        runWith(dut)(ALUOps.ADD, a, b, Ref32.add(a, b))
        runWith(dut)(ALUOps.SUB, a, b, Ref32.sub(a, b))
      }
    }
  }

  "ADDI (immediate arithmetic) tests" in {
    test(new ALU32).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      val rs1Vals = Seq(0, 1, -1, 0x7FFFFFFF, 0x80000000, 0x12345678)
      val immVals = Seq(0, 1, -1, 0x7FF, -0x800, 100, -100)

      for (a <- rs1Vals; i <- immVals) {
        val A = a & 0xFFFFFFFFL
        val I = Ref32.sext12(i) & 0xFFFFFFFFL
        runWith(dut)(ALUOps.ADD, A, I, Ref32.add(A, I)) // simulate ADDI as ADD(rs1, imm)
      }
    }
  }
}
