//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview id-Tech3 Engine: TUI/TTY Tools
//_______________________________________________|
const tui = @This();
const tty = @This();
const _This = @This();
// @deps id3c
const C = @import("../C.zig");
// @deps id3
const id3 = struct {
  const tui  = _This;
  const info = @import("../log.zig").info;
  const Cvar = @import("../cfg.zig").Cvar;
};
const input = struct {
  const init = C.tty.input.init;
};

pub const Status = C.tty.Status;
pub const TUI    = tui.type;
pub const TTY    = tty.type;
const @"type"    = struct {
  status  :id3.tui.Status,
  pub fn init () @This() {
    // Sys_ConsoleInputInit() might be called in signal handler, so modify/init the tty cvars before anything else
    id3.Cvar.tui_con_enabled.init();
    id3.Cvar.tui_con_colors.init();

    var result :tui.type= undefined;
    result.status = id3.tui.input.init();
    switch (result.status) {
      .enabled => { id3.info("[id3.info] Started tty console (use +set ttycon 0 to disable)\n"); },
      .err     => { id3.info("[id3.warn] stdin is not a tty, tty console mode failed\n"); id3.Cvar.set("ttycon", "0"); },
      else     => {},  }
    return result;
  } //:: id3.Engine.TUI.init
}; //:: id3.Engine.TUI

