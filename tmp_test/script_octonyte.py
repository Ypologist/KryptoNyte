import os
import glob
import re

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    # Skip if already modified
    if "val cosimulate: Boolean" in content:
        print(f"Skipping {filepath}, already modified.")
        return

    # Replace IO class constructor
    content = re.sub(
        r'class (OctoNyte\w+IO)\(val numThreads: Int, val fetchWidth: Int\) extends Bundle \{',
        r'class \1(val numThreads: Int, val fetchWidth: Int, val cosimulate: Boolean = false) extends Bundle {',
        content
    )

    # Replace Module constructor
    content = re.sub(
        r'class (OctoNyte\w+) extends Module \{',
        r'class \1(val cosimulate: Boolean = false) extends Module {',
        content
    )

    # Replace io instantiation
    content = re.sub(
        r'val io = IO\(new (OctoNyte\w+IO)\(numThreads, fetchWidth\)\)',
        r'val io = IO(new \1(numThreads, fetchWidth, cosimulate))\n  io.jtag_tdo := 0.U',
        content
    )

    # Handle flat array types (e.g. debugRegs01234, debugStageThreads)
    # val debugStageThreads = Output(Vec(8, UInt(threadBits.W)))
    content = re.sub(
        r'val debugStageThreads = Output\(Vec\(8, UInt\(threadBits\.W\)\)\)',
        r'val debugStageThreads = Output(Vec(8, UInt((if(cosimulate) threadBits else 0).W)))',
        content
    )
    content = re.sub(
        r'val debugStageValids\s*=\s*Output\(Vec\(8, Bool\(\)\)\)',
        r'val debugStageValids  = Output(Vec(8, UInt((if(cosimulate) 1 else 0).W)))',
        content
    )
    content = re.sub(
        r'val debugPC\s*=\s*Output\(Vec\(numThreads, UInt\(32\.W\)\)\)',
        r'val debugPC           = Output(Vec(numThreads, UInt((if(cosimulate) 32 else 0).W)))',
        content
    )
    content = re.sub(
        r'val debugRegs01234\s*=\s*Output\(Vec\(numThreads, Vec\(5, UInt\(32\.W\)\)\)\)',
        r'val debugRegs01234    = Output(Vec(numThreads, Vec(5, UInt((if(cosimulate) 32 else 0).W))))',
        content
    )
    content = re.sub(
        r'val debugRegX1\s*=\s*Output\(Vec\(numThreads, UInt\(32\.W\)\)\)',
        r'val debugRegX1        = Output(Vec(numThreads, UInt((if(cosimulate) 32 else 0).W)))',
        content
    )

    # Debug Ctrl/Exec widths
    content = re.sub(r'val debugCtrlValid    = Output\(Bool\(\)\)', r'val debugCtrlValid    = Output(UInt((if(cosimulate) 1 else 0).W))', content)
    content = re.sub(r'val debugCtrlInstr    = Output\(UInt\(32\.W\)\)', r'val debugCtrlInstr    = Output(UInt((if(cosimulate) 32 else 0).W))', content)
    content = re.sub(r'val debugCtrlTaken    = Output\(Bool\(\)\)', r'val debugCtrlTaken    = Output(UInt((if(cosimulate) 1 else 0).W))', content)
    content = re.sub(r'val debugCtrlThread   = Output\(UInt\(threadBits\.W\)\)', r'val debugCtrlThread   = Output(UInt((if(cosimulate) threadBits else 0).W))', content)
    content = re.sub(r'val debugCtrlFromPC   = Output\(UInt\(32\.W\)\)', r'val debugCtrlFromPC   = Output(UInt((if(cosimulate) 32 else 0).W))', content)
    content = re.sub(r'val debugCtrlTarget   = Output\(UInt\(32\.W\)\)', r'val debugCtrlTarget   = Output(UInt((if(cosimulate) 32 else 0).W))', content)
    content = re.sub(r'val debugCtrlIsBranch = Output\(Bool\(\)\)', r'val debugCtrlIsBranch = Output(UInt((if(cosimulate) 1 else 0).W))', content)
    content = re.sub(r'val debugCtrlIsJal    = Output\(Bool\(\)\)', r'val debugCtrlIsJal    = Output(UInt((if(cosimulate) 1 else 0).W))', content)
    content = re.sub(r'val debugCtrlIsJalr   = Output\(Bool\(\)\)', r'val debugCtrlIsJalr   = Output(UInt((if(cosimulate) 1 else 0).W))', content)

    content = re.sub(r'val debugExecValid    = Output\(Bool\(\)\)', r'val debugExecValid    = Output(UInt((if(cosimulate) 1 else 0).W))', content)
    content = re.sub(r'val debugExecThread   = Output\(UInt\(threadBits\.W\)\)', r'val debugExecThread   = Output(UInt((if(cosimulate) threadBits else 0).W))', content)
    content = re.sub(r'val debugExecPC       = Output\(UInt\(32\.W\)\)', r'val debugExecPC       = Output(UInt((if(cosimulate) 32 else 0).W))', content)
    content = re.sub(r'val debugExecInstr    = Output\(UInt\(32\.W\)\)', r'val debugExecInstr    = Output(UInt((if(cosimulate) 32 else 0).W))', content)
    content = re.sub(r'val debugExecIsBranch = Output\(Bool\(\)\)', r'val debugExecIsBranch = Output(UInt((if(cosimulate) 1 else 0).W))', content)
    content = re.sub(r'val debugExecIsJal    = Output\(Bool\(\)\)', r'val debugExecIsJal    = Output(UInt((if(cosimulate) 1 else 0).W))', content)
    content = re.sub(r'val debugExecIsJalr   = Output\(Bool\(\)\)', r'val debugExecIsJalr   = Output(UInt((if(cosimulate) 1 else 0).W))', content)
    content = re.sub(r'val debugExecBranchOp = Output\(UInt\(3\.W\)\)', r'val debugExecBranchOp = Output(UInt((if(cosimulate) 3 else 0).W))', content)
    content = re.sub(r'val debugExecRs1      = Output\(UInt\(32\.W\)\)', r'val debugExecRs1      = Output(UInt((if(cosimulate) 32 else 0).W))', content)
    content = re.sub(r'val debugExecRs2      = Output\(UInt\(32\.W\)\)', r'val debugExecRs2      = Output(UInt((if(cosimulate) 32 else 0).W))', content)
    content = re.sub(r'val debugExecCtrlTaken = Output\(Bool\(\)\)', r'val debugExecCtrlTaken = Output(UInt((if(cosimulate) 1 else 0).W))', content)
    content = re.sub(r'val debugExecCtrlTarget = Output\(UInt\(32\.W\)\)', r"""val debugExecCtrlTarget = Output(UInt((if(cosimulate) 32 else 0).W))

  // JTAG Interface
  val jtag_tck    = Input(UInt((if(!cosimulate) 1 else 0).W))
  val jtag_tms    = Input(UInt((if(!cosimulate) 1 else 0).W))
  val jtag_tdi    = Input(UInt((if(!cosimulate) 1 else 0).W))
  val jtag_tdo    = Output(UInt((if(!cosimulate) 1 else 0).W))
  val jtag_trst_n = Input(UInt((if(!cosimulate) 1 else 0).W))""", content)


    # Deal with assignment boolean conversions dynamically locally rather than via regex for complex states
    # Find all '.B' and '=== ...' assignments directed to debug fields and wrap with .asUInt
    
    # Simple regexes to find io.debug... assignments that were explicitly booleans:
    content = re.sub(r'io\.debugStageValids\((.*?)\)\s*:=\s*false\.B', r'io.debugStageValids(\1) := 0.U', content)
    content = re.sub(r'io\.debugStageValids\((.*?)\)\s*:=\s*true\.B', r'io.debugStageValids(\1) := 1.U', content)
    content = re.sub(r'io\.debugStageValids\((.*?)\)\s*:=\s*(.*?\.valid)', r'io.debugStageValids(\1) := (\2).asUInt', content)
    
    content = content.replace(r'io.debugCtrlValid    := false.B', r'io.debugCtrlValid    := 0.U')
    content = content.replace(r'io.debugCtrlValid    := dispatchPipelineRegs(0).decodePipelineSignals.fetchSignals.valid', r'io.debugCtrlValid    := dispatchPipelineRegs(0).decodePipelineSignals.fetchSignals.valid.asUInt')
    
    content = content.replace(r'io.debugCtrlTaken    := false.B', r'io.debugCtrlTaken    := 0.U')
    content = content.replace(r'io.debugCtrlTaken    :=', r'io.debugCtrlTaken    :=') # Need deeper regex
    content = re.sub(r'io\.debugCtrlTaken\s*:=\s*(.*?branchTaken.*? jalTaken.*? jalrTaken.*)', r'io.debugCtrlTaken := (\1).asUInt', content)
    
    content = content.replace(r'io.debugCtrlIsBranch := false.B', r'io.debugCtrlIsBranch := 0.U')
    content = content.replace(r'io.debugCtrlIsBranch := dispatchPipelineRegs(0).decodePipelineSignals.decodeSignals.isBranch', r'io.debugCtrlIsBranch := dispatchPipelineRegs(0).decodePipelineSignals.decodeSignals.isBranch.asUInt')
    
    content = content.replace(r'io.debugCtrlIsJal    := false.B', r'io.debugCtrlIsJal    := 0.U')
    content = content.replace(r'io.debugCtrlIsJal    := dispatchPipelineRegs(0).decodePipelineSignals.decodeSignals.isJAL', r'io.debugCtrlIsJal    := dispatchPipelineRegs(0).decodePipelineSignals.decodeSignals.isJAL.asUInt')
    
    content = content.replace(r'io.debugCtrlIsJalr   := false.B', r'io.debugCtrlIsJalr   := 0.U')
    content = content.replace(r'io.debugCtrlIsJalr   := dispatchPipelineRegs(0).decodePipelineSignals.decodeSignals.isJALR', r'io.debugCtrlIsJalr   := dispatchPipelineRegs(0).decodePipelineSignals.decodeSignals.isJALR.asUInt')
    
    content = content.replace(r'io.debugExecValid        := false.B', r'io.debugExecValid        := 0.U')
    content = content.replace(r'io.debugExecValid        := exec1PipelineRegs(0).regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid', r'io.debugExecValid        := exec1PipelineRegs(0).regReadSignals.dispatchSignals.decodePipelineSignals.fetchSignals.valid.asUInt')
    
    content = content.replace(r'io.debugExecIsBranch     := false.B', r'io.debugExecIsBranch     := 0.U')
    content = content.replace(r'io.debugExecIsBranch     := exec1PipelineRegs(0).regReadSignals.dispatchSignals.decodePipelineSignals.decodeSignals.isBranch', r'io.debugExecIsBranch     := exec1PipelineRegs(0).regReadSignals.dispatchSignals.decodePipelineSignals.decodeSignals.isBranch.asUInt')
    
    content = content.replace(r'io.debugExecIsJal        := false.B', r'io.debugExecIsJal        := 0.U')
    content = content.replace(r'io.debugExecIsJal        := exec1PipelineRegs(0).regReadSignals.dispatchSignals.decodePipelineSignals.decodeSignals.isJAL', r'io.debugExecIsJal        := exec1PipelineRegs(0).regReadSignals.dispatchSignals.decodePipelineSignals.decodeSignals.isJAL.asUInt')
    
    content = content.replace(r'io.debugExecIsJalr       := false.B', r'io.debugExecIsJalr       := 0.U')
    content = content.replace(r'io.debugExecIsJalr       := exec1PipelineRegs(0).regReadSignals.dispatchSignals.decodePipelineSignals.decodeSignals.isJALR', r'io.debugExecIsJalr       := exec1PipelineRegs(0).regReadSignals.dispatchSignals.decodePipelineSignals.decodeSignals.isJALR.asUInt')
    
    content = content.replace(r'io.debugExecCtrlTaken    := false.B', r'io.debugExecCtrlTaken    := 0.U')
    content = content.replace(r'io.debugExecCtrlTaken    := exec1PipelineRegs(0).ctrlTaken', r'io.debugExecCtrlTaken    := exec1PipelineRegs(0).ctrlTaken.asUInt')

    with open(filepath, 'w') as f:
        f.write(content)
    print(f"Processed {filepath}")

base = "/home/jglossner/KryptoNyte/rtl/OctoNyte/"
for root, dirs, files in os.walk(base):
    for filename in files:
        if filename.endswith("Core.scala") or filename.endswith("CoreWithCache.scala"):
            process_file(os.path.join(root, filename))
