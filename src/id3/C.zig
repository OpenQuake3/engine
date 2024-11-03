pub const C = @This();

//______________________________________
// @section C wrapper
//____________________________
const c = struct {
  //______________________________________
  // @section System
  //____________________________
  extern fn Sys_Milliseconds () c_int;

  //______________________________________
  // @section Core
  //____________________________
  extern fn Com_Init (commandLine :[*c]u8) void;
};


//______________________________________
// @section System
//____________________________
pub const sys = struct {
  pub const milliseconds = c.Sys_Milliseconds;
};

//______________________________________
// @section Core
//____________________________
pub const core = struct {
  pub const init = c.Com_Init;
};

