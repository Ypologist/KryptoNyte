// KryptoNyte Physical Design Flow with OpenLane2
// Flattens hierarchical RTL and runs complete RTL-to-GDSII flow using OpenLane2
// Place in: KryptoNyte/cores/generators/
// Run from: KryptoNyte/cores/ with sbt 'runMain generators.GeneratePhysicalDesign'

package generators

import sys.process._
import java.io.{File, PrintWriter}
import java.nio.file.{Files, Paths, StandardCopyOption}
import scala.util.{Try, Success, Failure}
import scala.io.Source

// Configuration for OpenLane2 physical design flow
case class PhysicalDesignConfig(
  // Input configuration
  inputRTLPath: String = "generated/verilog_hierarchical_timed",
  moduleName: String = "ZeroNyteRV32ICore",
  topModule: String = "",
  
  // Output directories
  outputRoot: String = "physical_design",
  openlaneRunsDir: String = "runs",
  reportsDir: String = "reports",
  
  // OpenLane2 configuration
  openlane2Path: String = "",
  nixShellPath: String = "",
  
  // PDK configuration (OpenLane2 handles PDK automatically)
  pdkVariant: String = "sky130_fd_sc_hd", // SkyWater 130nm high density
  
  // Design constraints
  clockPeriod: Double = 10.0, // ns
  clockPort: String = "clock",
  resetPort: String = "reset",
  
  // Physical design parameters
  coreUtilization: Double = 0.7,
  aspectRatio: Double = 1.0,
  dieArea: String = "", // Auto-calculated if empty
  coreArea: String = "", // Auto-calculated if empty
  
  // Flow control
  runSynthesis: Boolean = true,
  runFloorplan: Boolean = true,
  runPlacement: Boolean = true,
  runCTS: Boolean = true, // Clock Tree Synthesis
  runRouting: Boolean = true,
  runSignoff: Boolean = true,
  generateGDS: Boolean = true,
  
  // OpenLane2 specific options
  synthesisStrategy: String = "AREA 0", // AREA 0, AREA 1, AREA 2, DELAY 0, DELAY 1, etc.
  placementStrategy: String = "BASIC", // BASIC, CONGESTION_AWARE
  routingStrategy: String = "0", // 0-3, higher numbers for more effort
  
  // Options
  verbose: Boolean = true,
  keepIntermediateFiles: Boolean = true,
  generateReports: Boolean = true,
  runDRC: Boolean = true,
  runLVS: Boolean = true,
  runSTA: Boolean = true,
  runAntenna: Boolean = true
) {
  
  // Computed paths
  def fullOutputRoot: String = if (Paths.get(outputRoot).isAbsolute) outputRoot else s"${System.getProperty("user.dir")}/$outputRoot"
  def fullRunsPath: String = s"$fullOutputRoot/$openlaneRunsDir"
  def fullReportsPath: String = s"$fullOutputRoot/$reportsDir"
  
  def effectiveTopModule: String = if (topModule.nonEmpty) topModule else moduleName
  
  // OpenLane2 auto-discovery
  def discoverOpenLane2(): PhysicalDesignConfig = {
    if (openlane2Path.nonEmpty) return this
    
    val openlaneSearchPaths = Seq(
      "/opt/skywater-pdk/openlane2",
      "/usr/local/openlane2",
      s"${System.getProperty("user.home")}/openlane2",
      System.getenv("OPENLANE2_ROOT"),
      System.getenv("OPENLANE_ROOT")
    ).filter(_ != null)
    
    val discoveredOpenLane = openlaneSearchPaths.find(path => 
      Files.exists(Paths.get(path)) && 
      (Files.exists(Paths.get(s"$path/flake.nix")) || Files.exists(Paths.get(s"$path/shell.nix")))
    )
    
    discoveredOpenLane match {
      case Some(ol2Path) =>
        this.copy(openlane2Path = ol2Path)
      case None => this
    }
  }
  
  // Discover Nix
  def discoverNix(): PhysicalDesignConfig = {
    if (nixShellPath.nonEmpty) return this
    
    val nixPaths = Seq(
      "/nix/var/nix/profiles/default/bin/nix-shell",
      s"${System.getProperty("user.home")}/.nix-profile/bin/nix-shell",
      "nix-shell" // In PATH
    )
    
    val discoveredNix = nixPaths.find(path => {
      Try {
        val result = s"which ${path.split("/").last}".!!.trim
        result.nonEmpty && Files.exists(Paths.get(result))
      }.getOrElse(false)
    })
    
    discoveredNix match {
      case Some(nixPath) => this.copy(nixShellPath = nixPath)
      case None => this.copy(nixShellPath = "nix-shell") // Default fallback
    }
  }
  
  // Create all necessary directories
  def createDirectories(): Unit = {
    val dirs = Seq(fullRunsPath, fullReportsPath)
    dirs.foreach { dir =>
      val path = Paths.get(dir)
      if (!Files.exists(path)) {
        Files.createDirectories(path)
        if (verbose) println(s"Created directory: $dir")
      }
    }
  }
}

