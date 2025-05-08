//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview CPU Cvars: Definitions & Global State
//! @note Their names should match the cvarlist found on console.
//_________________________________________________________________________|
// @deps id3
const id3 = struct {
  const C    = @import("../../../C.zig");
  const Cvar = @import("../../cvar.zig").Cvar;
};

//____________________________
pub var cpu_yield = id3.Cvar.define("com_yieldCPU", "com_yieldCPU", id3.Cvar.DefineOptions{.descr=
  "Attempt to sleep specified amount of time between rendered frames when game is active\n" ++
  "This will greatly reduce CPU load. Use 0 only if you're experiencing some lag.",
  // FIX: Alias to cpu_yield on console
  .value = "1", .range=.{.min="0", .max="16"},
  .type  = .integer,
  .flags = .{.archive=true, .noDefault=true},
});

//____________________________
pub var cpu_affinity = id3.Cvar.define("com_affinityMask", "com_affinityMask", id3.Cvar.DefineOptions{.descr=
  "Bind game process to bitmask-specified CPU core(s).\n" ++
  "Special characters:\n"                                 ++
  " A or a    : all default cores\n"                      ++
  " P or p    : performance cores\n"                      ++
  " E or e    : efficiency cores\n"                       ++
  " 0x<value> : use hexadecimal notation\n"               ++
  " + or -    : add or exclude particular cores"          ,
  // FIX: Alias to cpu_yield on console
  .value   = "", .type= .none,
  .flags   = .{.archive=true, .noDefault=true},
});

