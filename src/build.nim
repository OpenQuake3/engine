#:__________________________________________________________________
#  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv2 or later  |
#:__________________________________________________________________
# @deps std
from std/sequtils import filterIt
# @deps ndk
import nstd/logger except dbg
import nstd/strings
import nstd/shell
import nstd/git
import confy except git, sh
# @deps engine.build
import ./build/src
import ./build/flags
import ./build/assembler


#_______________________________________
# @section Buildsystem Types
#_____________________________
type Name * = object
  short  *:string
  long   *:string
  human  *:string

type Repository * = object
  owner  *:string   ## GitHub's User or Organization name
  name   *:string   ## Name of the repository

type RemapList = seq[tuple[src:string, trg:string]]

#_______________________________________
# @section Patches
#_____________________________
proc patches_getList *(src :Path) :seq[Path]=
  for file in src.walkDirRec:
    if not file.string.endsWith(".patch"): continue
    result.add file.relativePath(src)

#_______________________________________
# @section SourceCode Management
#_____________________________
proc git_updateEngine *(id3URL :string; id3Dir :Path) :bool=
  result = true
  if dirExists(id3Dir): # Clean copy of the engine dir every time if it exists
    withDir id3Dir:
      git "clean -fdx"
      result = "up to date" notin git("pull")
  else: git "clone", id3URL, id3Dir
#___________________
proc dirs_remap *(
    srcDir    : Path;  ## From this folder
    trgDir    : Path;  ## To this folder
    remapList : RemapList;
  ) :void=
  ## @descr Moves/Remaps all {@arg srcDir} folders into a different structure at {@arg trgDir}, using the {@arg remapList}
  ## @note Includes are also renamed, so that compilation of the code still works the same
  for dir in remapList:
    info &"Remapping {dir} ..."
    # Create the target dir
    let trg = trgDir/dir.trg
    if not dirExists(trg): md trg
    cpDir srcDir/dir.src, trg
  # For every file in trgDir
  for file in trgDir.walkDirRec:
    if not file.string.endsWith(".c", ".h"): continue # Skip unwanted files
    dbg &"Remapping the includes of {file} ..."
    # Search the file to remap every folder that we have moved
    for remap in remapList:
      if remap.src == remap.trg: continue # Ignore folders that are not changed
      let src = &"{remap.src}/"
      var trg :string
      for ch in remap.trg:  # Add one `../` for every folder that we must go up in the target rename
        if ch == '/': trg.add "../"
      trg &= &"{remap.trg}/"
      # Read the file, replace with the change, and write it back
      file.writeFile file.readFile.replace(src, trg)


#_______________________________________
# @section Buildsystem Control
#_____________________________
const versEngine = version(0, 0, 0)


#_______________________________________
# @section Buildsystem Configuration
#_____________________________
const verbose = on                  ## Log debug messages from the buildsystem to CLI
const silent  = off and not verbose ## Silence every CLI message
#___________________
const name = Name(
  short : "oQ3",
  long  : "open-quake3",
  human : "OpenQuake3"
  ) # << Name(... )
const repo = Repository(
  owner : "OpenQuake3",
  name  : "engine"
  ) # << Repository( ... )
#___________________
let id3Dir    = cfg.libDir/"idtech3"
let id3URL    = "https://github.com/JBustos22/oDFe"
let patchDir  = cfg.srcDir/"patches"
let patchList = patches_getList(patchDir)



#_________________________________________________
# Buildsystem Entry Point
#_______________________________________
# @section Initialize the buildsystem
#_____________________________
logger.init(name=name.short, threshold=
  when verbose: Log.All elif silent: Log.None else: Log.Err
  ) # << logger.init( ... )


#_______________________________________
# @section Clone id-Tech3
#_____________________________
# Clone a clean copy id-Tech3's repository everytime
info &"Updating id-Tech3 clone from  {id3URL}  into  {id3Dir}"
let wasUpdated = git_updateEngine(id3URL, id3Dir)
info &"Done cloning id-Tech3."


#_______________________________________
# @section Apply the patches
#_____________________________
if wasUpdated:
  info &"Applying the list of patches from:  {patchDir}"
  for patch in patchList:
    info &"Applying {patch}"
  info &"Done applying patches."


#_______________________________________
# @section Reorganize the folder structure
#_____________________________
const remapList :RemapList= @[
  # Copy
  ("asm",            "asm"        ),
  ("botlib",         "botlib"     ),
  ("sdl",            "sdl"        ),
  # Remaps
  ("cgame",          "game_cl"    ),
  ("game",           "game_sv"    ),
  ("libcurl",        "lib_curl"   ),
  ("libjpeg",        "lib_jpeg"   ),
  ("libogg",         "lib_ogg"    ),
  ("libpcre2",       "lib_pcre2"  ),
  ("libsdl",         "lib_sdl"    ),
  ("libvorbis",      "lib_vorbis" ),
  ("renderer",       "rend1"      ),
  ("renderer2",      "rend2"      ),
  ("renderercommon", "rendc"      ),
  ("renderervk",     "rendv"      ),
  ("ui",             "ui_ta"      ),
  ("unix",           "sys_unix"   ),
  ("win32",          "sys_win32"  ),
  ("client",         "engine_cl"  ),
  ("server",         "engine_sv"  ),
  ("qcommon",        "engine_co"  ),
  ] # << remapList = [ ... ]
#___________________
if wasUpdated:
  info &"Remapping folders from  {id3Dir}  into  {cfg.srcDir} ..."
  dirs_remap(id3Dir/"code", cfg.srcDir, remapList)
  info &"Done remapping folders."


#_______________________________________
# @section Build oQ3
#_____________________________
info &"Building {name.short} ..."
info &"Compiling asm files for {name.short} ..."
let snd_mix_x86_64 = assembler.compile( cfg.srcDir/"asm"/"snd_mix_x86_64.s", cfg.binDir/"snd_mix_x86_64.o", flags.lnx_all )
# let snd_mix_sse    = assembler.compile( cfg.srcDir/"asm"/"snd_mix_sse.s", cfg.binDir/"snd_mix_sse.o", flags.lnx_all )
#___________________
info &"Compiling binaries for {name.short} ..."
let vulkan = Program.new(
  src   = src.vulkan & snd_mix_x86_64,
  trg   = name.short&"_vulkan",
  flags = flags.lnx_all,
  ) # << Program.new( ... )
vulkan.build()
#___________________
info &"Done building {name.short}."

