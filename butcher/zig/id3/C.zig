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
  extern fn Sys_Error (err :[*c]const u8, ...) noreturn;
  extern fn Sys_Pwd () callconv(.C) [*c]const u8;
  extern fn IN_Frame () callconv(.C) void;
  extern fn Sys_Init () callconv(.C) void;
  //____________________________
  // @section System: CPU
  extern fn Sys_GetProcessorId (vendor :[*c]u8) callconv(.C) void;
  extern fn Sys_GetAffinityMask () callconv(.C) u64;
  extern fn DetectCPUCoresConfig () callconv(.C) void;
  extern fn Com_SetAffinityMask (str :[*c]const u8) callconv(.C) void;
  //____________________________
  // @section System: Console
  extern fn Sys_ShowConsole (level :c_int, quitOnClose :C.Bool) callconv(.C) void;

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
  extern fn Com_ParseCommandLine (arg_commandLine :[*c]u8) callconv(.C) void;

  //______________________________________
  // @section CVars
  //____________________________
  const MAX_CVAR_VALUE_STRING :usize= 256;
  const cvarValidator_t = c_uint;
  const cvarGroup_t     = c_uint;
  const cvarFlags_t     = c_uint;
  const Cvar = extern struct {
    name              :[*c]u8       = @import("std").mem.zeroes([*c]u8),
    string            :[*c]u8       = @import("std").mem.zeroes([*c]u8),
    resetString       :[*c]u8       = @import("std").mem.zeroes([*c]u8),
    latchedString     :[*c]u8       = @import("std").mem.zeroes([*c]u8),
    flags             :c.Cvar.Flags = .{},
    modified          :C.Bool       = @import("std").mem.zeroes(C.Bool),
    modificationCount :c_int        = @import("std").mem.zeroes(c_int),
    value             :f32          = @import("std").mem.zeroes(f32),
    integer           :c_int        = @import("std").mem.zeroes(c_int),
    validator         :c.Cvar.Type  = @import("std").mem.zeroes(c.Cvar.Type),
    mins              :[*c]u8       = @import("std").mem.zeroes([*c]u8),
    maxs              :[*c]u8       = @import("std").mem.zeroes([*c]u8),
    description       :[*c]u8       = @import("std").mem.zeroes([*c]u8),
    next              :[*c]c.Cvar   = @import("std").mem.zeroes([*c]c.Cvar),
    prev              :[*c]c.Cvar   = @import("std").mem.zeroes([*c]c.Cvar),
    hashNext          :[*c]c.Cvar   = @import("std").mem.zeroes([*c]c.Cvar),
    hashPrev          :[*c]c.Cvar   = @import("std").mem.zeroes([*c]c.Cvar),
    hashIndex         :c_int        = @import("std").mem.zeroes(c_int),
    group             :c.Cvar.Group = @import("std").mem.zeroes(c.Cvar.Group),
    pub const Type  = enum(cvarValidator_t) { none, float, integer, fspath, max, _, };
    pub const Group = enum(cvarGroup_t) { none, renderer, server, max, _, };
    pub const Flags = packed struct {
      /// @descr Set to cause it to be saved to vars.rc. Used for system variables, not for player specific configurations
      archive         :bool = false,  // 00 :: #define CVAR_ARCHIVE         0x0001
      /// @descr Sent to server on connect or change
      info_user       :bool = false,  // 01 :: #define CVAR_USERINFO        0x0002
      /// @descr Sent in response to front end requests
      info_server     :bool = false,  // 02 :: #define CVAR_SERVERINFO      0x0004
      /// @descr These cvars will be duplicated on all clients
      info_system     :bool = false,  // 03 :: #define CVAR_SYSTEMINFO      0x0008
      /// @descr Don't allow change from console at all, but can be set from the command line
      init            :bool = false,  // 04 :: #define CVAR_INIT            0x0010
      /// @descr
      ///  Will only change when C code next does a Cvar_Get(), so it can't be changed without proper initialization.
      ///  Modified will be set, even though the value hasn't changed yet
      latch           :bool = false,  // 05 :: #define CVAR_LATCH           0x0020
      /// @descr Display only, cannot be set by user at all
      rom             :bool = false,  // 06 :: #define CVAR_ROM             0x0040 
      /// @descr Created by a set command
      created_user    :bool = false,  // 07 :: #define CVAR_USER_CREATED    0x0080
      /// @descr Can be set even when cheats are disabled, but is not archived
      temp            :bool = false,  // 08 :: #define CVAR_TEMP            0x0100
      /// @descr Can not be changed if cheats are disabled
      cheat           :bool = false,  // 09 :: #define CVAR_CHEAT           0x0200
      /// @descr Do not clear when a cvar_restart is issued
      noRestart       :bool = false,  // 10 :: #define CVAR_NORESTART       0x0400
      /// @descr Cvar was created by a server that the client connected to.
      created_server  :bool = false,  // 11 :: #define CVAR_SERVER_CREATED  0x0800
      /// @descr Cvar was created exclusively in one of the VMs.
      created_VM      :bool = false,  // 12 :: #define CVAR_VM_CREATED      0x1000
      /// @descr Prevent modifying this var from VMs or the server
      protected       :bool = false,  // 13 :: #define CVAR_PROTECTED       0x2000
      /// @descr Do not write to config if matching with default value
      noDefault       :bool = false,  // 14 :: #define CVAR_NODEFAULT       0x4000
      /// @descr Can't be read from VM
      private         :bool = false,  // 15 :: #define CVAR_PRIVATE         0x8000
      /// @descr Can be set only in developer mode
      developer       :bool = false,  // 16 :: #define CVAR_DEVELOPER       0x10000
      /// @descr No tab completion in console
      noTabComplete   :bool = false,  // 17 :: #define CVAR_NOTABCOMPLETE   0x20000
      __unused_bits_18_29 :u12=0,
      /// @descr Cvar was modified.  Only returned by the Cvar_Flags() function
      modified        :bool = false,  // 30 :: #define CVAR_MODIFIED        0x40000000
      // @descr Cvar doesn't exist.  Only returned by the Cvar_Flags() function
      nonExistent     :bool = false,  // 31 :: #define CVAR_NONEXISTENT     0x80000000

      pub usingnamespace zstd.Flags(@This(), cvarFlags_t);
      pub const archive_ND :@This()= .{.archive=true, .noDefault=true };  // #define CVAR_ARCHIVE_ND (CVAR_ARCHIVE | CVAR_NODEFAULT)
    }; //:: id3.C.Cvar.Flags
  }; //:: id3.C.Cvar
  extern fn Cvar_Get (
      name  : [*c]const u8,
      value : [*c]const u8,
      flags : c.Cvar.Flags
    ) callconv(.C) [*c]c.Cvar;
  extern fn Cvar_SetDescription (V :[*c]c.Cvar, descr :[*c]const u8) callconv(.C) void;
  extern fn Cvar_Set (name: [*c]const u8, value: [*c]const u8) callconv(.C) void;
  extern fn Cvar_Init () callconv(.C) void;
  extern fn Com_StartupVariable (match :[*c]const u8) void;
  extern fn Cvar_CheckRange(
      cv  : [*c]c.Cvar,
      min : [*c]const u8,
      max : [*c]const u8,
      typ : c.Cvar.Type,
    ) callconv(.C) void;

  //______________________________________
  // @section TUI
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
  extern fn Com_InitJournaling () callconv(.C) void;

  //______________________________________
  // @section Filesystem
  //____________________________
  extern fn FS_InitFilesystem () callconv(.C) void;

  //______________________________________
  // @section Configuration File
  //____________________________
  extern fn Com_ExecuteCfg () callconv(.C) void;

  //______________________________________
  // @section Virtual Machine
  //____________________________
  extern fn VM_Init () callconv(.C) void;

  //______________________________________
  // @section Core
  //____________________________
  extern fn Com_Init (commandLine :[*c]u8) callconv(.C) void;
  extern fn Com_Frame (noDelay :C.Bool) callconv(.C) void;

  //______________________________________
  // @section Events Manager
  //____________________________
  extern fn Com_InitPushEvent () callconv(.C) void;

  //______________________________________
  // @section Commands
  //____________________________
  extern fn Cbuf_Init () callconv(.C) void;
  extern fn Cmd_Init () callconv(.C) void;
  extern fn Com_InitKeyCommands () callconv(.C) void;
  const CommandFn = ?*const fn () callconv(.C) void;
  extern fn Cmd_AddCommand(name: [*c]const u8, function: CommandFn) callconv(.C) void;
  const CompletionFn = ?*const fn (args :[*c]const u8, argNum :c_int) callconv(.C) void;
  extern fn Cmd_SetCommandCompletionFunc (command :[*c]const u8, complete :CompletionFn) void;
  //______________________________________
  // Command: Functions
  extern fn Com_Error_f               () callconv(.C) void;
  extern fn Com_Crash_f               () callconv(.C) void;
  extern fn Com_Freeze_f              () callconv(.C) void;
  extern fn Com_Quit_f                () callconv(.C) void;
  extern fn MSG_ReportChangeVectors_f () callconv(.C) void;
  extern fn Com_WriteConfig_f         () callconv(.C) void;
  extern fn Com_GameRestart_f         () callconv(.C) void;
  //______________________________________
  // Command Completion: Functions
  extern fn Cmd_CompleteWriteCfgName (args :[*c]const u8, argNum :c_int) callconv(.C) void;

  //______________________________________
  // @section Network
  //____________________________
  extern fn NET_Init () callconv(.C) void;
  extern fn Netchan_Init (port :c_int) callconv(.C) void;

  //______________________________________
  // @section Client
  //____________________________
  extern fn CL_NoDelay () callconv(.C) C.Bool;
  extern fn CL_Init () callconv(.C) void;
  extern fn CL_StartHunkUsers () callconv(.C) void;

  //______________________________________
  // @section Server
  //____________________________
  extern fn SV_Init () callconv(.C) void;

  //______________________________________
  // @section Memory
  //____________________________
  extern fn Com_InitSmallZoneMemory () callconv(.C) void;
  extern fn Com_InitZoneMemory () callconv(.C) void;
  extern fn Com_InitHunkMemory () callconv(.C) void;

  //______________________________________
  // @section Math
  //____________________________
  //...
  //____________________________
  // @section Math: Random
  extern fn Com_RandomBytes (string :[*c]const u8, len :c_int) callconv(.C) void;
}; //:: C.wrapper


