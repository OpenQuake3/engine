//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "./client.h"

id3_Client id3_cl_init (
  id3_Args const* const cli
) {
  return (id3_Client){
    .system = id3_sys_init(cli),
  };
}

