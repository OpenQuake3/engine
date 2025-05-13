//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#if !defined H_id3_tools_args
#define H_id3_tools_args

#include "../base.h"

typedef struct id3_Args {
  Sz const          argc;
  cstr const* const argv;
} id3_Args;

id3_Args id3_args_parse (int const argc, cstr const* const argv);

#endif  // H_id3_tools_args

