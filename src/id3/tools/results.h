//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#if !defined H_id3_tools_results
#define H_id3_tools_results

typedef enum id3_Result {
  id3_Ok                = 0,
  id3_ShouldNeverHappen = 123,
  id3_Result_ForceU8    = 255,
} id3_Result;

#endif  // H_id3_tools_results

