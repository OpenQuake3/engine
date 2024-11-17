//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
#pragma once

using qboolean = bool;
extern "C" {
//______________________________________
// @section CLI
//____________________________
qboolean Com_EarlyParseCmdLine(char* commandLine, char* con_title, int title_size, int* vid_xpos, int* vid_ypos);

//______________________________________
// @section System
//____________________________
// Types
enum tui_Status { TTY_ENABLED, TTY_DISABLED, TTY_ERROR };
// Functions
const char*       Sys_Pwd(void);
void              Sys_ConfigureFPU(void);
[[noreturn]] void Sys_Quit(void);
int               Sys_Milliseconds(void);
tui_Status        Sys_ConsoleInputInit(void);
void              IN_Init(void);
void              IN_Frame(void);
void              IN_Shutdown(void);

//______________________________________
// @section Tools
//____________________________
// Logging
void Com_Printf(const char* msg, ...);
void Sys_Error(const char* error, ...);

//______________________________________
// @section Core
//____________________________
void Com_Init(char* commandLine);
void Com_Frame(qboolean noDelay);

//______________________________________
// @section Network
//____________________________
void NET_Init(void);
}

namespace id3::C::cli::parse {
inline constexpr auto &early = Com_EarlyParseCmdLine;
}  // namespace id3::C::cli::parse

namespace id3::C::core {
inline constexpr auto &init = Com_Init;
}  // namespace id3::C::core

namespace id3::C::net {
inline constexpr auto &init = NET_Init;
}  // namespace id3::C::net

namespace id3::C::sys {
inline constexpr auto &pwd = Sys_Pwd;
inline constexpr auto &err = Sys_Error;
}  // namespace id3::C::sys

namespace id3::C::sys::time {
inline constexpr auto &milliseconds = Sys_Milliseconds;
}  // namespace id3::C::sys::time

namespace id3::C::sys::FPU {
inline constexpr auto &configure = Sys_ConfigureFPU;
}  // namespace id3::C::sys::FPU

namespace id3::C::sys::input {
inline constexpr auto &update = IN_Frame;
}  // namespace id3::C::sys::input

namespace id3::C::log {
inline constexpr auto &info = Com_Printf;
}  // namespace id3::C::log

