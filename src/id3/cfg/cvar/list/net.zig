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
  const cfg   = @import("../../../cfg.zig");
};

//______________________________________
// @section 
//____________________________
pub const net_protocol = struct {
  extern var com_protocol :[*c]id3.C.Cvar;
  pub var data :id3.Cvar = undefined;
  var defined  :bool     = false;
  pub fn init   () void { @This().define(); data.init(); }
  pub fn define () void { if (defined) return; data = id3.Cvar.define(&com_protocol, "protocol", id3.Cvar.DefineOptions{.descr=
    "Specify network protocol version number. Use -compat suffix for OpenArena compatibility.",
    // FIX: Alias to net_protocol on console
    .value = id3.cfg.Network.Protocol.version.old, .range=.{.min="0", .max=null},
    .type  = .integer,
    .flags = .{.init=true, .protected=true},
    });
    defined = true;
  }
};

pub const net_protocol_compat = struct {
  extern var com_protocolCompat :id3.C.Bool;
  pub fn set (v :bool) void { com_protocolCompat = @intFromBool(v); }
  // TODO: @id3.Cvar.list.init.protocol
  // pub fn id3.Cvar.net_protocol_compat.init()
};

