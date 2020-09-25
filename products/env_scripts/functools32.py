#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os

def set_env(env, prereq_dir, version):
    env.set("FUNCTOOLS_ROOT_DIR",prereq_dir)
    pyver = 'python' + env.get('PYTHON_VERSION')
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))

def set_nativ_env(env):
    pass
