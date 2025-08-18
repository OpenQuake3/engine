//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "./common.h"

id3_Common id3_co_init (
  id3_CLI const* const         cli,
  id3_Config const* const      cfg_engine,
  id3_game_Config const* const cfg_game
) {
  // FIX: Expand Com_Init into this function
  id3_Common result = (id3_Common){ 0 };

  if (cfg_engine->dedicated) id3_sys_signals_init();  // There is no GLimp_Init for dedicated server. Init signal handler early.

  // Get the initial time base
  result.time = id3_time_start();  // FIX: Integrate with `Sys_milliseconds`

  // Setup error frame for setjmp
  if (!id3_unsafe_jmp_set(&result)) id3_sys_error("Error during initialization.");

  // Init early systems: mem.small and events
  id3_event_push_init();  // bk001129 - do this before anything else decides to push events
  id3_mem_zone_small_init();

  // Init Core Cvars & Commands
  id3_cvar_list_init_core();
  id3_cvar_set("fs_game", cfg_game->name.Short);  // TODO: Remove this hardcoded fs_game.set() in some way.
  id3_cli_parse(cli);
  // Swap_Init();  // @note Was commented out in the original code
  id3_cmd_buffer_init();
  id3_cvar_list_startup();

  // Init mem.zone
  id3_mem_zone_init();

  // Init Early Cvars & Commands
  id3_cmd_base_init();
  // id3_cvar_list_init_early();  // FIX: TODO
  // id3.cmd.input.init();  // Done early-init. `bind` commands exist

  return result;
}


id3_Common id3_co_init_original (
  id3_CLI const* const cli,
  bool                 dedicated
) {
  if (dedicated) id3_sys_signals_init();  // There is no GLimp_Init for dedicated server. Init signal handler early.
  Com_Init(cli->args.merged);
  return (id3_Common){ 0 };
}

