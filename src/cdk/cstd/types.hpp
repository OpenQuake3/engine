//:___________________________________________________________________
//  cdk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:___________________________________________________________________
#pragma once

//______________________________________
// @section Number Types
//____________________________
#include <cstdint>
using u8   = uint8_t;
using byte = u8;
using u16  = uint16_t;
using u32  = uint32_t;
using u64  = uint64_t;
using uP   = uintptr_t;
using i8   = int8_t;
using i16  = int16_t;
using i32  = int32_t;
using i64  = int64_t;
using iP   = intptr_t;
using f32  = float;
using f64  = double;
#include <cstddef>
using Sz   = size_t;


//______________________________________
// @section Strings
//____________________________
#include <iostream>
namespace cstd {
  using str  = std::string;
  using cstr = char const*;
}


//______________________________________
// @section Functions
//____________________________
#include <functional>
namespace cstd {
  template<typename T>
  using Func = std::function<T>;
}

//______________________________________
// @section Growable Arrays / lists
//____________________________
#include <vector>
namespace cstd {
  template<typename T>
  using Seq = std::vector<T>;
}

