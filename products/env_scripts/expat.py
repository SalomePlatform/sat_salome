#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('EXPAT_DIR', prereq_dir)
  env.set('EXPAT_ROOT_DIR', prereq_dir)  # update for cmake  
  root = env.get('EXPAT_DIR')
  if platform.system() == "Windows" :
    env.prepend('INCLUDE', os.path.join(prereq_dir, 'include'))
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
    env.prepend('LIB', os.path.join(prereq_dir, 'bin'))
  else :    
    env.prepend('PATH', os.path.join(root, 'bin'))
    env.prepend('LD_LIBRARY_PATH', os.path.join(root, 'lib'))

def set_nativ_env(env):
  env.set('EXPAT_ROOT_DIR', '/usr')  # update for cmake 
  env.set('EXPAT_DIR', '/usr')
