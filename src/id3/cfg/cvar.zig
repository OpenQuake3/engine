//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
pub const Cvar = @This();
const _This = @This();
// @deps zstd
const zstd = @import("../../lib/zstd.zig");
const cstr = zstd.cstr;
// @deps id3c
const C = @import("../C.zig");
// @deps id3
const id3 = struct {
  pub usingnamespace @import("../types.zig");
  const Cvar = _This;
  const Cfg  = @import("../cfg.zig");
};
// @deps id3.Cvar
pub usingnamespace @import("./cvar/types.zig");
pub usingnamespace @import("./cvar/list.zig");


/// @descr Name of the cvar, as found by the user in console at runtime.
name   :id3.String,
/// @descr The internal type that the Cvar is validated with
type   :id3.Cvar.Type,
/// @descr
///  Description of the cvar, as found by the user in console at runtime.
///  The cvar won't have a default description on init when this value is null.
descr  :?id3.String= null,
/// @descr Initial value of the cvar.
value  :?id3.String=  null,
/// @descr Option flags that the Cvar will be initialized with.
flags  :id3.Cvar.Flags= .{},
range  :?id3.Cvar.Range= null,

/// @descr Should the runtime code call `startup(name)` on the cvar when initializing it
should_startup :bool= false,
/// @descr Has the runtime code already called `startup(name)` on the cvar
_startup :bool= false,

/// @internal State managed by the Cvar
_state    :id3.Cvar.State,
/// @internal
///  false whenever the wrapper functions have not initialized the cvar yet
///  Calling any function that makes the variable known on CLI will trigger this to become true
///  Equivalent to `val.exists`, but clearer since cvars can be initialized by CLI before the code is aware of them.
_runtime  :bool=  false,

fn descr_set (V :*const id3.Cvar) void {
  if (V.descr == null) return;
  C.cvar.setDescr(V._state.*, V.descr.?.ptr);
} //:: id3.Cvar.descr.set

fn range_check (V :*const id3.Cvar) void {
  if (V.range == null) return;
  C.cvar.range.check(V._state.*,
    if (V.range.?.min != null) V.range.?.min.?.ptr else null,
    if (V.range.?.max != null) V.range.?.max.?.ptr else null,
    V.type);
} //:: id3.Cvar.Range.check

fn state_create (V :*id3.Cvar) void {
  V._state.* = C.cvar.get(V.name, if (V.value != null) V.value.?.ptr else null, V.flags);
  V._runtime = true;
} //:: id3.Cvar.state_create

//______________________________________
/// @descr
///  Searches for command line parameters that are set commands.
///  If {@arg name} is not null, only the cvar with that name will be searched for.
///  This is necessary because cddir and basedir need to be set before the filesystem is started,
///  but all other sets should started after executing the config and defaults.
///
/// @note Same as Com_StartupVariable
const std = @import("std");
pub fn startup (
    V       : *id3.Cvar,
    in      : struct {
      force : bool = false
  }) void {
  if (!V.should_startup and !in.force) return;
  C.cvar.startup(V.name.ptr);
  V._startup = true;
  V._runtime = true;
} //:: id3.Cvar.startup

pub const set = C.cvar.set;
pub fn setModified (V :*id3.Cvar, val :bool) void {
  V.flags.modified    = val;
  V._state.*.modified = @intFromBool(val);
}

pub fn init (V :*id3.Cvar) void {
  V.startup(.{});    // Startup the cvar when needed
  V.state_create();  // Create it if it doesn't already exist
  V.descr_set();     // Set the description when it has a value
} //:: id3.Cvar.init


pub const DefineOptions = struct {
  /// @descr The internal type that the Cvar is validated with
  type  :id3.Cvar.Type,
  /// @descr
  ///  Description of the cvar, as found by the user in console at runtime.
  ///  The cvar won't have a default description on init when this value is null.
  descr  :?id3.String= null,
  /// @descr Initial value of the cvar.
  value  :?id3.String= null,
  /// @descr The (min,max) range of values allowed for the cvar.
  range  :?id3.Cvar.Range= null,
  /// @descr Option flags that the Cvar will be initialized with.
  flags  :id3.Cvar.Flags= .{},

  /// @descr Should the runtime code call startup on the cvar when initializing it
  startup :bool= false,
};

//_____________________________________________________________________
/// @descr
///  Defines the setup data of a Cvar
///  that can be initialized at runtime by the engine code.
///
/// @why
///  !! Remove Boilerplate !!
///  The engine is filled with Cvar initialization boilerplate,
///  which is error prone, unsafe and extremely noisy.
///
///  This tackles the problem by:
///  1. Defining the data at comptime once
///  2. Using it at runtime with helper functions, instead of directly.
///  This indirection allows the setup data to be reduced to a minimum,
///  and also makes it type-safe
pub fn define (
    state : id3.Cvar.State,
    name  : id3.String,
    in    : DefineOptions,
  ) id3.Cvar {
  return id3.Cvar{
    ._state         = state,
    .name           = name,
    .type           = in.type,
    .descr          = in.descr,
    .value          = in.value,
    .range          = in.range,
    .flags          = in.flags,
    .should_startup = in.startup,
  }; //:: result
} //:: result

