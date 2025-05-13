#:__________________________________________________________________
#  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# @deps confy
import confy
# @deps builder
import ./src/build/glfw
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


#_______________________________________
# @section Build & Run
#_____________________________
# Order to build
quake3.report()
tests.build()
glfw.build()
quake3.build(pack)
# Order to run
quake3.run()

