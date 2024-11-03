//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview id-Tech3 Engine Core Logic
//____________________________________________|
pub const core = @This();
// @deps id3c
const C   = @import("../C.zig");
// @deps id3
const id3 = @import("../../id3.zig");

pub inline fn init1  (cli :*id3.Cli) void { C.core.init(cli.all.items.ptr); }
pub inline fn update (noDelay :bool) void { C.core.update(@intFromBool(noDelay)); }

pub fn init (cli :*id3.Cli) void {
  C.core.init(cli.all.items.ptr);
} //:: id3.core.init

