//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
// @deps zstd
const zstd = @import("./src/lib/zstd.zig");
const sh   = zstd.shell;
const echo = zstd.echo;
// @deps confy
const confy = @import("./src/lib/confy.zig");
const Name  = confy.Name;
const Git   = confy.Git;
// @deps build
const glfw = @import("./src/build/glfw.zig");


//______________________________________
// @section Package Information
//____________________________
const version     = "0.0.0";
const name        = "OpenQuake3-engine";
const description = "Open Quake3 Engine";
const license     = "GPLv3-or-later";
const author      = Name{ .short= "heysokam", .human= ".sOkam!" };
//________________________
const P = confy.Package.Info{
  .version = version,
  .name    = confy.Name{ .short= "oQ3", .long = "OpenQuake3", .human= description },
  .author  = author,
  .license = license,
  .git     = Git.Info{ .owner= "OpenQuake3", .repo= "engine" },
  }; //:: P


//______________________________________
// @section Build: Configuration
//____________________________
const alwaysClean = false;
const verbose     = false;
const dir         = struct {
  const bin       = "bin";
  const src       = "./src";
  const Engine    = "./engine";
}; //:: dir
const idtech3 = struct {
  const url = "https://github.com/JBustos22/oDFe";  // URL of the id-Tech3's repository
  const C   = @import("./src/build/id3c.zig");
  const src = struct {
    const engine =
      idtech3.C.Unix ++ idtech3.C.Core ++
      idtech3.C.Client ++ idtech3.C.Renderer ++
      idtech3.C.lib.jpeg ++
      idtech3.C.lib.bot ++
      idtech3.C.Server;
  };
  const flags = .{
    .cc = &.{
      "-I"++glfw.dir.src++"/include", "-I"++dir.bin,  },
    .ld = &.{
      "-L"++glfw.dir.src++"/build/src", "-lglfw3",
      "-lm", "-lvulkan",
      "-lSDL2",
      "-L"++dir.bin, "-lid3c", },
     }; //:: idtech3.flags
};


//______________________________________
// @section Build: Entry Point
//____________________________
pub fn main () !u8 {
  // Initialize the confy builder
  var builder = try confy.init(); defer builder.term();
  P.report();
  //______________________________________
  // @section Define Targets
  //____________________________
  _= try confy.UnitTest(.{
    .trg     = "tests",
    .entry   = dir.src++"/tests.zig",
    .version = P.version,
    }, &builder);
  //__________________
  var id3 = try confy.StaticLib(.{
    .trg     = "libid3c",
    .src     = idtech3.src.engine,
    .version = P.version,
    .flags   = idtech3.C.flags.lib,
    }, &builder);

  //______________________________________
  // @section Build Targets
  //____________________________
  // try tests.build();
  try id3.build();
  return 0;
}

