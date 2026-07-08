#:__________________________________________________________________
#  oQ3  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
import confy

proc runHost *(trgs :seq[confy.Target]) :confy.Target {.discardable.}=
  for trg in trgs:
    if trg.system != System.host(): continue
    return trg.run()
  return confy.Target() # memory safety. Should never happen