//______________________________________
// @section System
//____________________________
pub const sys = struct {
  pub const milliseconds  = c.Sys_Milliseconds;
  pub const pwd           = c.Sys_Pwd;
  pub const configureFPU  = c.Sys_ConfigureFPU;
  pub const err           = c.Sys_Error;
  pub const init          = c.Sys_Init;
  pub const input         = struct {
    pub const update      = c.IN_Frame;
  }; //:: id3.C.sys.input
  pub const cpu           = struct {
    pub const getID       = c.Sys_GetProcessorId;
    pub const getMask     = c.Sys_GetAffinityMask;
    pub const detectCfg   = c.DetectCPUCoresConfig;
    pub const setAffinity = c.Com_SetAffinityMask;
  }; //:: id3.C.sys.cpu
}; //:: id3.C.sys

//______________________________________
// @section TTY
//____________________________
pub const tui = struct {
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
    pub const args  = c.Com_ParseCommandLine;
  }; //:: id3.C.cli.parse
}; //:: id3.C.cli


//______________________________________
// @section Logging
//____________________________
pub const log       = struct {
  pub const Error   = c.Error;
  pub const err     = c.Com_Error;
  pub const dbg     = c.Com_DPrintf;
  pub const info    = c.Com_Printf; // TODO: Varargs with @call  https://stackoverflow.com/questions/72122366/how-to-initialize-variadic-function-arguments-in-zig
  pub const journal = struct {
    pub const init  = c.Com_InitJournaling;
  }; //:: id3.C.log.journal
}; //:: id3.C.log


