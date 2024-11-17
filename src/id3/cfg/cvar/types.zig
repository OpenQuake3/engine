//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Cvar related Types
//_________________________________________________|
// @deps id3c
const C = @import("../../C.zig");
// @deps id3
const id3 = struct {
  pub usingnamespace @import("../../types.zig");
};

pub const State  = *[*c]C.Cvar;
pub const Name   = [C.cvar.MaxLen]u8;
pub const Flags  = C.Cvar.Flags;
pub const Type   = C.Cvar.Type;
pub const Group  = C.Cvar.Group;
pub const Range  = struct {
  min  :?id3.String= null,
  max  :?id3.String= null,
}; //:: id3.Cvar.Range

