#:__________________________________________________________________
#  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# @deps ndk
import nstd/opts as cli
import nstd/logger
import confy
# @deps buildsystem
import ./build/engine


#_______________________________________
# @section Configuration
#_____________________________
# Folders
let engineDir * = cfg.libDir/"idtech3"
# Build Options
const verbose * = off                  ## Log debug messages from the buildsystem to CLI
const silent  * = off and not verbose  ## Silence every CLI message
const idtech3 * = "https://github.com/JBustos22/oDFe"  ## URL of the id-Tech3's repository
# Names
const name * = Name(
  short : "oQ3",
  long  : "OpenQuake3",
  human : "Open Quake3 Engine"
  ) # << Name(... )
const repo * = Repository(
  owner : "OpenQuake3",
  name  : "engine"
  ) # << Repository( ... )
#_____________________
let modes   * = if debug: @[Release, Debug] elif release: @[Release] else: @[Debug]
let systems * = if distribute: @[
  System(os: Linux,   cpu: x86_64),
  System(os: Windows, cpu: x86_64),  # Requires mingw
  # System(os: Mac,     cpu: x86_64),  # Requires osxcross
  # System(os: Mac,     cpu: arm64),   # Requires osxcross
  ] else: @[confy.getHost()]


#_______________________________________
# @section Build the Engine
#_____________________________
when isMainModule:
  # Initialize the Logger
  logger.init(name=name.short, threshold=
    when verbose: Log.All elif silent: Log.None else: Log.Err
    ) # << logger.init( ... )
  # Download and patch the Engine
  engine.download(engineDir, idtech3, force=debug)
  engine.patch(engineDir, force=debug)
  # Compile the Engine
  engine.build(
    rootDir = engineDir,
    binDir  = cfg.binDir,
    name    = name,
    systems = systems,
    modes   = modes,
    version = versEngine,
    ) # << engine.build( ... )

