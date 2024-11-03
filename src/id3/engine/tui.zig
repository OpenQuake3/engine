//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview id-Tech3 Engine: TUI/TTY Tools
//_______________________________________________|
const tui = @This();
const tty = @This();
// @deps id3c
const C   = @import("../C.zig");
// @deps id3
const id3 = @import("../../id3.zig");

const state = struct {  // TTY Global State
  extern var ttycon            :[*c]id3.Cvar;
  extern var ttycon_ansicolor  :[*c]id3.Cvar;
};

pub const TUI = tui.type;
pub const TTY = tty.type;
const @"type" = struct {
  status  :id3.tui.Status,
  pub fn init () @This() {
    // Sys_ConsoleInputInit() might be called in signal handler, so we modify/init the tty cvars before anything else
    tui.state.ttycon = id3.cvar.get("ttycon", "1", .{});
    id3.cvar.setDescr(tui.state.ttycon,
      "Enable access to input/output console terminal.");
    tui.state.ttycon_ansicolor = id3.cvar.get("ttycon_ansicolor", "0", .{.archive = true});
    id3.cvar.setDescr(tui.state.ttycon_ansicolor,
      "Convert in-game color codes to ANSI color codes in console terminal.");
    var result :tui.type= undefined;
    result.status = id3.tui.input.init();
    switch (result.status) {
      .enabled => { id3.info("[id3.info] Started tty console (use +set ttycon 0 to disable)\n"); },
      .err     => { id3.info("[id3.warn] stdin is not a tty, tty console mode failed\n"); id3.cvar.set("ttycon", "0"); },
      else     => {},  }
    return result;
  } //:: id3.Engine.TUI.init
}; //:: id3.Engine.TUI

