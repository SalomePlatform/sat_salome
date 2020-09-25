#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('PLANEGCS_ROOT_DIR', prereq_dir)    # update for cmake
  root = env.get('PLANEGCS_ROOT_DIR')
  if platform.system() == "Windows" :
    env.prepend('PATH',os.path.join(root, 'lib'))
  else:
    env.prepend('LD_LIBRARY_PATH', os.path.join(root, 'lib'))

def set_nativ_env(env):
    pass
