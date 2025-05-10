//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
//! @fileoverview Base QuakeIIIArena Game
//_________________________________________|
#if !defined H_q3a
#define H_q3a

#include "./id3/game.h"

void q3a_ui (id3_game_UserData data);
void q3a_cl (id3_game_UserData data);
void q3a_sv (id3_game_UserData data);

id3_Game q3a_create (id3_Args const* const cli);

#endif  // H_q3a

