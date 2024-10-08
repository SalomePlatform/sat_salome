#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    pyver = 'python' + env.get('PYTHON_VERSION')
    env.set('POETRY_CORE_ROOT_DIR',prereq_dir)
    env.set("POETRY_CORE_VERSION",version)
    if not platform.system() == "Windows" :
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages', 'poetry'))
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
    else:
        pass

def set_nativ_env(env):
    pass