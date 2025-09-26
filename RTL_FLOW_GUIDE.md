# KryptoNyte RTL Generation and Physical Design Flow Guide

## Overview

This guide provides comprehensive instructions for using the new flexible, two-part RTL generation and physical design flow for the KryptoNyte RISC-V processor family. The flow has been split into two distinct phases:

1. **Hierarchical RTL Generation** - Generates timed, hierarchical Verilog with flexible path configuration
2. **Physical Design Flow** - Flattens RTL and runs complete synthesis → place & route → GDS-II flow

## Architecture Benefits

### ✅ **Separation of Concerns**
- **Logical Design** (RTL generation) is independent of **Physical Implementation** (ASIC flow)
- Enables rapid RTL iteration without running expensive physical design steps
- Allows different teams to work on RTL and physical design in parallel

### ✅ **Flexible Path Management**
- **Configurable output directories** for different environments (development, CI/CD, production)
- **Auto-discovery** of external tools and PDK installations
- **Environment variable support** for seamless integration

### ✅ **Multi-Core Family Support**
- **Scalable architecture** supports ZeroNyte, PipeNyte, TetraNyte, OctoNyte
- **Consistent interface** across all core families
- **Easy addition** of new core variants

### ✅ **Professional ASIC Flow**
- **Industry-standard tools** (Yosys, OpenROAD, Magic, KLayout)
- **Complete signoff verification** (DRC, LVS, STA)
- **Comprehensive reporting** and documentation

## Installation Prerequisites

### External Dependencies

Before using the new flow, ensure you have installed:

1. **SkyWater PDK** (using our installation script):
   ```bash
   ./install_skywater_pdk.sh --with-sudo
   source ~/.skywater_pdk_env
   ```

2. **RISC-V Conformance Tests** (using our installation script):
   ```bash
   ./install_riscv_conformance_tests.sh --with-sudo
   source ~/.riscv_conformance_env
   ```

3. **EDA Tools** (included in oss-cad-suite or installed separately):
   - `firtool` (CIRCT/MLIR FIRRTL Compiler)
   - `sv2v` (SystemVerilog to Verilog converter)
   - `yosys` (Logic synthesis)
   - `openroad` (Place and route)
   - `magic` (Layout and verification)
   - `klayout` (Layout viewer/editor)

## Part 1: Hierarchical RTL Generation

### Basic Usage

```bash
# Navigate to your KryptoNyte RTL/Chisel directory
cd cores/

# Generate RTL with default settings (ZeroNyte RV32I)
sbt 'runMain kryptonyte.generators.GenerateHierarchicalRTL'
```

### Advanced Configuration

```bash
# Generate OctoNyte with custom output directory
sbt 'runMain kryptonyte.generators.GenerateHierarchicalRTL \
  --core-family OctoNyte \
  --core-variant rv64i \
  --output-root /tmp/kryptonyte_rtl'

# Generate with ASIC optimization enabled
sbt 'runMain kryptonyte.generators.GenerateHierarchicalRTL \
  --optimize-asic \
  --pdk-root /opt/skywater-pdk/pdks/sky130A'

# Quiet mode with cleanup
sbt 'runMain kryptonyte.generators.GenerateHierarchicalRTL \
  --quiet \
  --cleanup'
```

### Configuration Options

| Option | Description | Default |
|--------|-------------|---------|
| `--core-family` | Core family (ZeroNyte, PipeNyte, TetraNyte, OctoNyte) | ZeroNyte |
| `--core-variant` | Core variant (rv32i, rv64i, etc.) | rv32i |
| `--output-root` | Root directory for generated files | generators/generated |
| `--pdk-root` | PDK root directory | Auto-discovered |
| `--standard-cell-lib` | Standard cell library file | Auto-discovered |
| `--optimize-asic` | Enable ASIC optimization during synthesis | false |
| `--cleanup` | Delete intermediate files after generation | false |
| `--quiet` | Reduce output verbosity | false |

### Output Structure

```
generators/generated/
├── firrtl/                          # FIRRTL intermediate files
│   ├── ZeroNyteRV32ICore.fir
│   └── ZeroNyteRV32ICore.fir.mlir
├── systemverilog_hierarchical/      # Hierarchical SystemVerilog
│   └── ZeroNyteRV32ICore.sv
├── verilog_hierarchical/            # Clean Verilog (sv2v converted)
│   └── ZeroNyteRV32ICore.v
├── verilog_hierarchical_timed/      # Synthesized timed RTL
│   └── ZeroNyteRV32ICore.v
└── annotations/                     # Annotation files
    └── ZeroNyteRV32ICore_annotations.txt
```

## Part 2: Physical Design Flow

### Basic Usage

```bash
# Run complete physical design flow
sbt 'runMain kryptonyte.generators.GeneratePhysicalDesign \
  --module-name ZeroNyteRV32ICore'
```

### Advanced Configuration

