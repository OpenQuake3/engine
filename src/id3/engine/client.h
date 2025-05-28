#include "../system.h"

typedef struct id3_Client {
  id3_System system;
} id3_Client;

id3_Client id3_cl_init (id3_Args const* const cli);

