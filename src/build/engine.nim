#:__________________________________________________________________
#  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# @deps confy
import confy except cfg
# @deps oQ3.build
import ./state as B


#_______________________________________
# @section Engine: Configuration
#_____________________________
const name    * = "oQ3"
const version * = version(0,0,0)


#_______________________________________
# @section Engine: Compile Options
#_____________________________
let dir    * = B.cfg.dirs.src/"id3"
let source * = confy.glob(engine.dir)
let flags  * = Flags(cc: @[
  "-Wno-pre-c23-compat",
  "-Wno-documentation-unknown-command",
])

