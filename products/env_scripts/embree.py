#!/usr/bin/env python
import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('EMBREE_ROOT_DIR', prereq_dir)
  env.set('EMBREE_VERSION', version)
  env.set('embree_DIR', prereq_dir)
  if platform.system() == "Windows":
    env.prepend('PATH',os.path.join(prereq_dir, 'bin'))
  else:
    env.prepend('LD_LIBRARY_PATH',os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env):
    pass
