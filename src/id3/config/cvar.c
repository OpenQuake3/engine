//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "./cvar.h"


id3_Cvar* id3_cvar_create (
  std_cstring const                     name,
  std_cstring const                     value,
  id3_cvar_Flags const                  flags,
  std_cstring const std_pragma_Nullable description
) {
  id3_Cvar* result = id3_cvar_get(name, value, flags);
  if (description) id3_cvar_description_set(result, description);
  return result;
}


void id3_cvar_list_startup () { id3_cvar_init_fromCLI(NULL); }


void id3_cvar_list_init_early () {
  // id3.Cvar.dev_enabled.init();      // com_developer
  // id3.Cvar.vm_rtChecks.init();      // vm_rtChecks
  // id3.Cvar.dev_journal.init();      // journal
  // id3.Cvar.list.init.servers(.{});  // sv_master{1,2,3}
  // id3.Cvar.list.init.protocol();    // protocol
  // id3.Cvar.sv_dedicated.init();     // @note Not on the og code. We have to initialize it before we use it later
}  //:: id3.Cvar.list.init.early

