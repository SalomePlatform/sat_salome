#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('SALOMEBOOTSTRAP_ROOT_DIR', prereq_dir)
  if platform.system() == "Windows" :
    pass
  else:
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, '__SALOME_BOOTSTRAP'))

def set_nativ_env(env):
  pass
