//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview CPU Cvars: Definitions & Global State
//! @note Their names should match the cvarlist found on console.
//_________________________________________________________________________|
// @deps id3
const id3 = struct {
  const C       = @import("../../../C.zig");
  const Cvar    = @import("../../cvar.zig").Cvar;
  const Cfg     = @import("../../../cfg.zig");
  const version = id3.Cfg.defaults().engine.version ++ " " ++ id3.Cfg.defaults().engine.platform;
};

//____________________________
pub var co_version = id3.Cvar.define("com_version", "version", id3.Cvar.DefineOptions{.descr=
  "Read-only CVAR to see the version of the game.",
  .value = id3.version,
  .type  = .none,
  .flags = .{.protected=true, .rom=true, .info_server=true},
});

