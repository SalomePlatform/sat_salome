#!/usr/bin/env python

import os.path, platform

def set_env(env, prereq_dir, version):
  env.set("NLOPT_ROOT_DIR",prereq_dir)
  pyver = 'python' + env.get('PYTHON_VERSION')
  if platform.system() == "Windows" :
    env.prepend('PATH',os.path.join(prereq_dir, 'bin'))
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
  else :
    env.prepend('LD_LIBRARY_PATH',os.path.join(prereq_dir, 'lib'))
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))

def set_nativ_env(env):
  pass