//______________________________________
// @section Filesystem
//____________________________
pub const fs         = C.filesystem;
pub const filesystem = struct {
  pub const init = c.FS_InitFilesystem;
}; //:: id3.C.fs


//______________________________________
// @section Configuration File
//____________________________
pub const cfg = C.configuration;
pub const configuration = struct {
  pub const exec = c.Com_ExecuteCfg;
}; //:: id3.C.cfg


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
  pub const init     = c.Cvar_Init;
  pub const startup  = c.Com_StartupVariable;
  pub const range    = struct {
    pub const check  = c.Cvar_CheckRange;
  }; //:: id3.C.cvar.range
}; //:: id3.C.cvar


//______________________________________
// @section Core
//____________________________
pub const core     = struct {
  pub const init   = c.Com_Init;
  pub const update = c.Com_Frame;
}; //:: id3.C.core


//______________________________________
// @section Events Manager
//____________________________
pub const ev       = C.event;
pub const event    = struct {
  pub const push   = struct {
    pub const init = c.Com_InitPushEvent;
  }; //:: id3.C.event.push
}; //:: id3.C.event


//______________________________________
// @section Commands
//____________________________
pub const cmd             = C.command;
pub const command         = struct {
  pub const init          = c.Cmd_Init;
  pub const add           = c.Cmd_AddCommand;
  pub const buffer        = struct {
    pub const init        = c.Cbuf_Init;
  }; //:: id3.C.cmd.buffer
  pub const input         = struct {
    pub const init        = c.Com_InitKeyCommands;
  }; //:: id3.C.cmd.input
  pub const Fn            = struct {
    pub const Error       = c.Com_Error_f;
    pub const crash       = c.Com_Crash_f;
    pub const freeze      = c.Com_Freeze_f;
    pub const quit        = c.Com_Quit_f;
    pub const report      = struct {
      pub const changeVec = c.MSG_ReportChangeVectors_f ;
    }; //:: id3.C.cmd.Fn.report
    pub const cfg         = struct {
      pub const write     = c.Com_WriteConfig_f;
    }; //:: id3.C.cmd.Fn.cfg
    pub const game        = struct {
      pub const restart   = c.Com_GameRestart_f;
    }; //:: id3.C.cmd.Fn.game
  }; //:: id3.C.cmd.Fn
  pub const completion    = struct {
    pub const setFn       = c.Cmd_SetCommandCompletionFunc;
    pub const Fn          = struct {
      pub const cfg       = struct {
        pub const write   = c.Cmd_CompleteWriteCfgName;
      }; //:: id3.C.cmd.completion.Fn.cfg
    }; //:: id3.C.cmd.completion.Fn
  }; //:: id3.C.cmd.completion
}; //:: id3.C.cmd


