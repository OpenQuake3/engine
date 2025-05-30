//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "./cvar.h"


id3_Cvar* id3_cvar_create (
  cstr const                     name,
  cstr const                     value,
  id3_cvar_Flags                 flags,
  cstr const std_pragma_Nullable description
) {
  id3_Cvar* result = id3_cvar_get(name, value, flags);
  if (description) id3_cvar_description_set(result, description);
  return result;
}

