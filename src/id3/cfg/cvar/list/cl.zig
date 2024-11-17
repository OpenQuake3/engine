//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Client-Side Cvars: Definitions & Global State
//! @note Their names should match the cvarlist found on console.
//_________________________________________________________________________|
// @deps id3
const id3 = struct {
  const C    = @import("../../../C.zig");
  const Cvar = @import("../../cvar.zig").Cvar;
};

//____________________________
pub const cl_paused = struct {
  extern var cl_paused :[*c]id3.C.Cvar;
  pub var data :id3.Cvar = undefined;
  var defined  :bool     = false;
  pub fn init   () void { @This().define(); data.init(); }
  pub fn define () void { if (defined) return; data = id3.Cvar.define(&@This().cl_paused, "cl_paused", id3.Cvar.DefineOptions{.descr=
    "Read-only CVAR to toggle functionality of paused games (the variable holds the status of the paused flag on the client side).",
    .value   = "0",
    .type    = .none,
    .flags   = .{.rom=true},
    });
    defined = true;
  }
};
//____________________________
pub const cl_packetDelay = struct {
  extern var cl_packetdelay :[*c]id3.C.Cvar;
  pub var data :id3.Cvar = undefined;
  var defined  :bool     = false;
  pub fn init   () void { @This().define(); data.init(); }
  pub fn define () void { if (defined) return; data = id3.Cvar.define(&@This().cl_packetdelay, "cl_packetdelay", id3.Cvar.DefineOptions{.descr=
    "Artificially set the client's latency. Simulates packet delay, which can lead to packet loss.",
    // FIX: Alias to cl_packetDelay on console
    .value   = "0",
    .type    = .none,
    .flags   = .{.cheat=true},
    });
    defined = true;
  }
};
//____________________________
pub const cl_running = struct {
  extern var com_cl_running :[*c]id3.C.Cvar;
  pub var data :id3.Cvar = undefined;
  var defined  :bool     = false;
  pub fn init   () void { @This().define(); data.init(); }
  pub fn define () void { if (defined) return; data = id3.Cvar.define(&@This().com_cl_running, "cl_running", id3.Cvar.DefineOptions{.descr=
    "Can be used to check the status of the client game.",
    .value   = "0",
    .type    = .none,
    .flags   = .{.rom=true, .noTabComplete=true},
    });
    defined = true;
  }
};

