//:________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GPL-3.0-or-later  :
//:________________________________________________________________
pub const zlib = @This();
// @deps buildsystem
const confy = @import("confy");
// @deps config
const cfg = @import("./cfg.zig");


//______________________________________
// @section Zlib: Target
//____________________________
pub fn target (P :confy.Process, system :confy.System, build_cfg :confy.Config) !confy.Target {
  return confy.target(.static, .{
    .trg          = "z",
    .src          = zlib.src,
    .globs        = zlib.globs,
    .src_absolute = true,
    .flags        = zlib.flags,
    .system       = system,
    .cfg          = build_cfg,
    .P            = P,
  });
}


//______________________________________
// @section Zlib: Source
//____________________________
const src = &[_]confy.cstring{
  cfg.zlib.dir ++ "/zutil.c",
};

const globs = &[_]confy.Glob{
  .{.dir= cfg.zlib.dir},
};


//______________________________________
// @section Zlib: Flags
//____________________________
const flags = &[_]confy.cstring{
  "-fno-sanitize=all",
  "-I" ++ cfg.zlib.dir,
  "-D_LARGEFILE64_SOURCE",
  "-Wno-implicit-function-declaration",
  // zig cc compat
  "-fno-sanitize=all",
  "-Wno-unused-command-line-argument",
};

