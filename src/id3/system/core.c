//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "../system.h"

id3_System id3_sys_init (
  id3_CLI const* const cli
) {
  return (id3_System){
    .cli    = *cli,
    .input  = id3_sys_input_init(),
    .window = id3_sys_window_init(),
  };
}

void id3_sys_term (
  id3_System* sys
) {
  std_discard(sys->cli);
  std_discard(sys->input);
  std_discard(sys->window);
}

