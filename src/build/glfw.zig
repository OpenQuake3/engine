//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
//! @fileoverview Build Dependencies: GLFW
//__________________________________________|
const glfw  = @This();
// @deps built
const confy = @import("../lib/confy.zig");
const zstd  = @import("../lib/zstd.zig");


//______________________________________
// @section GLFW: Build Config
//____________________________
const dir = struct {
  const src = "./src/lib/glfw";
  const bin = glfw.dir.src++"/build";
}; //:: build.glfw.dir
//__________________
pub const flags = .{
  .cc = &.{ "-I"++glfw.dir.src++"/include", },
  .ld = &.{
    "-L"++glfw.dir.src++"/build/src",
    "-lm", "-lglfw3", "-lvulkan"
    }, };


//______________________________________
// @section GLFW Builder: Entry Point
//____________________________
pub fn build (b :*confy.Confy, alwaysClean :bool) !void {
  // Clean before running
  var clean = zstd.shell.Cmd.create(b.A.allocator());
  defer clean.destroy();
  try clean.addList(&.{"rm", "-rf", glfw.dir.bin});
  if (alwaysClean) try clean.run();

  // Run cmake to generate the builder
  var cmake = zstd.shell.Cmd.create(b.A.allocator());
  defer cmake.destroy();
  try cmake.addList(&.{"cmake", "-S", glfw.dir.src, "-B", glfw.dir.bin});
  try cmake.run();

  // Run make to build
  var make = zstd.shell.Cmd.create(b.A.allocator());
  defer make.destroy();
  try make.addList(&.{"make", "-j8", "-C", glfw.dir.bin, "glfw"});
  try make.run();
} //:: builder.glfw.build

