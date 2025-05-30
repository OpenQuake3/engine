//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#if !defined H_id3_tools_log
#define H_id3_tools_log

#include "../idtech3/shared.h"
#include "../cstd.h"

// TODO: echo, print, info, warn, err, debug, etc
#if !defined id3_log_Prefix
#define id3_log_Prefix "id3"
#endif
#define id3_log_echo(fmt, ...) Com_Printf(fmt "\n" __VA_OPT__(,) __VA_ARGS__)
#define id3_log_info(fmt, ...) Com_Printf("[" id3_log_Prefix ".info] " fmt "\n" __VA_OPT__(,) __VA_ARGS__)
#define id3_log_warn(fmt, ...) Com_Printf("[" id3_log_Prefix ".warning] " fmt "\n" __VA_OPT__(,) __VA_ARGS__)
#define id3_log_dbg(fmt, ...) Com_DPrintf("[" id3_log_Prefix ".debug] %s %s %s" fmt "\n", __func__, __FILE__, __LINE__ __VA_OPT__(,) __VA_ARGS__)

#endif  // H_id3_tools_log

