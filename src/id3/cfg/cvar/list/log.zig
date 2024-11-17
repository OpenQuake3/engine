//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Logging Cvars: Definitions & Global State
//! @note Their names should match the cvarlist found on console.
//_________________________________________________________________________|
// @deps std
const std = @import("std");
// @deps id3
const id3 = struct {
  const Cvar  = @import("../../cvar.zig").Cvar;
  const C     = @import("../../../C.zig");
  const debug = std.debug.runtime_safety;
};

//______________________________________
// @section 
//____________________________
pub const log_file_mode = struct {
  extern var com_logfile :[*c]id3.C.Cvar;
  pub var data    :id3.Cvar = undefined;
  var defined     :bool     = false;
  pub fn init   () void { @This().define(); data.init(); }
  pub fn define () void { if (defined) return; data = id3.Cvar.define(&@This().com_logfile, "logfile", id3.Cvar.DefineOptions{.descr=
    "System console logging:\n"       ++
    " 0 - disabled\n"                 ++
    " 1 - overwrite mode, buffered\n" ++
    " 2 - overwrite mode, synced\n"   ++
    " 3 - append mode, buffered\n"    ++
    " 4 - append mode, synced\n"      ,
    // FIX: Alias to log_file_mode on console
    .value   = if (id3.debug) "3" else "0", .range=.{.min="0", .max="4"},
    .type    = .integer,
    .flags   = .{.temp=true},
    });
    defined = true;
  }
};
//____________________________
pub const log_view = struct {
  extern var com_viewlog :[*c]id3.C.Cvar;
  pub var data    :id3.Cvar = undefined;
  var defined     :bool     = false;
  pub fn init   (dedicated :bool) void { @This().define(dedicated); data.init(); }
  pub fn define (dedicated :bool) void { if (defined) return; data = id3.Cvar.define(&@This().com_viewlog, "viewlog", id3.Cvar.DefineOptions{.descr=
    "Toggle the display of the startup console window over the game screen.",
    // FIX: Alias to log_view on console
    .value   = if (id3.debug or dedicated) "1" else "0",
    .type    = .none,
    });
    defined = true;
  }
};
//____________________________
pub const log_err_message = struct {
  extern var com_errorMessage :[*c]id3.C.Cvar;
  pub var data    :id3.Cvar = undefined;
  var defined     :bool     = false;
  pub fn init   () void { @This().define(); data.init(); }
  pub fn define () void { if (defined) return; data = id3.Cvar.define(&@This().com_errorMessage, "com_errorMessage", id3.Cvar.DefineOptions{
    // FIX: Alias to log_err_message on console
    .value   = "",
    .type    = .none,
    .flags   = .{.rom=true, .noRestart=true},
    });
    defined = true;
  }
};

