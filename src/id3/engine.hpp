//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
//! @fileoverview id-Tech3 Engine Core Logic and Management Tools
//________________________________________________________________|
#pragma once
// @deps id3
#include "./C.hpp"
#include "./game.hpp"
#include "./cli.hpp"
#include "./tools/log.hpp"
#include "./tools/filesystem.hpp"
#include "./ui/tui.hpp"


namespace id3 {
namespace {
  namespace engine::core {
    void init (id3::Cli const& cli) { id3::C::core::init(cli.get_all().data()); }
  }
  namespace engine::net {
    void init (void) { id3::C::net::init(); }
  }
}
class Engine {Engine* m = this;

id3::Game game;
id3::Cli  cli;
id3::TUI  tui;

inline bool close (void) { return false; }
inline void term (void) { return; }

public:
  //______________________________________
  /// @descr
  ///  Initializes the engine and all its required data.
  ///  Should call {@link Engine.start()} on the resulting object after calling this function.
  /// @return The engine's data object.
  inline Engine (
      id3::Game const G,
      i32       const argc,
      cstr      const argv[argc]
    ) {
    m->cli  = id3::Cli(argc, argv);
    m->game = G;
    id3::engine::core::init(m->cli);
    id3::engine::net::init();
    id3::prnt("[id3.info] Working directory: %s\n", id3::fs::pwd());
    m->tui = id3::TUI();
    id3::prnt("[id3.info] Done Initializing the Engine.\n");
    // TODO: Call InitSig() when defines.server.dedicated
  }

  //______________________________________
  /// @descr
  ///  Starts the engine loop and never returns.
  ///  Takes control of the application as soon as it is called.
  inline void start (void) { return; }
}; //:: id3.Game
} //:: id3

