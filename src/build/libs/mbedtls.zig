//:________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GPL-3.0-or-later  :
//:________________________________________________________________
pub const mbedtls = @This();
// @deps buildsystem
const confy = @import("confy");
// @deps config
const cfg = @import("./cfg.zig");


//______________________________________
// @section mbedTLS: Target
//____________________________
pub fn target (P :confy.Process, system :confy.System, build_cfg :confy.Config) !confy.Target {
  return confy.target(.static, .{
    .trg          = "mbedtls",
    .src          = mbedtls.src,
    .globs        = mbedtls.globs,
    .src_absolute = true,
    .flags        = mbedtls.flags,
    .system       = system,
    .cfg          = build_cfg,
    .P            = P,
  });
}


//______________________________________
// @section mbedTLS: Source
//____________________________
const src = &[_]confy.cstring{
  cfg.mbedtls.dir ++ "/library/ssl_tls.c",
};

const globs = &[_]confy.Glob{
  .{.dir= cfg.mbedtls.dir ++ "/library"},
};


//______________________________________
// @section mbedTLS: Flags
//____________________________
const flags = &[_]confy.cstring{
  "-I" ++ cfg.mbedtls.dir ++ "/include",
  "-I" ++ cfg.mbedtls.dir ++ "/library",
  // zig cc compat
  "-fno-sanitize=all",
  "-Wno-unused-command-line-argument",
};
