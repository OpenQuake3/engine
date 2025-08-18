//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
// @deps std
#include "../idtech3/tools/unsafe.h"
// @note Should not be forwarded from `../tools.h`

typedef jmp_buf id3_unsafe_jmp_Buffer;

/// @description
/// Calls setjmp and returns true if it was successful  (aka. the result was equal to 0 (Ok))
/// @note Equivalent to Q_setjmp
/// @unsafe Can create issues with application flow. Should only be used to replicate the native/original C behavior.
#define id3_unsafe_jmp_set(common) (Q_setjmp((common)->abortframe))

