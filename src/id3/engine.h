//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#if !defined ID3_ENGINE_H
#define ID3_ENGINE_H

#include "./base.h"
#include "./args.h"
#include "./game.h"
#include "./system.h"

typedef struct id3_Client {
  id3_System system;
} id3_Client;

typedef struct id3_Engine {
  id3_Args   cli;
  id3_Game   game;
  id3_Client cl;
  u8 priv_pad[7];
} id3_Engine;
id3_Engine id3_init (id3_Args const* const cli, id3_Game const game);
void       id3_update (id3_Engine* engine);
bool       id3_close (id3_Engine const* engine);
void       id3_start (id3_Engine* const engine);

typedef enum id3_Result {
  id3_Ok                = 0,
  id3_ShouldNeverHappen = 123,
  id3_Result_ForceU8    = 255,
} id3_Result;

#endif  // ID3_ENGINE_H
