//:________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GPL-3.0-or-later  :
//:________________________________________________________________
pub const flags = @This();
// @deps std
const std = @import("std");
// @deps buildsystem
const confy = @import("confy");
// @deps config
const cfg = @import("./cfg.zig");


//______________________________________
// @section Flag Aliases
//____________________________
const base = flags.all;


//______________________________________
// @section Common Flags: Optimization
//____________________________
const optimization = struct {
  const debug   = &[_]confy.cstring{ "-g", "-O0", "-DDEBUG", "-D_DEBUG" };
  const release = &[_]confy.cstring{ "-O2", "-flto", "-DNDEBUG", }; // TODO: Release optimization flags
};


//______________________________________
// @section Common Flags: (BASE_CFLAGS + LDFLAGS)
//____________________________
const platform = struct {
  const shared = &[_]confy.cstring{
    "-fvisibility=hidden",
    "-ldl",
  };
  //__________________
  const gnu = &[_]confy.cstring{
    "-D_GNU_SOURCE",
    "-Wl,--gc-sections",
  };
  //__________________
  const unix = &[_]confy.cstring{
    "-pipe",
  };
  //__________________
  const linux = &[_]confy.cstring{
    "-DUSE_ICON",
    "-lm",
    "-Wl,--hash-style=both",
  };
  //__________________
  const macos = &[_]confy.cstring{
    "-DMACOS_X",
  };
  //__________________
  const win32 = &[_]confy.cstring{
    "-DUSE_ICON",
    "-DMINGW=1",
    "-DCURL_STATICLIB",
    "-DPCRE2_STATIC",
    "-DUSE_LOCAL_HEADERS=1",
    "-ffunction-sections",
    "-mwindows",
    "-Wl,--dynamicbase",
    "-Wl,--nxcompat",
    "-lwsock32",
    "-lgdi32",
    "-lwinmm",
    "-lole32",
    "-lws2_32",
    "-lpsapi",
    "-lcomctl32",
  };
};


//______________________________________
// @section Engine Flags: Server
//____________________________
const names = &[_]confy.cstring{
  std.fmt.comptimePrint("-DQ3_VERSION=\"{s} {s}\"", .{cfg.name.human, cfg.info.version}),
  std.fmt.comptimePrint("-DENGINE_NAME=\"{s}\"",    .{cfg.name.human}),
};

pub const server = struct {
  const shared = flags.base ++ platform.shared ++ flags.names ++ [_]confy.cstring{
    // Defines
    "-DDEDICATED",
    "-DBOTLIB",
    // TODO: Includes
    // TODO: Exceptions
  };
  //__________________
  const os = struct {
    const linux = platform.unix  ++ platform.linux ++ platform.gnu;
    const macos = platform.unix  ++ platform.macos;
    const win32 = platform.win32 ++ platform.gnu;
  };
  //__________________
  const debug = struct {
    const linux = shared ++ optimization.debug ++ os.linux;
    const macos = shared ++ optimization.debug ++ os.macos;
    const win32 = shared ++ optimization.debug ++ os.win32;
    const other = shared ++ optimization.debug;
  };
  const rel = struct {
    const linux = shared ++ optimization.release ++ os.linux;
    const macos = shared ++ optimization.release ++ os.macos;
    const win32 = shared ++ optimization.release ++ os.win32;
    const other = shared ++ optimization.release;
  };
  //__________________
  pub fn all (system :confy.System, release :bool) confy.cstring_List { return switch (system.os) {
    .linux   => if (release) rel.linux else debug.linux,
    .macos   => if (release) rel.macos else debug.macos,
    .windows => if (release) rel.win32 else debug.win32,
    else     => if (release) rel.other else debug.other,
  };}
}; //:: build.engine.flags.server


