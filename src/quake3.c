//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
//! @fileoverview                                                 |
//!  Engine Debug Example                                         |
//!  Will run the engine with the default QuakeIIIArena Gamecode  |
//________________________________________________________________|
#include "./id3/engine.h"
#include "./q3a.h"

// Engine: Cross-Platform Entry Point
int main (
  int const                argc,
  char const* const* const argv
) {
  id3_Args const cli           = id3_args_parse(argc, argv);
  id3_Game const QuakeIIIArena = q3a_create(&cli);
  id3_Engine     engine        = id3_init(&cli, QuakeIIIArena);
  id3_start(&engine);
  return id3_ShouldNeverHappen;  // The engine has an internal termination system
}
