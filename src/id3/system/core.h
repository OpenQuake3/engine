//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#if !defined H_id3_system_core
#define H_id3_system_core

#include "./cli.h"
#include "./input.h"
#include "./window.h"

typedef struct id3_System {
  id3_CLI cli;
  id3_Input input;
  id3_Window window;  // TODO:
} id3_System;

#endif  // H_id3_system_core

