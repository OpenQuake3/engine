//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
const C = @import("../C.zig");

pub const sys = struct {
  pub const pwd = C.sys.pwd;
  pub const err = C.sys.err;

  pub const time = struct {
    pub fn milliseconds () i32 { return C.sys.milliseconds(); }
  }; //:: id3.sys.time

  pub const FPU = struct {
    pub const configure = C.sys.configureFPU;
  }; //:: id3.sys.FPU

  pub const input = struct {
    pub const update = C.sys.input.update;
  }; //:: id3.sys.input
}; //:: id3.sys

