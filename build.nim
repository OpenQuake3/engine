#:__________________________________________________________________
#  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
import confy

#_______________________________________
# @section Engine: Configuration
#_____________________________
const engine_name    = "oQ3"
const engine_version = version(0,0,0)


#_______________________________________
# @section Engine: Source Code
#_____________________________
const engine_entry  = "quake3.c"
const engine_source = @[ # FIX: Get with glob
  "id3/args.c",
  "id3/engine.c",
  "id3/game.c",
  ]
const engine_flags = Flags(cc: @[
  "-std=c2x",
  "-Wno-pre-c23-compat"
])

#_______________________________________
# @section QuakeIIIArena: Source Code
#_____________________________
const quake3_source = @[
  "q3a/entry.c",
]


#_______________________________________
# @section QuakeIIIArena: Build Target
#_____________________________
const quake3 = Program.new(
  trg     = engine_name,
  entry   = engine_entry,
  src     = engine_source & quake3_source,
  flags   = engine_flags,
  version = engine_version,
)

#_______________________________________
# @section Unit Testing: Build Target
#_____________________________
const tests = UnitTest.new(
  trg   = engine_name&".test",
  entry = "test.zig",
)

#_______________________________________
# @section Build & Run
#_____________________________
# Order to build
tests.build()
quake3.build()
# Order to run
tests.run()
quake3.run()

