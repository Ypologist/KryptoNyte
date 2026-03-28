// Licensed under the BSD 3-Clause License. 
// See https://opensource.org/licenses/BSD-3-Clause for details.

package RegFiles

import chisel3._

/**
  * An explicitly instantiated 8-read, 4-write version of the parameterized
  * memory-based multithreaded register file for a 4-issue superscalar processor.
  */
class RegFileMT8R4WMem(width: Int = 32, depth: Int = 32, numThreads: Int = 4) 
  extends RegFileMTMem(width, depth, numThreads, numReadPorts = 8, numWritePorts = 4)
