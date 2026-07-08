//:_________________________________________________________________
//  osdf  |  Copyright (C) Ivan Mar (sOkam!)  |  GPL-3.0-or-later  :
//:_________________________________________________________________
pub const cfg = @This();


pub const idtech3 = struct {
  pub const dir = "./src/lib/idtech3";
};

pub const patch_list = "src/build/patches/list.json";

pub const name = struct {
  pub const short = "oQ3";
  pub const long  = "openquake3";
  pub const human = "OpenQuake3";
};


pub const dir = struct {
  pub const root   = idtech3.dir;
  pub const src    = dir.root++"/code";
  pub const common = dir.src++"/qcommon";
  pub const client = dir.src++"/client";
  pub const server = dir.src++"/server";
};

