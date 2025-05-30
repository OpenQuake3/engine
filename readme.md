# oQ3 | OpenQuake3 Engine
OpenQuake3 Engine is a modernized id-Tech3 engine.  

### List of Features
OpenQuake3 Engine provides modern features for id-Tech3 games  
that would be incompatible with original vanilla mods and engines.  
```md
# Todo Category
- #todo
```

## Running your Game
OpenQuake3 Engine's architecture is distinct and completely separate from other id-Tech3 engines.  
There is no such concept as "loading a mod" in this engine.  
See the entry file at [src/quake3.c](./src/quake3.c) for an example of how to connect your game with oQ3.

You can find more details about this in the @[internals](./doc/internals.md) doc file.  

## Internals & Architecture
OpenQuake3 Engine tries to change just enough to provide support for modern features and capabilities.  
But it contains features that are "Not Vanilla",  
and therefore would be rejected by Vanilla Engines like Quake3e and oDFe.  
_(eg: Adding support for separate crouch/jump inputs, enabling native font support for mods, changing the `trap_` callbacks API to add new features, etc)_

The architecture and design of oQ3 are explained in the @[internals](./doc/internals.md) doc file.  

