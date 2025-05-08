//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "../q3a.h"

// clang-format off
// FIX: Port QuakeIIIArena base gamecode into these functions
void q3a_ui(id3_game_UserData data) { (void)data; }
void q3a_cl(id3_game_UserData data) { (void)data; }
void q3a_sv(id3_game_UserData data) { (void)data; }
// clang-format on

id3_Game q3a_create (
  id3_Args const* const cli
) {
  return (id3_Game){
    .cli = *cli,
    .ui  = q3a_ui,
    .cl  = q3a_cl,
    .sv  = q3a_sv,
  };
}
