//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
pub const con = @This();
pub const console = @This();
const This = @This();
// @deps id3c
const C = @import("../C.zig");

/// @descr System-replacement console
/// @note Not to be confused with the client's developer console found on the UI
pub const sys = struct {
  pub fn show (level :i64, quitOnClose :bool) void { C.con.sys.show(@intCast(level), @intFromBool(quitOnClose)); }
}; //:: id3.con.sys
