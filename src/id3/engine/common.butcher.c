
void Com_Init (char* commandLine) {
  char const* s;
  int         qport;

  // // get the initial time base
  // Sys_Milliseconds();

  // Com_Printf("%s %s %s\n", SVN_VERSION, PLATFORM_STRING, __DATE__);

  // if (Q_setjmp(abortframe)) { Sys_Error("Error during initialization"); }

  // bk001129 - do this before anything else decides to push events
  // Com_InitPushEvent();

  // Com_InitSmallZoneMemory();
  // Cvar_Init();

#if defined(_WIN32) && defined(_DEBUG)
  com_noErrorInterrupt = Cvar_Get("com_noErrorInterrupt", "0", 0);
#endif

#ifdef DEFAULT_GAME
  Cvar_Set("fs_game", DEFAULT_GAME);
#endif

  // prepare enough of the subsystems to handle
  // cvar and command buffer management
  // Com_ParseCommandLine(commandLine);

  // //	Swap_Init ();
  // Cbuf_Init();

  // override anything from the config files with command line args
  // Com_StartupVariable(NULL);

  // Com_InitZoneMemory();
  Cmd_Init();

  // get the developer cvar set as early as possible
  Com_StartupVariable("developer");
  com_developer = Cvar_Get("developer", "0", CVAR_TEMP);
  Cvar_CheckRange(com_developer, NULL, NULL, CV_INTEGER);

  Com_StartupVariable("vm_rtChecks");
  vm_rtChecks = Cvar_Get("vm_rtChecks", "15", CVAR_INIT | CVAR_PROTECTED);
  Cvar_CheckRange(vm_rtChecks, "0", "15", CV_INTEGER);
  Cvar_SetDescription(
    vm_rtChecks,
    "Runtime checks in compiled vm code, bitmask:\n 1 - program stack overflow\n"
    " 2 - opcode stack overflow\n 4 - jump target range\n 8 - data read/write range"
  );

  Com_StartupVariable("journal");
  com_journal = Cvar_Get("journal", "0", CVAR_INIT | CVAR_PROTECTED);
  Cvar_CheckRange(com_journal, "0", "2", CV_INTEGER);
  Cvar_SetDescription(com_journal, "When enabled, writes events and its data to 'journal.dat' and 'journaldata.dat'.");

  Com_StartupVariable("sv_master1");
  Com_StartupVariable("sv_master2");
  Com_StartupVariable("sv_master3");
  Cvar_Get("sv_master1", MASTER_SERVER_NAME, CVAR_INIT);
  Cvar_Get("sv_master2", "master.ioquake3.org", CVAR_INIT);
  Cvar_Get("sv_master3", "master.maverickservers.com", CVAR_INIT);

  com_protocol = Cvar_Get("protocol", XSTRING(DEFAULT_PROTOCOL_VERSION), 0);
  Cvar_SetDescription(com_protocol, "Specify network protocol version number, use -compat suffix for OpenArena compatibility.");
  if (Q_stristr(com_protocol->string, "-compat") > com_protocol->string) {
    // strip -compat suffix
    Cvar_Set2("protocol", va("%i", com_protocol->integer), qtrue);
    // enforce legacy stream encoding but with new challenge format
    com_protocolCompat = qtrue;
  } else {
    com_protocolCompat = qfalse;
  }

  Cvar_CheckRange(com_protocol, "0", NULL, CV_INTEGER);
  com_protocol->flags &= ~CVAR_USER_CREATED;
  com_protocol->flags |= CVAR_SERVERINFO | CVAR_ROM;

  // done early so bind command exists
  Com_InitKeyCommands();

  FS_InitFilesystem();

  com_logfile = Cvar_Get("logfile", "0", CVAR_TEMP);
  Cvar_CheckRange(com_logfile, "0", "4", CV_INTEGER);
  Cvar_SetDescription(
    com_logfile,
    "System console logging:\n"
    " 0 - disabled\n"
    " 1 - overwrite mode, buffered\n"
    " 2 - overwrite mode, synced\n"
    " 3 - append mode, buffered\n"
    " 4 - append mode, synced\n"
  );

  Com_InitJournaling();

  Com_ExecuteCfg();

  // override anything from the config files with command line args
  Com_StartupVariable(NULL);

  // get dedicated here for proper hunk megs initialization
#ifdef DEDICATED
  com_dedicated = Cvar_Get("dedicated", "1", CVAR_INIT);
  Cvar_CheckRange(com_dedicated, "1", "2", CV_INTEGER);
#else
  com_dedicated = Cvar_Get("dedicated", "0", CVAR_LATCH);
  Cvar_CheckRange(com_dedicated, "0", "2", CV_INTEGER);
#endif
  Cvar_SetDescription(com_dedicated, "Enables dedicated server mode.\n 0: Listen server\n 1: Unlisted dedicated server \n 2: Listed dedicated server");
  // allocate the stack based hunk allocator
  Com_InitHunkMemory();

  // if any archived cvars are modified after this, we will trigger a writing
  // of the config file
  cvar_modifiedFlags &= ~CVAR_ARCHIVE;

  //
  // init commands and vars
  //
#ifndef DEDICATED
  com_maxfps = Cvar_Get("com_maxfps", "125", 0);  // try to force that in some light way
  Cvar_CheckRange(com_maxfps, "0", "1000", CV_INTEGER);
  Cvar_SetDescription(com_maxfps, "Sets maximum frames per second.");
  com_maxfpsUnfocused = Cvar_Get("com_maxfpsUnfocused", "60", CVAR_ARCHIVE_ND);
  Cvar_CheckRange(com_maxfpsUnfocused, "0", "1000", CV_INTEGER);
  Cvar_SetDescription(com_maxfpsUnfocused, "Sets maximum frames per second in unfocused game window.");
  com_yieldCPU = Cvar_Get("com_yieldCPU", "1", CVAR_ARCHIVE_ND);
  Cvar_CheckRange(com_yieldCPU, "0", "16", CV_INTEGER);
  Cvar_SetDescription(
    com_yieldCPU,
    "Attempt to sleep specified amount of time between rendered frames when game is active, this will greatly reduce CPU load. Use 0 only if you're "
    "experiencing some lag."
  );
#endif

#ifdef USE_AFFINITY_MASK
  com_affinityMask = Cvar_Get("com_affinityMask", "", CVAR_ARCHIVE_ND);
  Cvar_SetDescription(
    com_affinityMask,
    "Bind game process to bitmask-specified CPU core(s), special characters:\n A or a - all default cores\n P or p - performance cores\n E or e - efficiency "
    "cores\n 0x<value> - use hexadecimal notation\n + or - can be used to add or exclude particular cores"
  );
  com_affinityMask->modified = qfalse;
#endif

  // com_blood = Cvar_Get( "com_blood", "1", CVAR_ARCHIVE_ND );

  com_timescale = Cvar_Get("timescale", "1", CVAR_CHEAT | CVAR_SYSTEMINFO);
  Cvar_CheckRange(com_timescale, "0", NULL, CV_FLOAT);
  Cvar_SetDescription(com_timescale, "System timing factor:\n < 1: Slows the game down\n = 1: Regular speed\n > 1: Speeds the game up");
  com_fixedtime = Cvar_Get("fixedtime", "0", CVAR_CHEAT);
  Cvar_SetDescription(
    com_fixedtime, "Toggle the rendering of every frame the game will wait until each frame is completely rendered before sending the next frame."
  );
  com_showtrace = Cvar_Get("com_showtrace", "0", CVAR_CHEAT);
  Cvar_SetDescription(com_showtrace, "Debugging tool that prints out trace information.");
  com_viewlog = Cvar_Get("viewlog", "0", 0);
  Cvar_SetDescription(com_viewlog, "Toggle the display of the startup console window over the game screen.");
  com_speeds = Cvar_Get("com_speeds", "0", 0);
  Cvar_SetDescription(com_speeds, "Prints speed information per frame to the console. Used for debugging.");
  com_cameraMode = Cvar_Get("com_cameraMode", "0", CVAR_CHEAT);

#ifndef DEDICATED
  com_timedemo = Cvar_Get("timedemo", "0", 0);
  Cvar_CheckRange(com_timedemo, "0", "1", CV_INTEGER);
  Cvar_SetDescription(com_timedemo, "When set to '1' times a demo and returns frames per second like a benchmark.");
  cl_paused = Cvar_Get("cl_paused", "0", CVAR_ROM);
  Cvar_SetDescription(
    cl_paused, "Read-only CVAR to toggle functionality of paused games (the variable holds the status of the paused flag on the client side)."
  );
  cl_packetdelay = Cvar_Get("cl_packetdelay", "0", CVAR_CHEAT);
  Cvar_SetDescription(cl_packetdelay, "Artificially set the client's latency. Simulates packet delay, which can lead to packet loss.");
  com_cl_running = Cvar_Get("cl_running", "0", CVAR_ROM | CVAR_NOTABCOMPLETE);
  Cvar_SetDescription(com_cl_running, "Can be used to check the status of the client game.");
#endif

  sv_paused      = Cvar_Get("sv_paused", "0", CVAR_ROM);
  sv_packetdelay = Cvar_Get("sv_packetdelay", "0", CVAR_CHEAT);
  Cvar_SetDescription(sv_packetdelay, "Simulates packet delay, which can lead to packet loss. Server side.");
  com_sv_running = Cvar_Get("sv_running", "0", CVAR_ROM | CVAR_NOTABCOMPLETE);
  Cvar_SetDescription(com_sv_running, "Communicates to game modules if there is a server currently running.");

  com_buildScript = Cvar_Get("com_buildScript", "0", 0);
  Cvar_SetDescription(com_buildScript, "Loads all game assets, regardless whether they are required or not.");

  Cvar_Get("com_errorMessage", "", CVAR_ROM | CVAR_NORESTART);

#ifndef DEDICATED
  com_introPlayed = Cvar_Get("com_introplayed", "1", CVAR_ARCHIVE);
  Cvar_SetDescription(com_introPlayed, "Skips the introduction cinematic.");
  com_skipIdLogo = Cvar_Get("com_skipIdLogo", "1", CVAR_ARCHIVE);
  Cvar_SetDescription(com_skipIdLogo, "Skip playing Id Software logo cinematic at startup.");
#endif

  if (com_dedicated->integer) {
    if (!com_viewlog->integer) { Cvar_Set("viewlog", "1"); }
    gw_minimized = qtrue;
  } else {
    gw_minimized = qfalse;
  }

  if (com_developer->integer) {
    Cmd_AddCommand("error", Com_Error_f);
    Cmd_AddCommand("crash", Com_Crash_f);
    Cmd_AddCommand("freeze", Com_Freeze_f);
  }

  Cmd_AddCommand("quit", Com_Quit_f);
  Cmd_AddCommand("changeVectors", MSG_ReportChangeVectors_f);
  Cmd_AddCommand("writeconfig", Com_WriteConfig_f);
  Cmd_SetCommandCompletionFunc("writeconfig", Cmd_CompleteWriteCfgName);
  Cmd_AddCommand("game_restart", Com_GameRestart_f);

  s           = va("%s %s %s", Q3_VERSION, PLATFORM_STRING, __DATE__);
  com_version = Cvar_Get("version", s, CVAR_PROTECTED | CVAR_ROM | CVAR_SERVERINFO);
  Cvar_SetDescription(com_version, "Read-only CVAR to see the version of the game.");

  // this cvar is the single entry point of the entire extension system
  Cvar_Get("//trap_GetValue", va("%i", COM_TRAP_GETVALUE), CVAR_PROTECTED | CVAR_ROM | CVAR_NOTABCOMPLETE);

  Sys_Init();

  // CPU detection
  Cvar_Get("sys_cpustring", "detect", CVAR_PROTECTED | CVAR_ROM | CVAR_NORESTART);
  if (!Q_stricmp(Cvar_VariableString("sys_cpustring"), "detect")) {
    char vendor[128];
    Com_Printf("...detecting CPU, found ");
    Sys_GetProcessorId(vendor);
    Cvar_Set("sys_cpustring", vendor);
  }
  Com_Printf("%s\n", Cvar_VariableString("sys_cpustring"));

#ifdef USE_AFFINITY_MASK
  // get initial process affinity - we will respect it when setting custom affinity masks
  eCoreMask = pCoreMask = affinityMask = Sys_GetAffinityMask();
#if (idx64 || id386)
  DetectCPUCoresConfig();
#endif
  if (com_affinityMask->string[0] != '\0') {
    Com_SetAffinityMask(com_affinityMask->string);
    com_affinityMask->modified = qfalse;
  }
#endif

  // Pick a random port value
  Com_RandomBytes((byte*)&qport, sizeof(qport));
  Netchan_Init(qport & 0xff'ff);

  VM_Init();
  SV_Init();

  com_dedicated->modified = qfalse;

#ifndef DEDICATED
  if (!com_dedicated->integer) {
    CL_Init();
    // Sys_ShowConsole( com_viewlog->integer, qfalse ); // moved down
  }
#endif

  // add + commands from command line
  if (!Com_AddStartupCommands()) {
    // if the user didn't give any commands, run default action
    if (!com_dedicated->integer) {
#ifndef DEDICATED
      if (!com_skipIdLogo || !com_skipIdLogo->integer) Cbuf_AddText("cinematic idlogo.RoQ\n");
      if (!com_introPlayed->integer) {
        Cvar_Set(com_introPlayed->name, "1");
        Cvar_Set("nextmap", "cinematic intro.RoQ");
      }
#endif
    }
  }

#ifndef DEDICATED
  CL_StartHunkUsers();
#endif

  // set com_frameTime so that if a map is started on the
  // command line it will still be able to count on com_frameTime
  // being random enough for a serverid
  // lastTime = com_frameTime = Com_Milliseconds();
  Com_FrameInit();

  if (!com_errorEntered) Sys_ShowConsole(com_viewlog->integer, qfalse);

#ifndef DEDICATED
  // make sure single player is off by default
  Cvar_Set("ui_singlePlayerActive", "0");
#endif

  com_fullyInitialized = qtrue;

  Com_Printf("--- Common Initialization Complete ---\n");

  NET_Init();

  Com_Printf("Working directory: %s\n", Sys_Pwd());
}
