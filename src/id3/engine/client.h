//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#if !defined H_id3_engine_client
#define H_id3_engine_client

#include "../idtech3/engine/client.h"
#include "../cstd.h"
#include "../tools/results.h"
#include "../tools/log.h"
#include "../system.h"
#include "./common.h"

typedef struct id3_Client {
  id3_System system;
} id3_Client;


/// @description
/// Initializes/allocates all the data used by the Client Engine
id3_Client id3_cl_init (id3_CLI const* const cli, id3_Common const* const co);

/// @description
/// Terminates/deallocates all the data used by the given Client Engine
void id3_cl_term (id3_Client* cl);

/// @description
/// Returns true when the client is not allowed to slowdown gameplay for this frame (eg: When Recording)
#define id3_cl_noDelay CL_NoDelay

#endif  //H_id3_engine_client

