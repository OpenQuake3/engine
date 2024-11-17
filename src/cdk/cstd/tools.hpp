//:___________________________________________________________________
//  cdk  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:___________________________________________________________________
#pragma once
#include "./types.hpp"

// clang-format off
//____________________________

/// Discards the given input.
#define unused(it) (void)(it)
/// Discards the given list of inputs.
template<class... Args> inline void discard(__attribute__((unused)) Args... args) {}
/// Formats the given varargs into a string.
template<class... Args> cstd::str f(Args... args) { cstd::str result; (result << ... << args); return result; };
/// Prints the given msg to console.
inline void echo(cstd::str msg) { std::cout << msg << std::endl; }
/// Prints the given list of messages to console, without a `\n` at the end.
template<class... Args> inline void prnt(Args... args) { (std::cout << ... << args); };
/// Echoes the given list of messages to console.
template<class... Args> inline void echo(Args... args) { (std::cout << ... << args) << std::endl; };
/// Reports the given error code and message.
inline void err(i32 code, cstd::str msg) { fprintf(stderr, "Error: %i->%s\n", code, msg.data()); };

//____________________________
// clang-format on

#define fn __PRETTY_FUNCTION__  // Function name

