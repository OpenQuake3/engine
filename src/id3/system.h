//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#if !defined H_id3_system
#define H_id3_system

#include "./system/cli.h"
#include "./system/input.h"
#include "./system/window.h"
#include "./system/fpu.h"

typedef struct id3_System {
  id3_CLI    cli;
  id3_Input  input;
  id3_Window window;  //< TODO: GLFW
} id3_System;

/// @description
/// Initializes/allocates all system-specific data used by the engine.
/// ie. Input, Window, CLI args, etc
id3_System id3_sys_init (id3_CLI const* const cli);

/// @description
/// Terminates/deallocates all system-specific data used by the engine.
/// ie. Input, Window, CLI args, etc
void id3_sys_term (id3_System* sys);

#endif  // H_id3_system