pub const list = struct {
  //______________________________________
  /// @descr
  ///  Set a specific cvar requested from CLI.
  ///  Will set all Cvars when {@arg match} is null.
  pub const loadCLI = C.cvar.startup;
  //______________________________________
  /// @descr Set all cvars requested from CLI.
  pub fn startup () void { id3.Cvar.list.loadCLI(null); }
  pub const modified = struct {
    extern var cvar_modifiedFlags :id3.Cvar.Flags;
    pub fn add    (flags :id3.Cvar.Flags) void { cvar_modifiedFlags = cvar_modifiedFlags.with(flags); }
    pub fn remove (flags :id3.Cvar.Flags) void { cvar_modifiedFlags = cvar_modifiedFlags.without(flags); }
  };

  pub const init = struct {
    //______________________________________
    /// @descr
    ///  1. Initializes the GlobalState of the cvar system
    ///  2. Creates the cvar_cheats (`sv_cheats`) and cvar_developer (`developer`) variables
    ///  3. Adds all basic/primary commands into the engine
    pub const core = C.cvar.init;

    pub const Server = struct {
      name  :id3.String,
      url   :id3.String,
      pub const List = []const id3.Cvar.list.init.Server;
      pub const DefaultList :Server.List= &.{
        // FIX: Should be part of the Cvar.list.net file
        Server{.name="sv_master1", .url= "master.quake3arena.com"     }, // FIX: Broken link. Remove/replace
        Server{.name="sv_master2", .url= "master.ioquake3.org"        }, // FIX: Broken link. Remove/replace
        Server{.name="sv_master3", .url= "master.maverickservers.com" }, // FIX: Broken link. Remove/replace
      }; //:: id3.Cvar.list.init.Server.DefaultList
    }; //:: id3.Cvar.list.init.Server

    fn servers (in :struct {
        L : Server.List = Server.DefaultList
      }) void {
      for (in.L) |sv| { C.cvar.startup(sv.name); _=C.cvar.get(sv.name, sv.url, .{.init=true}); }
    } //:: id3.Cvar.list.init.servers

    fn protocol () void {
      // TODO:
      // id3.Cvar.net_protocol_compat.init()
      //_____________________________________
      // if (Q_stristr(com_protocol.*.string, "-compat") > @as([*c]const u8, @ptrCast(@alignCast(com_protocol.*.string)))) {
      //     _ = Cvar_Set2("protocol", va("%i", com_protocol.*.integer), @as(c_uint, @bitCast(qtrue)));
      //     com_protocolCompat = @as(c_uint, @bitCast(qtrue));
      // } else {
      //     com_protocolCompat = @as(c_uint, @bitCast(qfalse));
      // }
      //_____________________________________
      id3.Cvar.net_protocol.define();  // Define it before init. We modify its default flags before the cvar is initialized
      id3.Cvar.net_protocol.data.flags.created_user = false; // com_protocol->flags &= ~CVAR_USER_CREATED;
      id3.Cvar.net_protocol.data.flags.info_server  = true;  // com_protocol->flags |= CVAR_SERVERINFO | CVAR_ROM;
      id3.Cvar.net_protocol.data.flags.rom          = true;
      id3.Cvar.net_protocol.init();  // TODO: Check that this initialized the flags as expected by the C code
    } //:: id3.Cvar.list.init.protocol

    //______________________________________
    /// @descr
    ///  Initializes the cvars required for some of the early-init systems of the engine.
    ///  `developer`, `vm_rtChecks`, `journal`, `protocol`, `sv_master{1,2,3}`
    pub fn early () void {
      id3.Cvar.dev_enabled.init();      // com_developer
      id3.Cvar.vm_rtChecks.init();      // vm_rtChecks
      id3.Cvar.dev_journal.init();      // journal
      id3.Cvar.list.init.servers(.{});  // sv_master{1,2,3}
      id3.Cvar.list.init.protocol();    // protocol
    } //:: id3.Cvar.list.init.early

    //______________________________________
    /// @descr Initializes the main/core cvars of the engine.
    pub fn engine (cfg :id3.Cfg) void {
      if (!cfg.engine.server.dedicated) {
        id3.Cvar.fps_max.init();
        id3.Cvar.fps_max_notFocused.init();
        id3.Cvar.cpu_yield.init();
      }
      if (cfg.cpu.affinity) {
        id3.Cvar.cpu_affinity.init();
        id3.Cvar.cpu_affinity.data.setModified(false);
      }
      id3.Cvar.time_scale.init();
      id3.Cvar.time_fixed_render.init();
      id3.Cvar.dev_trace_enabled.init();
      id3.Cvar.log_view.init();
      id3.Cvar.dev_speeds.init();
      id3.Cvar.cam_mode.init();
      if (!cfg.engine.server.dedicated) {
        id3.Cvar.time_demo.init();
        id3.Cvar.cl_paused.init();
        id3.Cvar.cl_packetDelay.init();
        id3.Cvar.cl_running.init();
      }
      id3.Cvar.sv_paused.init();
      id3.Cvar.sv_packetdelay.init();
      id3.Cvar.sv_running.init();
      id3.Cvar.dev_res_loadAll.init();
      id3.Cvar.log_err_message.init();
      if (!cfg.engine.server.dedicated) {
        id3.Cvar.res_cin_intro_skip.init();
        id3.Cvar.res_cin_logo_skip.init();
      }
    } //:: id3.Cvar.list.engine
  }; //:: id3.Cvar.list.init
}; //:: id3.Cvar.list

