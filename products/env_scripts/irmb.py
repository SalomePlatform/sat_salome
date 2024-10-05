#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('IRMB_ROOT_DIR', prereq_dir)
  env.set('IRMB_DIR', os.path.join(prereq_dir, 'lib', 'cmake'))
  env.set('IRMB_VERSION', version)

def set_nativ_env(env):
  pass
