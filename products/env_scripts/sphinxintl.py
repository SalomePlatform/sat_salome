#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os
import platform

def set_env(env, prereq_dir, version):
    env.set("SPHINXINTL_ROOT_DIR",prereq_dir)
    pyver = 'python' + env.get('PYTHON_VERSION')
    if  platform.system() == "Windows" :
      env.set('SPHINXINTL_EXECUTABLE',os.path.join(prereq_dir, 'Scripts','sphinx-build.exe'))
    else:
      env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
      env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))

def set_nativ_env(env):
    pass
