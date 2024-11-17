//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Server-Side Cvars: Definitions & Global State
//! @note Their names should match the cvarlist found on console.
//_________________________________________________________________________|
// @deps std
const std = @import("std");
// @deps id3
const id3 = struct {
  const Cvar      = @import("../../cvar.zig").Cvar;
  const C         = @import("../../../C.zig");
  const debug     = std.debug.runtime_safety;
  const dedicated = false;  // FIX: Take from defines.engine.server.dedicated
};


//______________________________________
// @section Dedicated Server
//____________________________
pub const sv_dedicated = struct {
  extern var com_dedicated :[*c]id3.C.Cvar;
  pub var data :id3.Cvar = undefined;
  var defined  :bool     = false;
  pub fn init   () void { @This().define(); data.init(); }
  pub fn define () void { if (defined) return; data = id3.Cvar.define(&com_dedicated , "dedicated", id3.Cvar.DefineOptions{.descr=
    "Enables dedicated server mode.\n" ++
    " 0: Listen server\n"              ++
    " 1: Unlisted dedicated server\n"  ++
    " 2: Listed dedicated server"      ,
    // FIX: Alias to sv_dedicated on console
    .value   =   if (id3.dedicated) "1" else "0",
    .range   = .{if (id3.dedicated) "1" else "0", "2"},
    .type    = .integer,
    .flags   = .{
      .init  =  id3.dedicated,
      .latch = !id3.dedicated,
      }, //:: sv_dedicated.flags
    });
    defined = true;
  }
  pub fn active () bool { return data._state.*.*.integer != 0; }
};

//______________________________________
// @section Server Status
//____________________________
pub const sv_paused = struct {
  extern var sv_paused :[*c]id3.C.Cvar;
  pub var data :id3.Cvar = undefined;
  var defined  :bool     = false;
  pub fn init   () void { @This().define(); data.init(); }
  pub fn define () void { if (defined) return; data = id3.Cvar.define(&@This().sv_paused, "sv_paused", id3.Cvar.DefineOptions{
    .value   = "0",
    .type    = .none,
    .flags   = .{.rom=true},
    });
    defined = true;
  }
};
//____________________________
pub const sv_running = struct {
  extern var com_sv_running :[*c]id3.C.Cvar;
  pub var data :id3.Cvar = undefined;
  var defined  :bool     = false;
  pub fn init   () void { @This().define(); data.init(); }
  pub fn define () void { if (defined) return; data = id3.Cvar.define(&@This().com_sv_running, "sv_running", id3.Cvar.DefineOptions{.descr=
    "Communicates to game modules if there is a server currently running.",
    .value   = "0",
    .type    = .none,
    .flags   = .{.rom=true, .noTabComplete=true},
    });
    defined = true;
  }
};

//______________________________________
// @section Network Config
//____________________________
pub const sv_packetDelay = struct {
  extern var sv_packetdelay :[*c]id3.C.Cvar;
  pub var data :id3.Cvar = undefined;
  var defined  :bool     = false;
  pub fn init   () void { @This().define(); data.init(); }
  pub fn define () void { if (defined) return; data = id3.Cvar.define(&@This().sv_packetdelay, "sv_packetdelay", id3.Cvar.DefineOptions{.descr=
    "Simulates packet delay, which can lead to packet loss. Server side.",
    // FIX: Alias to sv_packetDelay on console
    .value   = "0",
    .type    = .none,
    .flags   = .{.cheat=true},
    });
    defined = true;
  }
};

