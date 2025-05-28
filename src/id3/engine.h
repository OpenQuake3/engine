//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#if !defined H_id3_engine
#define H_id3_engine

#include "./base.h"
#include "./tools.h"
#include "./game.h"
#include "./system.h"
#include "./config.h"
#include "./engine/client.h"

typedef struct id3_Engine {
  id3_Config cfg;
  id3_Client cl;
  id3_Game   game;
  id3_Time   time;
} id3_Engine;

/// @description
/// Initializes the engine and all its required data.
/// Should call {@link Engine.start()} on the resulting object after calling this function.
/// @return The engine's data object.
id3_Engine id3_init (id3_Args const* const cli, id3_Game const game);

/// @description
/// Executes a single frame of the engine
void id3_update (id3_Engine* engine);

/// @description
/// Returns true when the engine should terminate/close.
bool id3_close (id3_Engine const* engine);

/// @description
/// Starts the Engine's process, giving full ownership of the code to the engine.
/// @note (TODO: not yet implemented) Use {@link id3_close} and {@link id3_update} if you want to retain ownership.
void id3_start (id3_Engine* const engine);

#endif  // H_id3_engine

