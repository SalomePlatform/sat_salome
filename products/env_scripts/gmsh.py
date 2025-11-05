#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version): 
  env.set('GMSHHOME', prereq_dir)
  env.set('GMSH_ROOT_DIR', prereq_dir)
  env.append('PATH',os.path.join(prereq_dir,'bin'))
  if platform.system() == "Windows" :
    env.set('GMSH_DIR', os.path.join(prereq_dir, 'share', 'gmsh'))
    env.prepend('GMSH_INCLUDE_DIRS', os.path.join(prereq_dir, 'include'))
    env.prepend('GMSH_INCLUDE_DIRS', os.path.join(prereq_dir, 'include', 'gmsh'))
    env.set('GMSH_LIBRARIES', os.path.join(prereq_dir, 'bin', 'gmsh.dll'))
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'bin'))
  else:
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env):
    env.set('GMSH_ROOT_DIR', '/usr')
