#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('EIGEN_ROOT_DIR', prereq_dir)
  env.set('Eigen3_DIR', prereq_dir)
  root = env.get('EIGEN_ROOT_DIR')
  if platform.system() != "Windows" :
    pass
  else:
    env.prepend('PATH', os.path.join(root, 'include', 'eigen3'))

def set_nativ_env(env):
  env.set('EIGEN_ROOT_DIR', '/usr')
