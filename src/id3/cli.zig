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

const C = struct {
  const Bool = c_uint;
  const parse = struct {
    extern fn Com_EarlyParseCmdLine (  // qboolean Com_EarlyParseCmdLine( char *commandLine, char *con_title, int title_size, int *vid_xpos, int *vid_ypos );
        commandLine : [*c]u8,
        con_title   : [*c]u8,
        title_size  : usize,
        vid_xpos    : [*c]c_int,
        vid_ypos    : [*c]c_int
      ) callconv(.C) C.Bool;
  };
};

const parse = struct {
  /// @note Returns true if both vid_xpos and vid_ypos were set
  fn early (all :*zstd.str, title :[]u8, vid_X :?*i32, vid_Y :?*i32) !bool {
    const str = try all.allocator.dupeZ(u8, all.items);
    defer all.allocator.free(str);
    const result = 1 == cli.C.parse.Com_EarlyParseCmdLine(str.ptr, title.ptr, title.len, vid_X, vid_Y);
    all.clearAndFree();
    try all.appendSlice(str);
    return result;
  }
};

pub const Cli = struct {
  pub const Args = zstd.cstr_List;
  A     :std.mem.Allocator,
  args  :std.process.ArgIterator,
  all   :zstd.str,  // FIX: Convert Com_EarlyParseCmdLine into a more sane API
  title :[]u8,
  vid   :struct { x:?i32=null, y:?i32=null },
  set   :Cli.Args,

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
    // _= try cli.parse.early(&result.all, result.title, &result.vid.x.?, &result.vid.y.?);
    std.debug.print("[id3.cli] Done parsing CLI Arguments.\n", .{});
    return result;
  } //:: id3.Cli.init
}; //:: id3.Cli

