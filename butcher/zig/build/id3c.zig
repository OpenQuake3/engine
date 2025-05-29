//______________________________________
// @section System-specific Files
//____________________________
pub const Unix :FileList= &.{
  src++"/unix/unix_main.c",
  src++"/unix/unix_shared.c",
  src++"/unix/linux_signals.c",
  // SDL2
  src++"/sdl/sdl_glimp.c",
  src++"/sdl/sdl_input.c",
  src++"/sdl/sdl_gamma.c",
  src++"/sdl/sdl_snd.c",
}; //:: id3c.Unix


//______________________________________
// @section Engine Core
//____________________________
pub const Core :FileList= &.{
  src++"/qcommon/common.c",         // Core
  src++"/qcommon/q_shared.c",       // Shared Core
  src++"/qcommon/cvar.c",           // Cvars
  src++"/qcommon/cmd.c",            // Commands
  src++"/qcommon/q_math.c",         // Math
  // Virtual Machine
  src++"/qcommon/vm.c",             // : Core
  src++"/qcommon/vm_interpreted.c", // : Interpreter
  vm_archCode,                      // : CPU/Architecture-specific tools
  // Console
  src++"/qcommon/history.c",        // : History
  // Filesystem
  src++"/qcommon/files.c",          // : Core
  src++"/qcommon/md4.c",            // : MD4
  src++"/qcommon/md5.c",            // : MD5
  src++"/qcommon/unzip.c",          // : UnZip
  src++"/qcommon/puff.c",           // : Puff Deflate
  // Input
  src++"/qcommon/keys.c",           // : Keys
  // Collision Map
  src++"/qcommon/cm_load.c",        // : Load
  src++"/qcommon/cm_patch.c",       // : Patch Tools
  src++"/qcommon/cm_test.c",        // : Testing
  src++"/qcommon/cm_trace.c",       // : Tracing
  src++"/qcommon/cm_polylib.c",     // : Polygon Visualization Library (for debugging)
  // Network
  src++"/qcommon/msg.c",            // : Messages
  src++"/qcommon/net_chan.c",       // : Channel
  src++"/qcommon/net_ip.c",         // : IP Address Tools
  src++"/qcommon/huffman.c",        // : Huffman
  src++"/qcommon/huffman_static.c", // : Huffman Static
}; //:: id3c.Core
const vm_archCode =
  if      (sys.cpu.arch.isX86())     src++"/qcommon/vm_x86.c"
  else if (sys.cpu.arch.isAARCH64()) src++"/qcommon/vm_aarch64.c";


//______________________________________
// @section Engine Client
//____________________________
pub const Client :FileList= &.{
  src++"/client/cl_main.c",       // Entry Point
  src++"/client/cl_console.c",    // Command Console
  src++"/client/cl_scrn.c",       // Screen Tools
  src++"/client/cl_ui.c",         // User Interface
  src++"/client/cl_parse.c",      // Parsing Tools
  // Input Manager
  src++"/client/cl_input.c",      // : Entry
  src++"/client/cl_keys.c",       // : Keyboard Keys
  // File Formats
  src++"/client/cl_cin.c",        // : Cinematics
  src++"/client/cl_jpeg.c",       // : JPEG
  src++"/client/cl_avi.c",        // : AVI
  // Game API
  src++"/client/cl_cgame.c",      // : Client Game
  // Map Tools
  src++"/client/cl_tc_vis.c",     // : Visibility
  // Sound
  src++"/client/snd_main.c",      // : Entry
  src++"/client/snd_dma.c",       // : Device Streaming
  src++"/client/snd_codec.c",     // : Codec
  src++"/client/snd_codec_wav.c", // : Codec: WAV Format
  src++"/client/snd_mem.c",       // : Memory Management
  src++"/client/snd_mix.c",       // : Mixing
  src++"/client/snd_adpcm.c",     // : ADPCM encoder/decoder
  src++"/client/snd_wavelet.c",   // : MuLaw Wavelet Tools
  // Network
  src++"/client/cl_net_chan.c",   // : Channel
}; //:: id3c.Client

//______________________________________
// @section Engine Renderer
//____________________________
const R = enum { vk, gl1, gl2,
  const Id = R.vk;
  fn id () cstr { return switch (R.Id) { .gl1=>"1", .gl2=>"2", else => @tagName(R.Id) }; }
};
pub const Renderer :FileList= &.{
  src++"/renderercommon"++"/tr_noise.c",        // Noise
  // API Specific
  src++"/renderer"++R.id()++"/vk.c",            // Vulkan: Entry Point
  src++"/renderer"++R.id()++"/vk_vbo.c",        // Vulkan: Vertex Buffer Object Tools
  src++"/renderer"++R.id()++"/tr_init.c",       // Initializaton
  src++"/renderer"++R.id()++"/tr_main.c",       // Entry Point
  src++"/renderer"++R.id()++"/tr_image.c",      // Image
  src++"/renderer"++R.id()++"/tr_cmds.c",       // Commands
  src++"/renderer"++R.id()++"/tr_backend.c",    // Backend
  src++"/renderer"++R.id()++"/tr_world.c",      // World
  src++"/renderer"++R.id()++"/tr_scene.c",      // Scenes
  src++"/renderer"++R.id()++"/tr_surface.c",    // Surfaces
  src++"/renderer"++R.id()++"/tr_animation.c",  // Animation
  src++"/renderer"++R.id()++"/tr_marks.c",      // Marks
  src++"/renderer"++R.id()++"/tr_shader.c",     // Shaders
  src++"/renderer"++R.id()++"/tr_model.c",      // Model
  src++"/renderer"++R.id()++"/tr_mesh.c",       // Meshes
  src++"/renderer"++R.id()++"/tr_curve.c",      // Curves
  // Lights
  src++"/renderer"++R.id()++"/tr_light.c",      // : Tools
  src++"/renderer"++R.id()++"/vk_flares.c",     // : Flares
  src++"/renderer"++R.id()++"/tr_shadows.c",    // : Shadows
  src++"/renderer"++R.id()++"/tr_sky.c",        // : Sky
  src++"/renderer"++R.id()++"/tr_shade.c",      // : Shading
  src++"/renderer"++R.id()++"/tr_shade_calc.c", // : Shading Calculations
  // File Formats
  src++"/renderer"++R.id()++"/tr_model_iqm.c",  // : IQM Model
  src++"/renderer"++R.id()++"/tr_bsp.c",        // : BSP Map
  src++"/renderercommon"++"/tr_font.c",         // : Fonts
  src++"/renderercommon"++"/tr_image_bmp.c",    // : BMP Images
  src++"/renderercommon"++"/tr_image_tga.c",    // : TGA Images
  src++"/renderercommon"++"/tr_image_pcx.c",    // : PCX Images
  src++"/renderercommon"++"/tr_image_png.c",    // : PNG Images
  src++"/renderercommon"++"/tr_image_jpg.c",    // : JPEG Images
}; //:: id3c.Renderer


