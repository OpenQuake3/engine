//:________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GPL-3.0-or-later  :
//:________________________________________________________________
pub const cfg = @This();
// @deps buildsystem
const confy = @import("confy");


//______________________________________
// @section Library Directories
//____________________________
pub const zlib = struct {
  pub const dir = "./src/lib/zlib";
};

pub const mbedtls = struct {
  pub const dir = "./src/lib/mbedtls";
};

pub const curl = struct {
  pub const dir     = "./src/lib/curl/lib";
  pub const include = "./src/lib/curl/include";
};
