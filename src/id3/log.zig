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

pub const dev = struct {
  pub const journal = struct {
    pub const init = C.log.journal.init;
  }; //:: id3.log.dev.journal
}; //:: id3.log.dev

