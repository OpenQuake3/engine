//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "../engine.h"

id3_Engine id3_init (
  id3_Args const* const cli,
  id3_Game const        game
) {
  printf("Hello oQ3 Entry\n");
  id3_Engine result = (id3_Engine){
    .cfg  = id3_cfg_defaults(),
    .game = game,
    .cl   = id3_cl_init(cli),
    .time = id3_time_start(),
  };

  id3_log_echo("[id3.info] %s %s %s\n", id3_meta_Version, id3_meta_BuildPlatform, id3_meta_BuildDate);

  return result;
}

void id3_update (
  id3_Engine* engine
) {
  (void)engine; /*discard*/
  return;
}

bool id3_close (
  id3_Engine const* engine
) {
  (void)engine; /*discard*/
  return false;
}

void id3_start (
  id3_Engine* engine
) {
  while (!id3_close(engine)) id3_update(engine);
}

