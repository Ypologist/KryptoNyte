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
lazy val library = (project in file("library/rtl/chisel"))
  .settings(
    name := "Library",
    commonSettings 
  )

// ----------------- ZeroNyte Project -----------------
lazy val zeroNyte = (project in file("ZeroNyte/rv32i/rtl/chisel"))
  .dependsOn(library)
  .settings(
    name := "ZeroNyte",
    commonSettings 
  )

// ----------------- Root Project -----------------
lazy val root = (project in file("."))
  .aggregate(library, zeroNyte)
