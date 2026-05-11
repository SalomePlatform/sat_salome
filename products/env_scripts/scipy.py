#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os
import platform

def set_env(env, prereq_dir, version):
  env.set("SCIPY_ROOT_DIR", prereq_dir)
  if platform.system() == "Windows" :
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'Lib', 'site-packages'))
  else :
    pyver = 'python' + env.get('PYTHON_VERSION')
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))

def set_nativ_env(env):
  pass