```bash
# Custom timing constraints and utilization
sbt 'runMain kryptonyte.generators.GeneratePhysicalDesign \
  --module-name ZeroNyteRV32ICore \
  --clock-period 5.0 \
  --utilization 0.8 \
  --aspect-ratio 1.2'

# Synthesis only (no physical design)
sbt 'runMain kryptonyte.generators.GeneratePhysicalDesign \
  --module-name ALU32 \
  --synthesis-only'

# Custom PDK and output location
sbt 'runMain kryptonyte.generators.GeneratePhysicalDesign \
  --pdk-root /opt/skywater-pdk/pdks/sky130A \
  --output-root /tmp/physical_design'
```

### Configuration Options

| Option | Description | Default |
|--------|-------------|---------|
| `--input-rtl` | Input RTL directory | generators/generated/verilog_hierarchical_timed |
| `--module-name` | Module name to process | ZeroNyteRV32ICore |
| `--top-module` | Top-level module name | Same as module-name |
| `--output-root` | Root directory for outputs | physical_design |
| `--pdk-root` | PDK root directory | Auto-discovered |
| `--clock-period` | Clock period in nanoseconds | 10.0 |
| `--utilization` | Core utilization ratio (0.0-1.0) | 0.7 |
| `--aspect-ratio` | Core aspect ratio | 1.0 |
| `--synthesis-only` | Run synthesis only | false |
| `--no-signoff` | Skip signoff verification | false |
| `--no-gds` | Skip GDS-II generation | false |

### Physical Design Flow Steps

1. **Synthesis** - Logic synthesis with standard cells
2. **Floorplan** - Die and core area planning  
3. **Placement** - Standard cell placement
4. **Routing** - Global and detailed routing
5. **Signoff** - DRC, LVS, and STA verification
6. **GDS Generation** - Final GDS-II layout export

### Output Structure

```
physical_design/
├── synthesis/                       # Logic synthesis outputs
│   ├── ZeroNyteRV32ICore_synth.v
│   └── synthesis.ys
├── floorplan/                       # Floorplan outputs
│   ├── ZeroNyteRV32ICore_floorplan.def
│   └── floorplan.tcl
├── placement/                       # Placement outputs
│   ├── ZeroNyteRV32ICore_placed.def
│   └── placement.tcl
├── routing/                         # Routing outputs
│   ├── ZeroNyteRV32ICore_routed.def
│   └── routing.tcl
├── signoff/                         # Verification outputs
│   ├── drc_report.txt
│   ├── lvs_report.txt
│   └── sta_report.txt
├── gds/                            # Final GDS-II layout
│   ├── ZeroNyteRV32ICore.gds
│   └── gds_gen.tcl
└── reports/                        # Comprehensive reports
    ├── synthesis_report.txt
    └── final_report.md
```

## Integration Examples

### Example 1: Complete ZeroNyte RV32I Flow

```bash
# Step 1: Generate hierarchical RTL
sbt 'runMain kryptonyte.generators.GenerateHierarchicalRTL \
  --core-family ZeroNyte \
  --core-variant rv32i \
  --optimize-asic'

# Step 2: Run physical design flow
sbt 'runMain kryptonyte.generators.GeneratePhysicalDesign \
  --module-name ZeroNyteRV32ICore \
  --clock-period 10.0'

# Result: Complete ASIC implementation from RTL to GDS-II
```

### Example 2: Multi-Core Family Generation

```bash
# Generate RTL for all core families
for family in ZeroNyte PipeNyte TetraNyte OctoNyte; do
  sbt "runMain kryptonyte.generators.GenerateHierarchicalRTL \
    --core-family $family \
    --output-root generated_rtl/$family"
done

# Run physical design for specific cores
sbt 'runMain kryptonyte.generators.GeneratePhysicalDesign \
  --input-rtl generated_rtl/OctoNyte/verilog_hierarchical_timed \
  --module-name OctoNyteCPU \
  --clock-period 5.0 \
  --utilization 0.75'
```

### Example 3: CI/CD Integration

```bash
#!/bin/bash
# ci_build_script.sh

# Set environment variables
export PDK_ROOT=/opt/skywater-pdk/pdks/sky130A
export OUTPUT_ROOT=/tmp/ci_build_$$

# Generate RTL
sbt "runMain kryptonyte.generators.GenerateHierarchicalRTL \
  --output-root $OUTPUT_ROOT/rtl \
  --quiet"

# Run synthesis only for verification
sbt "runMain kryptonyte.generators.GeneratePhysicalDesign \
  --input-rtl $OUTPUT_ROOT/rtl/verilog_hierarchical_timed \
  --output-root $OUTPUT_ROOT/physical \
  --synthesis-only \
  --quiet"

# Archive results
tar -czf kryptonyte_build_$$.tar.gz $OUTPUT_ROOT
```

### Example 4: Custom Module Integration

