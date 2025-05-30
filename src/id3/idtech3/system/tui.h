
typedef enum {
  id3_tui_Enabled,   //< Alias for TTY_ENABLED
  id3_tui_Disabled,  //< Alias for TTY_DISABLED
  id3_tui_Error      //< Alias for TTY_ERROR
} id3_tui_Status;    //< Alias for tty_err

id3_tui_Status Sys_ConsoleInputInit (void);

