//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
const C = @import("../C.zig");

pub const sys = struct {
  pub const time = struct {
    pub fn milliseconds () i32 { return C.sys.milliseconds(); }
  }; //:: id3.sys.time

  pub const pwd = C.sys.pwd;
  pub const FPU = struct {
    pub const configure = C.sys.configureFPU;
  }; //:: id3.sys.FPU
  pub const input = struct {
    pub const update = C.sys.input.update;
  }; //:: id3.sys.input
}; //:: id3.sys

pub const tty = tui;
pub const tui = struct {
  pub const Status = C.tty.Status;
  pub const input = struct {
    pub const init = C.tty.input.init;
  }; //:: id3.tui.input
}; //:: id3.tui

