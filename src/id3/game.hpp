//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#pragma once
// @deps id3
#include "./types.hpp"

namespace id3 {
class Game {Game* m = this;

using VoidFunc = id3::Func<void (id3::UserData data)>;
// FIX: These cause a segfault on the class destructor :shrug:
/* VoidFunc init_after    = VoidFunc(); */
/* VoidFunc phy_before    = VoidFunc(); */
/* VoidFunc phy_after     = VoidFunc(); */
/* VoidFunc render_before = VoidFunc(); */
/* VoidFunc render_after  = VoidFunc(); */
/* VoidFunc term_before   = VoidFunc(); */


public:
inline Game() {}
inline ~Game() {}

}; //:: id3.Game
} //:: id3

