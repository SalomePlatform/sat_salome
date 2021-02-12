#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path, platform

def set_env(env, prereq_dir, version):
  env.set('RKCOMMON_ROOT_DIR', prereq_dir)
  env.set('rkcommon_DIR', os.path.join(prereq_dir, 'lib','cmake','rkcommon-1.5.1'))
  if platform.system()=="Windows" :
    env.prepend('PATH', os.path.join(prereq_dir,'bin'))
  else:
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir,'lib'))

def set_nativ_env(env):
    pass

