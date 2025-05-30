//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
//! @fileoverview
//! Declarations of base aliases, tools and types.
//! Used by all id-Tech3 modules.
//! @note Contains declarations from:
//!  `qcommon.h`, `q_shared.h`, `q_platform.h`
//_________________________________________________|
#if !defined H_id3_idtech3_base
#define H_id3_idtech3_base


#if defined(__GNUC__) || defined(__clang__)
#define NORETURN     __attribute__((noreturn))
#define NORETURN_PTR __attribute__((noreturn))
#elif defined(_MSC_VER)
#define NORETURN     __declspec(noreturn)
// __declspec doesn't work on function pointers
#define NORETURN_PTR /* nothing */
#else
#define NORETURN     /* nothing */
#define NORETURN_PTR /* nothing */
#endif

#if defined(__GNUC__) || defined(__clang__)
#define FORMAT_PRINTF(x, y) __attribute__((format(printf, x, y)))
#else
#define FORMAT_PRINTF(x, y) /* nothing */
#endif

#define QDECL
#ifdef _WIN32
#undef QDECL
#define QDECL __cdecl
#endif

typedef enum { qfalse = 0, qtrue } qboolean;

#endif  // H_id3_idtech3_base

