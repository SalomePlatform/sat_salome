#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path, platform

def set_env(env, prereq_dir, version):
    env.set("PMML_ROOT_DIR",prereq_dir)
    env.set('PMML_INCLUDE_DIR',os.path.join(prereq_dir,'include'))
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
    if platform.system() == "Windows" :
      pass
    else:
      env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
      pyver = 'python' + env.get('PYTHON_VERSION')
      env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
      env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'bin'))

def set_nativ_env(env):
    pass
