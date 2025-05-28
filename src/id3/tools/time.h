//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
//! @fileoverview Cross-platform Monotonic timer
//_______________________________________________|
#if !defined H_id3_tools_time
#define H_id3_tools_time


//______________________________________
// @section stdlib: Monotonic Clock Dependencies
//____________________________
#include <stdint.h>

//__________________
// Mac
#if defined __APPLE__
  #include <mach/mach_time.h>
  typedef mach_timebase_info_data_t std_Time;

//__________________
// Windows
#elif defined _WIN32
  #include <windows.h>
  typedef LARGE_INTEGER std_Time;

//__________________
// Linux & BSD
#elif defined __unix__
  #ifdef _POSIX_C_SOURCE
    #define NS_OLD_POSIX_C_SOURCE _POSIX_C_SOURCE
    #undef _POSIX_C_SOURCE
  #endif

  #define _POSIX_C_SOURCE 199309L

  #pragma GCC diagnostic push
  #pragma GCC diagnostic ignored "-Wreserved-macro-identifier"
  #ifndef __USE_POSIX199309
    #define __USE_POSIX199309
    #define NS_DEFINED__USE_POSIX199309
  #endif

  #include <time.h>
  #ifdef NS_DEFINED__USE_POSIX199309
    #undef __USE_POSIX199309
  #endif
  #pragma GCC diagnostic pop // "-Wreserved-macro-identifier"

  #ifdef NS_OLD_POSIX_C_SOURCE
    #undef _POSIX_C_SOURCE
    #define _POSIX_C_SOURCE NS_OLD_POSIX_C_SOURCE
  #endif
  #ifdef CLOCK_MONOTONIC
    #define NS_CLOCK_ID CLOCK_MONOTONIC
  #else
    #define NS_CLOCK_ID CLOCK_REALTIME
  #endif
  typedef struct timespec std_Time;
#else // unknown
#error "Monotonic Clock not supported on this platform"
#endif


//______________________________________
// @section Time Management Tools
//____________________________

/// Nanoseconds Data
typedef uint64_t id3_Nanosecs;
/// Monotonic Clock Data
typedef struct id3_Time {
  std_Time data;
  id3_Nanosecs last;
  id3_Nanosecs current;
} id3_Time;

id3_Time     id3_time_defaults ();
id3_Time     id3_time_start ();
id3_Nanosecs id3_time_nsec (id3_Time* const clock);


#endif  // H_id3_tools_time

