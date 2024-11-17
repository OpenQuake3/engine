//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Terminal UI Cvars: Definitions & Global State
//! @note Their names should match the cvarlist found on console.
//_______________________________________________________________|
// @deps std
const std = @import("std");
// @deps id3
const id3 = struct {
  const Cvar  = @import("../../cvar.zig").Cvar;
  const C     = @import("../../../C.zig");
  const debug = std.debug.runtime_safety;
};

//______________________________________
// @section Terminal UI: Console
//____________________________
pub const tui_con_enabled = struct {
  extern var ttycon :[*c]id3.C.Cvar;
  pub var data :id3.Cvar = undefined;
  var defined  :bool     = false;
  pub fn init   () void { @This().define(); data.init(); }
  pub fn define () void { if (defined) return; data = id3.Cvar.define(&ttycon, "ttycon", id3.Cvar.DefineOptions{.descr=
    "Enable access to input/output console terminal.",
    // FIX: Alias to tui_con_enabled on console
    .value = "1",
    .type  = .integer,
    });
    defined = true;
  }
};
//____________________________
pub const tui_con_colors = struct {
  extern var ttycon_ansicolor :[*c]id3.C.Cvar;
  pub var data :id3.Cvar = undefined;
  var defined  :bool     = false;
  pub fn init   () void { @This().define(); data.init(); }
  pub fn define () void { if (defined) return; data = id3.Cvar.define(&ttycon_ansicolor, "ttycon_ansicolor", id3.Cvar.DefineOptions{.descr=
    "Convert in-game color codes to ANSI color codes in console terminal.",
    // FIX: Alias to tui_con_colors on console
    .value = "0",
    .type  = .integer,
    .flags = .{.archive=true}
    });
    defined = true;
  }
};

