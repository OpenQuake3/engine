#:__________________________________________________________________
#  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
##! @fileoverview Builder Tools and configuration for compiling QuakeIIIArena for oQ3 engine
#____________________________________________________________________________________________|
# @deps std
from std/times as time import `$`
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
const name * = Name(short: "QuakeIIIArena", long: "Quake-III-Arena", human: "Quake-III-Arena GPL source release")
const author = "id-Software"
const package * = confy.package.Info(
  name        : quake3.name.long,
  description : engine.name.human&" | "&quake3.name.human&"by "&quake3.author,
  author      : Name(short:quake3.author, long:quake3.author, human:quake3.author),
  license     : "GPLv3-or-later",
  repo        : Repository(owner:quake3.author, name:quake3.name.long),
  url         : "https://idsoftware.com",
  version     : version(1,32,0,"b"),
  ) #:: quake3.package.Info
# Source Code
let entry * = "quake3.c"
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
      trg     = quake3.name.short,
      src     = engine.source() & quake3.source(),
      flags   = engine.flags(lib),
      version = quake3.package.version,
      remotes = Remotes.none(),
      system  = lib.system,
      ) #:: quake3
    result[^1].src.add engine.cfg.dirs.src/".."/quake3.entry
    result[^1].flags.cc.add @[
      &"-Did3_meta_Version=\"\\\"{quake3.package.version}\"\\\"",
      &"-Did3_meta_BuildPlatform=\"\\\"{lib.system.os}-{lib.system.cpu}-{lib.system.abi}\"\\\"",
      &"-Did3_meta_BuildDate=\"\\\"{$time.now()}\\\"\"",
      &"-Did3_log_Prefix=\"\\\"{quake3.name.short}\\\"\""
      ]
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
  quake3.package.report()
  for trg in quake3.target(libid3):
    trg.report()

