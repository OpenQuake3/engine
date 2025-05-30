## id-Tech3
id-Tech3 declaration files, organized with the Single Responsability Principle.  

This folder aims to unify the original engine symbols into one place,  
but using the project structure/organization used by this project instead.  

Avoids having to include `q_shared.h`, `qcommon.h` and friends,  
which pull the entire engine of symbols with them when they are called.  

eg: You shouldn't be given access to every filesystem, console, cvars, etc, etc, functions inside a file,
when all you wanted was to use the `qboolean` type.
One File, One Responsibility.  

