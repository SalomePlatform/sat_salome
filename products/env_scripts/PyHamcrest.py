#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path

def set_env(env, prereq_dir, version):
    env.set('PYHAMCREST_ROOT_DIR', prereq_dir)
    
    pyver = 'python' + env.get('PYTHON_VERSION')
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))

def set_nativ_env(env):
    pass
