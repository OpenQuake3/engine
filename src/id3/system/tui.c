//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "./tui.h"


id3_TUI id3_tui_init () {
  // id3_tui_input_init (aka. Sys_ConsoleInputInit()) might be called in signal handler so modify/init its cvars here
  id3_TUI result    = (id3_TUI){};
  result.enabled    = id3_cvar_create("ttycon", "1", 0, "Enable access to input/output console terminal.");
  result.color_ansi = id3_cvar_create("ttycon_ansicolor", "0", id3_cvar_Archive, "Convert in-game color codes to ANSI color codes in console terminal.");

  switch (id3_tui_input_init()) {
    case id3_tui_Enabled : id3_log_info("Started tty console (use +set ttycon 0 to disable)"); break;
    case id3_tui_Error   : {
      id3_log_warn("stdin is not a tty, tty console mode failed");
      id3_cvar_set("ttycon", "0");
      break;
    }
    default : std_discard(0);
  }
  return result;
}

