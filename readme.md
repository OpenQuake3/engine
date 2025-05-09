# oQ3 | OpenQuake3 Engine
OpenQuake3 Engine is a modernized id-Tech3 engine.  
It provides modern features for mods and users that would be incompatible with original vanilla mods and engines.  

### List of Changes
```md
# Todo Category
- #todo
```

## Running your Mod
OpenQuake3 Engine's architecture is distinct and completely separate from other id-Tech3 engines.  
There is no such concept as "loading a mod" in this engine.  
Using vanilla concepts, a game based on OpenQuake3 Engine based will be the engine and the game -at the same time-.  
_See the [Modularity](#modularity) section for more details._

This means that you can't just grab your mod files and run them as they are.  
You need to create explicit support for your game's C code to run with this engine.  
The entry file at [src/quake3.c](./src/quake3.c) provides an example of how to run the C code of your game.

## Internals
OpenQuake3 Engine tries to change just enough to provide support for modern features and capabilities.  
But it contains features that are "Not Vanilla", and therefore would be rejected by Vanilla Engines like Quake3e and oDFe.  
_(eg: Adding support for separate crouch/jump inputs, enabling native font support for mods, changing the `trap_` callbacks API to add new features, etc)_

### Modularity
OpenQuake3 Engine is built with modularity as its main priority.  
This repository aims to convert the vanilla id-Tech3's codebase into a separate set of modules that can be used independently of each other (wherever possible).  
This allows for a strict separation of concerns, and a clear distinction between the functionality of each section of the engine.  

Just like modern engines and frameworks would do, this engine provides the basic building blocks to create a game with it.  
It is then the responsibility of the game to use the engine API to create the entry point for their game.  

### Buildsystem
oQ3 is built as a set of patches for the oDFe engine.  
The buildsystem of this project will:
- Clone a clean copy oDFe's repository
- Apply the list of patches
- Reorganize the folder structure
- Build oQ3 as a Static Library

You will need to create an entry point for your game, and statically link your game with the engine in your buildsystem.  
