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
pub var cl_paused = id3.Cvar.define("cl_paused", "cl_paused", id3.Cvar.DefineOptions{.descr=
  "Read-only CVAR to toggle functionality of paused games (the variable holds the status of the paused flag on the client side).",
  .value = "0",
  .type  = .none,
  .flags = .{.rom=true},
});

//____________________________
pub var cl_packetDelay = id3.Cvar.define("cl_packetdelay", "cl_packetdelay", id3.Cvar.DefineOptions{.descr=
  "Artificially set the client's latency. Simulates packet delay, which can lead to packet loss.",
  // FIX: Alias to cl_packetDelay on console
  .value = "0",
  .type  = .none,
  .flags = .{.cheat=true},
});
//____________________________
pub var cl_running = id3.Cvar.define("com_cl_running", "cl_running", id3.Cvar.DefineOptions{.descr=
  "Can be used to check the status of the client game.",
  .value = "0",
  .type  = .none,
  .flags = .{.rom=true, .noTabComplete=true},
});

