#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path, platform

def set_env(env, prereq_dir, version):
  env.set('TBB_ROOT_DIR', prereq_dir)
  if platform.system()=="Windows" :
    # this prerequisites is only used on windows platform
    arch = 'intel64'
    vs   = '14_uwp' # target is Visual studio 2017
    env.set('TBB_DIR', prereq_dir)
    env.set('TBB_TARGET_ARCH',arch)
    env.set('TBB_TARGET_VS',vs)
    env.prepend('PATH', os.path.join(prereq_dir,'bin'))
  else:
    env.set('TBB_ROOT', prereq_dir)
    env.set('TBBROOT', prereq_dir)
    env.set('TBB_INSTALL_DIR', prereq_dir)
    env.set('TBB_INCLUDE_DIR', os.path.join(prereq_dir,'include'))
    env.set('TBB_LIBRARY_DIR', os.path.join(prereq_dir,'lib'))
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir,'lib'))

def set_nativ_env(env):
    pass

