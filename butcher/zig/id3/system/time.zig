//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
pub const time = @This();
const This = @This();
// @deps std
const std = @import("std");
// @deps id3
const id3 = struct {
  const time = This;
};

pub const Clock = std.time.Timer;
pub fn msec (T :*time.Clock) u64 {
  const prev = T.previous;
  return (T.read() - prev) / std.time.ns_per_ms;
} //:: id3.sys.time.msec

pub fn start () id3.time.Clock { return time.Clock.start() catch unreachable; }

pub const last = struct {
  extern var lastTime :c_int;
  pub fn set (val :u64) void { id3.time.last.lastTime = @intCast(val); }
}; //:: id3.sys.time.last

pub const frame = struct {
  extern var com_frameTime :c_int;
  pub fn set (val :u64) void { id3.time.last.com_frameTime = @intCast(val); }
}; //:: id3.sys.time.frame

