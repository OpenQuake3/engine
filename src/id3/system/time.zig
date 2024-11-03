//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
const time = @This();
// @deps std
const std = @import("std");

pub const Clock = std.time.Timer;
pub fn msec (T :time.Clock) u64 {
  const prev = T.previous;
  return (T.read() - prev) / std.time.ns_per_ms;
} //:: id3.sys.time.msec

pub fn start () time.Clock { return time.Clock.start() catch unreachable; }

