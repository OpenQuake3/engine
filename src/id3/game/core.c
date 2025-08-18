//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "../game.h"

id3_Game id3_game_create (
  id3_game_create_args const* const args
) {
  return (id3_Game){
    .cli = *args->cli,
    .ui  = args->ui,
    .cl  = args->cl,
    .sv  = args->sv,
    .cfg = args->cfg,
  };
}

void id3_game_destroy (
  id3_Game* const game
) {
  game->cli = (id3_Args){ 0 };
  game->ui  = NULL;
  game->cl  = NULL;
  game->sv  = NULL;
  game->cfg = (id3_game_Config){ 0 };
}

