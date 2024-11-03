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
const id3 = @import("../id3.zig");

cli   :id3.Cli,
cfg   :id3.Cfg,
sys   :id3.System,
tui   :id3.Engine.TUI,
game  :id3.Game,

pub const core = struct {
  pub inline fn init   (cli :*id3.Cli) void { C.core.init(cli.all.items.ptr); }
  pub inline fn update (noDelay :bool) void { C.core.update(@intFromBool(noDelay)); }
};

pub const cl = struct {
  pub inline fn noDelay () bool { return C.client.noDelay() != 0; }
};

pub const sv = struct {
};

pub const net = struct {
  pub fn init () void { C.net.init(); }
};

pub const TUI = Engine.tui.type;
const tui = struct {
  pub const state = struct {  // TTY Global State
    extern var ttycon            :[*c]id3.Cvar;
    extern var ttycon_ansicolor  :[*c]id3.Cvar;
  };

  const @"type" = struct {
    status  :id3.tty.Status,
    pub fn init () @This() {
      // Sys_ConsoleInputInit() might be called in signal handler so modify/init any cvars here
      tui.state.ttycon = id3.cvar.get("ttycon", "1", .{});
      id3.cvar.setDescr(tui.state.ttycon,
        "Enable access to input/output console terminal.");
      tui.state.ttycon_ansicolor = id3.cvar.get("ttycon_ansicolor", "0", .{.archive = true});
      id3.cvar.setDescr(tui.state.ttycon_ansicolor,
        "Convert in-game color codes to ANSI color codes in console terminal.");
      var result :Engine.TUI= undefined;
      result.status = id3.tty.input.init();
      switch (result.status) {
        .enabled => { id3.info("[id3.info] Started tty console (use +set ttycon 0 to disable)\n"); },
        .err     => { id3.info("stdin is not a tty, tty console mode failed\n"); id3.cvar.set("ttycon", "0"); },
        else     => {},  }
      return result;
    } //:: id3.Engine.tty.init
  };
}; //:: id3.Engine.tty

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
  // if (defines.server.dedicated) Engine.core.update(false);   // Run the game
  id3.sys.input.update();                   // check for other input devices
  Engine.core.update(Engine.cl.noDelay());  // run the game
} //:: id3.Engine.update

/// @descr Starts the engine loop
pub fn start (E :*Engine) void { while (!E.close()) E.update(); }
/// @descr Returns true when the engine should terminate/close.
pub fn close (E :*const Engine) bool { return E.sys.close(); }

