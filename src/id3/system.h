//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#if !defined H_id3_system
#define H_id3_system

#include "./system/cli.h"
#include "./system/input.h"
#include "./system/window.h"

typedef struct id3_System {
  id3_CLI    cli;
  id3_Input  input;
  id3_Window window;  // TODO:
} id3_System;

id3_System id3_sys_init (id3_Args const* const cli);

#endif  // H_id3_system

