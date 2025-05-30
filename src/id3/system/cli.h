//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#if !defined H_id3_system_cli
#define H_id3_system_cli

// @deps idtech3
#include "../idtech3/shared.h"
#include "../idtech3/tools/cli.h"
#include "../idtech3/config/cvar.h"
// @deps engine
#include "../tools/results.h"
#include "../tools/args.h"
#include "../tools/log.h"

typedef struct id3_CLI {
  id3_Args args;
} id3_CLI;

/// @description
/// Returns a base id3_CLI object without parsing the arguments.
id3_CLI id3_cli_create (id3_Args const* const args);

/// @description
/// Returns whether or not the arguments given request to print a help/version message and quit
id3_Result id3_cli_shouldVersionHelpAndQuit (id3_Args const* const args);

/// @description
/// Simple parse the given cli arguments and quit when they request to print a help/version message
/// @reference Cross-platform rewrite of `unix_main.c/Sys_ParseArgs`, which only managed `--version` and `--help` arguments
std_pragma_MayNotReturn void id3_cli_maybeVersionHelpAndQuit (id3_Args const* const args);

/// @description
/// Alias for `Com_EarlyParseCmdLine` that ignores the outdated parts of the function.
void id3_cli_parse_early (id3_Args const* const args);

/// @description
/// Parse the arguments of the given cli object to create the internal data used by the engine
std_pragma_MayNotReturn void id3_cli_init (id3_CLI* cli);

#endif  // H_id3_system_cli

