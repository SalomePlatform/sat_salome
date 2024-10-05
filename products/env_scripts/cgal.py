#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('CGAL_ROOT_DIR', prereq_dir)
  env.set('CGAL_VERSION', version)
  env.set('CGAL_DIR', os.path.join(prereq_dir, 'lib', 'cmake'))

def set_nativ_env(env):
  pass
