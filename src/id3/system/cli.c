#include "./cli.h"

id3_CLI id3_cli_init (
  id3_Args const* const cli
) {
  return (id3_CLI){ .args = *cli };
}

