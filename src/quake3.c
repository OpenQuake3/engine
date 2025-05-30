//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
//! @fileoverview                                                 |
//!  Debug Example                                                |
//!  Will run the engine with the default QuakeIIIArena Gamecode  |
//________________________________________________________________|
#include "./id3.h"
#include "./q3a.h"

/// @description
/// Engine: Cross-Platform Entry Point Example.
/// Will setup and launch QuakeIIIArena gamecode.
int main (
  i32 const       argc,
  cstr_list const argv
) {
  id3_Args const args          = id3_args_create(argc, argv);
  id3_Game const QuakeIIIArena = q3a_create(&args);
  id3_Engine     engine        = id3_create(&args, QuakeIIIArena, /*dedicated=*/ false);
  id3_start(&engine);  // Will never return. The engine has an internal termination system
  std_discard(id3_ShouldNeverHappen);
}