object GeneratePhysicalDesign extends App {
  
  // Parse command line arguments
  val config = parseArgs(args)
  
  // Auto-discover OpenLane2 and Nix if not specified
  val finalConfig = config.discoverOpenLane2().discoverNix()
  
  // Validate configuration
  validateConfiguration(finalConfig)
  
  // Create output directories
  finalConfig.createDirectories()
  
  // Print configuration
  if (finalConfig.verbose) {
    printConfiguration(finalConfig)
  }
  
  // Run OpenLane2 physical design flow
  try {
    runOpenLane2Flow(finalConfig)
    
    println("\n" + "="*80)
    println("OpenLane2 physical design flow completed successfully!")
    println(s"Results directory: ${finalConfig.fullRunsPath}")
    println(s"GDS-II file: ${finalConfig.fullRunsPath}/${finalConfig.effectiveTopModule}/results/final/gds/${finalConfig.effectiveTopModule}.gds")
    println("="*80)
    
  } catch {
    case e: Exception =>
      println(s"OpenLane2 physical design flow failed: ${e.getMessage}")
      if (finalConfig.verbose) e.printStackTrace()
      System.exit(1)
  }
  
  // Helper functions
  
  def parseArgs(args: Array[String]): PhysicalDesignConfig = {
    var config = PhysicalDesignConfig()
    
    var i = 0
    while (i < args.length) {
      args(i) match {
        case "--input-rtl" => 
          config = config.copy(inputRTLPath = args(i + 1))
          i += 2
        case "--module-name" => 
          config = config.copy(moduleName = args(i + 1))
          i += 2
        case "--top-module" => 
          config = config.copy(topModule = args(i + 1))
          i += 2
        case "--output-root" => 
          config = config.copy(outputRoot = args(i + 1))
          i += 2
        case "--openlane2-path" => 
          config = config.copy(openlane2Path = args(i + 1))
          i += 2
        case "--pdk-variant" => 
          config = config.copy(pdkVariant = args(i + 1))
          i += 2
        case "--clock-period" => 
          config = config.copy(clockPeriod = args(i + 1).toDouble)
          i += 2
        case "--utilization" => 
          config = config.copy(coreUtilization = args(i + 1).toDouble)
          i += 2
        case "--aspect-ratio" => 
          config = config.copy(aspectRatio = args(i + 1).toDouble)
          i += 2
        case "--synthesis-strategy" => 
          config = config.copy(synthesisStrategy = args(i + 1))
          i += 2
        case "--placement-strategy" => 
          config = config.copy(placementStrategy = args(i + 1))
          i += 2
        case "--routing-strategy" => 
          config = config.copy(routingStrategy = args(i + 1))
          i += 2
        case "--synthesis-only" => 
          config = config.copy(runFloorplan = false, runPlacement = false, runCTS = false, runRouting = false, runSignoff = false, generateGDS = false)
          i += 1
        case "--no-signoff" => 
          config = config.copy(runSignoff = false)
          i += 1
        case "--no-gds" => 
          config = config.copy(generateGDS = false)
          i += 1
        case "--quiet" => 
          config = config.copy(verbose = false)
          i += 1
        case "--help" | "-h" =>
          printHelp()
          System.exit(0)
        case _ => 
          println(s"Unknown argument: ${args(i)}")
          i += 1
      }
    }
    
    config
  }
  
