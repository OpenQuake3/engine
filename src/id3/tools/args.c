#include "./args.h"

id3_Args id3_args_parse (
  i32 const                argc,
  char const* const* const argv
) {
  // FIX: Parse arguments like the engine expects
  return (id3_Args){
    .argc = (Sz)argc,
    .argv = argv,
  };
}

