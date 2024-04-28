# engine_co/q_shared.h
```c
#if !defined(DEFAULT_GAME)
#define DEFAULT_GAME			"defrag"
#endif
```


# engine_cl/cl_main.c
```c
Cvar_Get ("model", "ranger", CVAR_USERINFO | CVAR_ARCHIVE_ND );
Cvar_Get ("headmodel", "ranger", CVAR_USERINFO | CVAR_ARCHIVE_ND );
Cvar_Get ("team_model", "ranger", CVAR_USERINFO | CVAR_ARCHIVE_ND );
Cvar_Get ("team_headmodel", "ranger", CVAR_USERINFO | CVAR_ARCHIVE_ND );
```


# engine_co/vm.c
```c
void VM_Init( void ) {
#ifndef DEDICATED
	Cvar_Get( "vm_ui", "0", CVAR_ARCHIVE | CVAR_PROTECTED );	// !@# SHIP WITH SET TO 2
	Cvar_Get( "vm_cgame", "0", CVAR_ARCHIVE | CVAR_PROTECTED );	// !@# SHIP WITH SET TO 2
#endif
	Cvar_Get( "vm_game", "0", CVAR_ARCHIVE | CVAR_PROTECTED );	// !@# SHIP WITH SET TO 2
```


# engine_sv/sv_main.c
```c
	// get latched value
	Cvar_Get( "sv_pure", "0", CVAR_SYSTEMINFO | CVAR_LATCH );
```
