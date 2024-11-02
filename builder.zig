//:_______________________________________________________________________
//  id-Tech3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:_______________________________________________________________________
// @deps zstd
const zstd = @import("./src/lib/zstd.zig");
const sh   = zstd.shell;
const echo = zstd.echo;
// @deps confy
const confy = @import("./src/lib/confy.zig");
const Name  = confy.Name;
const Git   = confy.Git;


//______________________________________
// @section Package Information
//____________________________
const version     = "0.0.0";
const name        = "id3-testing";
const description = "id-Tec3: Unit Testing";
const license     = "GPLv3-or-later";
const author      = Name{ .short= "heysokam", .human= ".sOkam!" };
//________________________
const P = confy.Package.Info{
  .version = version,
  .name    = confy.Name{ .short= name, .human= description },
  .author  = author,
  .license = license,
  .git     = Git.Info{ .owner= author.short, .repo= name },
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
  var tests = try confy.UnitTest(.{
    .trg     = "tests",
    .entry   = dir.src++"/tests.zig",
    .version = P.version,
    }, &builder);
  //__________________

  //______________________________________
  // @section Build Targets
  //____________________________
  try tests.build();
  return 0;
}
