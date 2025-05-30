//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "./common.h"

id3_Common id3_co_init (
  id3_CLI const* const cli,
  bool dedicated
) {
  // FIX: Expand Com_Init into this function
  Com_Init(cli->args.merged);

  // There is no GLimp_Init for dedicated server.
  // Init signal handler early.
  if (dedicated) id3_sys_signals_init();

  return (id3_Common)0;
}

