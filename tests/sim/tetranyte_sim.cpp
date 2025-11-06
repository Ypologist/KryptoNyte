#include <array>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <string>

#include "VTetraNyteRV32ICore.h"
#include "elf_loader.h"
#include "memory.h"
#include "verilated.h"

namespace {
struct Options {
  std::string elf;
  std::string signature;
  std::string log;
  uint64_t max_cycles = 1'000'000;
};

Options parseArgs(int argc, char** argv) {
  Options opts;
  for (int i = 1; i < argc; ++i) {
    const std::string arg(argv[i]);
    if (arg == "--elf" && i + 1 < argc) {
      opts.elf = argv[++i];
    } else if (arg == "--signature" && i + 1 < argc) {
      opts.signature = argv[++i];
    } else if (arg == "--log" && i + 1 < argc) {
      opts.log = argv[++i];
    } else if (arg == "--max-cycles" && i + 1 < argc) {
      opts.max_cycles = std::stoull(argv[++i]);
    } else {
      throw std::invalid_argument("unknown or incomplete argument: " + arg);
    }
  }
  if (opts.elf.empty() || opts.signature.empty()) {
    throw std::invalid_argument("--elf and --signature are required");
  }
  return opts;
}

constexpr uint32_t kMemBase = 0x80000000u;
constexpr uint32_t kMemSize = 16 * 1024 * 1024;
constexpr int kResetCycles = 5;
constexpr int kNumThreads = 4;

void writeMasked(Memory& memory, uint32_t addr, uint32_t data, uint32_t mask) {
  for (int byte = 0; byte < 4; ++byte) {
    if ((mask >> byte) & 0x1) {
      memory.write8(addr + byte, static_cast<uint8_t>((data >> (8 * byte)) & 0xFFu));
    }
  }
}

}  // namespace

int main(int argc, char** argv) {
  Verilated::commandArgs(argc, argv);

  Options options;
  try {
    options = parseArgs(argc, argv);
  } catch (const std::exception& e) {
    std::cerr << "Argument error: " << e.what() << std::endl;
    return 1;
  }

  std::ofstream log;
  if (!options.log.empty()) {
    log.open(options.log);
  }

  Memory memory(kMemBase, kMemSize);
  ElfSymbols symbols;

  try {
    loadElfIntoMemory(options.elf, memory, symbols);
  } catch (const std::exception& e) {
    std::cerr << "ELF load failed: " << e.what() << std::endl;
    return 1;
  }

  VTetraNyteRV32ICore dut;

  std::array<uint32_t, kNumThreads> thread_pcs{};
  thread_pcs.fill(kMemBase);

  auto captureThreadPcs = [&]() {
    thread_pcs[0] = dut.io_if_pc_0;
    thread_pcs[1] = dut.io_if_pc_1;
    thread_pcs[2] = dut.io_if_pc_2;
    thread_pcs[3] = dut.io_if_pc_3;
  };

  auto setInstr = [&](int idx, uint32_t value) {
    switch (idx) {
      case 0: dut.io_instrMem_0 = value; break;
      case 1: dut.io_instrMem_1 = value; break;
      case 2: dut.io_instrMem_2 = value; break;
      case 3: dut.io_instrMem_3 = value; break;
      default: break;
    }
  };

  auto driveMemory = [&]() {
    for (int t = 0; t < kNumThreads; ++t) {
      setInstr(t, memory.read32(thread_pcs[t]));
    }
    dut.io_dataMemResp = memory.read32(dut.io_memAddr);
  };

  // Reset
  dut.reset = 1;
  captureThreadPcs();
  for (int cycle = 0; cycle < kResetCycles; ++cycle) {
    dut.clock = 0;
    driveMemory();
    dut.eval();
    captureThreadPcs();

    dut.clock = 1;
    driveMemory();
    dut.eval();
    captureThreadPcs();
  }
  dut.reset = 0;

  bool completed = false;
  uint32_t tohost_value = 0;

  for (uint64_t cycle = 0; cycle < options.max_cycles; ++cycle) {
    dut.clock = 0;
    driveMemory();
    dut.eval();
    captureThreadPcs();

    dut.clock = 1;
    driveMemory();
    dut.eval();
    captureThreadPcs();

    const uint32_t addr = dut.io_memAddr;
    const uint32_t data = dut.io_memWrite;
    const uint32_t mask = dut.io_memMask;
    if (mask != 0) {
      writeMasked(memory, addr, data, mask);
      if (addr == symbols.tohost && data != 0) {
        tohost_value = data;
        completed = true;
      }
    }

    if (log.is_open()) {
      log << std::hex
          << "cycle=0x" << cycle
          << " memAddr=0x" << addr
          << " mask=0x" << mask
          << " pc0=0x" << thread_pcs[0]
          << " rs1=0x" << dut.io_id_rs1Data_0
          << " rs2=0x" << dut.io_id_rs2Data_0
          << " tohost=0x" << symbols.tohost
          << std::dec << '\n';
    }

    if (completed) {
      break;
    }
  }

  if (!completed) {
    std::cerr << "Simulation terminated: max cycles reached" << std::endl;
    return 3;
  }

  if (tohost_value != 1) {
    std::cerr << "Test reported failure, tohost=0x" << std::hex << tohost_value << std::dec << std::endl;
  }

  try {
    memory.dumpSignature(symbols.begin_signature, symbols.end_signature, options.signature);
  } catch (const std::exception& e) {
    std::cerr << "Signature dump failed: " << e.what() << std::endl;
    return 4;
  }

  return tohost_value == 1 ? 0 : 5;
}