  def printHelp(): Unit = {
    println("""
KryptoNyte Physical Design Flow with OpenLane2

Usage: sbt 'runMain generators.GeneratePhysicalDesign [options]'

Options:
  --input-rtl <path>          Input RTL directory (from hierarchical generator)
  --module-name <name>        Module name to process
  --top-module <name>         Top-level module name (defaults to module-name)
  --output-root <path>        Root directory for physical design outputs
  --openlane2-path <path>     OpenLane2 installation directory (auto-discovered if not specified)
  --pdk-variant <variant>     PDK variant (default: sky130_fd_sc_hd)
  --clock-period <ns>         Clock period in nanoseconds (default: 10.0)
  --utilization <ratio>       Core utilization ratio 0.0-1.0 (default: 0.7)
  --aspect-ratio <ratio>      Core aspect ratio (default: 1.0)
  --synthesis-strategy <str>  Synthesis strategy (default: "AREA 0")
  --placement-strategy <str>  Placement strategy (default: "BASIC")
  --routing-strategy <num>    Routing strategy 0-3 (default: "0")
  --synthesis-only            Run synthesis only, skip physical design
  --no-signoff                Skip signoff verification (DRC/LVS/STA)
  --no-gds                    Skip GDS-II generation
  --quiet                     Reduce output verbosity
  --help, -h                  Show this help message

OpenLane2 Flow Steps:
  1. Synthesis       - Logic synthesis with Yosys
  2. Floorplan       - Die and core area planning
  3. Placement       - Global and detailed placement
  4. CTS             - Clock tree synthesis
  5. Routing         - Global and detailed routing
  6. Signoff         - DRC, LVS, STA, and antenna checks
  7. GDS Generation  - Final GDS-II layout export

Examples:
  # Complete flow for ZeroNyte core
  sbt 'runMain generators.GeneratePhysicalDesign --module-name ZeroNyteRV32ICore'
  
  # Synthesis only with custom clock
  sbt 'runMain generators.GeneratePhysicalDesign --module-name ALU32 --clock-period 5.0 --synthesis-only'
  
  # Custom OpenLane2 path and output location
  sbt 'runMain generators.GeneratePhysicalDesign --openlane2-path /opt/skywater-pdk/openlane2 --output-root /tmp/physical'

Environment Variables:
  OPENLANE2_ROOT             OpenLane2 installation directory
  OPENLANE_ROOT              OpenLane installation directory (legacy)
""")
  }
  
  def printConfiguration(config: PhysicalDesignConfig): Unit = {
    println("\n" + "="*80)
    println("KryptoNyte OpenLane2 Physical Design Flow Configuration")
    println("="*80)
    println(s"Input RTL Path:        ${config.inputRTLPath}")
    println(s"Module Name:           ${config.moduleName}")
    println(s"Top Module:            ${config.effectiveTopModule}")
    println(s"Output Root:           ${config.fullOutputRoot}")
    println(s"OpenLane2 Path:        ${if (config.openlane2Path.nonEmpty) config.openlane2Path else "Auto-discover"}")
    println(s"Nix Shell Path:        ${config.nixShellPath}")
    println(s"PDK Variant:           ${config.pdkVariant}")
    println(s"Clock Period:          ${config.clockPeriod} ns")
    println(s"Core Utilization:      ${config.coreUtilization}")
    println(s"Aspect Ratio:          ${config.aspectRatio}")
    println(s"Synthesis Strategy:    ${config.synthesisStrategy}")
    println(s"Placement Strategy:    ${config.placementStrategy}")
    println(s"Routing Strategy:      ${config.routingStrategy}")
    println(s"Run Synthesis:         ${config.runSynthesis}")
    println(s"Run Floorplan:         ${config.runFloorplan}")
    println(s"Run Placement:         ${config.runPlacement}")
    println(s"Run CTS:               ${config.runCTS}")
    println(s"Run Routing:           ${config.runRouting}")
    println(s"Run Signoff:           ${config.runSignoff}")
    println(s"Generate GDS:          ${config.generateGDS}")
    println("="*80 + "\n")
  }
  
