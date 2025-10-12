ThisBuild / scalaVersion := "2.13.15"
ThisBuild / version      := "0.1.0"
ThisBuild / organization := "%ORGANIZATION%"

val chiselVersion = "6.6.0"

// ***************************
// * COMMON SETTINGS
// ***************************
lazy val commonSettings = Seq(
  // Library Dependencies
  libraryDependencies ++= Seq(
    "org.chipsalliance" %% "chisel"     % chiselVersion,
    "org.scalatest"     %% "scalatest"  % "3.2.16" % Test,
    "edu.berkeley.cs"   %% "chiseltest" % "0.5.6"  % Test,
    "org.slf4j"         % "slf4j-api"   % "2.0.9",
    "org.slf4j"         % "slf4j-simple"% "2.0.9"
  ),

  // Scala Compiler Options
  scalacOptions ++= Seq(
    "-language:reflectiveCalls",
    "-deprecation",
    "-feature",
    "-Xcheckinit",
    "-Ymacro-annotations"
  ),

  // Chisel Compiler Plugin
  addCompilerPlugin("org.chipsalliance" % "chisel-plugin" % chiselVersion cross CrossVersion.full),

  // Fork a new JVM for running and testing to apply javaOptions
  run / fork := true,
  Test / fork := true,

  // Java Options for forked JVMs (run and test)
  javaOptions ++= Seq(
    "-Xmx4G",
    "-Dchisel.firtool.path=/usr/local/bin/firtool",
    "-Dorg.slf4j.simpleLogger.defaultLogLevel=WARN",
    "-Dorg.slf4j.simpleLogger.showDateTime=true",
    "-Dorg.slf4j.simpleLogger.dateTimeFormat=yyyy-MM-dd HH:mm:ss"
  )
)

// ***************************
// * PROJECT SETTINGS
// ***************************

// ----------------- Library Project -----------------
lazy val library = (project in file("library"))
  .settings(
    name := "Library"
  )
  .settings(commonSettings: _*)

// ----------------- ZeroNyte Project -----------------
lazy val zeroNyte = (project in file("ZeroNyte/rv32i"))
  .dependsOn(library)
  .settings(
    name := "ZeroNyte"
  )
  .settings(commonSettings: _*)

// ----------------- PipeNyte Project -----------------
lazy val tetraNyte = (project in file("TetraNyte/rv32i"))
  .dependsOn(library)
  .settings(
    name := "TetraNyte"
  )
  .settings(commonSettings: _*)

// ----------------- Generators Project -----------------
lazy val generators = (project in file("generators"))
  .dependsOn(library, zeroNyte, tetraNyte)
  .settings(
    name := "Generators"
  )
  .settings(commonSettings: _*)
  .settings(
    
    // Ensure dependencies are compiled before generators
    Compile / compile := (Compile / compile).dependsOn(
      library / Compile / compile,
      zeroNyte / Compile / compile,
      tetraNyte / Compile / compile
    ).value,
    
    // Additional dependencies for RTL generation 
    libraryDependencies ++= Seq(
      "com.typesafe" % "config" % "1.4.2"
    ),
    
    // Custom tasks for convenience - ensure dependencies are compiled first
    TaskKey[Unit]("generateRTL") := {
      (library / Compile / compile).value
      (zeroNyte / Compile / compile).value
      (tetraNyte / Compile / compile).value
      (Compile / runMain).toTask(" generators.GenerateHierarchicalRTL").value
    },
    
  )

// ----------------- Root Project -----------------
lazy val root = (project in file("."))
  .aggregate(library, zeroNyte, tetraNyte, generators)
  .settings(
    name := "KryptoNyte",
    
    // Custom command aliases for easy access
    addCommandAlias("genZeroNyte", "generators/runMain generators.GenerateHierarchicalRTL --core-family ZeroNyte"),
    addCommandAlias("genPipeNyte", "generators/runMain generators.GenerateHierarchicalRTL --core-family PipeNyte"),
    addCommandAlias("genTetraNyte", "generators/runMain generators.GenerateHierarchicalRTL --core-family TetraNyte"),
    addCommandAlias("genOctoNyte", "generators/runMain generators.GenerateHierarchicalRTL --core-family OctoNyte"),
    
  )
