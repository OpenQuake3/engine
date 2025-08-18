//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#ifndef H_id3_engine_common
#define H_id3_engine_common
// @deps idtech3
#include "../idtech3/engine/common.h"
// @deps oQ3
#include "../config.h"
#include "../system/signals.h"
#include "../system/cli.h"
#include "../tools/time.h"
#include "../tools/unsafe.h"
#include "../tools/mem.h"
#include "../tools/commands.h"
#include "../engine/event.h"


/// @description
/// Holds all of the data consumed by both the Client and Server Engines
typedef struct id3_Common {
  id3_Time              time;
  id3_unsafe_jmp_Buffer abortframe;  // Will exit the entire frame when an ERR_DROP occurred. @note: Originally global state
} id3_Common;


/// @description
/// Initializes/allocates all of the data structures consumed by both the Client and Server Engines.
/// @note Rewrite of `Com_Init` to own the initialization of the engine.
/// @FIX: Expand Com_Init into this function
id3_Common id3_co_init (  // clang-format off
  id3_CLI const* const         cli,
  id3_Config const* const      cfg_engine,
  id3_game_Config const* const cfg_game
); // clang-format on

/// @description
/// Launches by calling the original `Com_Init`
/// @deprecated Will be removed as soon as the `id3_co_init` rewrite is ready.
id3_Common id3_co_init_original (id3_CLI const* const cli, bool dedicated);


/// @description
/// Runs a single frame update of the entire engine
#define id3_co_frame Com_Frame


#endif  // H_id3_engine_common

