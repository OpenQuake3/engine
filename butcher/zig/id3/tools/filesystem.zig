//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
pub const fs         = @This();
pub const filesystem = @This();
// @deps id3c
const C = @import("../C.zig");

pub const init = C.fs.init;

