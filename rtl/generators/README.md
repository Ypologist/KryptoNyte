# KryptoNyte Flexible RTL Generator Installation Instructions

## Repository Structure Analysis

Based on the KryptoNyte repository structure, here's where to place the new flexible RTL generation scripts:

```
KryptoNyte/
├── cores/                           # ← You are here
│   ├── build.sbt                   # ← Replace with updated_build.sbt
│   ├── generators/                 # ← Create this directory
│   │   ├── GenerateHierarchicalRTL.scala
│   │   └── GeneratePhysicalDesign.scala
│   ├── ZeroNyte/
│   │   └── rv32i/
│   │       ├── generators/         # ← Original script location
│   │       │   └── generate_verilog_rtl_rv32i.scala
│   │       └── rtl/chisel/src/main/scala/
│   │           └── ZeroNyteRV32ICore.scala
│   └── library/
│       └── rtl/chisel/src/main/scala/
│           ├── ALUs/ALU32.scala
│           └── Decoders/RV32IDecode.scala
```

## Installation Steps

### 1. Create the Generators Directory

```bash
cd KryptoNyte/cores
mkdir -p generators
```

### 2. Copy the New Scripts

```bash
# Copy the hierarchical RTL generator
cp /path/to/generate_hierarchical_rtl.scala generators/GenerateHierarchicalRTL.scala

# Copy the physical design flow script  
cp /path/to/generate_physical_design.scala generators/GeneratePhysicalDesign.scala
```

### 3. Update build.sbt

```bash
# Backup the original build.sbt
cp build.sbt build.sbt.backup

# Replace with the updated version
cp /path/to/updated_build.sbt build.sbt
```

### 4. Test the Installation

```bash
# From KryptoNyte/cores directory
cd KryptoNyte/cores

# Test that sbt can find the new generators
sbt "generators/runMain generators.GenerateHierarchicalRTL --help"
sbt "generators/runMain generators.GeneratePhysicalDesign --help"
```

## Usage Examples

### Basic Usage (from KryptoNyte/cores directory)

```bash
# Generate hierarchical RTL for ZeroNyte
sbt "generators/runMain generators.GenerateHierarchicalRTL"

# Generate hierarchical RTL with custom settings
sbt "generators/runMain generators.GenerateHierarchicalRTL --core-family ZeroNyte --optimize-asic"

# Run physical design flow
sbt "generators/runMain generators.GeneratePhysicalDesign --module-name ZeroNyteRV32ICore"
```

### Using Command Aliases (after updating build.sbt)

```bash
# Generate RTL for different core families
sbt genZeroNyte
sbt genPipeNyte
sbt genTetraNyte
sbt genOctoNyte

# Run physical design
sbt physicalZeroNyte
sbt physicalALU32

# Complete flow (RTL + Physical)
sbt completeZeroNyte
```

### Custom Tasks

```bash
# Use the custom sbt tasks
sbt generators/generateRTL
sbt generators/generatePhysical
sbt generators/generateComplete
```

## Package Structure Explanation

### Current KryptoNyte Structure
- **Library modules**: `package ALUs`, `package Decoders` (in library project)
- **Core modules**: No explicit package (in zeroNyte project)
- **Generators**: `package rv32i_generators` (original script)

### New Generator Structure
- **New generators**: `package generators` (in generators project)
- **Imports**: Will import from library and zeroNyte projects
- **Dependencies**: generators project depends on both library and zeroNyte

## Module Integration

To use actual KryptoNyte modules instead of placeholders, you'll need to:

### 1. Add Imports to GenerateHierarchicalRTL.scala

```scala
// Add these imports at the top of the file after the package declaration
import ALUs.ALU32
import Decoders.RV32IDecode
// Note: ZeroNyteRV32ICore doesn't have a package, so it's imported directly
```

### 2. Update Module Specifications

```scala
def getZeroNyteModules(variant: String): Seq[ModuleSpec] = {
  variant match {
    case "rv32i" => Seq(
      ModuleSpec(() => new ZeroNyteRV32ICore, "ZeroNyteRV32ICore", 
        "Single-cycle RV32I core", "ZeroNyte", "rv32i"),
      ModuleSpec(() => new ALU32, "ALU32", 
        "32-bit ALU", "ZeroNyte", "rv32i"),
      ModuleSpec(() => new RV32IDecode, "RV32IDecode", 
        "RV32I instruction decoder", "ZeroNyte", "rv32i")
    )
    case _ => Seq.empty
  }
}
```

## Directory Structure After Installation

```
KryptoNyte/cores/
├── build.sbt                       # ← Updated with generators project
├── generators/                     # ← New directory
│   ├── GenerateHierarchicalRTL.scala
│   └── GeneratePhysicalDesign.scala
├── generated/                      # ← Will be created by scripts
│   ├── firrtl/
│   ├── systemverilog_hierarchical/
│   ├── verilog_hierarchical/
│   ├── verilog_hierarchical_timed/
│   └── annotations/
├── physical_design/                # ← Will be created by physical design script
│   ├── synthesis/
│   ├── floorplan/
│   ├── placement/
│   ├── routing/
│   ├── signoff/
│   ├── gds/
│   └── reports/
├── ZeroNyte/
├── library/
└── project/                        # ← sbt project files
```

## Advantages of This Structure

### 1. **Clean Separation**
- **Generators** are separate from core implementations
- **Flexible path management** without hardcoded assumptions
- **Multi-project sbt build** with proper dependencies

### 2. **Backward Compatibility**
- **Original scripts** remain in their locations
- **Existing workflows** continue to work
- **Gradual migration** possible

### 3. **Scalability**
- **Easy to add** new core families (PipeNyte, TetraNyte, OctoNyte)
- **Consistent interface** across all generators
- **Professional project structure**

### 4. **Integration Ready**
- **External PDK integration** with auto-discovery
- **CI/CD friendly** with environment variable support
- **Tool auto-discovery** for different environments

## Next Steps

1. **Install the scripts** using the steps above
2. **Test with placeholder modules** to verify the setup works
3. **Add actual module imports** when ready to generate real RTL
4. **Configure PDK paths** for physical design flow
5. **Integrate with your development workflow**

## Troubleshooting

### Common Issues

#### sbt Cannot Find Generators
```
[error] Not a valid command: generators
```
**Solution**: Make sure you updated `build.sbt` and the `generators` directory exists.

#### Module Import Errors
```
[error] not found: type ZeroNyteRV32ICore
```
**Solution**: The placeholder modules are being used. Add proper imports when ready to use real modules.

#### Permission Errors
```
[error] java.nio.file.AccessDeniedException
```
**Solution**: Ensure write permissions to the output directories or use absolute paths.

This structure follows the existing KryptoNyte conventions while providing the flexibility and professional features of the new generator system!
