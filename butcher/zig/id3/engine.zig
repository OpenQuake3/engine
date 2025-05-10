//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview id-Tech3 Engine Core Logic and Management Tools
//________________________________________________________________|
pub const Engine = @This();
// @deps std
const std = @import("std");
// @deps id3c
const C = @import("./C.zig");
// @deps id3
const id3 = struct {
 usingnamespace @import("../id3.zig");
 const tui  = @import("./ui/tui.zig");
};
const core   = @import("./engine/core.zig");
const sv     = @import("./engine/server.zig");
const net    = @import("./net.zig");
const TUI    = id3.tui.TUI;

cli   :id3.Cli,
cfg   :id3.Cfg,
sys   :id3.System,
tui   :id3.Engine.TUI,
game  :id3.Game,
time  :id3.time.Clock, // FIX:: Move it to Engine.sys when possible

//______________________________________
pub fn init (G :id3.Game, A :std.mem.Allocator) !Engine {
  var result :Engine= undefined;
  result.cli  = try id3.Cli.init(A);
  result.cfg  = id3.Cfg.defaults();
  result.sys  = undefined;  // try id3.System.init(result.cfg.win.W, result.cfg.win.H, result.cfg.win.title);
  result.game = G;
  result.time = id3.time.start();
  try Engine.core.init(&result.cli, result.cfg, id3.time.msec(&result.time));
  Engine.net.init();
  id3.info("[id3.info] Working directory: %s\n", id3.sys.pwd());
  result.tui = Engine.TUI.init();
  id3.info("[id3.info] Done Initializing the Engine.\n");
  // TODO: Call InitSig() when defines.server.dedicated
  return result;
} //:: id3.Engine.init

fn update (E :*Engine) void {
  // E.sys.update();
  id3.sys.FPU.configure();
  Engine.core.update(E.cfg);
} //:: id3.Engine.update


