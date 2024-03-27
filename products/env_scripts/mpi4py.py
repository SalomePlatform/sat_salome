#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path, platform

def set_env(env, prereq_dir, version):
  if platform.system() == "Windows" :
    pass
  else :
    versionPython = env.get('PYTHON_VERSION')
    env.set("MPI4PY_ROOT_DIR",os.path.join(prereq_dir, 'lib', 'python' + versionPython, 'site-packages'))
    env.prepend("PYTHONPATH",os.path.join(prereq_dir, 'lib', 'python' + versionPython, 'site-packages'))

def set_nativ_env(env):
    pass

