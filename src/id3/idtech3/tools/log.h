//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#if !defined H_id3_idtech3_tools_log
#define H_id3_idtech3_tools_log
#include "../base.h"

// parameters to the main Error routine
typedef enum {
  ERR_FATAL,             ///< exit the entire game with a popup window
  ERR_DROP,              ///< print to console and disconnect from game
  ERR_SERVERDISCONNECT,  ///< don't kill server
  ERR_DISCONNECT,        ///< client disconnected from the server
  ERR_NEED_CD            ///< pop up the need-cd dialog
} errorParm_t;

void NORETURN FORMAT_PRINTF(2, 3) QDECL Com_Error(errorParm_t level, char const* fmt, ...);
void          FORMAT_PRINTF(1, 2) QDECL Com_Printf(char const* msg, ...);

#endif  // H_id3_idtech3_tools_log

