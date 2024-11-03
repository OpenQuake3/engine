//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview id-Tech3 Engine: Client Logic
//______________________________________________|
pub const cl     = @This();
pub const client = @This();
// @deps id3c
const C   = @import("../C.zig");
// @deps id3
const id3 = @import("../../id3.zig");

pub inline fn noDelay () bool { return C.client.noDelay() != 0; }

