//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
pub const cvar = @This();
// @deps id3c
const C = @import("../C.zig");

pub const Name     = [C.cvar.MaxLen]u8;
pub const Cvar     = C.cvar.type;
pub const get      = C.cvar.get;
pub const set      = C.cvar.set;
pub const setDescr = C.cvar.setDescr;

