//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#ifndef H_id3_tools_mem_zone_small
#define H_id3_tools_mem_zone_small
// @deps idtech3
#include "../../idtech3/tools/mem/zone_small.h"


//__________________________________________________________________________________________________
/// @NOTE:
/// The Small Zone memory allocator is a linked list allocator backed by a fixed sized buffer.
/// Its global state/storage lives in the init function as the static variable `s_buf[ size ]`.
/// It uses one or multiple blocks of memory depending on the configuration for the Zone Allocators.
//__________________________________________________________________________________________________


/// @description
/// Initializes the SmallZone memory blocks so that they are ready to use from the engine.
#define id3_mem_zone_small_init Com_InitSmallZoneMemory

#endif  // H_id3_tools_mem_zone_small

