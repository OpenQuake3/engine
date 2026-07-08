# @deps confy
#:__________________________________________________________________
#  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# @deps std
from std/sequtils import filterIt
from std/strutils import replace
# @deps confy
import confy except cfg
# @deps builder
from ./engine import nil


#_______________________________________
# @section Unit Testing: Builder Entry Points
#_____________________________
proc target *(
    libid3 : seq[confy.Target];
    name   : string = engine.name.short,
  ) :confy.Target=
  let cfg = confy.Config()
  result = UnitTest.new(
    entry = "test.zig",
    trg   = name&".test",
    cfg   = cfg,
    ) #:: result
  let lib     = libid3.filterIt(it.system == System.host)[0]
  let libName = lib.trg.replace("lib", "")
  result.flags.ld.add @[&"-L{lib.cfg.dirs.bin}", &"-l{libName}"]
#___________________
proc build *(
    libid3 : seq[confy.Target];
    debug  : bool = off;
  ) :confy.Target {.discardable.}=
  if not debug: return tests.target(libid3)
  return tests.target(libid3).build()

