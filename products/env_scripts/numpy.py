#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  if not platform.system() == "Windows" :
    pyver = 'python' + env.get('PYTHON_VERSION')
    env.set('NUMPY_INCLUDE_DIR',os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
    env.set('NUMPY_INCLUDE_DIR2',os.path.join(prereq_dir, 'lib', pyver, 'site-packages','numpy','core','include'))
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'bin'))
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
  else:
    pyver = 'python' + env.get('PYTHON_VERSION')
    env.set('NUMPY_INCLUDE_DIR',os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
    env.set('NUMPY_INCLUDE_DIR2',os.path.join(prereq_dir, 'lib', pyver, 'site-packages','numpy','core','include'))
    env.prepend('PATH', os.path.join(prereq_dir, 'Scripts'))
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'Scripts'))
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
def set_nativ_env(env):
    pass
