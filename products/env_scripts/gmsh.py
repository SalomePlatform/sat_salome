#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version): 
  env.set('GMSHHOME', prereq_dir)
  env.set('GMSH_ROOT_DIR', prereq_dir)
  if platform.system() == "Windows" :
    env.append('PATH',os.path.join(prereq_dir,'bin'))
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib'))
  else:
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env):
    env.set('GMSH_ROOT_DIR', '/usr')
