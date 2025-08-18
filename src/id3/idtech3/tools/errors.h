//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#ifndef H_id3_idtech3_tools_errors
#define H_id3_idtech3_tools_errors
#include "../base.h"


// parameters to the main Error routine
typedef enum {
  ERR_FATAL,             ///< Exit the entire game with a popup window
  ERR_DROP,              ///< Print to console and disconnect from game
  ERR_SERVERDISCONNECT,  ///< Won't kill server
  ERR_DISCONNECT,        ///< Client disconnected from the server
  ERR_NEED_CD            ///< PopUp the need-cd dialog
} errorParm_t;

void NORETURN FORMAT_PRINTF(2, 3) QDECL Com_Error(errorParm_t level, char const* fmt, ...);


#endif  // H_id3_idtech3_tools_errors

