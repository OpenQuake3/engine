//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview FPS Cvars: Definitions & Global State
//! @note Their names should match the cvarlist found on console.
//_________________________________________________________________________|
// @deps id3
const id3 = struct {
  const C    = @import("../../../C.zig");
  const Cvar = @import("../../cvar.zig").Cvar;
};

//______________________________________
// @section FPS Cap
//____________________________
pub const fps_max = struct {
  extern var com_maxfps :[*c]id3.C.Cvar;
  pub var data :id3.Cvar = undefined;
  var defined  :bool     = false;
  pub fn init   () void { @This().define(); data.init(); }
  pub fn define () void { if (defined) return; data = id3.Cvar.define(&@This().com_maxfps, "com_maxfps", id3.Cvar.DefineOptions{.descr=
    "Sets the maximum number of frames per second allowed (rendering only).\n"                       ++
    "Note:\n"                                                                                        ++
    "  These values are limited to certain intervals.\n"                                             ++
    "  Anything in-between will cause weird effects when synchronizing with the physics timestep.\n" ++
    "\n"                                                                                             ++
    "Technical Explanation:\n"                                                                       ++
    "  Quake engines can only go from 111fps to 125, to 144, to 166 to 200 to 250 etc,\n"            ++
    "  and there is a strict a hardcap of 1000fps.\n"                                                ++
    "  - Rule#1 Time is measured in msec. 1000fps / 1000ms = 1frame\n"                               ++
    "  - Rule#2 Decimal values are not allowed in time-per-frame (integer, not float)\n"             ++
    "  - Resulting numbers:\n"                                                                       ++
    "    1000ms / 8ms = 125\n"                                                                       ++
    "    1000ms / 7ms = 144\n"                                                                       ++
    "    1000ms / 6ms = 166\n"                                                                       ++
    "     ...   / ... = ...  // Divide 1000 by 5, 4, 3, etc to get the in-betweens\n"                ++
    "    1000ms / 1ms = 1000 // Max framerate allowed. Anything lower becomes decimal\n"             ,
    // FIX: Alias to fps_max on console
    .value   = "125", .range=.{.min="0", .max="1000"},
    .type    = .integer,
    .flags   = .{},
    });
    defined = true;
  }
};
//____________________________
pub const fps_max_notFocused = struct {
  extern var com_maxfpsUnfocused :[*c]id3.C.Cvar;
  pub var data :id3.Cvar = undefined;
  var defined  :bool     = false;
  pub fn init   () void { @This().define(); data.init(); }
  pub fn define () void { if (defined) return; data = id3.Cvar.define(&@This().com_maxfpsUnfocused, "com_maxfpsUnfocused", id3.Cvar.DefineOptions{.descr=
    "Sets the maximum frames per second allowed when the window is not focused.",
    // FIX: Alias to fps_max_notFocused on console
    .value   = "60", .range=.{.min="0", .max="1000"},
    .type    = .integer,
    .flags   = .{.archive=true},
    });
    defined = true;
  }
};

