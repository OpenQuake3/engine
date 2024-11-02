### engine_co/q_shared.h
Enable compile-time definition of macros
```c
#if !defined(DEFAULT_GAME)
#define DEFAULT_GAME			"defrag"
#endif
```
```c
#if !defined(Q3_VERSION)
#define Q3_VERSION            "Q3 1.32e"
#endif
```


### engine_cl/cl_main.c
Switch sarge to ranger as default model
```c
Cvar_Get ("model", "ranger", CVAR_USERINFO | CVAR_ARCHIVE_ND );
Cvar_Get ("headmodel", "ranger", CVAR_USERINFO | CVAR_ARCHIVE_ND );
Cvar_Get ("team_model", "ranger", CVAR_USERINFO | CVAR_ARCHIVE_ND );
Cvar_Get ("team_headmodel", "ranger", CVAR_USERINFO | CVAR_ARCHIVE_ND );
```


### engine_co/vm.c
Use native libraries by default
```c
void VM_Init( void ) {
#ifndef DEDICATED
	Cvar_Get( "vm_ui", "0", CVAR_ARCHIVE | CVAR_PROTECTED );	// !@# SHIP WITH SET TO 2
	Cvar_Get( "vm_cgame", "0", CVAR_ARCHIVE | CVAR_PROTECTED );	// !@# SHIP WITH SET TO 2
#endif
	Cvar_Get( "vm_game", "0", CVAR_ARCHIVE | CVAR_PROTECTED );	// !@# SHIP WITH SET TO 2
```


### engine_sv/sv_main.c
Allow `sv_pure 0` by default (?todo : what was this for exactly?)
```c
	// get latched value
	Cvar_Get( "sv_pure", "0", CVAR_SYSTEMINFO | CVAR_LATCH );
```

### engine_cl/cl_main.c
Changed to support the cross-compilation setup.
The compiler flag `-fno-leading-underscores` does not exist with ZigCC/Clang, 
and does not work as expected with gcc _(might work, but could't make it work; figured its not worth the effort, as its fixed with a simple patch)_.
```c
#if idx64 && (!defined (_MSC_VER) || defined(USE_WIN32_ASM))
void _S_WriteLinearBlastStereo16_SSE_x64( int*, short*, int );
#endif


#if idx64 && (!defined (_MSC_VER) || defined (USE_WIN32_ASM))
		_S_WriteLinearBlastStereo16_SSE_x64( snd_p, snd_out, snd_linear_count );
#else
```

