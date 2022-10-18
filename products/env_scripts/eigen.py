#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('EIGEN_ROOT_DIR', prereq_dir)
  env.set('Eigen3_DIR', prereq_dir)

def set_nativ_env(env):
  env.set('EIGEN_ROOT_DIR', '/usr')
