//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
pub const cmd     = @This();
pub const command = @This();
const This        = @This();
// @deps id3c
const C = @import("../C.zig");
const id3 = struct {
  const cmd = This;
};

pub const buffer = struct {
  pub const init = C.cmd.buffer.init;
}; //:: id3.cmd.buffer

pub const input  = struct {
  pub const init = C.cmd.input.init;
}; //:: id3.cmd.input

pub const init = C.cmd.init;
pub const add  = C.cmd.add;
pub const completion = struct {
  pub const setFn = C.cmd.completion.setFn;
}; //:: id3.cmd.completion

pub const list = struct {
  pub const init = struct {
    pub fn engine (developer :bool) void {
      if (developer) {
        id3.cmd.add("error", C.cmd.Fn.Error);
        id3.cmd.add("crash", C.cmd.Fn.crash);
        id3.cmd.add("freeze", C.cmd.Fn.freeze);
      }
      id3.cmd.add("quit", C.cmd.Fn.quit);
      id3.cmd.add("changeVectors", C.cmd.Fn.report.changeVec);
      id3.cmd.add("writeconfig", C.cmd.Fn.cfg.write);
      id3.cmd.completion.setFn("writeconfig", C.cmd.completion.Fn.cfg.write);
      id3.cmd.add("game_restart", C.cmd.Fn.game.restart);
    } //:: id3.cmd.list.init.engine
  }; //:: id3.cmd.list.init
}; //:: id3.cmd.list

