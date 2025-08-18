//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
//! @fileoverview
//! Cvar variables are used to hold scalar or string variables
//! that can be changed or displayed at the console or prog code
//! as well as accessed directly in C code.
//!
//! The user can access cvars from the console in three ways:
//! r_draworder        prints the current value
//! r_draworder 0      sets the current value to 0
//! set r_draworder 0  as above, but creates the cvar if not present
//!
//! Cvars are restricted from having the same names as commands
//! (to keep this interface from being ambiguous)
//!
//! They are occasionally used to communicated information
//! between different modules of the program.
//____________________________________________________________________|
#if !defined H_id3_config_cvar
#define H_id3_config_cvar

#include "../cstd.h"
#include "../idtech3/config/cvar.h"

/// @description
/// Returns a reference to a new Cvar created with the given options
/// @param description Will be ignored when NULL
id3_Cvar* id3_cvar_create ( // clang-format off
  std_cstring const                     name,
  std_cstring const                     value,
  id3_cvar_Flags const                  flags,
  std_cstring const std_pragma_Nullable description
); // clang-format on

/// @description
/// Sets the internal value of the cvar identified by the given name.
/// Will create the variable with no flags if it doesn't already exist
#define id3_cvar_set             Cvar_Set

/// @description
/// Creates the variable if it doesn't exist,
/// or returns the existing one if it does.
/// If it exists, the value will not be changed, but flags will be ORed in.
/// This allows variables to be unarchived without needing bitflags.
/// If value is "", the value will not override a previously set value.
#define id3_cvar_get             Cvar_Get

#define id3_cvar_description_set Cvar_SetDescription

/// @description
/// 1. Initializes the GlobalState of the cvar system
/// 2. Creates the cvar_cheats (`sv_cheats`) and cvar_developer (`developer`) variables
/// 3. Adds all basic/primary commands into the engine
#define id3_cvar_list_init_core  Cvar_Init

/// @description
/// Set a specific cvar requested from CLI.
/// Will set all Cvars when `match` is null.
#define id3_cvar_init_fromCLI Com_StartupVariable

/// @description
/// Override anything from the config files with command line args
void id3_cvar_list_startup ();

/// @description
/// Override anything from the config files with command line args
/// FIX: TODO
void id3_cvar_list_init_early ();


#endif  // H_id3_config_cvar

