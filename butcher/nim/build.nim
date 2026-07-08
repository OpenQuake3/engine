#:__________________________________________________________________
#  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
##! @fileoverview Buildsystem Entry Point for oQ3
#_________________________________________________|
# @deps confy
import confy
# @deps builder
import ./src/build/base as builder
import ./src/build/glfw
import ./src/build/idtech3
import ./src/build/quake3
import ./src/build/tests

#_______________________________________
# @section Buildsystem Control
#_____________________________
# CLI Control
const debug    = on                             ## (note: should always be off)  Buildsystem debug mode on/off. Marking it `on` will test everything, ignoring all other filters
let publish    = cli.has("--publish") or debug  ## `./bin/build --publish` to publish the result to GitHub
let release    = cli.has("r") or publish        ## `./bin/build -r` to run the automatic release generation process
let distribute = cli.has("d") or release        ## `./bin/build -d` to build the distributable version
let pack       = cli.has("p") or distribute     ## `./bin/build -p` to pack everything
# Build Options
const verbose     * = off                  ## Log debug messages from the buildsystem to CLI
const silent      * = off and not verbose  ## Silence every CLI message
const alwaysClean * = off or build.debug   ## Always removes folders/binaries before building them


#_______________________________________
# @section Build & Run
#_____________________________
# Build Dependencies
glfw.build()
let lib = idtech3.build(debug)
# Build Unit Tests
tests.build(lib, debug)
# Build QuakeIII Arena for oQ3
if debug:
  quake3.report(lib, silent)
  let q3a = quake3.build(lib)
  if pack: quake3.pack(q3a)
  # builder.runHost(q3a)

