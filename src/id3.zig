//:______________________________________________________________________
//  id-Tech3 |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:______________________________________________________________________
//! @fileoverview Cable connector to all id-Tech3 Modules
//________________________________________________________|
pub usingnamespace @import("./id3/system.zig");
pub usingnamespace @import("./id3/cli.zig");
pub usingnamespace @import("./id3/tools/log.zig");
pub const mem    = @import("./id3/tools/mem.zig");
pub const cmd    = @import("./id3/tools/commands.zig");
pub const fs     = @import("./id3/tools/filesystem.zig");
pub const Cfg    = @import("./id3/cfg.zig").Cfg;
pub const Cvar   = Cfg.Cvar;
pub const Game   = @import("./id3/game.zig");
pub const Engine = @import("./id3/engine.zig");