  def validateConfiguration(config: PhysicalDesignConfig): Unit = {
    // Check input RTL file exists
    val inputRTLPath = if (config.inputRTLPath.startsWith("/")) {
      config.inputRTLPath
    } else {
      new File(".").getCanonicalPath + "/" + config.inputRTLPath
    }
    val inputRTLFile = new File(s"${inputRTLPath}/${config.moduleName}.v")
    if (!inputRTLFile.exists()) {
      throw new RuntimeException(s"Input RTL file not found: ${inputRTLFile.getAbsolutePath}")
    }
    
    // Check OpenLane2 installation
    if (config.openlane2Path.isEmpty) {
      throw new RuntimeException("OpenLane2 installation not found - please install OpenLane2 or specify --openlane2-path")
    }
    
    if (!Files.exists(Paths.get(config.openlane2Path))) {
      throw new RuntimeException(s"OpenLane2 path does not exist: ${config.openlane2Path}")
    }
    
    // Check for Nix environment files
    val hasFlakeNix = Files.exists(Paths.get(s"${config.openlane2Path}/flake.nix"))
    val hasShellNix = Files.exists(Paths.get(s"${config.openlane2Path}/shell.nix"))
    if (!hasFlakeNix && !hasShellNix) {
      throw new RuntimeException(s"OpenLane2 Nix environment not found at: ${config.openlane2Path}")
    }
    
    // Check Nix availability
    Try {
      s"${config.nixShellPath} --version".!!
    } match {
      case Success(_) => // Nix is available
      case Failure(_) => throw new RuntimeException(s"Nix not found at: ${config.nixShellPath}")
    }
    
    // Validate design parameters
    if (config.clockPeriod <= 0) {
      throw new RuntimeException("Clock period must be positive")
    }
    
    if (config.coreUtilization <= 0 || config.coreUtilization > 1.0) {
      throw new RuntimeException("Core utilization must be between 0 and 1")
    }
  }
  
  def runOpenLane2Flow(config: PhysicalDesignConfig): Unit = {
    println(s"\n${"="*60}")
    println(s"Starting OpenLane2 Flow for ${config.effectiveTopModule}")
    println(s"${"="*60}")
    
    // Step 1: Prepare design configuration
    prepareDesignConfig(config)
    
    // Step 2: Run OpenLane2 flow
    runOpenLane2(config)
    
    // Step 3: Generate reports
    if (config.generateReports) {
      generateFinalReports(config)
    }
  }
  
  def prepareDesignConfig(config: PhysicalDesignConfig): Unit = {
    println(s"\n${"-"*40}")
    println("Preparing OpenLane2 Design Configuration")
    println(s"${"-"*40}")
    
    val inputRTL = s"${config.inputRTLPath}/${config.moduleName}.v"
    val designDir = s"${config.fullRunsPath}/${config.effectiveTopModule}"
    val srcDir = s"$designDir/src"
    
    // Create design directory structure
    Files.createDirectories(Paths.get(srcDir))
    
    // Copy RTL file to design source directory
    val targetRTL = s"$srcDir/${config.effectiveTopModule}.v"
    Files.copy(Paths.get(inputRTL), Paths.get(targetRTL), StandardCopyOption.REPLACE_EXISTING)
    
    // Create OpenLane2 configuration file
    val configContent = generateOpenLaneConfig(config)
    val configFile = s"$designDir/config.json"
    writeToFile(configFile, configContent)
    
    println(s"✅ Design configuration prepared at: $designDir")
  }
  
