//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#pragma once
// @deps id3
#include "../types.hpp"

namespace id3 {
enum Error { none= 0, warn, fatal, ShouldNeverHappen = 255, };

/// Reports the given error code and message.
inline void err (id3::Error code, id3::str msg) { std::fprintf(stderr, "Error: %i-> %s\n", code, msg.data()); };
/// Reports the given error code and message, and exits the app
inline void fail (id3::Error code, id3::str msg) { std::fprintf(stderr, "Fatal Error: %i-> %s\n", code, msg.data()); std::exit(code); };
/// Reports the given message, and exits the app
inline void exit (id3::str msg) { std::fprintf(stderr, "%s\n", msg.data()); std::exit(0); };
};

