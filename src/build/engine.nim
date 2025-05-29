#:__________________________________________________________________
#  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
##! @fileoverview Tools and configuration for compiling oQ3 Engine
#__________________________________________________________________|
# @deps std
from std/os import splitFile
from std/strutils import startsWith
# @deps confy
import confy except cfg
# @deps oQ3.build


#_______________________________________
# @section Engine: Configuration
#_____________________________
var cfg * = confy.Config()
cfg.dirs.src = engine.cfg.dirs.src/"id3"
const version * = version(0,0,0)
const name * = Name(
  short : "oQ3",
  long  : "OpenQuake3",
  human : "Open Quake3 Engine"
  ) # << Name(... )
const repo * = Repository(
  owner : "OpenQuake3",
  name  : "engine"
  ) # << Repository( ... )


#_______________________________________
# @section Engine: Compile Options
#_____________________________
proc source *() :auto= confy.glob(engine.cfg.dirs.src)
#___________________
func linkFlags *(
    libid3 : confy.Target;
  ) :confy.Flags=
  let start = if libid3.trg.startsWith("lib"): 3 else: 0
  result = Flags(ld: @[
    &"-L{libid3.cfg.dirs.bin}",
    &"-l{libid3.trg[start..^1]}",
    "-lSDL2",
    ])
#___________________
func flags *(
    libid3 : confy.Target;
  ) :confy.Flags= result = engine.linkFlags(libid3) & Flags(cc: @[
  # Include libid3 code folder
  &"-I{libid3.cfg.dirs.src}",
  # Acceptable Warnings
  "-Wno-pre-c23-compat",
  "-Wno-documentation",
  "-Wno-documentation-unknown-command",
  # Stop ZigCC from silently crashing at runtime due to UBSAN traps
  "-fno-sanitize-trap=all",
  ], ld: engine.linkFlags(libid3).ld)

