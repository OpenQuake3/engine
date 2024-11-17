//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "./id3.hpp"

//______________________________________
// @section Engine: Entry Point
//______________________________________
i32 main (i32 const argc, cstr const argv[argc]) {
  id3::Game game;
  id3::Engine engine = id3::Engine(game, argc, argv);
  engine.start();
  return id3::Error::ShouldNeverHappen;  // @note The engine has an internal termination process using jmp.
} //:: main

