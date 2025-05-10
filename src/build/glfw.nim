#:__________________________________________________________________
#  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
#! @fileoverview Build Dependencies: GLFW
#__________________________________________|
# @deps std
import std/os
# @deps build
import confy


#______________________________________
# @section GLFW: Build Config
#____________________________
let dir_src * = confy.cfg.dirs.src/"lib"/"glfw"
let dir_bin * = glfw.dir_src/"build"
let flags   * = confy.Flags(
  cc: @[ "-I" & glfw.dir_src/"include" ],
  ld: @[
    "-L" & glfw.dir_src/"build/src",
    "-lm", "-lglfw3", "-lvulkan",
  ],
)


#______________________________________
# @section GLFW Builder: Entry Point
#____________________________
proc build *(alwaysClean :bool= false) :void=
  # Clean before running
  var clean = confy.Command()
  clean.add("rm", "-rf", glfw.dir_bin)
  if alwaysClean: clean.run()

  # Run cmake to generate the builder
  var cmake = confy.Command()
  cmake.add("cmake", "-S", glfw.dir_src, "-B", glfw.dir_bin)
  cmake.run()

  # Run make to build
  var make = confy.Command()
  make.add("make", "-j8", "-C", glfw.dir_bin, "glfw")
  make.run()

