//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
//! @fileoverview Collection of C stdlib aliases and helpers.
//____________________________________________________________|
#if !defined H_id3_cstd
#define H_id3_cstd
// @deps std
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>


//______________________________________
// @section Aliases: Numbers
//____________________________

typedef uint8_t  u8;
typedef int8_t   i8;
typedef uint16_t u16;
typedef int16_t  i16;
typedef uint32_t u32;
typedef int32_t  i32;
typedef uint64_t u64;
typedef int64_t  i64;
typedef size_t   Sz;


//______________________________________
// @section Aliases: Strings
//____________________________

typedef char const* cstr;
typedef cstr const* cstr_list;
#define std_cstr_equal(A,B) strcmp((A),(B)) == 0
#define std_cstr_equal_caseInsensitive(A,B) strcmpi((A),(B)) == 0
#define std_cstr_add(A,B) strcat((A),(B))
#define std_cstr_len(A) strlen((A))



//______________________________________
// @section Aliases: General Purpose Tools
//____________________________

#define std_discard(arg) (void)((arg))
#define std_exit(code) exit((int)code)



//______________________________________
// @section Aliases: Memory Management Tools
//____________________________

#define std_alloc(T,len) (T)malloc((len))
#define std_free(P) free((P))



//______________________________________
// @section Aliases: Compiler Pragmas
//____________________________

#if !defined std_pragma_Pure
/// @description
/// Inform the compiler that the marked function must have no side effects
#define std_pragma_Pure __attribute__((const))
#endif

#if !defined std_pragma_NoReturn
/// @description
/// Inform the compiler that the marked function will never return
#define std_pragma_NoReturn [[noreturn]]
#endif

#if !defined std_pragma_MayNotReturn
/// @description
/// Information marker for functions that may potentially not return in one of their branches
#define std_pragma_MayNotReturn /** May Not Return */
#endif

#if !defined std_pragma_Nullable
/// @description
/// Information marker for values that can potentially be null
#define std_pragma_Nullable /** Nullable */
#endif

#endif  // H_id3_cstd

