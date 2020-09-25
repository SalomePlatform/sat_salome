#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('FREEIMAGEDIR', prereq_dir)
  env.set('FREEIMAGE_ROOT_DIR', prereq_dir)    # update for cmake
  env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
  if platform.system() == "Windows" :
    env.prepend('LIBS', os.path.join(prereq_dir, 'lib'))
  else:
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env):
    # CAS KO on UB16 with this vars set because /usr/lib/x86_64-linux-gnu/libfreeimage.so is not found
    #env.set('FREEIMAGE_ROOT_DIR', '/usr')    # update for cmake
    #env.set('FREEIMAGEDIR', '/usr')
    pass
