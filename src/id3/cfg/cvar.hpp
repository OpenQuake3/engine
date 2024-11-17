//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
//! @fileoverview id-Tech3 Engine: Command Line Tools
//________________________________________________________________|
#pragma once
// @deps id3
#include "../types.hpp"

namespace id3 {
class Cvar {Cvar* m = this;

static constexpr Sz const Max = 256; // MAX_CVAR_VALUE_STRING

public:
/* using Value = char[Max]; */
using Value = std::array<char, Max>;

}; //:: id3.Cvar
} //:: id;

