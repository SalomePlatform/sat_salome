#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  if platform.system() == "Windows" :
    env.set('PYREADLINE_ROOT_DIR', prereq_dir)
  else:
    env.set('PYREADLINE_ROOT_DIR', env.get('PYTHON_ROOT_DIR'))
    
def set_nativ_env(env):
    env.set('PYREADLINE_ROOT_DIR', env.get('PYTHON_ROOT_DIR'))
