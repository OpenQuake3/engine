//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "./args.h"

/// @description
/// Merges the command line arguments into a newly allocated string, and returns it.
/// Calls `Com_EarlyParseCmdLine` to process the command line arguments internally.
/// @note The fact that this needs to happen is bad design. FIX: Refactor any uses of the output string into using id3_CLI instead
static char* id3_args_merge (
  id3_Args const* const args
) {
  // merge the command line, this is kinda silly
  Sz len = 0;
  for (Sz id = 1; id < args->argc; id++) len += std_cstr_len(args->argv[id]) + 1;

  char* result = std_alloc(char*, len);
  result[0]    = 0;
  for (Sz id = 1; id < args->argc; id++) {
    if (id > 1) std_cstr_add(result, " ");
    std_cstr_add(result, args->argv[id]);
  }
  return result;
}


id3_Args id3_args_create (
  i32 const       argc,
  cstr_list const argv
) {
  id3_Args result = (id3_Args){
    .argc   = (Sz)argc,
    .argv   = argv,
    .merged = NULL,
  };
  result.merged = id3_args_merge(&result);
  return result;
}

