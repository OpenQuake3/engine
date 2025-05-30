//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#if !defined H_id3_engine_common
#define H_id3_engine_common
#include "../idtech3/engine/common.h"
#include "../system/signals.h"
#include "../system/cli.h"

typedef char id3_Common;

/// @description
/// Initializes/allocates all of the data structures consumed by both the Client and Server Engines
/// @note Rewrite of `Com_Init` to own the startup logic of the engine
/// FIX: Expand Com_Init into this function
id3_Common id3_co_init (id3_CLI const* const cli, bool dedicated);

/// @description
/// Runs a single frame update of the entire engine
#define id3_co_frame Com_Frame

#endif  // H_id3_engine_common

