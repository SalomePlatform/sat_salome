#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    if not platform.system() == "Windows" :
        pyver = 'python' + env.get('PYTHON_VERSION')
        env.set('H5PY_ROOT_DIR',prereq_dir)
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'bin'))
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages','numpy','core','include'))

def set_nativ_env(env):
    pass
