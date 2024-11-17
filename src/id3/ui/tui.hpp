//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
//! @fileoverview id-Tech3 Terminal UI Tools & Management
//________________________________________________________|
#pragma once
// @deps id3
#include "../C.hpp"
#include "../cfg/cvar.hpp"

namespace id3::tui {
  using Status = tui_Status;
} //:: id3.tui

namespace id3 {
class TUI {TUI* m = this;
  id3::tui::Status status;


public:
inline TUI () {
  // Sys_ConsoleInputInit() might be called in signal handler, so modify/init the tty cvars before anything else
  id3::Cvar::tui_con_enabled.init();
  id3::Cvar::tui_con_colors.init();
}

inline ~TUI () {}
};
} //:: id3
