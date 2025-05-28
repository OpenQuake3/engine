//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#if !defined H_id3_config
#define H_id3_config

#include "./config/cvar.h"
#include "./config/engine.h"
#include "./config/game.h"

#if !defined id3_meta_BuildDate
#undef id3_meta_BuildDate
#define id3_meta_BuildDate "UnknownBuildDate"
#endif  // id3_meta_BuildDate

#if !defined id3_meta_BuildPlatform
#undef id3_meta_BuildPlatform
#define id3_meta_BuildPlatform "UnknownBuildPlatform"
#endif  // id3_meta_BuildPlatform


#if !defined id3_meta_Version
#undef id3_meta_Version
#define id3_meta_Version "UnknownVersion"
#endif  // id3_meta_Version

#endif  // H_id3_config

