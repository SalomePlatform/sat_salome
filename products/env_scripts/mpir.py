#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('MPIR_ROOT_DIR', prereq_dir)
  env.set('MPIR_VERSION', version)

def set_nativ_env(env):
  pass
