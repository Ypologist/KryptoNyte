#include <cstdint>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <string>

#include "VZeroNyteRV32IFRVVCore.h"
#include "elf_loader.h"
#include "memory.h"
#include "verilated.h"

namespace {
struct Options {
  std::string elf;
  std::string signature;
  std::string log;
  uint64_t max_cycles = 1000000;
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

void writeMasked(Memory& memory, uint32_t addr, uint32_t data, uint32_t mask) {
  for (int byte = 0; byte < 4; ++byte) {
    if ((mask >> byte) & 0x1) {
      memory.write8(addr + byte, static_cast<uint8_t>((data >> (8 * byte)) & 0xffu));
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

  VZeroNyteRV32IFRVVCore dut;

  auto driveStaticInputs = [&]() {
    dut.io_extIssue_ready = 1;
    dut.io_extComplete_valid = 0;
    dut.io_extComplete_bits_fault = 0;
    dut.io_extComplete_bits_cause = 0;
    dut.io_extComplete_bits_writeRd = 0;
    dut.io_extComplete_bits_rd = 0;
    dut.io_extComplete_bits_rdData = 0;
    dut.io_extComplete_bits_writeVl = 0;
    dut.io_extComplete_bits_vl = 0;
    dut.io_extComplete_bits_writeVtype = 0;
    dut.io_extComplete_bits_vtype = 0;
    dut.io_extComplete_bits_writeVstart = 0;
    dut.io_extComplete_bits_vstart = 0;
    dut.io_extComplete_bits_writeVxsat = 0;
    dut.io_extComplete_bits_vxsat = 0;
    dut.io_replay_enable = 0;
    dut.io_replay_valid = 0;
    dut.io_replay_pc = 0;
    dut.io_replay_finish = 0;
    dut.io_replay_finish_pc = 0;
    dut.io_interruptVector = kMemBase;
    dut.io_interruptPending = 0;
  };

  auto applyMemory = [&]() {
    dut.io_imem_rdata = memory.read32(dut.io_imem_addr);
    dut.io_dmem_rdata = memory.read32(dut.io_dmem_addr);
  };

  dut.reset = 1;
  for (int cycle = 0; cycle < kResetCycles; ++cycle) {
    dut.clock = 0;
    driveStaticInputs();
    dut.eval();
    applyMemory();
    dut.eval();
    dut.clock = 1;
    driveStaticInputs();
    dut.eval();
    applyMemory();
    dut.eval();
  }
  dut.reset = 0;

  bool completed = false;
  uint32_t tohost_value = 0;

  for (uint64_t cycle = 0; cycle < options.max_cycles; ++cycle) {
    dut.clock = 0;
    driveStaticInputs();
    dut.eval();
    applyMemory();
    dut.eval();

    dut.clock = 1;
    driveStaticInputs();
    dut.eval();
    applyMemory();
    dut.eval();

    if (dut.io_dmem_valid && dut.io_dmem_wmask != 0) {
      const uint32_t addr = dut.io_dmem_addr;
      const uint32_t data = dut.io_dmem_wdata;
      const uint8_t mask = dut.io_dmem_wmask;
      try {
        writeMasked(memory, addr, data, mask);
      } catch (const std::exception& e) {
        std::cerr << "Memory error: " << e.what() << "\n";
        return 2;
      }
      if (addr == symbols.tohost && data != 0) {
        tohost_value = data;
        completed = true;
      }
    }

    if (log.is_open()) {
      log << std::hex
          << "cycle=0x" << cycle
          << " pc=0x" << dut.io_pc_out
          << " instr=0x" << dut.io_instr_out
          << " dmem_valid=0x" << static_cast<unsigned>(dut.io_dmem_valid)
          << " dmem_addr=0x" << dut.io_dmem_addr
          << " dmem_rdata=0x" << dut.io_dmem_rdata
          << " dmem_wmask=0x" << static_cast<unsigned>(dut.io_dmem_wmask)
          << " dmem_wdata=0x" << dut.io_dmem_wdata
          << " retire_valid=0x" << static_cast<unsigned>(dut.io_retire_valid)
          << " retire_pc=0x" << dut.io_retire_pc
          << " retire_instr=0x" << dut.io_retire_instr
          << " retire_write_fp=0x" << static_cast<unsigned>(dut.io_retire_write_fp)
          << " retire_fp_rd=0x" << static_cast<unsigned>(dut.io_retire_fp_rd)
          << " retire_fp_wdata=0x" << dut.io_retire_fp_wdata
          << " fflags=0x" << static_cast<unsigned>(dut.io_csr_fflags)
          << std::dec << '\n';
    }

    if (dut.io_trap_valid) {
      std::cerr << "Core trap cause=0x" << std::hex << dut.io_trap_cause
                << " pc=0x" << dut.io_pc_out << std::dec << "\n";
      return 6;
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
