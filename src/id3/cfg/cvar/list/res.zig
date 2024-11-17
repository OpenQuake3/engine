//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Resource Management Cvars: Definitions & Global State
//! @note Their names should match the cvarlist found on console.
//_________________________________________________________________________|
// @deps std
const std = @import("std");
// @deps id3
const id3 = struct {
  const C    = @import("../../../C.zig");
  const Cvar = @import("../../cvar.zig").Cvar;
};


//____________________________
pub const res_cin_intro_skip = struct {
  extern var com_introPlayed :[*c]id3.C.Cvar;
  pub var data :id3.Cvar = undefined;
  var defined  :bool     = false;
  pub fn init   () void { @This().define(); data.init(); }
  pub fn define () void { if (defined) return; data = id3.Cvar.define(&@This().com_introPlayed, "com_introplayed", id3.Cvar.DefineOptions{.descr=
    "Skips playing the introduction cinematic at engine startup.",
    // FIX: Alias to res_cin_intro_skip on console
    .value   = "1",
    .type    = .none,
    .flags   = .{.archive=true},
    });
    defined = true;
  }
};
//____________________________
pub const res_cin_logo_skip = struct {
  extern var com_skipIdLogo :[*c]id3.C.Cvar;
  pub var data :id3.Cvar = undefined;
  var defined  :bool     = false;
  pub fn init   () void { @This().define(); data.init(); }
  pub fn define () void { if (defined) return; data = id3.Cvar.define(&@This().com_skipIdLogo, "com_skipIdLogo", id3.Cvar.DefineOptions{.descr=
    "Skip playing Id Software logo cinematic at engine startup.",
    // FIX: Alias to res_cin_logo_skip on console
    .value   = "1",
    .type    = .none,
    .flags   = .{.archive=true},
    });
    defined = true;
  }
};

