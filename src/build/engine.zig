//:_________________________________________________________________
//  osdf  |  Copyright (C) Ivan Mar (sOkam!)  |  GPL-3.0-or-later  :
//:_________________________________________________________________
pub const Engine = @This();
// @deps buildsystem
const confy = @import("confy");


//______________________________________
// @section Object Fields
//____________________________
client  :confy.Target,
server  :confy.Target,
pkg     :confy.package.Info,
P       :confy.Process,


//______________________________________
// @section Engine: Project Configuration
//____________________________
const engine = @import("./engine/cfg.zig");
const flags  = @import("./engine/flags.zig");
const code   = @import("./engine/source.zig");


//______________________________________
// @section Engine: Build Targets
//____________________________
const target = struct {
  //__________________
  // Engine: Client
  fn client (
      P       : confy.Process,
      pkg     : confy.package.Info,
      system  : confy.System,
      cfg     : confy.Config,
      release : bool,
    ) !confy.Target {_=pkg;
    return confy.target(.program, .{
      .trg          = "oQ3.",  // TODO: Take from options  (todo: pkg)
      .src          = Engine.code.client.files(system),
      .globs        = Engine.code.client.dirs(system),
      .src_absolute = true,
      .flags        = Engine.flags.client.all(system, release),
      .cfg          = cfg,
      .system       = system,
      .P            = P,
      // .version      = pkg.version,  // TODO: Is this needed??
    });
  }
  //__________________
  // Engine: Server
  fn server (
      P       : confy.Process,
      pkg     : confy.package.Info,
      system  : confy.System,
      cfg     : confy.Config,
      release : bool,
    ) !confy.Target {_=pkg;
    return confy.target(.program, .{
      .trg          = "oQ3.dedicated.",  // TODO: Take from options  (todo: pkg)
      .src          = Engine.code.server.files(system),
      .globs        = Engine.code.server.dirs(system),
      .src_absolute = true,
      .flags        = Engine.flags.server.all(system, release),
      .cfg          = cfg,
      .system       = system,
      .P            = P,
      // .version      = pkg.version,  // TODO: Is this needed??
    });
  }
};
//__________________
pub fn create (P :confy.Process, pkg :confy.package.Info, release :bool) !Engine {
  var cfg :confy.Config= .default();
  cfg.system.subfolder = true;
  cfg.system.appendCpu = true;
  cfg.verbose = true;
  //__________________
  // Make sure the requirements are accessible
  try Engine.requirements(P, pkg);
  //__________________
  // Create the Targets
  return Engine{
    .client = try Engine.target.client(P, pkg, confy.System.host(), cfg, release),
    .server = try Engine.target.server(P, pkg, confy.System.host(), cfg, release),
    .pkg    = pkg,
    .P      = P,
  };
}

//______________________________________
// @section Engine: Requirements
//____________________________
fn requirements (P :confy.Process, pkg :confy.package.Info) !void {_=pkg;
  if (!confy.dir.exists(Engine.engine.idtech3.dir, P.io, .{})) {
    // 1. Init/update the submodule
    try confy.git.submodule.update(Engine.engine.idtech3.dir, P.io, P.arena.allocator(), .{});
    // 2. Apply custom patches
    const dir        = try confy.dir.absolute(Engine.engine.idtech3.dir, P.io, P.arena.allocator(), .{});
    var   patches    = try confy.Patch.List.create(Engine.engine.patch_list, .{.mode= .absolute, .cfg= .{.verbose= true}});
    const wiggle_src = try confy.dir.absolute("./bin/.wiggle", P.io, P.arena.allocator(), .{});
    const wiggle_dir = try confy.path.join(P.arena.allocator(), &.{dir, "bin"});
    try confy.dir.create(wiggle_dir, P.io, .{});
    const wiggle_trg = try confy.path.join(P.arena.allocator(), &.{dir, "bin/.wiggle"});
    try confy.dir.link(wiggle_src, wiggle_trg, P.io);
    for (patches.list.data()) |*patch| try patch.apply(.{.cwd= dir });
  }
}


//______________________________________
// @section Engine Builder: Entry Point
//____________________________
pub fn buildFor (E :*Engine, systems :[]const confy.System) !void {
  //__________________
  for (systems) |system| {
    if (system.eq(confy.System.host())) {
      try E.client.build();
      try E.server.build();
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
    }
  }
}

