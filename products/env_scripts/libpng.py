#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  # this prerequisites is only used on windows platform
  if platform.system()=="Windows" :
    env.set('LIBPNG_DIR', prereq_dir)
    env.set('LIBPNG_BINDIR', os.path.join(prereq_dir, 'bin'))
    env.set('LIBPNG_LIBRARY', os.path.join(prereq_dir, 'bin'))
    env.set('LIBPNG_INCLUDE_DIR', os.path.join(prereq_dir, 'include'))
    env.set('PNG_LIBRARIES', os.path.join(prereq_dir, 'bin'))
    env.set('PNG_INCLUDE_DIR', os.path.join(prereq_dir, 'include'))
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
    env.prepend('INCLUDE', os.path.join(prereq_dir, 'include'))
    env.prepend('LIB', os.path.join(prereq_dir, 'bin'))
  else:
    pass

def set_nativ_env(env):
    pass

    
