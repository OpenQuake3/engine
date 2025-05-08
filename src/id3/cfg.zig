//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Engine Configuration Management
//________________________________________________|
pub const Cfg = @This();
// @deps zstd
const zstd = @import("../lib/zstd.zig");
const cstr = zstd.cstr;
// @deps id3c
const C = @import("./C.zig");
// @deps id3
const id3 = struct {
  const String = @import("./types.zig").String;
};

//______________________________________
// @section Forward Declares for external access
pub const Cvar = @import("./cfg/cvar.zig").Cvar;
//______________________________________


win     :Cfg.Window,
engine  :Cfg.Engine,
game    :Cfg.Game,
net     :Cfg.Network,
cpu     :Cfg.Cpu,


pub const Window = struct {
  /// @descr Initial Width of the Window
  W     : u32,
  /// @descr Initial Height of the Window
  H     : u32,
  /// @descr Initial Title of the Window
  title : cstr,
}; //:: id3.Cfg.Window


pub const Engine = struct {
  version   :cstr,
  platform  :cstr,
  server    :Cfg.Server,
}; //:: id3.Cfg.Engine

pub const Server = struct {
  dedicated  :bool,
}; //:: id3.Cfg.Engine


pub const Game = struct {
  name     :cstr,
  version  :cstr,
}; //:: id3.Cfg.Game

pub const Network = struct {
  protocol :Network.Protocol,
  pub const Protocol = struct {
    version  :Network.Protocol.Version,
    pub const Version = id3.String;
    pub const vers = struct {
      /// @descr Protocol of version:  1.31
      pub const v131 :Network.Protocol.Version= "67";
      pub const old  :Network.Protocol.Version= "68";  // OLD_PROTOCOL_VERSION  qcommon.h
      /// @descr Network Protocol with UDP spoofing protection
      pub const new  :Network.Protocol.Version= "71";  // NEW_PROTOCOL_VERSION  qcommon.h
    };
  };
};

pub const Cpu = struct {
  affinity :bool,
}; //:: id3.Cfg.Engine

pub fn defaults () @This() { return @This(){
  .win           = Cfg.Window{
    .W           = 960,
    .H           = 540,
    .title       = "id-Tech3 | Engine",
    }, //:: result.win
  .engine        = Cfg.Engine{
    .version     = "oQ3 1.32e",                // FIX: Take from defines.build.version
    .platform    = "linux-x86_64-debug",       // FIX: Take from defines.build.platform
    .server      = Cfg.Server{
      .dedicated = false,                      // FIX: Take from defines.server.dedicated
      }, //:: result.engine.server
    }, //:: result.engine
  .game          = Cfg.Game{
    .name        = "defrag",                   // FIX: Take from defines.game.name
    .version     = "1.32e",                    // FIX: Take from defines.game.version
    }, //:: result.game
  .net           = Cfg.Network{
    .protocol    = Cfg.Network.Protocol{
      .version   = Network.Protocol.vers.old,  // FIX: Take from defines.network.protocol.version
      }, //:: result.net.protocol
    }, //:: result.net
  .cpu           = Cfg.Cpu{
    .affinity    = true,                       // FIX: Take from defines.cpu.affinity
    }, //:: result.cpu
  }; //:: result
} //:: id3.Cfg.defaults


//______________________________________
/// @descr Tools to manage configuration files
pub const load = struct {
  //______________________________________
  /// @descr
  ///  Load the `default.cfg`, `q3config.cfg` and `autoexec.cfg` files  _(in that order)_
  ///  Checks for `safe` on the command line, which will skip loading custom config files: q3config.cfg and autoexec.cfg
  ///  Running the `cvar_restart` command will also execute only the `default.cfg` file, skipping any custom configuration.
  //
  // TODO: Replace with custom config loader function.
  // Its very small (10sloc), and will be really helpful to give customization options to the caller
  pub const defaults = C.cfg.exec;
}; //:: id3.Cfg.file

