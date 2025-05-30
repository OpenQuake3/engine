//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#if !defined H_id3_tools_results
#define H_id3_tools_results

typedef enum id3_Result {
  id3_Ok                = 0,   ///< Generic Success
  id3_Error             = 1,   ///< Generic Error Code
  id3_Test42            = 42,  ///< ID for Testing Purposes
  id3_VersionAndQuit    = 100, ///< Returned when the engine should print the version message and quit immediately
  id3_HelpAndQuit       = 101, ///< Returned when the engine should print the help message and quit immediately
  id3_ShouldNeverHappen = 123, ///< Error code printed by the engine when the code reaches the end of the main function.
  id3_Result_ForceU8    = 255,
} id3_Result;

#endif  // H_id3_tools_results

