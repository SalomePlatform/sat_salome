#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('MMG_ROOT_DIR', prereq_dir)
  env.prepend('PATH', os.path.join(prereq_dir, 'bin'))

def set_nativ_env(env):
  pass
