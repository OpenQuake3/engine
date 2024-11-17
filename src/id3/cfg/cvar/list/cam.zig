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


//____________________________
pub const cam_mode = struct {
  extern var com_cameraMode :[*c]id3.C.Cvar;
  pub var data    :id3.Cvar = undefined;
  var defined     :bool     = false;
  pub fn init   () void { @This().define(); data.init(); }
  pub fn define () void { if (defined) return; data = id3.Cvar.define(&@This().com_cameraMode, "com_cameraMode", id3.Cvar.DefineOptions{
    // FIX: Alias to cam_mode on console
    .value   = "0",
    .type    = .none,
    .flags   = .{.cheat=true}
    });
    defined = true;
  }
};

