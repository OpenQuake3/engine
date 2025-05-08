//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
//! @fileoverview                                                 |
//!  Engine Debug Example                                         |
//!  Will run the engine with the default QuakeIIIArena Gamecode  |
//________________________________________________________________|
// @deps std
const std = @import("std");
// @deps id3
const id3 = @import("./id3.zig");


//______________________________________
// @section Entry Point
//____________________________
pub fn main () !u8 {
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit();
  const A = arena.allocator();

  const game = id3.Game.create(.{});
  var engine = try id3.Engine.init(game, A);
  engine.start();
  return error.ShouldNeverHappen;  // @note The engine has an internal termination process.
}

