#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform
import re

def set_env(env, prereq_dir, version):
  pyver = 'python' + env.get('PYTHON_VERSION')
  env.set('SALOMEBOOTSTRAP_ROOT_DIR', prereq_dir)
  env.set('SALOME_APPLICATION_DIR', prereq_dir)
  env.prepend('PYTHONPATH', os.path.join(prereq_dir, '__SALOME_BOOTSTRAP__'))
  if re.match(r'^V9_[1][0-5]_[0]$', version):
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, '__RUN_SALOME__', 'lib', 'salome'))
  else:
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, '__RUN_SALOME__', 'lib', pyver, 'site-packages'))
  if platform.system() == "Windows" :
    env.prepend('PATH', os.path.join(prereq_dir, '__RUN_SALOME__', 'lib', 'salome'))
  else:
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, '__RUN_SALOME__', 'lib', 'salome'))

def set_nativ_env(env):
  pass
