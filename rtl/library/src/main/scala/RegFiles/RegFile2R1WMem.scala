// Licensed under the BSD 3-Clause License. 
// See https://opensource.org/licenses/BSD-3-Clause for details.

package RegFiles

import chisel3._
import chisel3.util._

/**
  * An explicitly instantiated 2-read, 1-write single-threaded version of the parameterized
  * memory-based register file (`RegFileMTMem`).
  * 
  * It inherits the vectorized IO bundle (`readAddrs`, `writeAddrs`, `readData`, etc.)
  * from the base generator class.
  */
class RegFile2R1WMem(width: Int = 32, depth: Int = 32) 
  extends RegFileMTMem(width, depth, numThreads = 1, numReadPorts = 2, numWritePorts = 1)
