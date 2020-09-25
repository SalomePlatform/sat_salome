#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('PYQTDIR', prereq_dir)
  version_table = version.split('.')
  if version_table[0] == '5':
    env.set('PYQT5_ROOT_DIR', prereq_dir)
  else:
    env.set('PYQT4_ROOT_DIR', prereq_dir)

  env.set('PYQT_SIPS', os.path.join(prereq_dir, 'sip'))
  env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
  env.prepend('PYTHONPATH', prereq_dir)
  pyver = 'python' + env.get('PYTHON_VERSION')
  env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
  if not platform.system() == "Windows" :
    env.set('PYUIC5',os.path.join(prereq_dir, 'bin','pyuic5'))
    env.prepend('LD_LIBRARY_PATH', prereq_dir)
  else:
    env.set('PYUIC5',os.path.join(prereq_dir, 'bin','pyuic5.bat'))

def set_nativ_env(env):
  env.set('PYQT5_ROOT_DIR', '/usr')
