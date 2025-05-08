//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "./game.h"

id3_Game id3_game_create (
  id3_Args const* const          cli,
  id3_game_callback_UI const     ui,
  id3_game_callback_Client const cl,
  id3_game_callback_Server const sv
) {
  return (id3_Game){
    .cli = *cli,
    .ui  = ui,
    .cl  = cl,
    .sv  = sv,
  };
}

void id3_game_destroy (
  id3_Game* const game
) {
  game->ui = NULL;
  game->cl = NULL;
  game->sv = NULL;
}
