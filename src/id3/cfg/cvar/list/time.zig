//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Timestep Cvars: Definitions & Global State
//! @note Their names should match the cvarlist found on console.
//_________________________________________________________________________|
// @deps id3
const id3 = struct {
  const C    = @import("../../../C.zig");
  const Cvar = @import("../../cvar.zig").Cvar;
};

//____________________________
pub const time_scale = struct {
  extern var com_timescale :[*c]id3.C.Cvar;
  pub var data :id3.Cvar = undefined;
  var defined  :bool     = false;
  pub fn init   () void { @This().define(); data.init(); }
  pub fn define () void { if (defined) return; data = id3.Cvar.define(&@This().com_timescale, "timescale", id3.Cvar.DefineOptions{.descr=
    "System timing factor:\n"     ++
    " < 1 : Slows the game down\n" ++
    " = 1 : Regular speed\n"       ++
    " > 1 : Speeds the game up"    ,
    // FIX: Alias to time_scale on console
    .value   = "1", .range=.{.min="0", .max=null},
    .type    = .float,
    .flags   = .{.cheat=true, .info_system=true},
    });
    defined = true;
  }
};
//____________________________
pub const time_fixed_render = struct {
  extern var com_fixedtime :[*c]id3.C.Cvar;
  pub var data :id3.Cvar = undefined;
  var defined  :bool     = false;
  pub fn init   () void { @This().define(); data.init(); }
  pub fn define () void { if (defined) return; data = id3.Cvar.define(&@This().com_fixedtime, "fixedtime", id3.Cvar.DefineOptions{.descr=
    "When active (not 0), the rendering of every frame will wait until each frame is completely rendered before sending the next frame.",
    // FIX: Alias to time_fixed_render on console
    .value   = "0",
    .type    = .none,
    .flags   = .{.cheat=true},
    });
    defined = true;
  }
};

//____________________________
pub const time_demo = struct {
  extern var com_timedemo :[*c]id3.C.Cvar;
  pub var data :id3.Cvar = undefined;
  var defined  :bool     = false;
  pub fn init   () void { @This().define(); data.init(); }
  pub fn define () void { if (defined) return; data = id3.Cvar.define(&@This().com_timedemo, "timedemo", id3.Cvar.DefineOptions{.descr=
    "When set to '1', the engine will time demos and return frames per second like a benchmark.",
    // FIX: Alias to time_demo on console
    .value   = "0", .range= .{.min="0", .max="1"},
    .type    = .integer,
    });
    defined = true;
  }
};

