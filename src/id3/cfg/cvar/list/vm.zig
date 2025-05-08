//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Virtual Machine Cvars: Definitions & Global State
//! @note Their names should match the cvarlist found on console.
//__________________________________________________________________|
// @deps std
const std = @import("std");
// @deps id3
const id3 = struct {
  const Cvar  = @import("../../cvar.zig").Cvar;
  const C     = @import("../../../C.zig");
  const debug = std.debug.runtime_safety;
};


//______________________________________
// @section Validation
//____________________________
pub var vm_rtChecks = id3.Cvar.define("vm_rtChecks", "vm_rtChecks", id3.Cvar.DefineOptions{.descr=
  "Runtime checks in compiled vm code, bitmask:\n" ++
  " 1 - program stack overflow\n"                  ++
  " 2 - opcode stack overflow\n"                   ++
  " 4 - jump target range\n"                       ++
  " 8 - data read/write range\n"                   ,
  .value   = "15", .range= .{.min="0", .max="15"},
  .type    = .integer,
  .flags   = .{.init=true, .protected=true},
  .startup = true,
});

