//:________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GPL-3.0-or-later  :
//:________________________________________________________________
pub const curl = @This();
// @deps buildsystem
const confy = @import("confy");
// @deps config
const cfg = @import("./cfg.zig");


//______________________________________
// @section Curl: Target
//____________________________
pub fn target (P :confy.Process, system :confy.System, build_cfg :confy.Config) !confy.Target {
  return confy.target(.static, .{
    .trg          = "curl",
    .src          = curl.src,
    .globs        = curl.globs,
    .src_absolute = true,
    .flags        = curl.flags,
    .system       = system,
    .cfg          = build_cfg,
    .P            = P,
  });
}


//______________________________________
// @section Curl: Source
//____________________________
const src = &[_]confy.cstring{
  cfg.curl.dir ++ "/easy.c",
};

const globs = &[_]confy.Glob{
  .{.dir= cfg.curl.dir},
  .{.dir= cfg.curl.dir ++ "/curlx"},
  .{.dir= cfg.curl.dir ++ "/vauth"},
  .{.dir= cfg.curl.dir ++ "/vtls"},
  .{.dir= cfg.curl.dir ++ "/vquic"},
  .{.dir= cfg.curl.dir ++ "/vssh"},
};


//______________________________________
// @section Curl: Flags
//____________________________
const flags = &[_]confy.cstring{
  "-DBUILDING_LIBCURL",
  "-DCURL_STATICLIB",
  "-DUSE_SCHANNEL",
  "-DUSE_WINDOWS_SSPI",
  "-DUSE_MBEDTLS",
  "-DHAVE_LIBZ",
  "-DUSE_IPV6",
  "-DCURL_DISABLE_LDAP",
  "-DCURL_DISABLE_LDAPS",
  "-I" ++ cfg.curl.include,
  "-I" ++ cfg.curl.dir,
  "-I" ++ cfg.zlib.dir,
  "-I" ++ cfg.mbedtls.dir ++ "/include",
  // zig cc compat
  "-fno-sanitize=all",
  "-Wno-unused-command-line-argument",
};
