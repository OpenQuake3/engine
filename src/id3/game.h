//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
//! @fileoverview Data required by the Engine to run a Game.
//___________________________________________________________|
#ifndef H_id3_game
#define H_id3_game
// @deps id3
#include "./base.h"
#include "./tools/args.h"
#include "./config/game.h"

typedef std_pointer id3_game_UserData;
typedef void (*id3_game_callback_UI)(id3_game_UserData data);
typedef void (*id3_game_callback_Client)(id3_game_UserData data);
typedef void (*id3_game_callback_Server)(id3_game_UserData data);

typedef struct id3_Game {
  id3_Args                 cli;
  id3_game_callback_UI     ui;
  id3_game_callback_Client cl;
  id3_game_callback_Server sv;
  id3_game_Config          cfg;
} id3_Game;

typedef struct id3_game_create_args {
  id3_Args const* const          cli;
  id3_game_callback_UI const     ui;
  id3_game_callback_Client const cl;
  id3_game_callback_Server const sv;
  id3_game_Config const* const   cfg;
} id3_game_create_args;
id3_Game id3_game_create (id3_game_create_args const* const args);
void     id3_game_destroy (id3_Game* const game);

#endif  // H_id3_game

