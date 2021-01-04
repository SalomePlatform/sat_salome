#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('PETSCDIR', prereq_dir)
  env.set('PETSC_ROOT_DIR', prereq_dir)
  env.set('PETSC_DIR', prereq_dir)
  if platform.system() == "Windows" :
    pass
  else:
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
    env.set('PETSC_ARCH', 'arch-linux-c-opt')

def set_nativ_env(env):
  pass
