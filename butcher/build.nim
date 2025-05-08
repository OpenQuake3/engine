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
# @section Buildsystem Control
#_____________________________
# const versEngine  = version(0, 0, 0)
# CLI Control
const debug    = on                                ## (note: should always be off)  Buildsystem debug mode on/off. Marking it `on` will test everything, ignoring all other filters
let publish    = cli.getOpt("--publish") or debug  ## `./bin/build --publish` to publish the result to GitHub
let release    = cli.getOpt("r") or publish        ## `./bin/build -r` to run the automatic release generation process
let distribute = cli.getOpt("d") or release        ## `./bin/build -d` to build the distributable version
let pack       = cli.getOpt("p") or distribute     ## `./bin/build -p` to pack everything


#_______________________________________
# @section Configuration
#_____________________________
# Folders
let engineDir = cfg.libDir/"idtech3"
# Build Options
const verbose = off                  ## Log debug messages from the buildsystem to CLI
const silent  = off and not verbose  ## Silence every CLI message
const idtech3 = "https://github.com/JBustos22/oDFe"  ## URL of the id-Tech3's repository
# Names
const name = Name(
  short : "oQ3",
  long  : "OpenQuake3",
  human : "Open Quake3 Engine"
  ) # << Name(... )
const repo = Repository(
  owner : "OpenQuake3",
  name  : "engine"
  ) # << Repository( ... )
#_____________________
let modes   = if debug: @[Release, Debug] elif release: @[Release] else: @[Debug]
let systems = if distribute: @[
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