//______________________________________
// @section Engine Server
//____________________________
pub const Server :FileList= &.{
  src++"/server/sv_main.c",     // Entry
  src++"/server/sv_init.c",     // Initialization
  src++"/server/sv_world.c",    // World Management
  src++"/server/sv_game.c",     // Game Management
  src++"/server/sv_filter.c",   // Filtering
  src++"/server/sv_bot.c",      // Botlib
  // Client Management
  src++"/server/sv_ccmds.c",    // : Commands
  src++"/server/sv_client.c",   // : Tools
  // Network
  src++"/server/sv_snapshot.c", // : Snapshot
  src++"/server/sv_net_chan.c", // : Channel
}; //:: id3c.Server

pub const lib = struct {
  pub const jpeg :FileList= &.{
    src++"/libjpeg/jaricom.c",
    src++"/libjpeg/jcapimin.c",
    src++"/libjpeg/jcapistd.c",
    src++"/libjpeg/jcarith.c",
    src++"/libjpeg/jccoefct.c",
    src++"/libjpeg/jccolor.c",
    src++"/libjpeg/jcdctmgr.c",
    src++"/libjpeg/jchuff.c",
    src++"/libjpeg/jcinit.c",
    src++"/libjpeg/jcmainct.c",
    src++"/libjpeg/jcmarker.c",
    src++"/libjpeg/jcmaster.c",
    src++"/libjpeg/jcomapi.c",
    src++"/libjpeg/jcparam.c",
    src++"/libjpeg/jcprepct.c",
    src++"/libjpeg/jcsample.c",
    src++"/libjpeg/jctrans.c",
    src++"/libjpeg/jdapimin.c",
    src++"/libjpeg/jdapistd.c",
    src++"/libjpeg/jdarith.c",
    src++"/libjpeg/jdatadst.c",
    src++"/libjpeg/jdatasrc.c",
    src++"/libjpeg/jdcoefct.c",
    src++"/libjpeg/jdcolor.c",
    src++"/libjpeg/jddctmgr.c",
    src++"/libjpeg/jdhuff.c",
    src++"/libjpeg/jdinput.c",
    src++"/libjpeg/jdmainct.c",
    src++"/libjpeg/jdmarker.c",
    src++"/libjpeg/jdmaster.c",
    src++"/libjpeg/jdmerge.c",
    src++"/libjpeg/jdpostct.c",
    src++"/libjpeg/jdsample.c",
    src++"/libjpeg/jdtrans.c",
    src++"/libjpeg/jerror.c",
    src++"/libjpeg/jfdctflt.c",
    src++"/libjpeg/jfdctfst.c",
    src++"/libjpeg/jfdctint.c",
    src++"/libjpeg/jidctflt.c",
    src++"/libjpeg/jidctfst.c",
    src++"/libjpeg/jidctint.c",
    src++"/libjpeg/jmemmgr.c",
    src++"/libjpeg/jmemnobs.c",
    src++"/libjpeg/jquant1.c",
    src++"/libjpeg/jquant2.c",
    src++"/libjpeg/jutils.c",
  }; //:: id3c.lib.jpeg

  pub const bot :FileList= &.{
    src++"/botlib/be_aas_bspq3.c",
    src++"/botlib/be_aas_cluster.c",
    src++"/botlib/be_aas_debug.c",
    src++"/botlib/be_aas_entity.c",
    src++"/botlib/be_aas_file.c",
    src++"/botlib/be_aas_main.c",
    src++"/botlib/be_aas_move.c",
    src++"/botlib/be_aas_optimize.c",
    src++"/botlib/be_aas_reach.c",
    src++"/botlib/be_aas_route.c",
    src++"/botlib/be_aas_routealt.c",
    src++"/botlib/be_aas_sample.c",
    src++"/botlib/be_ai_char.c",
    src++"/botlib/be_ai_chat.c",
    src++"/botlib/be_ai_gen.c",
    src++"/botlib/be_ai_goal.c",
    src++"/botlib/be_ai_move.c",
    src++"/botlib/be_ai_weap.c",
    src++"/botlib/be_ai_weight.c",
    src++"/botlib/be_ea.c",
    src++"/botlib/be_interface.c",
    src++"/botlib/l_crc.c",
    src++"/botlib/l_libvar.c",
    src++"/botlib/l_log.c",
    src++"/botlib/l_memory.c",
    src++"/botlib/l_precomp.c",
    src++"/botlib/l_script.c",
    src++"/botlib/l_struct.c",
  }; //:: id3c.lib.bot
}; //:: id3c.lib

