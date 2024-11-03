//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
pub const system = @This();
pub const System = system.Data;
// @deps External
const glfw = @import("./glfw.zig");
// @deps id3 dependencies
const zstd = @import("../../lib/zstd.zig");
const cstr = zstd.cstr;
// @deps id3.sys dependencies
const cb     = @import("./cb.zig");
const Window = @import("./window.zig").Window;
const Input  = @import("./input.zig").Input;
const time   = @import("./time.zig");
const Time   = time.Clock;
const id3    = @import("./tools.zig");


pub const Data  = struct {
  win   :system.Window,
  inp   :system.Input,
  time  :system.Time,
  pub fn update (S :*System) void { S.win.update(); S.inp.update(); }
  pub fn close (S :*const System) bool { return glfw.window.close(S.win.ct); }
  pub fn term (S :*System) void {
    // Terminate GLFW and Window
    glfw.window.destroy(S.win.ct);
    glfw.term();
  }

  pub fn init (W :u32, H :u32, title :cstr) !System {
    var result = System{
      .time = system.time.start(), // @note Replaces   id3.sys.milliseconds()
      .win  = try system.Window.init(W,H,title),
      .inp  = undefined,
      }; //:: result
    result.inp  = system.Input.init(&result.win);
    return result;
  } //:: id3.System.init
}; //:: id3.System

