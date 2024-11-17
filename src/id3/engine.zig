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
const tui  = @import("./ui/tui.zig");
const TUI  = tui.TUI;

cli   :id3.Cli,
cfg   :id3.Cfg,
sys   :id3.System,
tui   :id3.Engine.TUI,
game  :id3.Game,

//______________________________________
/// @descr
///  Initializes the engine and all its required data.
///  Should call {@link Engine.start()} on the resulting object after calling this function.
/// @return The engine's data object.
pub fn init (G :id3.Game, A :std.mem.Allocator) !Engine {
  var result :Engine= undefined;
  result.cli  = try id3.Cli.init(A);
  result.cfg  = id3.Cfg.defaults();
  result.sys  = undefined;  // try id3.System.init(result.cfg.win.W, result.cfg.win.H, result.cfg.win.title);
  result.game = G;
  Engine.core.init(&result.cli, result.cfg);
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

//______________________________________
/// @descr Returns true when the engine should terminate/close.
fn close (E :*const Engine) bool { return E.sys.close(); }

//______________________________________
/// @descr
///  Starts the engine loop and never returns.
///  Takes control of the application as soon as it is called.
pub fn start (E :*Engine) void { while (!E.close()) E.update(); }

