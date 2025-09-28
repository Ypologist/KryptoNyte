# KryptoNyte Physical Design Configuration Guide

## Overview

The KryptoNyte physical design flow has been enhanced with a flexible, modular configuration system that combines the professional structure of JSON with the flexibility inspired by OctoNyte's TCL approach. This system allows for easy customization of the OpenLane2 physical design flow while maintaining compatibility with OpenLane2's expected configuration format.

## Configuration System Architecture

The configuration system consists of three main components:

### 1. Base Configuration (`config.base.json`)

This file defines common settings that are shared across all designs in the KryptoNyte project. It contains default values for all OpenLane2 parameters and helps ensure consistency across different modules.

**Key Features:**
- Contains all standard OpenLane2 configuration parameters
- Provides sensible defaults for the SkyWater 130nm PDK
- Serves as the foundation for all module-specific configurations

### 2. Module-Specific Configuration (`config.<module_name>.json`)

This file contains settings that are specific to a particular module. It inherits from the base configuration and can override any of the default settings.

**Key Features:**
- **`DESIGN_NAME`**: The name of the module being processed
- **`VERILOG_FILES`**: List of Verilog files required for the module
- **`PNR_SDC_FILE`** and **`SIGNOFF_SDC_FILE`**: Paths to timing constraint files
- Module-specific parameter overrides (clock period, utilization, etc.)

### 3. Enhanced Physical Design Script (`generate_physical_design.sh`)

The script has been enhanced to support the new configuration system while maintaining backward compatibility.

**Key Features:**
- Automatic configuration merging using `jq`
- Command-line parameter support for common settings
- Improved error handling and validation
- Better logging and reporting

## How to Use the Configuration System

### Basic Usage

To run the physical design flow for the ZeroNyteRV32ICore module:

```bash
cd physical_design
./generate_physical_design.sh --module-name ZeroNyteRV32ICore
```

### Advanced Usage

You can override specific parameters using command-line arguments:

```bash
./generate_physical_design.sh \
    --module-name ZeroNyteRV32ICore \
    --clock-period 8.0 \
    --utilization 0.8
```

### Custom Configuration Files

You can specify custom configuration files:

```bash
./generate_physical_design.sh \
    --module-name MyModule \
    --config-base my_base_config.json \
    --config-module my_module_config.json
```

## Configuration Merging Process

The script follows this process:

1. **Load Base Configuration**: Reads the base configuration file containing default settings
2. **Load Module Configuration**: Reads the module-specific configuration file
3. **Merge Configurations**: Uses `jq` to merge the configurations, with module settings taking precedence
4. **Apply to OpenLane2**: The merged configuration is passed directly to OpenLane2

## Timing Constraints

The system includes support for timing constraints through SDC (Synopsys Design Constraints) files:

- **`constraints/<module_name>.sdc`**: Basic timing constraints for synthesis and place-and-route
- **`constraints/<module_name>_signoff.sdc`**: Tighter constraints for final signoff verification

These files are automatically copied to the design directory and referenced in the OpenLane2 configuration.

## Benefits of the New System

### Flexibility
- Easy parameter customization through command-line arguments
- Modular configuration inheritance
- Support for module-specific overrides

### Maintainability
- Clear separation between base and module-specific settings
- Reduced configuration duplication
- Centralized default parameter management

### Professional Structure
- Uses standard JSON format compatible with OpenLane2
- Maintains industry-standard configuration practices
- Easy integration with automated tools and CI/CD systems

### Compatibility
- Fully compatible with OpenLane2's expected configuration format
- No custom configuration keys that could cause warnings
- Backward compatible with existing workflows

## Example Configuration Files

### Base Configuration Structure
```json
{
  "PDK": "sky130A",
  "STD_CELL_LIBRARY": "sky130_fd_sc_hd",
  "CLOCK_PORT": "clock",
  "CLOCK_PERIOD": 10.0,
  "FP_CORE_UTIL": 0.7,
  "SYNTH_STRATEGY": "AREA 0",
  ...
}
```

### Module-Specific Configuration Structure
```json
{
  "DESIGN_NAME": "ZeroNyteRV32ICore",
  "VERILOG_FILES": [
    "dir::../rtl/generators/generated/verilog_hierarchical_timed/ZeroNyteRV32ICore.v"
  ],
  "CLOCK_PERIOD": 10.0,
  "FP_CORE_UTIL": 0.7,
  "PNR_SDC_FILE": "constraints/ZeroNyteRV32ICore.sdc",
  "SIGNOFF_SDC_FILE": "constraints/ZeroNyteRV32ICore_signoff.sdc"
}
```

## Troubleshooting

### Common Issues

1. **Missing RTL Files**: Ensure that the RTL has been generated before running the physical design flow
2. **Configuration Validation Errors**: Check that all required OpenLane2 parameters are present
3. **Path Issues**: Verify that all file paths in the configuration are correct and accessible

### Prerequisites

- **jq**: Required for JSON configuration processing
- **OpenLane2**: Must be installed and accessible
- **Nix**: Required for OpenLane2 execution environment

## Future Enhancements

The configuration system is designed to be extensible. Future enhancements could include:

- Template-based configuration generation
- Environment variable substitution
- Configuration validation schemas
- Integration with design space exploration tools

This enhanced configuration system provides a solid foundation for managing complex physical design flows while maintaining the professional standards expected in modern ASIC design environments.
