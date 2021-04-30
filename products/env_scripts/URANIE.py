#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path, platform

def set_env(env, prereq_dir, version, forBuild=None):
  version = '.'.join(version.replace('-', '.').split('.')[:2])
  env.set('URANIE_VERSION', version)

  if platform.system()=="Windows" :
    pass
  else :
    env.set('URANIE_ROOT_DIR', prereq_dir)
    uranie = env.get('URANIE_ROOT_DIR')

    # URANIE PATH
    env.set('URANIESYS', prereq_dir)

    # PYTHON PATH
    env.prepend('PYTHONPATH', os.path.join(uranie, 'lib', 'python'))

    # LD LIBRARY PATH
    env.prepend('LD_LIBRARY_PATH', os.path.join(uranie, 'lib'))

    # ROOT PATH
    root_env = env.get('ROOTSYS')
    root_lib_env = os.path.join(root_env,'lib','root')
    if os.path.isdir(root_lib_env):
      env.prepend('ROOTSYSLIB', root_lib_env)
    else:
      env.prepend('ROOTSYSLIB', os.path.join(root_env,'lib'))

    # PATH
    env.prepend('PATH', os.path.join(uranie,'bin'))
    env.prepend('PATH', os.path.join(root_env,'bin'))

    # OPT
    opt_env = os.path.join(uranie, 'OPT++','optpp-2.4','lib')
    env.prepend('LD_LIBRARY_PATH', opt_env)

def set_nativ_env(env):
  pass
