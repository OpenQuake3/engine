//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#include "./time.h"

id3_Time id3_time_defaults () {
  return (id3_Time){
    .data    = (std_Time){},
    .last    = 0,
    .current = 0,
  };
}

#if defined _WIN32
static id3_Time id3_time_start_win () {
  id3_Time result = id3_time_defaults();
  QueryPerformanceFrequency(&result.data);
  return result;
}

#elif defined __APPLE__
static id3_Time id3_time_start_mac () {
  id3_Time result = id3_time_defaults();
  mach_timebase_info(&result.data);
  return result;
}

#else // posix
static id3_Time id3_time_start_lnx () {
  id3_Time result = id3_time_defaults();
  clock_getres(NS_CLOCK_ID, &result.data);
  return result;
}
#endif

id3_Time id3_time_start () {
  #if defined _WIN32
  return id3_time_start_win();
  #elif defined __APPLE__
  return id3_time_start_mac();
  #elif defined __unix__
  return id3_time_start_lnx();
  #else
  #error "Could not start the Monotonic Clock"
  #endif
}

#if defined _WIN32
static id3_Nanosecs id3_time_nsec_win (id3_Time* const clock) {
  std_Time time;
  QueryPerformanceCounter(&time);
  clock->last = clock->current;
  clock->current = (id3_Nanosecs)((1.0e9 * time.QuadPart) / clock->data.QuadPart);
  return clock->current;
}

#elif defined __APPLE__
static id3_Nanosecs id3_time_nsec_mac (id3_Time* const clock) {
  clock->last = clock->current;
  clock->current = mach_absolute_time();
  clock->current *= clock->data.numer;
  clock->current /= clock->data.denom;
  return clock->current;
}

#else // posix
static id3_Nanosecs id3_time_nsec_lnx (id3_Time* const clock) {
  std_Time time;
  clock->last = clock->current;
  clock_gettime(NS_CLOCK_ID, &time);
  clock->current = (id3_Nanosecs)time.tv_sec * (id3_Nanosecs)1.0e9 + (id3_Nanosecs)time.tv_nsec;
  return clock->current;
}
#endif

id3_Nanosecs id3_time_nsec (id3_Time* const clock) {
  #if defined _WIN32
  return id3_time_nsec_win(clock);
  #elif defined __APPLE__
  return id3_time_nsec_mac(clock);
  #elif defined __unix__
  return id3_time_nsec_lnx(clock);
  #else
  #error "Monotonic Clock not supported on this platform"
  #endif
}

