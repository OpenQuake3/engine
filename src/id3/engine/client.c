//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "./client.h"


id3_Client id3_cl_init (
  id3_CLI const* const cli,
  id3_Common const* const co
) {
  std_discard(co);
  return (id3_Client){
    .system = id3_sys_init(cli),
  };
}


void id3_cl_term (
  id3_Client* cl
) {
  id3_sys_term(&cl->system);
}

