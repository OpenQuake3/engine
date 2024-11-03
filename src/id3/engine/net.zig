//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview id-Tech3 Engine: Networking Tools
//__________________________________________________|
pub const net        = @This();
pub const networking = @This();
// @deps id3c
const C   = @import("../C.zig");
// @deps id3
const id3 = @import("../../id3.zig");

pub inline fn init () void { C.net.init(); }

