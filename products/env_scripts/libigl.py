#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('LIBIGL_ROOT_DIR', prereq_dir)
  env.set('LIBIGL_VERSION', version)
  env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
  env.set('LIBIGL_INCLUDE_DIR', os.path.join(prereq_dir, 'include'))

def set_nativ_env(env):
  pass
