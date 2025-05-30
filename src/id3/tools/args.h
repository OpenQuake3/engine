//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#if !defined H_id3_tools_args
#define H_id3_tools_args

#include "../cstd.h"
#include "../idtech3/config/cvar.h"

typedef struct id3_Args {
  Sz        argc;
  cstr_list argv;
  char*     merged;
} id3_Args;

id3_Args id3_args_create (int const argc, cstr_list const argv);

#endif  // H_id3_tools_args

