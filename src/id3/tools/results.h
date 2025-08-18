//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#if !defined H_id3_tools_results
#define H_id3_tools_results

#include "../idtech3/tools/errors.h"
#include "../idtech3/system/errors.h"

typedef enum id3_Result {  // clang-format off
  id3_Ok                = 0,    ///< Generic Success
  id3_Error             = 1,    ///< Generic Error Code
  id3_Test42            = 42,   ///< ID for Testing Purposes
  id3_VersionAndQuit    = 100,  ///< Returned when the engine should print the version message and quit immediately
  id3_HelpAndQuit       = 101,  ///< Returned when the engine should print the help message and quit immediately
  id3_ShouldNeverHappen = 123,  ///< Error code printed by the engine when the code reaches the end of the main function.
  // Original Codes
  id3_DisconnectServer  = ERR_SERVERDISCONNECT,  ///< Won't kill server
  id3_DisconnectClient  = ERR_DISCONNECT,        ///< Client disconnected from the server
  id3_NeedGameCD        = ERR_NEED_CD,           ///< PopUp the need-cd dialog
  // TODO: Conflicting IDs
  // ERR_FATAL = 0, ///< Exit the entire game with a popup window
  // ERR_DROP  = 1, ///< Print to console and disconnect from game
  /// Force enum size to sizeof(u8)
  id3_Result_ForceU8    = 255,
} id3_Result;  // clang-format on

#define id3_error     Com_Error
#define id3_sys_error Sys_Error

#endif  // H_id3_tools_results

