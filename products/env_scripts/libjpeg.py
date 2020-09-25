#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  # this prerequisites is only used on windows platform
  if platform.system()=="Windows" :
    env.set('LIBJPEG_DIR', prereq_dir)
    env.set('LIBJPEG_BINDIR', os.path.join(prereq_dir, 'bin'))
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
    env.prepend('LIB', os.path.join(prereq_dir, 'bin'))
  else:
    pass

def set_nativ_env(env):
    pass

    
