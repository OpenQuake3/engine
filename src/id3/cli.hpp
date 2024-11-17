//:__________________________________________________________________
//  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
//:__________________________________________________________________
//! @fileoverview id-Tech3 Engine: Command Line Tools
//________________________________________________________________|
#pragma once
// @deps id3
#include "./C.hpp"
#include "./types.hpp"
#include "./cfg/cvar.hpp"
#include "./tools/error.hpp"
#include "./tools/log.hpp"

namespace id3 {

namespace {
namespace is {
  static bool help    (id3::str arg) { return (arg.compare("-h") || arg.compare("--help"))    == 0; }
  static bool version (id3::str arg) { return (arg.compare("-v") || arg.compare("--version")) == 0; }
}
namespace printExit {
  static void help    (void) { id3::exit(id3::str("TODO: HELP GOES HERE"));    };  //:: FIX: Help printing
  static void version (void) { id3::exit(id3::str("TODO: VERSION GOES HERE")); };  //:: FIX: Version printing
}
}


class Cli {Cli* m = this;
public:
using Args = id3::Seq<id3::str>;

private:
id3::Cli::Args    args;
id3::Cvar::Value  title = {""}; // con_title
id3::str          all;
i32               vid_x = 0;
i32               vid_y = 0;

bool parse_early (void) { return id3::C::cli::parse::early(m->all.data(), m->title.data(), m->title.size(), &m->vid_x, &m->vid_y); }

public:
inline Cli () {}
inline Cli (i32 const argc, cstr const argv[argc]) {
  id3::prnt("[id3.cli] Parsing CLI Arguments ...\n");
  for (Sz id=0; id<argc; ++id) {
    m->args.push_back(id3::str(argv[id]));
    if (id != 0) m->all.append(" ");
    m->all.append(argv[id]);
    if (is::help(m->args.back())   ) printExit::help();
    if (is::version(m->args.back())) printExit::version();
  }
  m->parse_early();
  id3::prnt("[id3.cli] Done parsing CLI Arguments.\n");
  if (m->args.size() > 1) id3::prnt("[id3.cli] CLI Arguments found:\n", m->all.data());
} //:: id3.Cli.create

inline ~Cli () {
  m->all.clear();
  /* for (auto arg : m->args) arg.clear(); */
} //:: id3.Cli.destroy

inline id3::str get_all () const { return m->all;}
}; //:: id3.Cli
} //:: id;

