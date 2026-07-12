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
const target = struct {
  const zlib    = @import("./libs/zlib.zig").target;
  const mbedtls = @import("./libs/mbedtls.zig").target;
  const curl    = @import("./libs/curl.zig").target;
};


//______________________________________
// @section Libs: Create
//____________________________
pub fn create (P :confy.Process, system :confy.System) !Libs {
  var build_cfg :confy.Config = .default();
  build_cfg.system.subfolder = true;
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

