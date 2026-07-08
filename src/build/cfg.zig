//:_________________________________________________________________
//  osdf  |  Copyright (C) Ivan Mar (sOkam!)  |  GPL-3.0-or-later  :
//:_________________________________________________________________
pub const cfg = @This();
// @deps buildsystem
const confy = @import("confy");


pub const idtech3 = struct {
  pub const dir        = "./src/lib/idtech3";
  pub const patch_list = "./src/build/patches/list.json";
};


pub const name = struct {
  pub const short = "oQ3";
  pub const long  = "openquake3";
  pub const human = "OpenQuake3";
  pub const full  = confy.Name{.short= name.short, .long= name.long, .human= name.human};
};


pub const package = confy.package.info(.{
  .name    = name.full,
  .author  = confy.Name{.short= "sOkam"},
  .git     = confy.git.Info{.owner= "OpenQuake3", .repo= "engine", .host= "https://github.com"},
});


pub const dir = struct {
  pub const root   = idtech3.dir;
  pub const src    = dir.root++"/code";
  pub const common = dir.src++"/qcommon";
  pub const client = dir.src++"/client";
  pub const server = dir.src++"/server";
};

