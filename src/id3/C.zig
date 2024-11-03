//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview id-Tech3 Engine: C Wrapper for Zig
//____________________________________________________|
pub const C = @This();
pub const zstd = @import("../lib/zstd.zig");


//______________________________________
// @section General Types
//____________________________
pub const Bool  = c_uint;
pub const Flags = c_uint;


//______________________________________
// @section C wrapper
//____________________________
const c = struct {
  //______________________________________
  // @section System
  //____________________________
  extern fn Sys_Milliseconds () callconv(.C) c_int;
  extern fn Sys_Pwd () callconv(.C) [*c]const u8;
  extern fn IN_Frame () callconv(.C) void;

  //______________________________________
  // @section CLI
  //____________________________
  // qboolean Com_EarlyParseCmdLine( char *commandLine, char *con_title, int title_size, int *vid_xpos, int *vid_ypos );
  extern fn Com_EarlyParseCmdLine (
      commandLine : [*c]u8,
      con_title   : [*c]u8,
      title_size  : usize,
      vid_xpos    : [*c]c_int,
      vid_ypos    : [*c]c_int
    ) callconv(.C) C.Bool;

  //______________________________________
  // @section CVars
  //____________________________
  const MAX_CVAR_VALUE_STRING :usize= 256;
  const cvarValidator_t = c_uint;
  const cvarGroup_t     = c_uint;
  const cvarFlags_t     = c_uint;
  const Cvar = extern struct {
    name              :[*c]u8           = @import("std").mem.zeroes([*c]u8),
    string            :[*c]u8           = @import("std").mem.zeroes([*c]u8),
    resetString       :[*c]u8           = @import("std").mem.zeroes([*c]u8),
    latchedString     :[*c]u8           = @import("std").mem.zeroes([*c]u8),
    flags             :c_int            = @import("std").mem.zeroes(c_int),
    modified          :C.Bool           = @import("std").mem.zeroes(C.Bool),
    modificationCount :c.Cvar.Flags     = @import("std").mem.zeroes(c_int),
    value             :f32              = @import("std").mem.zeroes(f32),
    integer           :c_int            = @import("std").mem.zeroes(c_int),
    validator         :c.Cvar.Validator = @import("std").mem.zeroes(c.Cvar.Validator),
    mins              :[*c]u8           = @import("std").mem.zeroes([*c]u8),
    maxs              :[*c]u8           = @import("std").mem.zeroes([*c]u8),
    description       :[*c]u8           = @import("std").mem.zeroes([*c]u8),
    next              :[*c]c.Cvar       = @import("std").mem.zeroes([*c]c.Cvar),
    prev              :[*c]c.Cvar       = @import("std").mem.zeroes([*c]c.Cvar),
    hashNext          :[*c]c.Cvar       = @import("std").mem.zeroes([*c]c.Cvar),
    hashPrev          :[*c]c.Cvar       = @import("std").mem.zeroes([*c]c.Cvar),
    hashIndex         :c_int            = @import("std").mem.zeroes(c_int),
    group             :c.Cvar.Group     = @import("std").mem.zeroes(c.Cvar.Group),
    const Validator = enum(cvarValidator_t) { none, float, integer, fspath, max, _, };
    const Group     = enum(cvarGroup_t) { none, renderer, server, max, _, };
    const Flags     = packed struct {
      /// set to cause it to be saved to vars.rc. Used for system variables, not for player specific configurations
      archive         :bool = false,  // 00 :: #define CVAR_ARCHIVE         0x0001
      /// sent to server on connect or change
      info_user       :bool = false,  // 01 :: #define CVAR_USERINFO        0x0002
      /// sent in response to front end requests
      info_server     :bool = false,  // 02 :: #define CVAR_SERVERINFO      0x0004
      /// these cvars will be duplicated on all clients
      info_system     :bool = false,  // 03 :: #define CVAR_SYSTEMINFO      0x0008
      /// don't allow change from console at all, but can be set from the command line
      init            :bool = false,  // 04 :: #define CVAR_INIT            0x0010
      /// will only change when C code next does a Cvar_Get(), so it can't be changed without proper initialization.
      /// modified will be set, even though the value hasn't changed yet
      latch           :bool = false,  // 05 :: #define CVAR_LATCH           0x0020
      /// display only, cannot be set by user at all
      rom             :bool = false,  // 06 :: #define CVAR_ROM             0x0040 
      /// created by a set command
      created_user    :bool = false,  // 07 :: #define CVAR_USER_CREATED    0x0080
      /// can be set even when cheats are disabled, but is not archived
      temp            :bool = false,  // 08 :: #define CVAR_TEMP            0x0100
      /// can not be changed if cheats are disabled
      cheat           :bool = false,  // 09 :: #define CVAR_CHEAT           0x0200
      /// do not clear when a cvar_restart is issued
      noRestart       :bool = false,  // 10 :: #define CVAR_NORESTART       0x0400
      /// cvar was created by a server the client connected to.
      created_server  :bool = false,  // 11 :: #define CVAR_SERVER_CREATED  0x0800
      /// cvar was created exclusively in one of the VMs.
      created_VM      :bool = false,  // 12 :: #define CVAR_VM_CREATED      0x1000
      /// prevent modifying this var from VMs or the server
      protected       :bool = false,  // 13 :: #define CVAR_PROTECTED       0x2000
      /// do not write to config if matching with default value
      noDefault       :bool = false,  // 14 :: #define CVAR_NODEFAULT       0x4000
      /// can't be read from VM
      private         :bool = false,  // 15 :: #define CVAR_PRIVATE         0x8000
      /// can be set only in developer mode
      developer       :bool = false,  // 16 :: #define CVAR_DEVELOPER       0x10000
      /// no tab completion in console
      noTabComplete   :bool = false,  // 17 :: #define CVAR_NOTABCOMPLETE   0x20000
      __unused_bits_18_29 :u12=0,
      /// Cvar was modified.  Only returned by the Cvar_Flags() function
      modified        :bool = false,  // 30 :: #define CVAR_MODIFIED        0x40000000
      // Cvar doesn't exist.  Only returned by the Cvar_Flags() function
      nonExistent     :bool = false,  // 31 :: #define CVAR_NONEXISTENT     0x80000000

      pub usingnamespace zstd.Flags(@This(), cvarFlags_t);
      pub const archive_ND :@This()= .{.archive=true, .noDefault=true };  // #define CVAR_ARCHIVE_ND (CVAR_ARCHIVE | CVAR_NODEFAULT)
                                                                          //
    }; //:: id3.C.Cvar.Flags
  }; //:: id3.C.Cvar
  extern fn Cvar_Get (name :[*c]const u8, value :[*c]const u8, flags :c.Cvar.Flags) callconv(.C) [*c]c.Cvar;
  extern fn Cvar_SetDescription (V :[*c]c.Cvar, descr :[*c]const u8) callconv(.C) void;
  extern fn Cvar_Set (name: [*c]const u8, value: [*c]const u8) callconv(.C) void;

  //______________________________________
  // @section TTY
  //____________________________
  const tty_err    = c_uint;
  const tty_Status = enum(c.tty_err) { enabled, disabled, err };
  extern fn Sys_ConsoleInputInit() callconv(.C) c.tty_Status;
  /// @note NoOp in any system that is not specifically linux-32bit
  extern fn Sys_ConfigureFPU() callconv(.C) void;

  //______________________________________
  // @section Logging
  //____________________________
  const errorParm_t = c_uint;
  const Error = enum(c.errorParm_t) { fatal, drop, serverDisconnect, disconnect, needCD, _ };
  extern fn Com_Error (level :c.Error, fmt: [*c]const u8, ...) callconv(.C) noreturn;
  extern fn Com_DPrintf (msg :[*c]const u8, ...) callconv(.C) void;
  extern fn Com_Printf (msg :[*c]const u8, ...) callconv(.C) void;

  //______________________________________
  // @section Core
  //____________________________
  extern fn Com_Init (commandLine :[*c]u8) callconv(.C) void;
  extern fn Com_Frame (noDelay :C.Bool) callconv(.C) void;

  //______________________________________
  // @section Network
  //____________________________
  extern fn NET_Init () callconv(.C) void;

  //______________________________________
  // @section Client
  //____________________________
  extern fn CL_NoDelay() callconv(.C) C.Bool;
}; //:: C.wrapper


