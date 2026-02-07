package OctoNyte

import chisel3._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.flatspec.AnyFlatSpec
import chisel3.util._

class ICacheTest extends AnyFlatSpec {
  behavior of "ICache"

  it should "handle miss and refill, then hit" in {
    simulate(new ICache(CacheParams(capacityBytes = 256, blockBytes = 16))) { dut => // Small cache for testing
      
      // Initial state
      dut.io.cpu.req.valid.poke(false.B)
      dut.io.mem.resp.valid.poke(false.B)
      dut.clock.step()

      // 1. Send Request for Address 0x100
      dut.io.cpu.req.bits.addr.poke(0x100.U)
      dut.io.cpu.req.valid.poke(true.B)
      
      // Wait for Ready (Should be ready in Idle)
      assert(dut.io.cpu.req.ready.peek().litToBoolean)
      
      dut.clock.step()
      // Cycle 1: Cache is now in Compare. 
      // Tag mismatch (valid bit is 0). Should go to Refill.
      
      dut.io.cpu.req.valid.poke(false.B) // Request is captured
      
      // Check IOs
      dut.clock.step() 
      // Cycle 2: sRefill. mem.req should be valid.
      assert(dut.io.mem.req.valid.peek().litToBoolean)
      val reqAddr = dut.io.mem.req.bits.addr.peek().litValue
      // Address should be block aligned. 0x100 is aligned to 16 bytes.
      assert(reqAddr == 0x100)
      
      // Acknowledge Mem Req
      dut.io.mem.req.ready.poke(true.B)
      dut.clock.step()
      dut.io.mem.req.ready.poke(false.B)
      
      // Cycle 3: sWaitResp. Waiting for data.
      dut.io.mem.resp.valid.poke(true.B)
      // Data: 16 bytes. 128 bits. 
      // 0x112233445566778899AABBCCDDEEFF00
      // LSB (Byte 0) is 00.
      // Byte 1 is FF.
      // Byte 2 is EE.
      // Byte 3 is DD.
      // Byte 4 is CC.
      val data = BigInt("112233445566778899AABBCCDDEEFF00", 16)
      dut.io.mem.resp.bits.data.poke(data.U)
      
      dut.clock.step()
      
      // Cycle 4: sReplay. Data written. Logic transitions to Compare.
      dut.io.mem.resp.valid.poke(false.B)
      
      dut.clock.step()
      
      // Cycle 5: sCompare. Should be a Hit now.
      // Address 0x100 -> Offset 0.
      // We expect [Byte3, Byte2, Byte1, Byte0] = DD EE FF 00 -> 0xDDEEFF00
      
      assert(dut.io.cpu.resp.valid.peek().litToBoolean)
      val respData = dut.io.cpu.resp.bits.data.peek().litValue
      assert(respData == 0xDDEEFF00L) 
      
      // Now let's try another read to same block (Hit)
      // Address 0x104 (Offset 4)
      dut.io.cpu.req.bits.addr.poke(0x104.U)
      dut.io.cpu.req.valid.poke(true.B)
      // Check ready is high (pipelined hit support)
      assert(dut.io.cpu.req.ready.peek().litToBoolean)
      
      dut.clock.step()
      
      // Next cycle: Result for 0x104
      // Bytes at offset 4: [Byte7, Byte6, Byte5, Byte4]
      // Byte 4 is CC.
      // Byte 5 is BB.
      // Byte 6 is AA.
      // Byte 7 is 99.
      // Expected: 0x99AABBCC
      assert(dut.io.cpu.resp.valid.peek().litToBoolean)
      val respData2 = dut.io.cpu.resp.bits.data.peek().litValue
      assert(respData2 == 0x99AABBCCL)
    }
  }
}
