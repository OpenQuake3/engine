//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "../system.h"

id3_System id3_sys_init (
  id3_Args const* const cli
) {
  return (id3_System){
    .cli    = id3_cli_init(cli),
    .input  = id3_sys_input_init(),
    .window = id3_sys_window_init(),
  };
}

