//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
//! @fileoverview Data required by the Engine to run a Game.
//___________________________________________________________|
#ifndef H_id3_base
#define H_id3_base
// @deps id3
#include "./cstd.h"

typedef struct id3_Name {
  std_cstring Short;
  std_cstring Long;
  std_cstring human;
} id3_Name;

#endif  // H_id3_base

