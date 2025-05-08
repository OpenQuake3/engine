//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
pub const ev    = @This();
pub const event = @This();
// @deps id3c
const C = @import("../C.zig");

pub const push   = struct {
  /// @internal Dont use. Artificially exposed to take ownership of Com_Init from Zig
  /// @descr Initializes the PushEvent internal GlobalState.
  pub const init = C.event.push.init;
}; //:: id3.event.push

