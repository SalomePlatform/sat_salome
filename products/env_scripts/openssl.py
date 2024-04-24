#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('OPENSSL_ROOT_DIR', prereq_dir)
  env.set('OPENSSL_DIR', prereq_dir)
  if platform.system() == "Windows" :
    # no need to expand PATH since it is embedded in Qt/bin
    # env.prepend('PATH', os.path.join(prereq_dir), 'lib')
    pass

def set_nativ_env(env):
  pass
