#include <cstdint>
#include <fstream>
#include <iostream>
#include <limits>
#include <stdexcept>
#include <string>

#include "VZeroNyteRV32ICore.h"
#include "elf_loader.h"
#include "memory.h"
#include "verilated.h"

namespace {
struct Options {
  std::string elf;
  std::string signature;
  std::string log;
  uint64_t max_cycles = 1000000;
  uint64_t log_start_cycle = 0;
  uint64_t log_stop_cycle = std::numeric_limits<uint64_t>::max();
  bool log_debug_traces = false;
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
    } else if (arg == "--log-start-cycle" && i + 1 < argc) {
      opts.log_start_cycle = std::stoull(argv[++i]);
    } else if (arg == "--log-stop-cycle" && i + 1 < argc) {
      opts.log_stop_cycle = std::stoull(argv[++i]);
    } else if (arg == "--log-debug") {
      opts.log_debug_traces = true;
    } else {
      throw std::invalid_argument("unknown or incomplete argument: " + arg);
    }
  }
  if (opts.elf.empty() || opts.signature.empty()) {
    throw std::invalid_argument("--elf and --signature are required");
  }
  if (opts.log_stop_cycle < opts.log_start_cycle) {
    throw std::invalid_argument("--log-stop-cycle must be >= --log-start-cycle");
  }
  return opts;
}

constexpr uint32_t kMemBase = 0x80000000u;
constexpr uint32_t kMemSize = 16 * 1024 * 1024;
constexpr int kResetCycles = 5;
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

  VZeroNyteRV32ICore dut;

  auto applyMemory = [&]() {
    dut.io_imem_rdata = memory.read32(dut.io_imem_addr);
    dut.io_dmem_rdata = memory.read32(dut.io_dmem_addr);
  };

  // Reset
  dut.reset = 1;
  for (int cycle = 0; cycle < kResetCycles; ++cycle) {
    dut.clock = 0;
    applyMemory();
    dut.eval();
    dut.clock = 1;
    applyMemory();
    dut.eval();
  }
  dut.reset = 0;

  bool completed = false;
  uint32_t tohost_value = 0;

  for (uint64_t cycle = 0; cycle < options.max_cycles; ++cycle) {
    dut.clock = 0;
    applyMemory();
    dut.eval();

    dut.clock = 1;
    applyMemory();
    dut.eval();

    if (dut.io_dmem_wen) {
      const uint32_t addr = dut.io_dmem_addr;
      const uint32_t data = dut.io_dmem_wdata;
      const uint8_t mask  = dut.io_dmem_wmask;
      try {
        if (mask & 0x1) memory.write8(addr + 0, (data >> 0) & 0xFF);
        if (mask & 0x2) memory.write8(addr + 1, (data >> 8) & 0xFF);
        if (mask & 0x4) memory.write8(addr + 2, (data >> 16) & 0xFF);
        if (mask & 0x8) memory.write8(addr + 3, (data >> 24) & 0xFF);
      } catch (const std::exception& e) {
        std::cerr << "Memory write failed at 0x" << std::hex << addr << ": " << e.what() << std::endl;
        return 2;
      }
      if (addr == symbols.tohost && data != 0) {
        tohost_value = data;
        completed = true;
      }
    }

    if (log.is_open() && cycle >= options.log_start_cycle && cycle <= options.log_stop_cycle) {
      log << std::hex
          << "cycle=0x" << cycle
          << " pc=0x" << dut.io_pc_out
          << " instr=0x" << dut.io_instr_out
          << " result=0x" << dut.io_result;

      if (options.log_debug_traces) {
        log << " aluA=0x" << dut.io_debug_aluA
            << " aluB=0x" << dut.io_debug_aluB
            << " aluOpcode=0x" << static_cast<uint64_t>(dut.io_debug_aluOpcode)
            << " effAddr=0x" << dut.io_debug_effAddr
            << " dmemAddr=0x" << dut.io_dmem_addr
            << " dmemWData=0x" << dut.io_dmem_wdata
            << " dmemWEn=" << (dut.io_dmem_wen ? 1 : 0)
            << " storeData=0x" << dut.io_debug_memWriteData
            << " storeMask=0x" << static_cast<uint64_t>(dut.io_debug_memWriteMask)
            << " branchTaken=" << (dut.io_debug_branchTaken ? 1 : 0)
            << " branchTarget=0x" << dut.io_debug_branchTarget
            << " divActive=" << (dut.io_debug_divActive ? 1 : 0)
            << " divDone=" << (dut.io_debug_divDone ? 1 : 0)
            << " divDividend=0x" << dut.io_debug_divDividend
            << " divDivisor=0x" << dut.io_debug_divDivisor;
      }

      log << std::dec << '\n';
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
