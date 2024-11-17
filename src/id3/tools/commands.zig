//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
pub const cmd     = @This();
pub const command = @This();
// @deps id3c
const C = @import("../C.zig");

pub const buffer = struct {
  pub const init = C.cmd.buffer.init;
}; //:: id3.cmd.buffer

pub const init = C.cmd.init;
pub const add  = C.cmd.add;

pub const input  = struct {
  pub const init = C.cmd.input.init;
}; //:: id3.cmd.input
