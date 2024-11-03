//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
pub const sys = struct {
  const C = @import("../C.zig");
  pub const time = struct {
    pub fn milliseconds () i32 { return C.sys.milliseconds(); }
  }; //:: id3.sys.time
}; //:: id3.sys

