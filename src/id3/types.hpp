//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
//! @fileoverview General type Definitions & Aliases
//____________________________________________________|
#pragma once

#include "../cdk/cstd/types.hpp"
using cstr = cstd::cstr;

namespace id3 {

using str      = cstd::str;
using cstr     = cstd::cstr;
using UserData = void*;

template<typename T>
using Func = cstd::Func<T>;

// Arrays / lists
template<typename T>
using Seq = cstd::Seq<T>;

} //:: id3

