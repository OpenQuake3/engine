//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @private
//! @fileoverview
//!  Unsafe C tools. Should avoid at all costs.
//!  They are very prone to Undefined Behavior and Memory Leaks.
//_______________________________________________________________|
pub const unsafe = @This();


//______________________________________
// @internal
// @section Mappings to C symbol names
//____________________________
const C = struct {
  const jmp = struct {
    const __sigset_t = extern struct {
      __val: [16]c_ulong = @import("std").mem.zeroes([16]c_ulong),
    };
    const sigset_t = __sigset_t;
    const __jmp_buf = [8]c_long;
    const __jmp_buf_tag = extern struct {
      __jmpbuf         : __jmp_buf  = @import("std").mem.zeroes(__jmp_buf),
      __mask_was_saved : c_int      = @import("std").mem.zeroes(c_int),
      __saved_mask     : __sigset_t = @import("std").mem.zeroes(__sigset_t),
    };
    const jmp_buf    = [1]__jmp_buf_tag;
    const sigjmp_buf = [1]__jmp_buf_tag;

    extern fn _setjmp     (__env :[*c]__jmp_buf_tag) c_int;
    extern fn _longjmp    (__env :[*c]__jmp_buf_tag, __val :c_int) noreturn;
    extern fn __sigsetjmp (__env :[*c]__jmp_buf_tag, __savemask :c_int) c_int;
    extern fn siglongjmp  (__env :[*c]__jmp_buf_tag, __val :c_int) noreturn;
    const setjmp    = C.jmp._setjmp;
    const longjmp   = C.jmp._longjmp;
    const sigsetjmp = C.jmp.__sigsetjmp;
  };
};


//______________________________________
// @section C jmp Tools
//____________________________
pub const jmp        = struct {
  const state        = struct {
    extern var abortframe :C.jmp.jmp_buf;
  };
  pub const Buffer   = C.jmp.jmp_buf;
  //______________________________________
  /// @descr Calls setjmp and returns true if it was successful  (aka. the result was equal to 0 (Ok))
  /// @note Equivalent to Q_setjmp
  /// @unsafe Can create issues with defer and application flow. Should only be used to replicate the native/original C behavior.
  pub inline fn set () bool { return 0 == C.jmp.setjmp(@as([*c]C.jmp.__jmp_buf_tag, @ptrCast(@alignCast(&state.abortframe)))); }

  pub const long     = struct {
    pub const set    = C.jmp.sigsetjmp;
  }; //:: id3.unsafe.jmp.long

  pub const sig      = struct {
    pub const Buffer = C.jmp.sigjmp_buf;
    pub const set    = C.jmp.sigsetjmp;
  }; //:: id3.unsafe.jmp.sig
}; //:: id3.unsafe.jmp

