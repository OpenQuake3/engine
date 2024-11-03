//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Logging
//________________________|
pub const log = @This();
// @deps id3c
const C = @import("./C.zig");

pub const Error = C.log.Error;
pub const err   = C.log.err;
pub const dbg   = C.log.dbg;
pub const info  = C.log.info;

