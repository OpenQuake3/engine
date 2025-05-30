//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#if !defined H_id3_system_tui
#define H_id3_system_tui

#include "../idtech3/system/tui.h"
#include "../config/cvar.h"
#include "../tools/log.h"

typedef struct id3_TUI {
  id3_Cvar* enabled;
  id3_Cvar* color_ansi;
} id3_TUI;

#define id3_tui_input_init Sys_ConsoleInputInit

/// @description
/// Initializes/allocates all the system's TUI data used by the engine.
/// FIX: Might need to rename to split it in two parts, and rename this to id3_tui_create
id3_TUI id3_tui_init ();

#endif  // H_id3_system_tui

