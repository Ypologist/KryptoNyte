
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "VZeroNyteRV32ICore.h"
#include <iostream>
#include <fstream>
#include <iomanip>
#include <vector>

#define MAX_CYCLES 1000000
#define MEM_BASE 0x80000000
#define SIGNATURE_START 0x80001000
#define SIGNATURE_END   0x80002000

int main(int argc, char** argv) { 
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);
    
    VZeroNyteRV32ICore* dut = new VZeroNyteRV32ICore;
    VerilatedVcdC* tfp = new VerilatedVcdC;

    // Simulated Memory (4MB starting at MEM_BASE)
    std::vector<uint32_t> mem(1 << 22, 0);
    if (argc > 1) {
        std::ifstream hex_file(argv[1]);
        std::string line;
        uint32_t addr = MEM_BASE;
        std::cout << "Loading hex file: " << argv[1] << std::endl;
        
        while (std::getline(hex_file, line)) {
            if (line.empty() || line[0] == '#') continue; // Skip empty lines and comments
            
            if (line[0] == '@') {
                // Address directive - convert from hex words to byte address
                uint32_t word_addr = std::stoul(line.substr(1), nullptr, 16);
                addr = word_addr * 4; // Convert word address to byte address
                std::cout << "Setting address to: 0x" << std::hex << addr << std::endl;
            } else {
                // Data line - ensure address is within our memory range
                if (addr >= MEM_BASE && addr < MEM_BASE + (mem.size() * 4)) {
                    uint32_t mem_index = (addr - MEM_BASE) / 4;
                    uint32_t value = std::stoul(line, nullptr, 16);
                    mem[mem_index] = value;
                    std::cout << "Loaded 0x" << std::hex << value << " at address 0x" << addr 
                             << " (mem[" << std::dec << mem_index << "])" << std::endl;
                } else {
                    std::cout << "Warning: Address 0x" << std::hex << addr 
                             << " outside memory range" << std::endl;
                }
                addr += 4;
            }
        }
        std::cout << "Hex file loading completed" << std::endl;
    }

    dut->trace(tfp, 99);
    tfp->open("misalign-bne-01.vcd");
    
    // Initialize
    dut->clock = 0;
    dut->reset = 1;
    
    // Reset sequence
    for (int i = 0; i < 10; i++) {
        dut->clock = 0;
        dut->eval();
        tfp->dump(2*i);
        dut->clock = 1;
        dut->eval();
        tfp->dump(2*i+1);
    }
    
    dut->reset = 0;
    std::cout << "Reset completed, starting execution" << std::endl;
    
    // Run simulation
    for (int cycle = 0; cycle < MAX_CYCLES; cycle++) {
        dut->clock = 0;
        dut->eval();
        tfp->dump(2*cycle + 20);

        // Memory Read - with bounds checking
        if (dut->io_imem_addr >= MEM_BASE && (dut->io_imem_addr - MEM_BASE) / 4 < mem.size()) {
            dut->io_imem_rdata = mem[(dut->io_imem_addr - MEM_BASE) / 4];
        } else {
            dut->io_imem_rdata = 0; // Return NOP for out-of-bounds
            if (cycle < 100) { // Only print first few to avoid spam
                std::cout << "imem access out of bounds: 0x" << std::hex << dut->io_imem_addr << std::endl;
            }
        }

        if (dut->io_dmem_addr >= MEM_BASE && (dut->io_dmem_addr - MEM_BASE) / 4 < mem.size()) {
            dut->io_dmem_rdata = mem[(dut->io_dmem_addr - MEM_BASE) / 4];
        } else {
            dut->io_dmem_rdata = 0; // Return 0 for out-of-bounds reads
        }
        
        dut->clock = 1;
        dut->eval();
        tfp->dump(2*cycle + 21);

        // Debug output for first few cycles
        if (cycle < 20) {
            std::cout << "Cycle " << cycle << ": PC=0x" << std::hex << dut->io_pc_out 
                     << " Instr=0x" << dut->io_instr_out 
                     << " Result=0x" << dut->io_result << std::endl;
        }

        // Memory Write - with bounds checking
        if (dut->io_dmem_wen && dut->io_dmem_addr >= MEM_BASE && (dut->io_dmem_addr - MEM_BASE) / 4 < mem.size()) {
            mem[(dut->io_dmem_addr - MEM_BASE) / 4] = dut->io_dmem_wdata;
            
            // Debug: Print writes to signature area
            if (dut->io_dmem_addr >= SIGNATURE_START && dut->io_dmem_addr < SIGNATURE_END && cycle < 1000) {
                std::cout << "Signature write at 0x" << std::hex << dut->io_dmem_addr 
                         << " = 0x" << dut->io_dmem_wdata << std::endl;
            }
        }

        // Test completion check - look for any non-zero value in signature area
        bool test_complete = false;
        for (uint32_t i = SIGNATURE_START; i < SIGNATURE_END; i += 4) {
            if (mem[(i - MEM_BASE) / 4] != 0) {
                test_complete = true;
                break;
            }
        }
        
        if (test_complete && cycle > 1000) { // Give it some time to run
            std::cout << "Test completed at cycle " << cycle << std::endl;
            break;
        }
    }
    
    // Extract signature - check multiple areas and create comprehensive signature
    std::ofstream sig_file("misalign-bne-01.signature");
    bool found_signature = false;
    
    // First check the standard signature area
    for (uint32_t i = SIGNATURE_START; i < SIGNATURE_END; i += 4) {
        uint32_t value = mem[(i - MEM_BASE) / 4];
        if (value != 0) {
            sig_file << std::hex << std::setw(8) << std::setfill('0') << value << std::endl;
            found_signature = true;
        }
    }
    
    // If no signature found in standard area, check for any writes in the test area
    if (!found_signature) {
        std::cout << "No signature in standard area, checking for any memory writes..." << std::endl;
        for (uint32_t i = 0; i < mem.size(); i++) {
            if (mem[i] != 0 && mem[i] != 0xdeadbeef) { // Skip initialization markers
                uint32_t addr = MEM_BASE + (i * 4);
                sig_file << std::hex << std::setw(8) << std::setfill('0') << mem[i] << std::endl;
                std::cout << "Found data: 0x" << std::hex << mem[i] << " at 0x" << addr << std::endl;
                found_signature = true;
            }
        }
    }
    
    if (!found_signature) {
        sig_file << "# No signature data found" << std::endl;
        std::cout << "Warning: No signature data found in any memory area" << std::endl;
        
        // Debug: show register file state or other test results
        sig_file << "# Test completed but no signature data written" << std::endl;
        sig_file << "# This may indicate the test passed without explicit signature writes" << std::endl;
    } else {
        std::cout << "Signature extracted successfully" << std::endl;
    }
    
    sig_file.close();
    
    tfp->close();
    delete dut;
    delete tfp;
    
    return 0;
}
