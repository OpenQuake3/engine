//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
// TODO: Port the descriptions from the headers into this module
//       https://github.com/heysokam/idtech3-modules/tree/master/src/mem
//_______________________________________________________________________|
pub const mem    = @This();
pub const memory = @This();
// @deps id3c
const C = @import("../C.zig");

pub const zone = struct {
  pub const init = C.mem.zone.init;
  pub const small = struct {
    pub const init = C.mem.zone.small.init;
  }; //:: id3.mem.zone.small
}; //:: id3.mem.zone

//______________________________________
/// @descr Hunk allocator _(Stack based)_
pub const hunk = struct {
  //______________________________________
  /// @descr Allocates the memory needed for the stack based Hunk allocator
  pub const init = C.mem.hunk.init;
}; //:: id3.mem.hunk

