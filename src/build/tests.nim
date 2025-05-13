# @deps confy
#:__________________________________________________________________
#  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
import confy except cfg
# @deps builder
import ./engine
import ./state as B


#_______________________________________
# @section Unit Testing: Engine
#_____________________________
let target * = UnitTest.new(
  cfg   = B.cfg,
  trg   = engine.name&".test",
  entry = "test.zig",
)

#_______________________________________
# @section Unit Testing: Builder Entry Point
#_____________________________
proc build *() :auto {.discardable.}= return tests.target.build()

