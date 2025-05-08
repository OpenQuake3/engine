//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Development & Debugging Cvars: Definitions & Global State
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
pub var dev_enabled = id3.Cvar.define("com_developer", "developer", id3.Cvar.DefineOptions{
  // FIX: Alias to dev_enabled on console
  .value   = if (id3.debug) "1" else "0",
  .type    = .integer,
  .flags   = .{.temp=true},
  .startup = true,
});

//__________________
pub var dev_journal = id3.Cvar.define("com_journal", "journal", id3.Cvar.DefineOptions{.descr=
  "When enabled, writes events and its data to 'journal.dat' and 'journaldata.dat'.",
  // FIX: Alias to dev_journal on console
  .value   = if (id3.debug) "1" else "0", .range = .{.min="0", .max="2"},
  .type    = .integer,
  .flags   = .{.init=true, .protected=true},
  .startup = true,
});


//__________________
pub var dev_trace_enabled = id3.Cvar.define("com_showtrace", "com_showtrace", id3.Cvar.DefineOptions{.descr=
  "Debugging tool that prints out trace information.",
  // FIX: Alias to dev_trace_enabled on console
  .value   = if (id3.debug) "1" else "0",
  .type    = .none,
  .flags   = .{.cheat=true},
  .startup = true,
});


//__________________
pub var dev_speeds = id3.Cvar.define("com_speeds", "com_speeds", id3.Cvar.DefineOptions{.descr=
  "Prints speed information per frame to the console. Used for debugging.",
  // FIX: Alias to dev_speeds on console
  .value   = if (id3.debug) "1" else "0",
  .type    = .none,
  .startup = true,
});


//______________________________________
// @section Development: Resources/Assets Management
//____________________________
pub var dev_res_loadAll = id3.Cvar.define("com_buildScript", "com_buildScript", id3.Cvar.DefineOptions{.descr=
  "Loads all game assets, regardless of whether they are required or not.",
  // FIX: Alias to res_loadAll on console
  .value = if (id3.debug) "1" else "0",
  .type  = .none,
});

