#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('MCUT_ROOT_DIR', prereq_dir)
  env.set('MCUT_VERSION', version)
  env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
  env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env):
  pass
