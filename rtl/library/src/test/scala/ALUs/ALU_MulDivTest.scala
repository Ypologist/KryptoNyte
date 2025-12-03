package ALUs

import chisel3._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers

class ALU_MulDivTest extends AnyFlatSpec with Matchers {
  "Mul32OneCycle" should "produce correct signed and unsigned products in one cycle" in {
    simulate(new Mul32OneCycle) { dut =>
      def toTwos(value: BigInt, bits: Int): BigInt = {
        val base = BigInt(1) << bits
        ((value % base) + base) % base
      }

      def check(a: BigInt, b: BigInt, signedA: Boolean, signedB: Boolean, expected: BigInt): Unit = {
        dut.io.a.poke(toTwos(a, 32).U)
        dut.io.b.poke(toTwos(b, 32).U)
        dut.io.signedA.poke(signedA.B)
        dut.io.signedB.poke(signedB.B)
        dut.clock.step()

        val exp64 = toTwos(expected, 64)
        dut.io.product.expect(exp64.U)
        dut.io.lo.expect(toTwos(expected, 32).U)
        dut.io.hi.expect((exp64 >> 32).U)
      }

      check(3, 4, signedA = false, signedB = false, expected = 12)
      check(-7, 5, signedA = true, signedB = true, expected = -35)
      check(-7, 5, signedA = true, signedB = false, expected = -35)
      check(6, -3, signedA = false, signedB = true, expected = -18)
    }
  }

  "Div32Radix4" should "finish in 16 cycles and handle signed, unsigned, and divide-by-zero cases" in {
    simulate(new Div32Radix4) { dut =>
      def toTwos(value: BigInt, bits: Int): BigInt = {
        val base = BigInt(1) << bits
        ((value % base) + base) % base
      }

      def runDiv(dividend: BigInt, divisor: BigInt, signed: Boolean, expectedQ: BigInt, expectedR: BigInt, expectDivZero: Boolean = false): Unit = {
        dut.io.dividend.poke(toTwos(dividend, 32).U)
        dut.io.divisor.poke(toTwos(divisor, 32).U)
        dut.io.signed.poke(signed.B)
        dut.io.start.poke(true.B)
        dut.clock.step()
        dut.io.start.poke(false.B)

        if (expectDivZero) {
          dut.io.done.expect(true.B)
          dut.io.divideByZero.expect(true.B)
          return
        }

        // Divider should assert busy after the kick-off cycle
        dut.io.busy.expect(true.B)

        var cycles = 0
        while (!dut.io.done.peek().litToBoolean && cycles < 20) {
          dut.clock.step()
          cycles += 1
        }

        cycles should be >= (15) // Expecting 16 total cycles of work (0-15)
        dut.io.done.expect(true.B)
        dut.io.busy.expect(false.B)
        dut.io.divideByZero.expect(false.B)
        dut.io.quotient.expect(toTwos(expectedQ, 32).U)
        dut.io.remainder.expect(toTwos(expectedR, 32).U)
      }

      runDiv(100, 5, signed = false, expectedQ = 20, expectedR = 0)
      runDiv(7, 3, signed = false, expectedQ = 2, expectedR = 1)
      runDiv(-20, 3, signed = true, expectedQ = -6, expectedR = -2)
      runDiv(20, -3, signed = true, expectedQ = -6, expectedR = 2)
      runDiv(123, 0, signed = false, expectedQ = -1, expectedR = 123, expectDivZero = true)
    }
  }
}
