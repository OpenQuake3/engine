//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview id-Tech3 Math: Random Values
//_____________________________________________|
pub const random = @This();
// @deps id3c
const C = @import("../C.zig");

//______________________________________
/// @descr Fills the given string array with len random bytes, preferably from the OS randomizer
pub const bytes = C.math.random.bytes;