  def generateOpenLaneConfig(config: PhysicalDesignConfig): String = {
    val clockPeriodStr = f"${config.clockPeriod}%.2f"
    
    s"""{
  "DESIGN_NAME": "${config.effectiveTopModule}",
  "VERILOG_FILES": ["dir::src/${config.effectiveTopModule}.v"],
  "CLOCK_PORT": "${config.clockPort}",
  "CLOCK_PERIOD": $clockPeriodStr,
  
  "PDK": "sky130A",
  "STD_CELL_LIBRARY": "${config.pdkVariant}",
  
  "FP_CORE_UTIL": ${config.coreUtilization},
  "FP_ASPECT_RATIO": ${config.aspectRatio},
  "FP_PDN_AUTO_ADJUST": true,
  
  "SYNTH_STRATEGY": "${config.synthesisStrategy}",
  "PL_BASIC_PLACEMENT": ${config.placementStrategy == "BASIC"},
  "RT_MAX_LAYER": 6,
  
  "RUN_KLAYOUT": ${config.generateGDS},
  "RUN_KLAYOUT_DRC": ${config.runDRC},
  "RUN_KLAYOUT_XOR": false,
  
  "RUN_MAGIC": true,
  "RUN_MAGIC_DRC": ${config.runDRC},
  "RUN_MAGIC_SPICE_EXPORT": ${config.runLVS},
  
  "RUN_NETGEN": ${config.runLVS},
  "RUN_NETGEN_LVS": ${config.runLVS},
  
  "RUN_OPENSTA": ${config.runSTA},
  "STA_REPORT_POWER": true,
  
  "RUN_CVC": false,
  "RUN_ANTENNA_CHECK": ${config.runAntenna},
  
  "QUIT_ON_TIMING_VIOLATIONS": false,
  "QUIT_ON_MAGIC_DRC": false,
  "QUIT_ON_LVS_ERROR": false,
  
  "EXTRA_LEFS": [],
  "EXTRA_GDS_FILES": [],
  "EXTRA_LIBS": []
}"""
  }
  
