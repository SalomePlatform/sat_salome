#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  pyver = 'python' + env.get('PYTHON_VERSION')
  env.set('PYSIDE_ROOT_DIR', prereq_dir)
  env.set('PYSIDE2_ROOT_DIR', prereq_dir)
  env.set("PYSIDE_VERSION",version)
  env.set("SALOME_USE_PYSIDE","1")
  if not platform.system() == "Windows" :
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages', 'PySide2'))
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages', 'shiboken2'))
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
    env.set('PYSIDE2_PYTHON_DIR', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
  else:
    env.prepend('PATH', os.path.join(prereq_dir, 'Scripts'))
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'Lib', 'site-packages'))
    env.prepend('PATH', os.path.join(prereq_dir, 'Scripts'))
    env.prepend('PATH', os.path.join(prereq_dir, 'Lib', 'site-packages', 'PySide2'))
    env.prepend('PATH', os.path.join(prereq_dir, 'Lib', 'site-packages', 'shiboken2'))
    env.prepend('PATH', os.path.join(prereq_dir, 'Lib', 'site-packages', 'shiboken_generator'))
    env.set('PYSIDE2_PYTHON_DIR', os.path.join(prereq_dir, 'Lib', 'site-packages'))

def set_nativ_env(env):
    pass
