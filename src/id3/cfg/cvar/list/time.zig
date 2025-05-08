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
pub var time_scale = id3.Cvar.define("com_timescale", "timescale", id3.Cvar.DefineOptions{.descr=
  "System timing factor:\n"     ++
  " < 1 : Slows the game down\n" ++
  " = 1 : Regular speed\n"       ++
  " > 1 : Speeds the game up"    ,
  // FIX: Alias to time_scale on console
  .value = "1", .range=.{.min="0", .max=null},
  .type  = .float,
  .flags = .{.cheat=true, .info_system=true},
});

//____________________________
pub var time_fixed_render = id3.Cvar.define("com_fixedtime", "fixedtime", id3.Cvar.DefineOptions{.descr=
  "When active (not 0), the rendering of every frame will wait until each frame is completely rendered before sending the next frame.",
  // FIX: Alias to time_fixed_render on console
  .value = "0",
  .type  = .none,
  .flags = .{.cheat=true},
});

//____________________________
pub var time_demo = id3.Cvar.define("com_timedemo", "timedemo", id3.Cvar.DefineOptions{.descr=
  "When set to '1', the engine will time demos and return frames per second like a benchmark.",
  // FIX: Alias to time_demo on console
  .value = "0", .range= .{.min="0", .max="1"},
  .type  = .integer,
});

