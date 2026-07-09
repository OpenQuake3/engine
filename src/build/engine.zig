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


//______________________________________
// @section Engine: Project Configuration
//____________________________
const config = @import("./cfg.zig");
const flags  = @import("./flags.zig");
const code   = @import("./source.zig");


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
    .setup  = setup,
    .pkg    = arg.pkg,
    .root   = arg.root,
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
  // 1. Init/update the submodule
  if (!confy.dir.exists(Engine.config.idtech3.dir, P.io, .{}))
    try confy.git.submodule.update(Engine.config.idtech3.dir, P.io, P.arena.allocator(), .{});
  // 2. Reset submodule to clean state and apply patches
  const dir        = try confy.dir.absolute(Engine.config.idtech3.dir, P.io, P.arena.allocator(), .{});
  try confy.git.checkout.run(".", P.io, P.arena.allocator(), .{.cwd= dir});
  try confy.git.clean.run(P.io, P.arena.allocator(), .{.cwd= dir});
  var   patches    = try confy.Patch.List.create(Engine.config.idtech3.patch_list, .{.mode= .absolute, .cfg= .{.verbose= true}});
  const wiggle_src = try confy.dir.absolute("./bin/.wiggle", P.io, P.arena.allocator(), .{});
  const wiggle_dir = try confy.path.join(P.arena.allocator(), &.{dir, "bin"});
  try confy.dir.create(wiggle_dir, P.io, .{});
  const wiggle_trg = try confy.path.join(P.arena.allocator(), &.{dir, "bin/.wiggle"});
  if (!confy.dir.exists(wiggle_trg, P.io, .{}))
    try confy.dir.link(wiggle_src, wiggle_trg, P.io);
  for (patches.list.data()) |*patch| try patch.apply(.{.cwd= dir });
}


//______________________________________
// @section Engine Builder: Entry Point
//____________________________
pub fn buildFor (E :*Engine, systems :[]const confy.System) !void {
  const prev = try E.setup.currentPath(E.root);
  const A    = E.setup.A.allocator();
  const io   = E.setup.io.io();
  //__________________
  // Make sure the requirements are accessible
  try Engine.requirements(E.setup.P, E.pkg);
  //__________________
  for (systems) |system| {
    if (system.eq(confy.System.host())) {
      try E.client.build();
      try E.server.build();
      //__________________
      // Copy engine binaries into game output
      const engine_out = try E.client.out_dir();
      const game_out   = try confy.path.join(E.setup.P.arena.allocator(), &.{prev, engine_out});
      try confy.dir.copy_contents(engine_out, game_out, io, A, .{.kind= .files});
    } else {
      //__________________
      var client         = try E.client.clone();
      client.cfg.dir.sub = "";
      client.system      = system;
      try client.build();
      //__________________
      var server         = try E.server.clone();
      server.cfg.dir.sub = "";
      server.system      = system;
      try server.build();
      //__________________
      // Copy engine binaries into game output
      const engine_out = try client.out_dir();
      const game_out   = try confy.path.join(A, &.{prev, engine_out});
      try confy.dir.copy_contents(engine_out, game_out, io, A, .{.kind= .files});
    }
  }
  _ = try E.setup.currentPath(prev);
}

