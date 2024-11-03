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
const id3  = @import("../id3.zig");
const core = @import("./engine/core.zig");
const cl   = @import("./engine/client.zig");
const sv   = @import("./engine/server.zig");
const net  = @import("./engine/net.zig");
const tui  = @import("./engine/tui.zig");
const TUI  = tui.TUI;

cli   :id3.Cli,
cfg   :id3.Cfg,
sys   :id3.System,
tui   :id3.Engine.TUI,
game  :id3.Game,

pub fn init (G :id3.Game, A :std.mem.Allocator) !Engine {
  var result :Engine= undefined;
  result.cli  = try id3.Cli.init(A);
  result.cfg  = id3.Cfg.defaults();
  result.sys  = undefined;  // try id3.System.init(result.cfg.win.W, result.cfg.win.H, result.cfg.win.title);
  result.game = G;
  Engine.core.init(&result.cli);
  Engine.net.init();
  id3.info("[id3.info] Working directory: %s\n", id3.sys.pwd());
  result.tui = Engine.TUI.init();
  id3.info("[id3.info] Done Initializing the Engine.\n");
  // TODO: Call InitSig() when defines.server.dedicated
  return result;
} //:: id3.Engine.init

pub fn update (E :*Engine) void { _=E;
  // E.sys.update();
  id3.sys.FPU.configure();
  // if (defines.server.dedicated) Engine.core.update(false);   // Run the dedicated server game
  id3.sys.input.update();                   // Check for input device events
  Engine.core.update(Engine.cl.noDelay());  // Run the client+server game
} //:: id3.Engine.update

/// @descr Starts the engine loop
pub fn start (E :*Engine) void { while (!E.close()) E.update(); }
/// @descr Returns true when the engine should terminate/close.
pub fn close (E :*const Engine) bool { return E.sys.close(); }

