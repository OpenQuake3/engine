//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#ifndef H_id3_config_engine
#define H_id3_config_engine
// @deps id3
#include "../base.h"
// @deps id3.config
#include "./meta.h"

typedef struct id3_Config {
  bool     dedicated;
  id3_Name name;
} id3_Config;

id3_Config id3_cfg_defaults ();

#endif  // H_id3_config_engine

