#!/usr/bin/env python
import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('ROOTSYS', prereq_dir)
  if platform.system() == "Windows":
    env.prepend('PATH',os.path.join(prereq_dir, 'bin'))
    env.prepend('PYTHONPATH',os.path.join(prereq_dir, 'bin'))
  else:
    env.prepend('PYTHONPATH',os.path.join(prereq_dir, 'lib'))
    env.prepend('LD_LIBRARY_PATH',os.path.join(prereq_dir, 'lib'))
    env.prepend('DYLD_LIBRARY_PATH',os.path.join(prereq_dir, 'lib'))
    env.prepend('SHLIB_PATH',os.path.join(prereq_dir, 'lib'))
    env.prepend('LIBPATH',os.path.join(prereq_dir, 'lib'))
    env.prepend('PATH',os.path.join(prereq_dir, 'bin'))

def set_nativ_env(env):
    pass
