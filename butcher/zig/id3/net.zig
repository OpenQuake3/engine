//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview id-Tech3 Engine: Networking Tools
//__________________________________________________|
pub const net        = @This();
// @deps std
const std = @import("std");
// @deps id3c
const C   = @import("./C.zig");
// @deps id3
const id3 = @import("../id3.zig");

pub inline fn init () void { C.net.init(); }

pub const chan = struct {
  pub inline fn init () void {
    var rng = std.Random.DefaultPrng.init(@truncate(@as(u128, @bitCast(std.time.nanoTimestamp()))));
    C.net.chan.init(rng.random().int(c_int));
  }
};
