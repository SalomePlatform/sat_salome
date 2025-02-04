#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('JSONCPP_ROOT_DIR', prereq_dir)
  env.set('JsonCpp_DIR', os.path.join(prereq_dir,'lib','cmake', 'jsoncpp'))
  env.set('JsonCpp_INCLUDE_DIR', os.path.join(prereq_dir,'include'))
  env.set('JsonCpp_LIBRARY', os.path.join(prereq_dir,'lib'))
    
  if not platform.system() == "Windows" :
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
  else:
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))

def set_nativ_env(env):
    env.set('JSONCPP_ROOT_DIR', '/usr')
