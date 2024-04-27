# oQ3 | OpenQuake3 Engine
The goal of this engine is to provide Quality of Life features for mods that would be incompatible with original Quake3 Mods support.  

oQ3 is built as a set of patches for the oDFe engine.  
It tries to change as little as possible, while still providing access to modern features that would be out of reach for a fully vanilla compatible engine.  
It contains changes that are "Not Vanilla", and would otherwise be rejected by Vanilla Engines like Quake3e and oDFe.  
_(eg: Adding support for separate crouch/jump inputs, enabling native font support for mods, changing the `trap_` callbacks API to add new features, etc)_

### List of Changes
```md
# Todo Category
- #todo
```

### Buildsystem
The buildsystem of this project will:
- Clone a clean copy oDFe's repository
- Apply the list of patches
- Reorganize the folder structure to simplify the build process
- Build oQ3

