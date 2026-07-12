//:________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GPL-3.0-or-later  :
//:________________________________________________________________
pub const Engine = @This();
// @deps std
const std = @import("std");
// @deps buildsystem
const confy = @import("confy");


//______________________________________
// @section Object Fields
//____________________________
client  :confy.Target,
server  :confy.Target,
setup   :confy.Confy,
pkg     :confy.package.Info,
root    :confy.Path= ".",
release :bool      = true,
game    :?confy.Name = null,


//______________________________________
// @section Engine: Project Configuration
//____________________________
const config = @import("./cfg.zig");
const flags  = @import("./flags.zig");
const code   = @import("./source.zig");
const Libs   = @import("./libs.zig").Libs;


//______________________________________
// @section Engine: Build Targets
//____________________________
const target = struct {
  //__________________
  // Engine: Client
  fn client (
      P      : confy.Process,
      system : confy.System,
      cfg    : confy.Config,
      arg    : Engine.create_args,
    ) !confy.Target {
    return confy.target(.program, .{
      .trg          = "oQ3.",  // TODO: Take from options  (todo: pkg)
      .src          = Engine.code.client.files(system),
      .globs        = Engine.code.client.dirs(system),
      .src_absolute = true,
      .flags        = Engine.flags.client.all(system, arg.release),
      .cfg          = cfg,
      .system       = system,
      .P            = P,
      // .version      = pkg.version,  // TODO: Is this needed??
    });
  }
  //__________________
  // Engine: Server
  fn server (
      P      : confy.Process,
      system : confy.System,
      cfg    : confy.Config,
      arg    : Engine.create_args,
    ) !confy.Target {
    return confy.target(.program, .{
      .trg          = "oQ3.dedicated.",  // TODO: Take from options  (todo: pkg)
      .src          = Engine.code.server.files(system),
      .globs        = Engine.code.server.dirs(system),
      .src_absolute = true,
      .flags        = Engine.flags.server.all(system, arg.release),
      .cfg          = cfg,
      .system       = system,
      .P            = P,
      // .version      = pkg.version,  // TODO: Is this needed??
    });
  }
};
//__________________
pub const create_args = struct {
  pkg      :confy.package.Info = Engine.config.package,
  root     :confy.Path         = ".",
  release  :bool               = true,
  verbose  :bool               = false,
  game     :?confy.Name        = null,
};
//__________________
pub fn create (
    P   : confy.Process,
    arg : Engine.create_args,
  ) !Engine {
  var cfg :confy.Config= .default();
  cfg.system.subfolder = true;
  cfg.system.appendCpu = true;
  cfg.verbose          = arg.verbose;
  //__________________
  // Setup and change to engine root
  var setup = try confy.setup(arg.root, P, .{.linked= true, .cfg= cfg});
  const prev = try setup.currentPath(arg.root);
  //__________________
  // Create the Targets
  var result = Engine{
    .client = try Engine.target.client(P, confy.System.host(), cfg, arg),
    .server = try Engine.target.server(P, confy.System.host(), cfg, arg),
    .setup   = setup,
    .pkg     = arg.pkg,
    .root    = arg.root,
    .release = arg.release,
    .game    = arg.game,
  };
  //__________________
  // Pass down game name as DEFAULT_GAME define
  if (arg.game) |game| {
    const default_game = try confy.string.create_format("-DDEFAULT_GAME=\"{s}\"", .{game.short}, P.arena.allocator());
    try result.client.flags.add_one(default_game.data());
    try result.server.flags.add_one(default_game.data());
  }
  //__________________
  _ = try setup.currentPath(prev);
  return result;
}

