#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('OPENCV_ROOT_DIR', prereq_dir)
  env.set('OPENCV_HOME', prereq_dir)
  env.set('OPENCV_DIR', prereq_dir)
  env.set('OpenCV_DIR', prereq_dir)
  env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
  if not platform.system() == "Windows" :
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
    pyver = 'python' + env.get('PYTHON_VERSION')
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
  else:
    env.prepend('PATH', os.path.join(prereq_dir, 'x64','vc15','bin'))
    env.prepend('PATH', os.path.join(prereq_dir, 'x64','vc15','lib'))
    env.set('OpenCV_INCLUDE_DIRS', os.path.join(prereq_dir, 'include') + ';' + os.path.join(prereq_dir, 'include','opencv') + ';' + os.path.join(prereq_dir, 'include','opencv2'))

def set_nativ_env(env):
  env.set('OPENCV_ROOT_DIR', '/usr')
  env.set('OPENCV_HOME', '/usr')