```scala
// Add to getZeroNyteModules() in generate_hierarchical_rtl.scala
case "rv32i" => Seq(
  ModuleSpec(() => new ZeroNyte.ZeroNyteRV32ICore, "ZeroNyteRV32ICore", 
    "Single-cycle RV32I core", "ZeroNyte", "rv32i"),
  ModuleSpec(() => new ALUs.ALU32, "ALU32", 
    "32-bit ALU", "ZeroNyte", "rv32i"),
  ModuleSpec(() => new Decoders.RV32IDecode, "RV32IDecode", 
    "RV32I instruction decoder", "ZeroNyte", "rv32i"),
  ModuleSpec(() => new YourCustomModule, "YourCustomModule",
    "Your custom module description", "ZeroNyte", "rv32i")
)
```

## Environment Variables

The scripts support several environment variables for seamless integration:

### PDK Configuration
```bash
export PDK_ROOT=/opt/skywater-pdk/pdks/sky130A
export SKYWATER_PDK_ROOT=/opt/skywater-pdk/pdks/sky130A
```

### Tool Paths
```bash
export FIRTOOL_PATH=/usr/local/bin/firtool
export SV2V_PATH=/usr/local/bin/sv2v
export YOSYS_PATH=/usr/local/bin/yosys
export OPENROAD_PATH=/usr/local/bin/openroad
export MAGIC_PATH=/opt/skywater-pdk/magic-install/bin/magic
export KLAYOUT_PATH=/usr/local/bin/klayout
```

### Output Configuration
```bash
export KRYPTONYTE_OUTPUT_ROOT=/tmp/kryptonyte_builds
export KRYPTONYTE_KEEP_INTERMEDIATE=true
```

## Troubleshooting

### Common Issues

#### 1. **PDK Not Found**
```
Error: Standard cell library not configured - required for synthesis
```
**Solution**: Install SkyWater PDK using our script or set `PDK_ROOT` environment variable.

#### 2. **Tool Not Found**
```
Warning: firtool not found, skipping SystemVerilog generation
```
**Solution**: Install oss-cad-suite or set specific tool paths in environment variables.

#### 3. **Module Import Errors**
```
Error: object ZeroNyte is not a member of package
```
**Solution**: Ensure your module imports are correct in the `getModulesToGenerate()` functions.

#### 4. **Permission Errors**
```
Error: Cannot write to installation directory
```
**Solution**: Use absolute paths or ensure write permissions to output directories.

### Debug Mode

Enable verbose output for debugging:
```bash
sbt 'runMain kryptonyte.generators.GenerateHierarchicalRTL --verbose'
sbt 'runMain kryptonyte.generators.GeneratePhysicalDesign --verbose'
```

## Performance Optimization

### Parallel Builds
```bash
# Generate multiple modules in parallel
sbt 'runMain kryptonyte.generators.GenerateHierarchicalRTL --core-family ZeroNyte' &
sbt 'runMain kryptonyte.generators.GenerateHierarchicalRTL --core-family PipeNyte' &
wait
```

### Incremental Builds
```bash
# Only regenerate if source changed
if [ src/main/scala/ZeroNyte.scala -nt generated_rtl/ZeroNyte/verilog_hierarchical_timed/ZeroNyteRV32ICore.v ]; then
  sbt 'runMain kryptonyte.generators.GenerateHierarchicalRTL --core-family ZeroNyte'
fi
```

## Migration from Original Script

### Key Differences

| Original Script | New Flow |
|----------------|----------|
| Monolithic generation | Two-phase approach |
| Hardcoded paths | Flexible configuration |
| Single core family | Multi-family support |
| Limited PDK integration | Full PDK auto-discovery |
| Basic error handling | Comprehensive validation |

### Migration Steps

1. **Replace the old script** with the new two-part flow
2. **Update build scripts** to use the new command-line interface
3. **Configure environment variables** for your specific setup
4. **Test with existing modules** to ensure compatibility
5. **Gradually migrate** to the new configuration options

## Best Practices

### 1. **Use Environment Variables**
Set up your environment once and reuse across projects:
```bash
# Add to ~/.bashrc or ~/.zshrc
source ~/.skywater_pdk_env
source ~/.riscv_conformance_env
export KRYPTONYTE_OUTPUT_ROOT=$HOME/kryptonyte_builds
```

### 2. **Organize Output Directories**
Use descriptive output directory structures:
```bash
--output-root builds/$(date +%Y%m%d)_$(git rev-parse --short HEAD)
```

### 3. **Version Control Integration**
Add generated files to `.gitignore` but keep configuration:
```gitignore
# Generated RTL (regenerate from source)
generators/generated/
physical_design/

# Keep configuration files
!*.config
!build_scripts/
```

### 4. **Automated Testing**
Integrate with your test suite:
```bash
# Generate RTL and run conformance tests
sbt 'runMain kryptonyte.generators.GenerateHierarchicalRTL'
./scripts/run_conformance_tests.sh rv32i
```

## Conclusion

The new flexible RTL generation and physical design flow provides a professional, scalable foundation for KryptoNyte processor development. The separation of concerns, flexible configuration, and comprehensive toolchain integration enable efficient development workflows from initial RTL design through final GDS-II generation.

For questions or issues, refer to the troubleshooting section or examine the verbose output for detailed error information.