//______________________________________
// @section Engine: Requirements
//____________________________
fn requirements (P :confy.Process, pkg :confy.package.Info) !void {_=pkg;
  //__________________
  // 1. Init/update the submodule
  if (!confy.dir.exists(Engine.config.idtech3.dir, P.io, .{}))
    try confy.git.submodule.update(Engine.config.idtech3.dir, P.io, P.arena.allocator(), .{});
  //__________________
  // 2. Reset submodule to clean state and apply patches
  const dir        = try confy.dir.absolute(Engine.config.idtech3.dir, P.io, P.arena.allocator(), .{});
  try confy.git.reset_full(P.io, P.arena.allocator(), .{.cwd= dir, .case_sensitive= true, .exclude= &.{"-e", "bin"}});
  var   patches    = try confy.Patch.List.create(Engine.config.idtech3.patch_list, .{.mode= .absolute, .cfg= .{.verbose= true}});
  const wiggle_src = try confy.dir.absolute("./bin/.wiggle", P.io, P.arena.allocator(), .{});
  const wiggle_dir = try confy.path.join(P.arena.allocator(), &.{dir, "bin"});
  try confy.dir.create(wiggle_dir, P.io, .{});
  const wiggle_trg = try confy.path.join(P.arena.allocator(), &.{dir, "bin/.wiggle"});
  if (!confy.dir.exists(wiggle_trg, P.io, .{}))
    try confy.dir.link(wiggle_src, wiggle_trg, P.io);
  for (patches.list.data()) |*patch| try patch.apply(.{.cwd= dir });
  //__________________
  // 3. Symlink GL headers for macOS cross-compilation
  const lib_dir  = try confy.dir.absolute("./bin/.lib", P.io, P.arena.allocator(), .{});
  const gl_links = [_][2]confy.Path{
    .{"/usr/include/GL",  "OpenGL"},
    .{"/usr/include/GL",  "GL"},
    .{"/usr/include/KHR", "KHR"},
  };
  for (gl_links) |entry| {
    const src     = entry[0];
    const name    = entry[1];
    const trg_rel = try confy.path.join(P.arena.allocator(), &.{"./bin/.lib", name});
    if (confy.dir.exists(src, P.io, .{}) and !confy.dir.exists(trg_rel, P.io, .{}))
      try confy.dir.link(src, try confy.path.join(P.arena.allocator(), &.{lib_dir, name}), P.io);
  }
}


//______________________________________
// @section Engine Dependencies
//____________________________
fn libs (E :*Engine, systems :[]const confy.System) !void { for (systems) |system| {
  //__________________
  // Build static libraries for windows
  if (system.os == .windows) {
    var L = try Libs.create(E.setup.P, system);
    try L.build();
  }
}}


//______________________________________
// @section Engine Builder: Entry Point
//____________________________
pub fn buildFor (E :*Engine, systems :[]const confy.System) !void {
  const prev = try E.setup.currentPath(E.root);
  const A    = E.setup.A.allocator();
  const io   = E.setup.io.io();
  //__________________
  // Make sure the requirements and libraries are available
  try Engine.requirements(E.setup.P, E.pkg);
  try Engine.libs(E, systems);
  //__________________
  for (systems) |system| {
    const out_dir = try confy.path.join(A, &.{prev, "bin", try system.zig_triple(A)});
    try confy.dir.create(out_dir, io, .{});
    if (system.eq(confy.System.host())) {
      try E.client.build();
      try E.server.build();
      //__________________
      // Copy engine binaries into output
      try confy.dir.copy_contents(try E.client.out_dir(), out_dir, io, A, .{.kind= .files});
      // Cleanup Windows build noise
      if (system.os == .windows) try confy.dir.remove_extensions(
        out_dir, &.{".pdb", ".lib"}, io, A, .{});
    } else {
      //__________________
      var client = try Engine.target.client(E.setup.P, system, E.client.cfg, .{ .release = E.release, .game = E.game });
      if (E.game) |game| try client.flags.add_one(
        (try confy.string.create_format("-DDEFAULT_GAME=\"{s}\"", .{game.short}, A)).data());
      if (system.os == .windows) try client.flags.add_one(
        (try confy.string.create_format("-L./bin/{s}", .{try system.zig_triple(A)}, A)).data());
      try client.build();
      //__________________
      var server = try Engine.target.server(E.setup.P, system, E.server.cfg, .{ .release = E.release, .game = E.game });
      if (E.game) |game| try server.flags.add_one(
        (try confy.string.create_format("-DDEFAULT_GAME=\"{s}\"", .{game.short}, A)).data());
      try server.build();
      //__________________
      // Copy engine binaries into output
      try confy.dir.copy_contents(try client.out_dir(), out_dir, io, A, .{.kind= .files});
      // Cleanup Windows build noise
      if (system.os == .windows) try confy.dir.remove_extensions(
        out_dir, &.{".pdb", ".lib"}, io, A, .{});
    }
  }
  _ = try E.setup.currentPath(prev);
}

