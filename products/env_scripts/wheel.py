#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    pyver = 'python' + env.get('PYTHON_VERSION')
    env.set('WHEEL_ROOT_DIR',prereq_dir)
    env.set("WHEEL_VERSION",version)
    if not platform.system() == "Windows" :
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
    else:
        pass

def set_nativ_env(env):
    pass
