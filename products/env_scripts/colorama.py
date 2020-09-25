#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    env.set('COLORAMA_ROOT_DIR', env.get('PYTHON_ROOT_DIR'))
    pyver = 'python' + env.get('PYTHON_VERSION')
    if not platform.system() == "Windows" :
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))

def set_nativ_env(env):
    pass
