//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "./engine.h"

id3_Engine id3_init (
  id3_Args const* const cli,
  id3_Game const        game
) {
  (void)game; /*discard*/

  printf("Hello oQ3 Entry\n");
  return (id3_Engine){
    .cli  = *cli,
    .game = game,
  };
}

bool id3_close (
  id3_Engine const* engine
) {
  (void)engine; /*discard*/
  return false;
}

void id3_update (
  id3_Engine* engine
) {
  (void)engine; /*discard*/
  return;
}

#if defined __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wmissing-noreturn"
#endif
void id3_start (
  id3_Engine* engine
) {
  while (true) id3_update(engine);
}
#if defined __clang__
#pragma clang diagnostic pop
#endif
