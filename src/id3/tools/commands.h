//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#ifndef H_id3_tools_commands
#define H_id3_tools_commands
// @deps idtech3
#include "../idtech3/tools/commands.h"


/// @description
/// Allocates an initial text buffer for the commands system that will grow as needed.
#define id3_cmd_buffer_init Cbuf_Init

/// @description
/// Initializes the base commands of the engine and their completion functions where relevant.
/// Commands initialized: `cmdlist`, `exec`, `execq`, `vstr`, `echo`, `wait`
#define id3_cmd_base_init Cmd_Init


#endif  // H_id3_tools_commands