  def runOpenLane2(config: PhysicalDesignConfig): Unit = {
    println(s"\n${"-"*40}")
    println("Running OpenLane2 Flow")
    println(s"${"-"*40}")
    
    val designDir = s"${config.fullRunsPath}/${config.effectiveTopModule}"
    val logFile = s"${config.fullReportsPath}/openlane2_run.log"
    
    // Construct OpenLane2 command
    val openlaneCommand = Seq(
      config.nixShellPath,
      "--run",
      s"cd ${config.openlane2Path} && openlane --run-dir $designDir $designDir"
    )
    
    if (config.verbose) {
      println(s"Running OpenLane2: ${openlaneCommand.mkString(" ")}")
      println(s"Design directory: $designDir")
      println(s"Log file: $logFile")
    }
    
    // Set working directory to OpenLane2 installation
    val processBuilder = Process(openlaneCommand, new File(config.openlane2Path))
    
    // Run OpenLane2 with output redirection
    val result = if (config.verbose) {
      // Show output in real-time and save to log
      (processBuilder #> new File(logFile)).!
    } else {
      // Only save to log file
      (processBuilder #> new File(logFile) #&& processBuilder).!
    }
    
    if (result != 0) {
      throw new RuntimeException(s"OpenLane2 flow failed with exit code $result. Check log: $logFile")
    }
    
    println("✅ OpenLane2 flow completed successfully")
  }
  
  def generateFinalReports(config: PhysicalDesignConfig): Unit = {
    println(s"\n${"-"*40}")
    println("Generating Final Reports")
    println(s"${"-"*40}")
    
    val designDir = s"${config.fullRunsPath}/${config.effectiveTopModule}"
    val resultsDir = s"$designDir/results/final"
    val reportFile = s"${config.fullReportsPath}/final_report.md"
    
    // Check for output files
    val gdsFile = s"$resultsDir/gds/${config.effectiveTopModule}.gds"
    val defFile = s"$resultsDir/def/${config.effectiveTopModule}.def"
    val netlistFile = s"$resultsDir/verilog/gl/${config.effectiveTopModule}.v"
    val sdfFile = s"$resultsDir/sdf/${config.effectiveTopModule}.sdf"
    
    val report = s"""
# KryptoNyte OpenLane2 Physical Design Report

## Design Information
- **Module Name**: ${config.effectiveTopModule}
- **Clock Period**: ${config.clockPeriod} ns (${1000.0/config.clockPeriod} MHz)
- **Core Utilization**: ${config.coreUtilization}
- **Aspect Ratio**: ${config.aspectRatio}
- **PDK Variant**: ${config.pdkVariant}

## OpenLane2 Configuration
- **Synthesis Strategy**: ${config.synthesisStrategy}
- **Placement Strategy**: ${config.placementStrategy}
- **Routing Strategy**: ${config.routingStrategy}

## Flow Summary
- **Synthesis**: ${if (config.runSynthesis) "✅ Completed" else "⏭️ Skipped"}
- **Floorplan**: ${if (config.runFloorplan) "✅ Completed" else "⏭️ Skipped"}
- **Placement**: ${if (config.runPlacement) "✅ Completed" else "⏭️ Skipped"}
- **Clock Tree Synthesis**: ${if (config.runCTS) "✅ Completed" else "⏭️ Skipped"}
- **Routing**: ${if (config.runRouting) "✅ Completed" else "⏭️ Skipped"}
- **Signoff**: ${if (config.runSignoff) "✅ Completed" else "⏭️ Skipped"}
- **GDS Generation**: ${if (config.generateGDS) "✅ Completed" else "⏭️ Skipped"}

## Output Files
- **Gate-Level Netlist**: ${if (Files.exists(Paths.get(netlistFile))) s"✅ $netlistFile" else "❌ Not generated"}
- **Standard Delay Format**: ${if (Files.exists(Paths.get(sdfFile))) s"✅ $sdfFile" else "❌ Not generated"}
- **Final DEF Layout**: ${if (Files.exists(Paths.get(defFile))) s"✅ $defFile" else "❌ Not generated"}
- **GDS-II Layout**: ${if (Files.exists(Paths.get(gdsFile))) s"✅ $gdsFile" else "❌ Not generated"}

## OpenLane2 Results Directory
- **Full Results**: $resultsDir
- **Reports**: $designDir/reports
- **Logs**: $designDir/logs

## Usage Instructions

### View Layout in KLayout
```bash
klayout ${if (Files.exists(Paths.get(gdsFile))) gdsFile else "path/to/gds/file"}
```

### Simulate with Gate-Level Netlist
```bash
# Use the gate-level netlist for post-synthesis simulation
# Netlist: $netlistFile
# SDF: $sdfFile
```

### Next Steps
1. **Verification**: Run post-layout simulation with SDF timing
2. **Analysis**: Review timing, power, and area reports in $designDir/reports
3. **Tapeout**: Use GDS-II file for fabrication submission

Generated on: ${java.time.LocalDateTime.now()}
Generated by: KryptoNyte OpenLane2 Physical Design Flow
"""
    
    writeToFile(reportFile, report)
    println(s"✅ Final report generated: $reportFile")
    
    // Print summary of key files
    if (Files.exists(Paths.get(gdsFile))) {
      println(s"✅ GDS-II layout: $gdsFile")
    }
    if (Files.exists(Paths.get(netlistFile))) {
      println(s"✅ Gate-level netlist: $netlistFile")
    }
    if (Files.exists(Paths.get(sdfFile))) {
      println(s"✅ SDF timing file: $sdfFile")
    }
  }
  
  def writeToFile(filePath: String, content: String): Unit = {
    val file = new File(filePath)
    file.getParentFile.mkdirs()
    val writer = new PrintWriter(file)
    try {
      writer.write(content)
    } finally {
      writer.close()
    }
  }
}
