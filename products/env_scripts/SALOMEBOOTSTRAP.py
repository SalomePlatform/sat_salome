#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('SALOMEBOOTSTRAP_ROOT_DIR', prereq_dir)
  env.set('SALOME_APPLICATION_DIR', prereq_dir)
  env.prepend('PYTHONPATH', os.path.join(prereq_dir, '__SALOME_BOOTSTRAP__'))
  env.prepend('PYTHONPATH', os.path.join(prereq_dir, '__RUN_SALOME__', 'lib', 'salome'))
  if platform.system() == "Windows" :
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, '__RUN_SALOME__', 'lib', 'salome'))
  else:
    env.prepend('PATH', os.path.join(prereq_dir, '__RUN_SALOME__', 'lib', 'salome'))

def set_nativ_env(env):
  pass
