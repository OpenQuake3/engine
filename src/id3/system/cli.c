//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "./cli.h"


id3_Result id3_cli_shouldVersionHelpAndQuit (
  id3_Args const* const cli
) {
  for (Sz id = 0; id < cli->argc; ++id) {
    cstr const arg = cli->argv[id];
    if (std_cstr_equal(arg, "--version")) return id3_VersionAndQuit;
    if (std_cstr_equal(arg, "--help")) return id3_HelpAndQuit;
  }
  return id3_Ok;
}


void id3_cli_maybeVersionHelpAndQuit (
  id3_Args const* const cli
) {
  switch (id3_cli_shouldVersionHelpAndQuit(cli)) {
    case id3_HelpAndQuit : {
      id3_log_info("TODO: Help Message Here");
      std_exit(id3_HelpAndQuit);
    }
    case id3_VersionAndQuit : {
      id3_log_info("TODO: Version Message Here");
      std_exit(id3_VersionAndQuit);
    }
    default : (void)cli; /* discard */
  }
}


void id3_cli_parse_early (
  id3_Args const* const args
) {
  char con_title[id3_cvar_value_string_MaxLen];
  int  xpos = 0;
  int  ypos = 0;
  /*useXYpos = */ Com_EarlyParseCmdLine(args->merged, con_title, sizeof(con_title), &xpos, &ypos);
}


id3_CLI id3_cli_create (
  id3_Args const* const args
) {
  return (id3_CLI){
    .args = id3_args_create((int)args->argc, args->argv),
  };
}


void id3_cli_init (
  id3_CLI* cli
) {
  id3_cli_maybeVersionHelpAndQuit(&cli->args);
  //__________________________________________________
  // TODO: mac
  // #ifdef __APPLE__
  // Sys_SetBinaryPath( argv[ 0 ] );
  // Sys_SetDefaultBasePath( Sys_StripAppBundle( binaryPath ) );
  // #endif
  //__________________________________________________
  id3_cli_parse_early(&cli->args);
}

