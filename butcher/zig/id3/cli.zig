//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Engine CLI Arguments Management
//________________________________________________|
pub const cli = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../lib/zstd.zig");
// @deps id3c
const C    = @import("./C.zig");
const cvar = @import("./cfg/cvar.zig");


const printExit = struct {
  fn version () noreturn {
    std.debug.print("{s}\n", .{"TODO: VERSION GOES HERE"});  //:: FIX: Version printing
    std.process.exit(zstd.result.ok());
  } //:: cli.print.version
  fn help () noreturn {
    std.debug.print("{s}\n", .{"TODO: HELP GOES HERE"});  //:: FIX: Help printing
    std.process.exit(zstd.result.ok());
  } //:: cli.print.help
}; //:: cli.print

const is = struct {
  fn version (arg :zstd.cstr) bool { return std.mem.eql(u8, arg, "--version") or std.mem.eql(u8, arg, "-v"); }
  fn help    (arg :zstd.cstr) bool { return std.mem.eql(u8, arg, "--help") or std.mem.eql(u8, arg, "-h"); }
}; //:: cli.check

const parse = struct {
  /// @note Returns true if both vid_xpos and vid_ypos were set
  fn early (
      all   : *zstd.str,
      title : []u8,
      vid_X : ?*i32,
      vid_Y : ?*i32
    ) !bool {
    const str = try all.allocator.dupeZ(u8, all.items);
    defer all.allocator.free(str);
    const result = 1 == C.cli.parse.early(str.ptr, title.ptr, title.len, vid_X, vid_Y);
    all.clearAndFree();
    try all.appendSlice(str);
    return result;
  } //:: id3.cli.parse.early

  //______________________________________
  /// @descr Request C to parse our list of concatenated cli arguments
  inline fn args (all :*const zstd.str) void { C.cli.parse.args(all.items.ptr); }
};

pub const Cli = struct {
  pub const Args = zstd.cstr_List;
  A      :std.mem.Allocator,
  args   :std.process.ArgIterator,
  all    :zstd.str,  // FIX: Convert Com_EarlyParseCmdLine into a more sane API
  title  :cvar.Value,
  vid    :struct { x:?i32=null, y:?i32=null },
  set    :Cli.Args,

  //______________________________________
  pub fn init (A :std.mem.Allocator) !Cli {
    var result :Cli= undefined;
    result.A    = A;
    result.args = try std.process.argsWithAllocator(result.A);
    result.all  = zstd.str.init(result.A);
    std.debug.print("[id3.cli] Parsing CLI Arguments ...\n", .{});
    while (result.args.next()) |arg| {
      try result.all.appendSlice(arg);
      try result.all.append(' ');
      if (cli.is.version(arg)) cli.printExit.version();
      if (cli.is.help(arg)) cli.printExit.help();
      std.debug.print("{s}\n", .{arg});
    }
    _= try cli.parse.early(&result.all, &result.title, &result.vid.x.?, &result.vid.y.?);
    std.debug.print("[id3.cli] Done parsing CLI Arguments.\n", .{});
    return result;
  } //:: id3.Cli.init

  //______________________________________
  /// @descr Parses all Command Line Arguments into configuration values for the engine
  pub fn parse (V :*Cli) void { cli.parse.args(&V.all); }
}; //:: id3.Cli

