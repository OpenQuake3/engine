#:__________________________________________________________________
#  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# @deps confy
import confy except cfg
# @deps oQ3.build
import ./state as B
import ./engine


#_______________________________________
# @section QuakeIIIArena: Configuration
#_____________________________
let entry   * = "quake3.c"
let version * = version(1,32,0,"b")


#_______________________________________
# @section QuakeIIIArena: Source Code
#_____________________________
let dir    * = B.cfg.dirs.src/"q3a"
let source * = confy.glob(quake3.dir)


#_______________________________________
# @section QuakeIIIArena: Build Target
#_____________________________
var target * = Program.new(
  cfg     = B.cfg,
  trg     = engine.name,
  entry   = quake3.entry,
  src     = engine.source & quake3.source,
  flags   = engine.flags,
  version = quake3.version,
  remotes = Remotes.none(),
  ) #:: quake3


#_______________________________________
# @section QuakeIIIArena: Builder Entry Point
#_____________________________
proc build  *(
    pack :bool= false;
  ) :auto {.discardable.}= return quake3.target.build()
proc run    *() :auto {.discardable.}= return quake3.target.run()
proc report *() :void= quake3.target.report()

