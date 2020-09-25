#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    #env.set('DATEUTIL_ROOT_DIR', env.get('PYTHON_ROOT_DIR'))
    env.set('DATEUTIL_ROOT_DIR', prereq_dir)
    if not platform.system() == "Windows" :
        pyver = 'python' + env.get('PYTHON_VERSION')
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))

def set_nativ_env(env):
    pass
