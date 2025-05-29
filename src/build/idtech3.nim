#:__________________________________________________________________
#  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
##! @fileoverview Tools to compile id-Tech3 as a Static Library
#_______________________________________________________________|
# @deps ndk
from nstd/defines import nil
# @deps buildsystem
import confy except cfg


#_______________________________________
# @section libidtech3 Configuration
#_____________________________
# Project Options
var cfg * = confy.Config()
cfg.dirs.lib  = "."/"src"/"lib"
cfg.dirs.root = cfg.dirs.lib/"idtech3"
cfg.dirs.src  = cfg.dirs.root/"code"
const version * = version(1,32,0,"b") # FIX: Take from the repository
# Names
const name * = Name(
  short : "libidtech3",
  long  : "id-Tech3",
  human : "id-Tech3 Engine"
  ) #:: Name
const repo * = Repository(
  owner : "JBustos22",
  name  : "oDFe"
  ) #:: Repository
#_____________________
proc modes *(
    debug   : bool = true;
    release : bool = defined(release);
    danger  : bool = defined(danger);
  ) :seq[confy.ModeKind]=
  result = if debug: @[Release, Debug] elif (release or danger): @[Release] else: @[Debug]
#_____________________
proc systems *(distribute :bool= off) :seq[System]=
  result = if distribute: @[
    System(os: Linux,   cpu: x86_64),
    System(os: Windows, cpu: x86_64),  # Requires mingw
    # System(os: Mac,     cpu: x86_64),  # Requires osxcross
    # System(os: Mac,     cpu: arm64),   # Requires osxcross
    ] else: @[System.host()]
#_______________________________________
proc source *(
    syst :confy.System= System.host();
  ) :seq[PathLike]=
  ## Source Code for building:
  ##   └─>  build/debug-linux-x86_64/oQ3_vulkan.x64
  let srcDir :PathLike= idtech3.cfg.dirs.src
  discard syst # FIX: Select code based on the system
  # Excepts
  glob( srcDir/"unix", filters = @[ # sys_unix
    "linux_qvk.c",
    "linux_joystick.c",
    "linux_qgl.c",
    "x11_randr.c",
    "x11_vidmode.c",
    "linux_snd.c",
    "linux_glimp.c",
    "x11_dga.c",
    ]) &
  glob( srcDir/"qcommon", filters = @[ # engine_co
    "vm_armv7l.c",
    "vm_aarch64.c",
    ]) &
  glob( srcDir/"server", filters = @[ # engine_sv
    "sv_rankings.c",
    ]) &
  # Globs
  glob( srcDir/"client"              ) & # engine_cl
  glob( srcDir/"renderercommon"      ) & # rendc
  glob( srcDir/"renderervk", rec=off ) & # rendv | Don't recurse, shader.c files are already #include'd
  glob( srcDir/"botlib"              ) &
  glob( srcDir/"sdl"                 ) &
  glob( srcDir/"libjpeg"             ) & # lib_jpeg
  glob( srcDir/"libogg"/"src"        ) & # lib_ogg
  glob( srcDir/"libvorbis"/"lib"     ) # lib_vorbis
#___________________
let flags * = Flags(cc: @[
  "-std=c11",
  "-Wall", "-Wextra", #"-Wpedantic",
  # Expected Warnings: id-Tech3
  "-Wno-unused-parameter",
  "-Wno-sign-compare",
  "-Wno-missing-field-initializers",
  "-Wno-ignored-qualifiers",
  # Expected Warnings: libvorbis
  "-Wno-implicit-function-declaration",
  "-Wno-int-conversion",
  # Dependencies
  "-I"&idtech3.cfg.dirs.src,
  "-I/usr/include/SDL2/",
  # Defines: libidtech3
  "-DUSE_SIMD_SND=0",
  "-DID3_STATIC_LIBRARY",
  "-D_GNU_SOURCE", # FIX: Shouldn't be needed, defined at unix_shared.h. Fixes missing addrinfo due to specifying an std= higher than 89
  # Defines: Original
  "-DBOTLIB",
  "-DUSE_SDL",
  "-DUSE_VULKAN_API",
  # Stop ZigCC from crashing the game due to UBSAN traps
  "-fno-sanitize=all",
], ld : @[
  "-lSDL2",
])




#_______________________________________
# @section libidtech3 Management Tools
#_____________________________
proc download *(
    dir   : PathLike;
    url   : URL;
    name  : Name;
    force : bool = false;
  ) :void=
  if not force and dirExists(dir) : return  # Do nothing if the target engine folder exists
  # if force and dirExists(dir)     : rm dir  # Remove the target engine folder when forcing
  info &"Downloading {name.human} from {url} into folder:  {dir}"
#___________________
proc patch *(
    dir   : PathLike;
    force : bool = false;
  ) :void=
  if not force and dirExists(dir): return  # Do nothing if the target engine folder exists
  info &"Patching {name.human} at folder:  {dir}"
#___________________
proc target *(
    version : confy.Version;
  ) :auto=
  echo ".........................."
  echo idtech3.cfg.dirs.src
  echo idtech3.source()
  echo ".........................."

  result = StaticLib.new(
    trg     = "lib"&idtech3.name.short,
    src     = idtech3.source(),
    cfg     = idtech3.cfg,
    version = version,
    ) #:: idtech3.target
  result.flags = idtech3.flags

#_______________________________________
# @section id-Tech3 as a Library: Builder Entry Points
#_____________________________
proc build *(
    config  : confy.Config;
    files   : seq[PathLike];
    name    : Name;
    systems : seq[System];
    modes   : seq[confy.ModeKind];
    version : Version;
    force   : bool = false;
  ) :seq[confy.Target]=
  # info &"Source Code List:\n  {files}"
  result = @[]
  for syst in systems:
    info &"Building {name.short} for {syst} from folder:  {config.dirs.root}  into:  {config.dirs.bin}"
    var trg = StaticLib.new(
      trg     = name.short,
      cfg     = config,
      src     = files,
      system  = syst,
      version = version,
      ) #:: trg
    trg.flags = idtech3.flags
    result.add trg.build()
#___________________
proc build *(
    debug :bool= off;
  ) :seq[confy.Target]=
  # Download and patch the Engine
  idtech3.download(idtech3.cfg.dirs.root, repo.url(), name, force=debug)
  idtech3.patch(idtech3.cfg.dirs.root, force=debug)
  # Compile the Engine as Static Libraries
  result = idtech3.build(
    config  = idtech3.cfg,
    files   = idtech3.source(),
    name    = idtech3.name,
    systems = idtech3.systems(),
    modes   = idtech3.modes(),
    version = idtech3.version,
    ) #:: engine.build
#___________________
when isMainModule: idtech3.build()