//______________________________________
// @section Network
//____________________________
pub const net        = C.networking;
pub const networking = struct {
  pub const init     = c.NET_Init;
  pub const channel  = C.networking.chan;
  pub const chan     = struct {
    pub const init   = c.Netchan_Init;
  }; //:: id3.C.net.chan
}; //:: id3.C.net


//______________________________________
// @section Client
//____________________________
pub const client = struct {
  pub const noDelay = c.CL_NoDelay;
  pub const init    = c.CL_Init;
  pub const start   = c.CL_StartHunkUsers;
}; //:: id3.C.client


//______________________________________
// @section Server
//____________________________
pub const server = struct {
  pub const init = c.SV_Init;
}; //:: id3.C.server


//______________________________________
// @section Memory
//____________________________
pub const mem        = C.memory;
pub const memory     = struct {
  pub const zone     = struct {
    pub const init   = c.Com_InitZoneMemory;
    pub const small  = struct {
      pub const init = c.Com_InitSmallZoneMemory;
    }; //:: id3.C.mem.zone.small
  }; //:: id3.C.mem.zone
  pub const hunk     = struct {
    pub const init   = c.Com_InitHunkMemory;
  }; //:: id3.C.mem.hunk
}; //:: id3.C.mem


//______________________________________
// @section Math
//____________________________
pub const math = struct {
  pub const random = struct {
    pub const bytes = c.Com_RandomBytes;
  }; //:: id3.C.math.random
}; //:: id3.C.math


//______________________________________
// @section VM
//____________________________
pub const vm     = struct {
  pub const init = c.VM_Init;
}; //:: id3.C.vm


//______________________________________
// @section Console
//____________________________
pub const con      = struct {
  pub const sys    = struct {
    pub const show = c.Sys_ShowConsole;
  }; //:: id3.C.con.sys
}; //:: id3.C.con

