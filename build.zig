//:_________________________________________________________________
//  osdf  |  Copyright (C) Ivan Mar (sOkam!)  |  GPL-3.0-or-later  :
//:_________________________________________________________________
// @deps confy
const confy   = @import("confy");
// @deps builder
const Engine  = @import("./src/build/engine.zig").Engine;


//______________________________________
// @section Configuration Options
//____________________________
pub const release    = true;                  // Whether we are building a release or debug version
pub const distribute = release    and false;  // Prepare the output for distribution (manual or automated) when true
pub const publish    = distribute and false;  // Publish to the relevant platforms when true


//______________________________________
// @section Package Information
//____________________________
const cfg = @import("./src/build/cfg.zig");


//______________________________________
// @section Buildsystem Entry Point
//____________________________
pub fn main (P :confy.Process) !void {
  //__________________
  // Build Targets
  var engine = try Engine.create(P, .{.release= release, .pkg= cfg.package});
  //__________________
  // Target System
  const systems =
    if (distribute) confy.System.desktops()
    else            &.{confy.System.host()};
  //__________________
  // Order to Build
  cfg.package.report();
  try engine.buildFor(systems);
  confy.echo(cfg.package.name.short++": Done building.");
}


//______________________________________
// @section Zig Buildsystem: Error Message
//____________________________
pub fn build (b :*@import("std").Build) void {_=b; @import("std").debug.print(
  \\[ERROR] `zig build` is not supported.
  \\  Use `confy build` instead.
  \\  https://codeberg.org/heysokam/confy/releases {s}
  , .{"\n"});
}

