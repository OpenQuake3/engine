//:________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GPL-3.0-or-later  :
//:________________________________________________________________
pub const Libs = @This();
// @deps buildsystem
const confy = @import("confy");


//______________________________________
// @section Object Fields
//____________________________
zlib    :confy.Target,
mbedtls :confy.Target,
curl    :confy.Target,


//______________________________________
// @section Libs: Configuration
//____________________________
pub const config = @import("./libs/cfg.zig");


//______________________________________
// @section Libs: Dependencies
//____________________________
pub const freetype = struct {
  pub const dependency = confy.dependency("freetype", "https://github.com/ubawurinna/freetype-windows-binaries", .{.src= "include"});
  //__________________
  pub fn path (
      cfg : confy.Config,
      arg : confy.Dependency.path_args,
    ) !confy.cstring { return try dependency.path(cfg, arg); }
};


//______________________________________
// @section Libs: Create
//____________________________
const target    = struct {
  const zlib    = @import("./libs/zlib.zig").target;
  const mbedtls = @import("./libs/mbedtls.zig").target;
  const curl    = @import("./libs/curl.zig").target;
};
//__________________
pub fn create (
    P      : confy.Process,
    cfg    : confy.Config,
    system : confy.System,
    root   : confy.Path,
  ) !Libs {
  var build_cfg              = cfg;
  build_cfg.system.subfolder = true;
  build_cfg.system.appendCpu = false;
  build_cfg.dir.bin          = try confy.path.join(P.arena.allocator(), &.{root, "bin"});
  return .{
    .zlib    = try Libs.target.zlib(P, system, build_cfg),
    .mbedtls = try Libs.target.mbedtls(P, system, build_cfg),
    .curl    = try Libs.target.curl(P, system, build_cfg),
  };
}


//______________________________________
// @section Libs: Build
//____________________________
pub fn build (L :*Libs) !void {
  try L.zlib.build();
  try L.mbedtls.build();
  try L.curl.build();
}

