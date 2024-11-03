//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Data required by the Engine to run a Game.
//___________________________________________________________|
pub const Game = @This();
// @deps id3
const id3 = @import("../id3.zig");

ui   :id3.Game.Fn.UI,
cl   :id3.Game.Fn.Client,
sv   :id3.Game.Fn.Server,

pub const UserData = ?*anyopaque;
pub const Fn = struct {
  pub const UI     = *const fn (data :id3.Game.UserData) void;
  pub const Client = *const fn (data :id3.Game.UserData) void;
  pub const Server = *const fn (data :id3.Game.UserData) void;
}; //:: id3.Game.Fn

pub const CreateOptions = struct {
  callback :Callbacks= .{},
  pub const Callbacks = struct {
    ui  :?id3.Game.Fn.UI     = null,
    cl  :?id3.Game.Fn.Client = null,
    sv  :?id3.Game.Fn.Server = null,
  }; //:: id3.Game.CreateOptions.Callbacks
}; //:: id3.Game.CreateOptions

pub const Q3A = @import("./q3a.zig");
pub fn create (in :id3.Game.CreateOptions) id3.Game {
  return id3.Game{
    .ui = in.callback.ui orelse id3.Game.Q3A.ui,
    .cl = in.callback.cl orelse id3.Game.Q3A.cl,
    .sv = in.callback.sv orelse id3.Game.Q3A.sv,
     };
} //:: id3.Game.create

