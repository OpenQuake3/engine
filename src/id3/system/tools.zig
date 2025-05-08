//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
const This = @This();
// @deps std
const system = @import("builtin");
// @deps id3c
const C = @import("../C.zig");
const id3 = struct {
  const Cfg  = @import("../cfg.zig");
  const sys  = This.sys;
  const Cvar = @import("../cfg/cvar.zig");
};

pub const sys = struct {
  pub const pwd = C.sys.pwd;
  pub const err = C.sys.err;
  //______________________________________
  /// @note
  ///  All this does is initialize the `arch` cvar in both win & unix.
  ///  It also sets the Timer resolution, but only on Windows.
  pub const init = C.sys.init;


  pub const time = struct {
    pub fn milliseconds () i32 { return C.sys.milliseconds(); }
  }; //:: id3.sys.time

  pub const FPU = struct {
    pub const configure = C.sys.configureFPU;
  }; //:: id3.sys.FPU

  pub const input = struct {
    pub const update = C.sys.input.update;
  }; //:: id3.sys.input

  pub const cpu = struct {
    pub const getID = C.sys.cpu.getID;
    pub const affinity = struct {
      const state = struct {
        extern var eCoreMask    :u64;
        extern var pCoreMask    :u64;
        /// Saved at startup
        extern var affinityMask :u64;
      };
      pub const set = C.sys.cpu.setAffinity;
      pub fn init () void {
        // Get initial process affinity - we will respect it when setting custom affinity masks
        id3.sys.cpu.affinity.state.eCoreMask    = C.sys.cpu.getMask();
        id3.sys.cpu.affinity.state.pCoreMask    = id3.sys.cpu.affinity.state.eCoreMask;
        id3.sys.cpu.affinity.state.affinityMask = id3.sys.cpu.affinity.state.eCoreMask;
        if (system.cpu.arch.isX86()) C.sys.cpu.detectCfg();
        if (id3.Cvar.cpu_affinity.str()[0] == 0) return;
        id3.sys.cpu.affinity.set(id3.Cvar.cpu_affinity.str());
        id3.Cvar.cpu_affinity.setModified(false);
      } //:: id3.cpu.affinity.set
    }; //:: id3.cpu.affinity
  }; //:: id3.sys.cpu
}; //:: id3.sys

