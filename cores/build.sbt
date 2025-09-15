ThisBuild / scalaVersion := "2.13.15"
ThisBuild / version := "0.1.0"
ThisBuild / organization := "%ORGANIZATION%"

val chiselVersion = "6.6.0"

// ----------------- Library Project -----------------
lazy val library = (project in file("library/rtl/chisel"))
  .settings(
    name := "Library",
    libraryDependencies ++= Seq(
      "org.chipsalliance" %% "chisel" % chiselVersion,
      "org.scalatest" %% "scalatest" % "3.2.16" % Test,
      "edu.berkeley.cs" %% "chiseltest" % "0.5.6" % Test,
      "org.slf4j" % "slf4j-api" % "2.0.9",
      "org.slf4j" % "slf4j-simple" % "2.0.9"
    ),
    scalacOptions ++= Seq(
      "-language:reflectiveCalls",
      "-deprecation",
      "-feature",
      "-Xcheckinit",
      "-Ymacro-annotations"
    ),
    addCompilerPlugin("org.chipsalliance" % "chisel-plugin" % chiselVersion cross CrossVersion.full),
    Compile / run / fork := true,
    Compile / run / javaOptions ++= Seq(
      "-Xmx4G",
      "-Dchisel.firtool=true",
      "-Dorg.slf4j.simpleLogger.defaultLogLevel=WARN",
      "-Dorg.slf4j.simpleLogger.showDateTime=true",
      "-Dorg.slf4j.simpleLogger.dateTimeFormat=yyyy-MM-dd HH:mm:ss"
    )
  )

// ----------------- ZeroNyte Project -----------------
lazy val zeroNyte = (project in file("ZeroNyte/rv32i/rtl/chisel"))
  .dependsOn(library)
  .settings(
    name := "ZeroNyte",
    libraryDependencies ++= Seq(
      "org.chipsalliance" %% "chisel" % chiselVersion,
      "org.scalatest" %% "scalatest" % "3.2.16" % Test,
      "edu.berkeley.cs" %% "chiseltest" % "0.5.6" % Test,
      "org.slf4j" % "slf4j-api" % "2.0.9",
      "org.slf4j" % "slf4j-simple" % "2.0.9"
    ),
    scalacOptions ++= Seq(
      "-language:reflectiveCalls",
      "-deprecation",
      "-feature",
      "-Xcheckinit",
      "-Ymacro-annotations"
    ),
    addCompilerPlugin("org.chipsalliance" % "chisel-plugin" % chiselVersion cross CrossVersion.full),
    Compile / run / fork := true,
    Compile / run / javaOptions ++= Seq(
      "-Xmx4G",
      "-Dchisel.firtool=true",
      "-Dorg.slf4j.simpleLogger.defaultLogLevel=WARN",
      "-Dorg.slf4j.simpleLogger.showDateTime=true",
      "-Dorg.slf4j.simpleLogger.dateTimeFormat=yyyy-MM-dd HH:mm:ss"
    ),

    // Compile / runMain / javaOptions ++= Seq(
    //   "-Xmx4G",
    //   "-Dchisel.firtool=true",
    //   "-Dorg.slf4j.simpleLogger.defaultLogLevel=WARN", 
    //   "-Dorg.slf4j.simpleLogger.showDateTime=true",    
    //   "-Dorg.slf4j.simpleLogger.dateTimeFormat=yyyy-MM-dd HH:mm:ss" 
    // )
  )

// ----------------- Root Project -----------------
lazy val root = (project in file(".")).aggregate(library, zeroNyte)
