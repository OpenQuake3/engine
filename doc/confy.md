### Why confy
After spending many months cleaning the engine's buildsystem, wasting hundreds of work hours,  
only to end up at square one, with nothing solved and the same limitations and outdated workflows polluting the project...  
it was clear that a better solution needed to be created from scratch.  

That's why Confy was created.  

[Confy](https://github.com/heysokam/confy) is a complete make/cmake replacement,  
that was created **specifically** for id-Tech3.  
Confy is not just used by this project, **it exists** because of this project.  

Some other buildsystems that have already been **thoroughly** tested, and **proven** to not solve the problems:
```md
- make  : Cryptic bash syntax, outdated restrictions, platform specific, declarative
- cmake : Improved but still cryptic syntax, convoluted workflow, platform specific, declarative, needs a complete rewrite to be usable... only to end up at square one
- SCons : Python+SCons is difficult to install, Python stdlib is unintuitive, typeless language, declarative
- meson : Similar to cmake, provides little (or nothing) better than SCons, declarative
```
All of them suffered from the same issues when dealing with the complexity of id-Tech3's buildsystem architecture.  
As such we don't provide support for other buildsystems, and never will.  

> Sidenote:  
> Building this project is just a single call to `confy build`.  
> So, before blanket rejecting the buildsystem and writing your own cmake script from scratch _(has happened before)_,  
> consider that there might be valid reasons for confy to exist, and give it a test run.  
> _You may get surprised. It was made for this engine and this goal after all._  

