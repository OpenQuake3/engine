#:__________________________________________________________________
#  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv2 or later  :
#:__________________________________________________________________
# @deps ndk
import nstd/paths
import nstd/strings
import nstd/logger except info
import confy
from confy/convert import MakeInputs, MakeInput


#_______________________________________
# @section Engine Buildsystem Defaults
#_____________________________
const DefaultEngineName = Name(
  short : "oQ3",
  long  : "OpenQuake3",
  human : "Open Quake3 Engine"
  ) # << Name(... )
#___________________
const DefaultEngineVersion = version(0, 0, 0)


#_______________________________________
# @section Code Management tools
#_____________________________
func postprocess (content :string) :string=
  result = content.multiReplace(
    ("-Lcode/", "-Llib/idtech3/code/"),
    ("-Icode/", "-Ilib/idtech3/code/"),
    ) # << content.multiReplace( ... )


#_______________________________________
# @section Engine Management Tools
#_____________________________
proc download *(
    dir   : Path;
    url   : string;
    force : bool = false;
  ) :void=
  if not force and dirExists(dir): return  # Do nothing if the target engine folder exists
  info &"Downloading id-Tech3 from {url} into folder:  {dir}"
#_____________________________
proc patch *(
    dir   : Path;
    force : bool = false;
  ) :void=
  if not force and dirExists(dir): return  # Do nothing if the target engine folder exists
  info &"Patching id-Tech3 at folder:  {dir}"

#_______________________________________
# @section Run Make
#_____________________________
proc make *(target :MakeInput) :void=
  let cmd = &"make -j8 V=1 TARGET_NAME={target.name} "&target.key
  info &"Running make for target {{{target.name}_{target.dir}}} with command:\n  {cmd}"
  withDir target.root: sh cmd
proc make *(targets :MakeInputs) :void=
  for target in targets: make target

