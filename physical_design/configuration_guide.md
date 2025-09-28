_metadata```

### 2. Base Configuration (`config.base.json`)

This file defines common settings that are shared across all designs in the KryptoNyte project. It helps to ensure consistency and reduce duplication.

**Key Sections:**
- **`PDK_CONFIG`**: Defines the Process Design Kit (PDK) and standard cell library.
- **`DEFAULT_*_CONFIG`**: Provides default parameters for various stages of the flow (synthesis, floorplan, placement, routing).
- **`COMMON_PATHS`**: Defines base paths for RTL, constraints, and output directories.

### 3. Module-Specific Configuration (`config.<module_name>.json`)

This file contains settings that are specific to a particular module. It inherits from the base configuration and can override any of the default settings.

**Key Features:**
- **`_metadata.extends`**: Specifies the base configuration file to inherit from.
- **`DESIGN_NAME`**: The name of the module being processed.
- **`VERILOG_FILES`**: A list of Verilog files required for the module.
- **`CONSTRAINT_FILES`**: Paths to the SDC constraint files for the module.
- **`MODULE_SPECIFIC`**: A section for custom, module-specific metadata.

## How to Use the New Configuration System

The enhanced physical design flow is driven by the `generate_physical_design_v2.sh` script. Here’s how to use it:

### Basic Usage

To run the physical design flow for a specific module, use the `--module-name` argument:

```bash
./generate_physical_design_v2.sh --module-name ZeroNyteRV32ICore
```

By default, the script will look for a configuration file named `config.ZeroNyteRV32ICore.json`.

### Specifying Custom Configuration Files

You can also specify custom base and module configuration files:

```bash
./generate_physical_design_v2.sh \
    --module-name MyCustomModule \
    --config-base my_base_config.json \
    --config-module my_module_config.json
```

### How it Works

1.  **Configuration Merging**: The script first merges the base and module-specific configuration files. The module-specific settings take precedence.
2.  **Template Processing**: The merged configuration is then used to populate the `config.template.json` file. This is done by substituting environment variables in the template with the values from the merged configuration.
3.  **OpenLane2 Execution**: The final, processed JSON configuration is then passed to OpenLane2 to run the physical design flow.

## Benefits of the New System

- **Flexibility**: The template-based approach allows for dynamic and conditional configurations, similar to the flexibility of TCL-based systems.
- **Maintainability**: By separating base, module-specific, and template configurations, the system is easier to manage and update.
- **Professional Structure**: The use of JSON maintains a professional, industry-standard configuration format that is easy to parse and validate.
- **Portability**: The use of environment variables and relative paths makes the flow more portable across different environments.

## Conclusion

The new configuration system provides a powerful and flexible way to manage the physical design flow in KryptoNyte. By combining the structured nature of JSON with the flexibility of a template-based approach, it offers the best of both worlds, enabling a more robust and maintainable design process.
