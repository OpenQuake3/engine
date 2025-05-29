#:__________________________________________________________________
#  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
##! @fileoverview Builder Tools and configuration for compiling QuakeIIIArena for oQ3 engine
#____________________________________________________________________________________________|
# @deps confy
import confy except cfg
# @deps oQ3.build
import ./engine
import ./idtech3


#_______________________________________
# @section QuakeIIIArena: Configuration
#_____________________________
var cfg * = confy.Config()
cfg.dirs.src = cfg.dirs.src/"q3a"
let version * = version(1,32,0,"b")
# Source Code
let entry  * = "quake3.c"
proc source *() :auto= confy.glob(quake3.cfg.dirs.src)


#_______________________________________
# @section QuakeIIIArena: Builder Entry Points
#_____________________________
proc target *(
    libid3 : seq[confy.Target];
  ) :seq[confy.Target]=
  result = @[]
  for lib in libid3:
    result.add Program.new(
      entry   = quake3.entry,
      cfg     = quake3.cfg,
      trg     = engine.name.short,
      src     = engine.source() & quake3.source(),
      flags   = engine.flags(lib),
      version = quake3.version,
      remotes = Remotes.none(),
      ) #:: quake3
    result[^1].src.add engine.cfg.dirs.src/".."/quake3.entry
#___________________
proc build *(
    libid3 : seq[confy.Target];
  ) :seq[confy.Target] {.discardable.}=
  result = @[]
  for trg in quake3.target(libid3):
    result.add trg.build()
#___________________
proc pack *(
    q3a : seq[confy.Target];
  ) :void= discard q3a; echo ":::::::::::::: Packing QuakeIIIArena goes here ::::::::::::::::::::\n:::::::::::::: ..."
#___________________
proc report *(
    libid3 : seq[confy.Target];
    silent : bool = off;
  ) :void=
  if silent: return
  for trg in quake3.target(libid3):
    trg.report()