#_______________________________________
# @section Entry Point: Engine Buildsystem
#_____________________________
proc build *(
    rootDir : Path                 = getCurrentDir();
    binDir  : Path                 = getCurrentDir()/"bin";
    name    : Name                 = DefaultEngineName;
    systems : openArray[System]    = [confy.getHost()];
    modes   : openArray[BuildMode] = [Release];
    version : Version              = DefaultEngineVersion;
  ) :void=
  info &"""
Compiling {DefaultEngineName.human}:
  Name    : {name}
  Version : {version}
  Modes   : {modes}
  Systems : {systems}
"""
  # Dummy subfolders for the confy.make runner. Not used.
  const lnxDir = Path "lnx"
  const winDir = Path "win"
  const macDir = Path "mac_x64"
  const armDir = Path "mac_aarch64"
  # Mac compilers
  let CC_mac_x86 = &"\"{binDir}/.zig/zig cc -target x86_64-macos\"" #"x86_64-apple-darwin20.4-cc"
  let CC_mac_arm = &"\"{binDir}/.zig/zig cc -target aarch64-macos\"" #"aarch64-apple-darwin20.4-cc"
  # Option presets for each of the engine's build types
  let Config       = &"CNAME={name.short} DNAME={name.short}.server BUILD_DIR={binDir} "
  let RenderDyn    = Config&"BUILD_CLIENT=1 BUILD_SERVER=0 USE_RENDERER_DLOPEN=1 USE_VULKAN_API=1 USE_OPENGL_API=1 RENDERER_DEFAULT=opengl"
  let VulkanStatic = Config&"BUILD_CLIENT=1 BUILD_SERVER=0 USE_RENDERER_DLOPEN=0 RENDERER_DEFAULT=vulkan  USE_VULKAN=1 USE_VULKAN_API=1 USE_OPENGL=0 USE_OPENGL_API=0"
  let GL1Static    = Config&"BUILD_CLIENT=1 BUILD_SERVER=0 USE_RENDERER_DLOPEN=0 RENDERER_DEFAULT=opengl  USE_OPENGL=1 USE_OPENGL_API=1 USE_VULKAN=0 USE_VULKAN_API=0"
  let GL2Static    = Config&"BUILD_CLIENT=1 BUILD_SERVER=0 USE_RENDERER_DLOPEN=0 RENDERER_DEFAULT=opengl2 USE_OPENGL=1 USE_OPENGL_API=1 USE_VULKAN=0 USE_VULKAN_API=0"
  let ServerOnly   = Config&"BUILD_CLIENT=0 BUILD_SERVER=1 USE_RENDERER_DLOPEN=0"
  # Define the inputs for Make
  var targets :MakeInputs
  # Linux Debug
  if Debug   in modes and System( os: Linux,   cpu: x86_64 ) in systems: targets.add (name: "opengl1_dbg", dir: lnxDir, root: rootDir, key: "debug COMPILE_PLATFORM=linux " & GL1Static)
  if Debug   in modes and System( os: Linux,   cpu: x86_64 ) in systems: targets.add (name: "vulkan_dbg",  dir: lnxDir, root: rootDir, key: "debug COMPILE_PLATFORM=linux " & VulkanStatic)
  if Debug   in modes and System( os: Linux,   cpu: x86_64 ) in systems: targets.add (name: "rdyn_dbg",    dir: lnxDir, root: rootDir, key: "debug COMPILE_PLATFORM=linux " & RenderDyn)
  if Debug   in modes and System( os: Linux,   cpu: x86_64 ) in systems: targets.add (name: "server_dbg",  dir: lnxDir, root: rootDir, key: "debug COMPILE_PLATFORM=linux " & ServerOnly)
  # Mac.arm Debug
  if Debug   in modes and System( os: Mac,     cpu: arm64  ) in systems: targets.add (name: "opengl1_dbg", dir: armDir, root: rootDir, key: &"CC={CC_mac_arm} debug COMPILE_PLATFORM=darwin COMPILE_ARCH=aarch64 USE_LOCAL_HEADERS=1 " & GL1Static)
  if Debug   in modes and System( os: Mac,     cpu: arm64  ) in systems: targets.add (name: "vulkan_dbg",  dir: armDir, root: rootDir, key: &"CC={CC_mac_arm} debug COMPILE_PLATFORM=darwin COMPILE_ARCH=aarch64 USE_LOCAL_HEADERS=1 " & VulkanStatic)
  if Debug   in modes and System( os: Mac,     cpu: arm64  ) in systems: targets.add (name: "rdyn_dbg",    dir: armDir, root: rootDir, key: &"CC={CC_mac_arm} debug COMPILE_PLATFORM=darwin COMPILE_ARCH=aarch64 USE_LOCAL_HEADERS=1 " & RenderDyn)
  if Debug   in modes and System( os: Mac,     cpu: arm64  ) in systems: targets.add (name: "server_dbg",  dir: armDir, root: rootDir, key: &"CC={CC_mac_arm} debug COMPILE_PLATFORM=darwin COMPILE_ARCH=aarch64 USE_LOCAL_HEADERS=1 " & ServerOnly)
  # Mac.x86 Debug
  if Debug   in modes and System( os: Mac,     cpu: x86_64 ) in systems: targets.add (name: "opengl1_dbg", dir: macDir, root: rootDir, key: &"CC={CC_mac_x86} debug COMPILE_PLATFORM=darwin COMPILE_ARCH=x86_64 USE_LOCAL_HEADERS=1 " & GL1Static)
  if Debug   in modes and System( os: Mac,     cpu: x86_64 ) in systems: targets.add (name: "vulkan_dbg",  dir: macDir, root: rootDir, key: &"CC={CC_mac_x86} debug COMPILE_PLATFORM=darwin COMPILE_ARCH=x86_64 USE_LOCAL_HEADERS=1 " & VulkanStatic)
  if Debug   in modes and System( os: Mac,     cpu: x86_64 ) in systems: targets.add (name: "rdyn_dbg",    dir: macDir, root: rootDir, key: &"CC={CC_mac_x86} debug COMPILE_PLATFORM=darwin COMPILE_ARCH=x86_64 USE_LOCAL_HEADERS=1 " & RenderDyn)
  if Debug   in modes and System( os: Mac,     cpu: x86_64 ) in systems: targets.add (name: "server_dbg",  dir: macDir, root: rootDir, key: &"CC={CC_mac_x86} debug COMPILE_PLATFORM=darwin COMPILE_ARCH=x86_64 USE_LOCAL_HEADERS=1 " & ServerOnly)
  # Windows Debug
  if Debug   in modes and System( os: Windows, cpu: x86_64 ) in systems: targets.add (name: "vulkan_dbg",  dir: winDir, root: rootDir, key: "debug COMPILE_PLATFORM=mingw64 " & VulkanStatic)
  if Debug   in modes and System( os: Windows, cpu: x86_64 ) in systems: targets.add (name: "opengl1_dbg", dir: winDir, root: rootDir, key: "debug COMPILE_PLATFORM=mingw64 " & GL1Static)
  if Debug   in modes and System( os: Windows, cpu: x86_64 ) in systems: targets.add (name: "rdyn_dbg",    dir: winDir, root: rootDir, key: "debug COMPILE_PLATFORM=mingw64 " & RenderDyn)
  if Debug   in modes and System( os: Windows, cpu: x86_64 ) in systems: targets.add (name: "server_dbg",  dir: winDir, root: rootDir, key: "debug COMPILE_PLATFORM=mingw64 " & ServerOnly)
  # Linux Release
  if Release in modes and System( os: Linux,   cpu: x86_64 ) in systems: targets.add (name: "opengl1_rls", dir: lnxDir, root: rootDir, key: "release COMPILE_PLATFORM=linux " & GL1Static)
  if Release in modes and System( os: Linux,   cpu: x86_64 ) in systems: targets.add (name: "vulkan_rls",  dir: lnxDir, root: rootDir, key: "release COMPILE_PLATFORM=linux " & VulkanStatic)
  if Release in modes and System( os: Linux,   cpu: x86_64 ) in systems: targets.add (name: "rdyn_rls",    dir: lnxDir, root: rootDir, key: "release COMPILE_PLATFORM=linux " & RenderDyn)
  if Release in modes and System( os: Linux,   cpu: x86_64 ) in systems: targets.add (name: "server_rls",  dir: lnxDir, root: rootDir, key: "release COMPILE_PLATFORM=linux " & ServerOnly)
  # Mac.arm Release
  if Release in modes and System( os: Mac,     cpu: arm64  ) in systems: targets.add (name: "opengl1_rls", dir: armDir, root: rootDir, key: &"CC={CC_mac_arm} release COMPILE_PLATFORM=darwin COMPILE_ARCH=aarch64 USE_LOCAL_HEADERS=1 " & GL1Static)
  if Release in modes and System( os: Mac,     cpu: arm64  ) in systems: targets.add (name: "vulkan_rls",  dir: armDir, root: rootDir, key: &"CC={CC_mac_arm} release COMPILE_PLATFORM=darwin COMPILE_ARCH=aarch64 USE_LOCAL_HEADERS=1 " & VulkanStatic)
  if Release in modes and System( os: Mac,     cpu: arm64  ) in systems: targets.add (name: "rdyn_rls",    dir: armDir, root: rootDir, key: &"CC={CC_mac_arm} release COMPILE_PLATFORM=darwin COMPILE_ARCH=aarch64 USE_LOCAL_HEADERS=1 " & RenderDyn)
  if Release in modes and System( os: Mac,     cpu: arm64  ) in systems: targets.add (name: "server_rls",  dir: armDir, root: rootDir, key: &"CC={CC_mac_arm} release COMPILE_PLATFORM=darwin COMPILE_ARCH=aarch64 USE_LOCAL_HEADERS=1 " & ServerOnly)
  # Mac.x86 Release
  if Release in modes and System( os: Mac,     cpu: x86_64 ) in systems: targets.add (name: "opengl1_rls", dir: macDir, root: rootDir, key: &"CC={CC_mac_x86} release COMPILE_PLATFORM=darwin COMPILE_ARCH=x86_64 USE_LOCAL_HEADERS=1 " & GL1Static)
  if Release in modes and System( os: Mac,     cpu: x86_64 ) in systems: targets.add (name: "vulkan_rls",  dir: macDir, root: rootDir, key: &"CC={CC_mac_x86} release COMPILE_PLATFORM=darwin COMPILE_ARCH=x86_64 USE_LOCAL_HEADERS=1 " & VulkanStatic)
  if Release in modes and System( os: Mac,     cpu: x86_64 ) in systems: targets.add (name: "rdyn_rls",    dir: macDir, root: rootDir, key: &"CC={CC_mac_x86} release COMPILE_PLATFORM=darwin COMPILE_ARCH=x86_64 USE_LOCAL_HEADERS=1 " & RenderDyn)
  if Release in modes and System( os: Mac,     cpu: x86_64 ) in systems: targets.add (name: "server_rls",  dir: macDir, root: rootDir, key: &"CC={CC_mac_x86} release COMPILE_PLATFORM=darwin COMPILE_ARCH=x86_64 USE_LOCAL_HEADERS=1 " & ServerOnly)
  # Windows Release
  if Release in modes and System( os: Windows, cpu: x86_64 ) in systems: targets.add (name: "opengl1_rls", dir: winDir, root: rootDir, key: "release COMPILE_PLATFORM=mingw64 " & GL1Static)
  if Release in modes and System( os: Windows, cpu: x86_64 ) in systems: targets.add (name: "vulkan_rls",  dir: winDir, root: rootDir, key: "release COMPILE_PLATFORM=mingw64 " & VulkanStatic)
  if Release in modes and System( os: Windows, cpu: x86_64 ) in systems: targets.add (name: "rdyn_rls",    dir: winDir, root: rootDir, key: "release COMPILE_PLATFORM=mingw64 " & RenderDyn)
  if Release in modes and System( os: Windows, cpu: x86_64 ) in systems: targets.add (name: "server_rls",  dir: winDir, root: rootDir, key: "release COMPILE_PLATFORM=mingw64 " & ServerOnly)

  # Build the targets
  make targets

