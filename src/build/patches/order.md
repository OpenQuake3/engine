# Static Library
./unix/unix_main.c.lib.patch                     ;;  Allow compilation as a static library

# Buildsystem Helpers
./client/snd_mix.c.simd.patch                    ;;  Allow snd SIMD configuration from the buildsystem
./qcommon/q_shared.h.configurable.patch          ;;  Allow configuring Version and DefaultGame from the buildsystem

# Global State
./unix/unix_main.c.state.tty.patch               ;;  Expose GlobalState tty to Zig
./qcommon/common.c.state.jmp.patch               ;;  Expose GlobalState jmp to Zig

# Internal Functions
./qcommon/common.c.Fn.InitPushEvent.patch        ;;  Expose InternalFunction Com_InitPushEvent to Zig
./qcommon/common.c.Fn.InitSmallZoneMemory.patch  ;;  Expose InternalFunction Com_InitSmallZoneMemory to Zig
./qcommon/common.c.Fn.InitZoneMemory.patch       ;;  Expose InternalFunction Com_InitZoneMemory to Zig
./qcommon/common.c.Fn.InitHunkMemory.patch       ;;  Expose InternalFunction Com_InitHunkMemory to Zig
./qcommon/common.c.Fn.ParseCommandLine.patch     ;;  Expose InternalFunction Com_ParseCommandLine to Zig

# Configuration: Modern Defaults

# Configuration: Quality of Life
./client/cl_main.c.ranger.patch                  ;;  Change default player model to ranger (default: sarge)

