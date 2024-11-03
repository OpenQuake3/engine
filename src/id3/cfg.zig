//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Engine Configuration Management
//________________________________________________|
pub const Cfg = @This();
// @deps zstd
const zstd = @import("../lib/zstd.zig");
const cstr = zstd.cstr;

win :Cfg.Window,

pub const Window = struct {
  /// @descr Initial Width of the Window
  W     : u32,
  /// @descr Initial Height of the Window
  H     : u32,
  /// @descr Initial Title of the Window
  title : cstr,
};

pub fn defaults () @This() { return @This(){
  .win     = Cfg.Window{
    .W     =  960,
    .H     =  540,
    .title =  "id-Tech3 | Engine",
    }, //:: result.win
  }; //:: result
} //:: id3.Cfg.defaults

