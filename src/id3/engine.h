//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#if !defined H_id3_engine
#define H_id3_engine

#include "./cstd.h"
#include "./tools.h"
#include "./game.h"
#include "./system.h"
#include "./config.h"
#include "./engine/common.h"
#include "./engine/client.h"

typedef struct id3_Engine {
  id3_CLI    cli;
  id3_Config cfg;
  id3_Common co;
  id3_Client cl;
  id3_Game   game;
  id3_Time   time;
} id3_Engine;

/// @description
/// Creates the engine object, without calling for any initialization logic.
/// Should call {@link Engine.start()} on the resulting object after calling this function.
/// @return The engine's data object.
id3_Engine id3_create (id3_Args const* const args, id3_Game const game, bool dedicated);

/// @description
/// Initializes the engine and all its required data.
void id3_init (id3_Engine* engine);

/// @description
/// Terminates/deallocates all data of the engine
void id3_term (id3_Engine* engine);

/// @description
/// Executes a single frame of the engine
void id3_update (id3_Engine* engine);

/// @description
/// Returns true when the engine should terminate/close.
bool id3_close (id3_Engine const* engine);

/// @description
/// Starts the Engine's process, giving full ownership of the code to the engine.
/// @note Use {@link id3_close} and {@link id3_update} if you want to retain ownership.
/// @note Will never return. The engine has an internal termination system
std_pragma_NoReturn void id3_start (id3_Engine* const engine);

/// @description
/// Prints the given message, terminates the engine and exits the app with the given code.
std_pragma_NoReturn void id3_quit (id3_Engine* engine, id3_Result const code, cstr const message);

#endif  // H_id3_engine

