#!/bin/bash
set -eu
ROOT_DIR="$(pwd)"
IDTECH3_DIR="$ROOT_DIR/src/lib/idtech3"
ENGINE_PATCHES="$ROOT_DIR/src/build/patches"
BUTCHER_PATCHES="$ROOT_DIR/butcher/patches"

# Remove and re-clone idtech3
rm -rf "$IDTECH3_DIR"
git submodule update --init src/lib/idtech3

# Apply patches from idtech3 submodule dir
cd "$IDTECH3_DIR"

#______________________________________
# Engine patches (src/build/patches)
# Created for oDFe, need validation against Quake3e
#____________________________

# unix
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/unix/unix_main.c.lib.patch"
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/unix/unix_main.c.state.tty.patch"

# qcommon
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/qcommon/q_shared.h.configurable.patch"
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/qcommon/common.c.state.jmp.patch"
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/qcommon/common.c.state.affinityMasks.patch"
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/qcommon/common.c.state.cvars.com.patch"
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/qcommon/common.c.Fn.Cmd.Crash.patch"
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/qcommon/common.c.Fn.Cmd.Error.patch"
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/qcommon/common.c.Fn.Cmd.Freeze.patch"
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/qcommon/common.c.Fn.Cmd.Restart.patch"
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/qcommon/common.c.Fn.Cmd.WriteConfig.patch"
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/qcommon/common.c.Fn.DetectCPUCoresConfig.patch"
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/qcommon/common.c.Fn.ExecuteCfg.patch"
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/qcommon/common.c.Fn.GetProcessorId.patch"
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/qcommon/common.c.Fn.InitHunkMemory.patch"
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/qcommon/common.c.Fn.InitJournaling.patch"
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/qcommon/common.c.Fn.InitPushEvent.patch"
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/qcommon/common.c.Fn.InitSmallZoneMemory.patch"
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/qcommon/common.c.Fn.InitZoneMemory.patch"
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/qcommon/common.c.Fn.ParseCommandLine.patch"
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/qcommon/common.c.Fn.SetAffinityMask.patch"
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/qcommon/vm.c.native_libs.patch"

# client
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/client/cl_main.c.ranger.patch"
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/client/snd_mix.c.simd.patch"
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/client/snd_mix.c.sse_underscore.patch"

# server
# wiggle --merge --replace -p1 "$ENGINE_PATCHES/server/sv_init.c.sv_pure.patch"


#______________________________________
# Butcher patches (butcher/patches)
# Implement desirable changes from oDFe into Quake3e
# Need full validation before enabling.
#____________________________

# wiggle --merge --replace -p1 "$BUTCHER_PATCHES/console.patch"
# wiggle --merge --replace -p1 "$BUTCHER_PATCHES/download-support.patch"
# wiggle --merge --replace -p1 "$BUTCHER_PATCHES/input.patch"
# wiggle --merge --replace -p1 "$BUTCHER_PATCHES/tc-vis.patch"
# wiggle --merge --replace -p1 "$BUTCHER_PATCHES/ui.patch"

# defaults
# wiggle --merge --replace -p1 "$BUTCHER_PATCHES/defaults/skip-intro.patch"

# defrag
# wiggle --merge --replace -p1 "$BUTCHER_PATCHES/defrag/colors.patch"
# wiggle --merge --replace -p1 "$BUTCHER_PATCHES/defrag/cvars.patch"
# wiggle --merge --replace -p1 "$BUTCHER_PATCHES/defrag/defaults.patch"
# wiggle --merge --replace -p1 "$BUTCHER_PATCHES/defrag/dfstatus.patch"
# wiggle --merge --replace -p1 "$BUTCHER_PATCHES/defrag/engine-name.patch"
# wiggle --merge --replace -p1 "$BUTCHER_PATCHES/defrag/modes.patch"

# filesystem
# wiggle --merge --replace -p1 "$BUTCHER_PATCHES/filesystem/no-fatal-baseq3.patch"

# networking
# wiggle --merge --replace -p1 "$BUTCHER_PATCHES/networking/protocol-prefix.patch"

# renderer
# wiggle --merge --replace -p1 "$BUTCHER_PATCHES/renderer/shader-warning.patch"
# wiggle --merge --replace -p1 "$BUTCHER_PATCHES/renderer/tga-warning.patch"

# sound
# wiggle --merge --replace -p1 "$BUTCHER_PATCHES/sound/missing-sounds.patch"

# win32
# wiggle --merge --replace -p1 "$BUTCHER_PATCHES/win32/viewlog-style.patch"
