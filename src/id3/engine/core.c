//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "../engine.h"


id3_Engine id3_create (
  id3_Args const* const args,
  id3_Game const        game,
  bool                  dedicated
) {
  id3_log_info("%s %s %s", id3_meta_Version, id3_meta_BuildPlatform, id3_meta_BuildDate);

  id3_Engine result = (id3_Engine){
    .cfg  = id3_cfg_defaults(),
    .game = game,
    .time = id3_time_start(),
  };
  result.cli           = id3_cli_create(args);
  result.cfg.dedicated = dedicated;
  return result;
}

void id3_init (
  id3_Engine* engine
) {
  id3_cli_init(&engine->cli);
  engine->co = id3_co_init(&engine->cli, engine->cfg.dedicated);
  engine->cl = id3_cl_init(&engine->cli, &engine->co);
}

static void id3_update_dedicated () {
  // Run the game
  id3_co_frame(false);
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wpedantic"
void id3_update (
  id3_Engine* engine
) {
  id3_sys_fpu_configure();
  if (engine->cfg.dedicated) return id3_update_dedicated();
  id3_sys_input_frame();           // Check for other input devices
  id3_co_frame(id3_cl_noDelay());  // Run the game
}
#pragma GCC diagnostic pop


bool id3_close (
  id3_Engine const* engine
) {
  std_discard(engine);
  return false;
}


std_pragma_NoReturn void id3_start (
  id3_Engine* engine
) {
  id3_init(engine);
  while (!id3_close(engine)) id3_update(engine);
  id3_quit(engine, id3_ShouldNeverHappen, "FATAL: Something went wrong. Should never reach the end of the start function");
}


void id3_term (
  id3_Engine* engine
) {
  id3_cl_term(&engine->cl);
}


std_pragma_NoReturn void id3_quit (
  id3_Engine*      engine,
  id3_Result const code,
  cstr const       message
) {
  id3_log_echo("%s", message);
  id3_term(engine);
  std_exit(code);
}