//______________________________________
// @section System
//____________________________
pub const sys = struct {
  pub const milliseconds = c.Sys_Milliseconds;
  pub const pwd          = c.Sys_Pwd;
  pub const configureFPU = c.Sys_ConfigureFPU;
  pub const input        = struct {
    pub const update     = c.IN_Frame;
  };
}; //:: id3.C.sys

//______________________________________
// @section TTY
//____________________________
pub const tty = struct {
  pub const Status = c.tty_Status;
  pub const input = struct {
    pub const init = c.Sys_ConsoleInputInit;
  };
};


//______________________________________
// @section CLI
//____________________________
pub const cli = struct {
  pub const parse = struct {
    pub const early = c.Com_EarlyParseCmdLine;
  }; //:: id3.C.cli.parse
}; //:: id3.C.cli


//______________________________________
// @section Logging
//____________________________
pub const log = struct {
  pub const Error = c.Error;
  pub const err   = c.Com_Error;
  pub const dbg   = c.Com_DPrintf;
  pub const info  = c.Com_Printf; // TODO: Varargs with @call  https://stackoverflow.com/questions/72122366/how-to-initialize-variadic-function-arguments-in-zig
}; //:: id3.C.log


//______________________________________
// @section CVars
//___________________________
pub const Cvar = cvar.type;
pub const cvar = struct {
  pub const MaxLen   = c.MAX_CVAR_VALUE_STRING;
  pub const @"type"  = c.Cvar;
  pub const get      = c.Cvar_Get;
  pub const set      = c.Cvar_Set;
  pub const setDescr = c.Cvar_SetDescription;
}; //:: id3.C.cvar


//______________________________________
// @section Core
//____________________________
pub const core = struct {
  pub const init   = c.Com_Init;
  pub const update = c.Com_Frame;
}; //:: id3.C.core

//______________________________________
// @section Network
//____________________________
pub const net = struct {
  pub const init = c.NET_Init;
}; //:: id3.C.net

//______________________________________
// @section Client
//____________________________
pub const client = struct {
  pub const noDelay = c.CL_NoDelay;
}; //:: id3.C.client

