//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview id-Tech3 Engine Core Logic
//____________________________________________|
pub const core = @This();
const This = @This();
// @deps std
const std = @import("std");
// TODO: Move to a module with the buildsystem
const defines = struct { const build = struct { const date = "NO_DATE"; }; };
// @deps id3c
const C = @import("../C.zig");
// @deps id3
const id3 = struct {
  const sys    = @import("../system/tools.zig").sys;
  usingnamespace @import("../tools/log.zig");
  const Cfg    = @import("../cfg.zig");
  const Cvar   = @import("../cfg/cvar.zig");
  const Cli    = @import("../cli.zig").Cli;
  const unsafe = @import("../unsafe.zig");
  const net    = @import("../net.zig");
  const vm     = @import("../tools/vm.zig");
  const con    = @import("../tools/console.zig");
  const cmd    = @import("../tools/commands.zig");
  const fs     = @import("../tools/filesystem.zig");
  const mem    = @import("../tools/mem.zig");
  const time   = @import("../system/time.zig");
  const core   = This;
  const event  = @import("./event.zig");
  const cl     = @import("./client.zig");
  const sv     = @import("./server.zig");
};

pub const raw = struct {
  pub inline fn init   (cli :*id3.Cli) void { C.core.init(cli.all.items.ptr); }
  pub inline fn update (cfg :id3.Cfg) void {
    if (cfg.engine.server.dedicated) {
      C.core.update(@intFromBool(false));             // Run the dedicated server game
    } else {
      id3.sys.input.update();                         // Check for input device events
      C.core.update(@intFromBool(id3.cl.noDelay()));  // Run the client+server game
    }
  } //:: id3.Engine.core.update
}; //:: id3.Engine.core

/// @descr Global State of the Engine Core module
const state =struct {
  const minimized = struct {
    extern var gw_minimized :C.Bool;
    fn set (val :bool) void { @This().gw_minimized = @intFromBool(val); }
    fn get () bool { return @This().gw_minimized != 0; }
  };
  const hasError = struct {
    extern var com_errorEntered :C.Bool;
    // fn set (val :bool) void { @This().com_errorEntered = @intFromBool(val); }
    fn get () bool { return @This().com_errorEntered != 0; }
  };

  const initialized = struct {
    extern var com_fullyInitialized :C.Bool;
    fn set (val :bool) void { @This().com_fullyInitialized = @intFromBool(val); }
    // fn get () bool { return @This().com_fullyInitialized != 0; }
  };
};

//______________________________________
/// @descr Executes a frame update
/// @originally Com_Frame : id3.core.raw.update
pub const update = id3.core.raw.update;
pub const init   = id3.core.init_WIP;


//______________________________________
/// @descr Initializes all Core Systems of the engine
/// @originally Com_Init : id3.core.raw.init
pub fn init_WIP (cli :*id3.Cli, cfg :id3.Cfg, now :u64) !void {
  id3.info("[id3.info] %s %s %s\n", cfg.engine.version.ptr, cfg.engine.platform.ptr, defines.build.date);
  if (!id3.unsafe.jmp.set()) id3.sys.err("Error during initialization");
  // Init early systems: mem.small and events
  id3.event.push.init();
  id3.mem.zone.small.init();
  // Init Core Cvars & Commands
  id3.Cvar.list.init.core();
  id3.Cvar.raw.set("fs_game", cfg.game.name.ptr);  // TODO: Remove this hardcoded fs_game.set() in some way.
  cli.parse();
  id3.cmd.buffer.init();
  id3.Cvar.list.startup();  // Override anything from the config files with command line args
  // Init mem.zone
  id3.mem.zone.init();
  // Init Early Cvars & Commands
  id3.Cvar.list.init.early();
  id3.cmd.input.init();  // Done early-init. `bind` commands exist
  // Init the Filesystem & Logging
  id3.fs.init();
  id3.Cvar.log_file_mode.init();
  id3.log.dev.journal.init();
  // Load the default config and autoexec files  (unless safe mode was requested)
  id3.Cfg.load.defaults();
  id3.Cvar.list.startup();  // Override anything from the config files with command line args
  // Init mem.Hunk
  id3.mem.hunk.init();
  // Remove {archive} from the cvar list modified flags
  // We would trigger a writing of the config file if any archived cvars are modified after this.
  id3.Cvar.list.modified.remove(.{.archive=true});
  // Init Engine Cvars
  try id3.Cvar.list.init.engine(cfg, cli.A);
  // Set minimized state. Always true for the dedicated server
  core.state.minimized.set(id3.Cvar.sv_dedicated.active());
  // Init Engine Commands
  id3.cmd.list.init.engine(id3.Cvar.dev_enabled.active());
  // Init the System/Platform-specific Cvars
  id3.sys.init();
  id3.Cvar.list.init.cpu();
  if (cfg.cpu.affinity) id3.sys.cpu.affinity.init();
  // Init the tools required by the Networking systems
  id3.net.chan.init();
  // Init VM Cvars, Commands & Table
  // @important This will be (eventually) removed in favor of a callback-based system.
  id3.vm.init();
  // Init Server Cvars & Commands
  id3.sv.init();
  id3.Cvar.sv_dedicated.setModified(false);
  // Init Client Cvars & Commands
  if (!id3.Cvar.sv_dedicated.active()) {
    id3.cl.init();
    // Add `+` commands given from CLI
    // TODO: ...
    // if ( !Com_AddStartupCommands() ) {
    //   // if the user didn't give any commands, run default action
    //   if ( !com_dedicated->integer ) {
    // #ifndef DEDICATED
    //     if ( !com_skipIdLogo || !com_skipIdLogo->integer )
    //       Cbuf_AddText( "cinematic idlogo.RoQ\n" );
    //     if( !com_introPlayed->integer ) {
    //       Cvar_Set( com_introPlayed->name, "1" );
    //       Cvar_Set( "nextmap", "cinematic intro.RoQ" );
    //     }
    // #endif
    //   }
    // }
    // ........
    id3.cl.start();
  }
  // Set frameTime.
  // If a map is started on CLI, it will still be able to count on it being random enough for a serverid
  id3.time.last.set(now);
  id3.time.frame.set(now);
  // Open the custom console  (ie: Windows tty replacement)
  if (!id3.core.state.hasError.get()) id3.con.sys.show(id3.Cvar.log_view.int(), false);
  // Make sure that SinglePlayer is off by default
  id3.Cvar.raw.set("ui_singlePlayerActive", "0");
  // Done Initializing
  id3.core.state.initialized.set(true);
  id3.info("--- Core Initialization Complete ---\n");
} //:: id3.core.init

