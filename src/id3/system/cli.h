//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#if !defined H_id3_system_cli
#define H_id3_system_cli

#include "../tools/args.h"

typedef struct id3_CLI {
  id3_Args args;
} id3_CLI;

id3_CLI id3_cli_init (id3_Args const* const cli);

#endif  // H_id3_system_cli

