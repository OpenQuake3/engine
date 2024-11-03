//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
// @deps std
const std = @import("std");
// @deps zstd
const zstd  = @import("./lib/zstd.zig");
const never = zstd.err;
// @deps id3
const id3 = struct {
  pub usingnamespace @import("./id3.zig");
  const C = @import("./id3/C.zig");

  // @section Logging
  pub const Error = C.log.Error;
  pub const err   = C.log.err;
  pub const dbg   = C.log.dbg;
  pub const info  = C.log.info;

  // @section Base QuakeIIIArena Game
  pub const Q3A = struct {
    pub const game :id3.Game= .{
      .ui = id3.Q3A.ui,
      .cl = id3.Q3A.cl,
      .sv = id3.Q3A.sv,
      };
    pub fn ui (_:id3.Game.UserData) void {}
    pub fn cl (_:id3.Game.UserData) void {}
    pub fn sv (_:id3.Game.UserData) void {}
  };

  pub const Game = struct {
    ui   :id3.Game.Fn.UI,
    cl   :id3.Game.Fn.Client,
    sv   :id3.Game.Fn.Server,

    pub const Q3A = id3.Q3A;

    pub const UserData = ?*anyopaque;
    pub const Fn = struct {
      pub const UI     = *const fn (data :id3.Game.UserData) void;
      pub const Client = *const fn (data :id3.Game.UserData) void;
      pub const Server = *const fn (data :id3.Game.UserData) void;
    };

    pub const CreateOptions = struct {
      callback :Callbacks= .{},
      pub const Callbacks = struct {
        ui  :?id3.Game.Fn.UI     = null,
        cl  :?id3.Game.Fn.Client = null,
        sv  :?id3.Game.Fn.Server = null,
      }; //:: id3.Game.CreateOptions.Callbacks
    }; //:: id3.Game.CreateOptions

    pub fn create (in :id3.Game.CreateOptions) id3.Game {
      return id3.Game{
        .ui = in.callback.ui orelse id3.Game.Q3A.ui,
        .cl = in.callback.cl orelse id3.Game.Q3A.cl,
        .sv = in.callback.sv orelse id3.Game.Q3A.sv,
         };
    }
  };

  pub const Engine = struct {
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
  }; //:: id3.Engine
};





//______________________________________
// @section Entry Point: Engine Debug Example
//____________________________
pub fn main () !u8 {
  std.debug.print("Hello: oQ3 Entry\n", .{});
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit();
  const A = arena.allocator();

  const game = id3.Game.create(.{});
  var engine = try id3.Engine.init(game, A);
  engine.start();
  return never();  // Should never happen. The engine has an internal termination process.
}