//______________________________________
// @section Engine Flags: Client
//____________________________
pub const client = struct {
  const This = @This();
  //__________________
  const shared = flags.base ++ platform.shared ++ names ++ &[_]confy.cstring{
    // Warnings/Errors
    // "-MMD",
    // "-Wall",
    // "-Wimplicit",
    // "-Wstrict-prototypes",
    // "-Wno-unused-result",
    // Defines
    "-DUSE_CURL",
    "-DUSE_PCRE2",
    "-DUSE_OPENGL_API",
    "-DUSE_OGG_VORBIS",
    // Includes
    "-I./bin/.lib/idtech3/code/libogg/include",
    "-I./bin/.lib/idtech3/code/libvorbis/include",
    "-I./bin/.lib/idtech3/code/libvorbis/lib",
    // Exceptions
    "-fno-fast-math",       // NOTE: Only for vm_* files, but we add it for all
    "-DBOTLIB",             // NOTE: Only for botlib/* files, but we add it for all
    // Linker Flags
    "-lSDL2",
    "-lpcre2-8",
  };
  //__________________
  const unix = &[_]confy.cstring{
    "-DUSE_CURL_DLOPEN",
  };
  //__________________
  const linux = &[_]confy.cstring{
    // "-I/usr/include",
    "-I/usr/local/include",
    "-I/usr/include/SDL2",
    "-rdynamic",
  };
  //__________________
  const macos = &[_]confy.cstring{
    "-I/Library/Frameworks/SDL2.framework/Headers",
    "-F/Library/Frameworks",
    "-framework", "SDL2",
  };
  //__________________
  const win32 = &[_]confy.cstring{
    "-lcurl",
    "-lz",
    "-lcrypt32",
  };
  //__________________
  const os = struct {
    const linux = platform.unix  ++ This.unix ++ platform.linux ++ platform.gnu ++ This.linux;
    const macos = platform.unix  ++ This.unix ++ platform.macos ++ This.macos;
    const win32 = platform.win32 ++ platform.gnu ++ This.win32;
  };
  //__________________
  const debug = struct {
    const linux = This.shared ++ optimization.debug ++ os.linux;
    const macos = This.shared ++ optimization.debug ++ os.macos;
    const win32 = This.shared ++ optimization.debug ++ os.win32;
    const other = This.shared ++ optimization.debug;
  };
  const rel = struct {
    const linux = This.shared ++ optimization.release ++ os.linux;
    const macos = This.shared ++ optimization.release ++ os.macos;
    const win32 = This.shared ++ optimization.release ++ os.win32;
    const other = This.shared ++ optimization.release;
  };
  //__________________
  pub fn all (system :confy.System, release :bool) confy.cstring_List { return switch (system.os) {
    .linux   => if (release) rel.linux else debug.linux,
    .macos   => if (release) rel.macos else debug.macos,
    .windows => if (release) rel.win32 else debug.win32,
    else     => if (release) rel.other else debug.other,
  };}
}; //:: build.engine.flags.client



pub const all = confy.flags.default(.c) ++ flags.unsafe;
const unsafe = &[_]confy.cstring{
  "-std=c99",
  // Explicitly disable the warnings that the codebase does not respect.
  // Ideally this list should be completely empty, but that's a lot of work fixing old code.
  "-Wno-alloca",
  "-Wno-pedantic",
  "-Wno-strict-prototypes",
  "-Wno-shadow",
  "-Wno-undef",
  "-Wno-conditional-uninitialized",
  "-Wno-cast-qual",
  "-Wno-cast-align",
  "-Wno-cast-function-type-strict",
  "-Wno-bad-function-cast",
  "-Wno-implicit-void-ptr-cast",
  "-Wno-implicit-int-enum-cast",  // C enums are ints
  "-Wno-double-promotion",
  "-Wno-float-conversion",
  "-Wno-enum-float-conversion",
  "-Wno-bitfield-enum-conversion",
  "-Wno-int-conversion",
  "-Wno-sign-conversion",
  "-Wno-sign-compare",
  "-Wno-implicit-float-conversion",
  "-Wno-implicit-int-conversion",
  "-Wno-implicit-int-float-conversion",
  "-Wno-implicit-function-declaration",
  "-Wno-shorten-64-to-32",
  "-Wno-shift-sign-overflow",
  "-Wno-float-equal",
  "-Wno-overlength-strings",
  "-Wno-tautological-unsigned-zero-compare",
  "-Wno-tautological-pointer-compare",
  "-Wno-missing-field-initializers",
  "-Wno-missing-variable-declarations",
  "-Wno-missing-noreturn",
  "-Wno-incompatible-pointer-types-discards-qualifiers",
  "-Wno-unreachable-code",
  "-Wno-unreachable-code-loop-increment",
  "-Wno-unreachable-code-break",
  "-Wno-unreachable-code-return",
  "-Wno-invalid-noreturn",
  "-Wno-nrvo",
  "-Wno-implicit-fallthrough",
  "-Wno-switch",
  "-Wno-switch-default",
  "-Wno-switch-enum",
  "-Wno-assign-enum",
  "-Wno-unsafe-buffer-usage",
  "-Wno-padded",
  "-Wno-format",
  "-Wno-format-nonliteral",
  "-Wno-comma",
  "-Wno-extra-semi",
  "-Wno-extra-semi-stmt",
  "-Wno-ignored-qualifiers",
  "-Wno-pre-c11-compat",
  "-Wno-pre-c23-compat",
  "-Wno-c11-extensions",
  "-Wno-typedef-redefinition",
  "-Wno-missing-prototypes",
  "-Wno-unused-parameter",
  "-Wno-unused-variable",
  "-Wno-unused-macros",
  "-Wno-unused-function",
  "-Wno-used-but-marked-unused",
  "-Wno-unused-but-set-variable",
  "-Wno-unused-command-line-argument",
  "-Wno-disabled-macro-expansion",
  "-Wno-keyword-macro",
  "-Wno-macro-redefined",
  "-Wno-reserved-macro-identifier",
  "-Wno-reserved-identifier",
  "-Wno-redundant-parens",
  "-Wno-empty-translation-unit",
  "-Wno-date-time",
  "-Wno-documentation-unknown-command",
  "-Wno-documentation",
  "-fno-sanitize=all",
};

