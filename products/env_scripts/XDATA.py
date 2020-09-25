#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path

def set_env(env, prereq_dir, version):
    env.set('XDATAROOT', prereq_dir)
    env.set('XDATA_ROOT_DIR', prereq_dir)    # update for cmake
    root = env.get('XDATAROOT')
    pyver = 'python' + env.get('PYTHON_VERSION')
    
    env.prepend('PATH', os.path.join(root, 'bin'))
    env.prepend('PYTHONPATH', os.path.join(root, 'lib', pyver, 'site-packages', 'xdata'))

def set_nativ_env(env):
    pass
