## Refactored Structure
oQ3 is a complete refactor of id-Tech3's Entry Point logic.  
It was created with this mindset:  
- Cross-platform and Modern initialization algorithm
- Complete and Clear [Separation of Concerns](https://en.wikipedia.org/wiki/Separation_of_concerns)
  Each module should do one thing and one thing only.
- Respect the [Single Responsibility Principle](https://en.wikipedia.org/wiki/Single-responsibility_principle)
- Make the engine as modular as it allows itself to be  
  _ie. Allow usage of parts of the engine without pulling the entire engine with it._  
- Give the game ownership of the engine, not the other way around

## Modularity
OpenQuake3 Engine is built with modularity as its main priority.  
This repository aims to convert the vanilla id-Tech3's codebase into a separate set of modules that can be used independently of each other (wherever possible).  
This allows for a strict separation of concerns,  
and a clear distinction between the functionality of each section of the engine.  

Just like other modern engines and frameworks would do,  
this engine provides the basic building blocks to create a game with it.  
It is then the responsibility of the game to use the engine API to create the entry point for their application.  

## Running your Game
OpenQuake3 Engine's architecture is distinct and completely separate from other id-Tech3 engines.  
There is no such concept as "loading a mod" in this engine.  

Using vanilla concepts, a game running on OpenQuake3 Engine  
will become the engine and the game -at the same time-.  
_See the [Modularity](#modularity) section for more details._

This means that you can't just grab your mod files and run them as they are.  
You need to create explicit support for your game's C code to run with this engine.  
The entry file at [src/quake3.c](./src/quake3.c) provides an example of how to connect your game with the engine.

## Buildsystem
### libidtech3
`libidtech3` is a static library created with a set of patches for the id-Tech3 engine.  
The buildsystem of this project will:  
- Clone a clean copy of id-Tech3 (currently: oDFe's repository)  
- Apply the list of patches  
- Build id-Tech3 as a Static Library  

### OpenQuake3 Engine
oQ3's source code can be either compiled right next to your game,  
or built into a static library that your game links to.  
Both workflows are supported.  

This Engine provides a distinct API for ergonomic usage of `libidtech3`.   

### Your Game in oQ3
Instead of compiling each part of your game as library (`.so`,`.dll`,`.dylib`,`.qvm`),  
and loading the game from a `mods` list using the engine's VM,  
with OpenQuake3 Engine you will, instead, create an entry point for your game, and statically link the engine into your game.  

> Sidenote:  
> This is completely opposite to how id-Tech3 originally did things.  
> They wanted to create a **platform** for mod makers, and not just a standalone game.  
> This is no longer necessary for two reasons:
> - Opensource: The code is freely accessible and allows for direct modification without interfacing with a closed source SDK.  
> - Modern Internet: You can download entire games in just a few minutes.  

### Why confy
[Confy](https://github.com/heysokam/confy) is a complete make/cmake replacement,  
that was created **specifically** for id-Tech3.  
Confy is not just used by this project, **it exists** because of this project.  

You can read more about why/how we use it in the @[confy](./confy.md) doc file

