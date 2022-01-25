#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    env.set('C3PODIR', prereq_dir)
    env.set('C3PO_ROOT_DIR', prereq_dir)   
    if not platform.system() == "Windows" :
        env.prepend('PATH',prereq_dir)
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
        pyver = 'python' + env.get('PYTHON_VERSION')
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))

def set_nativ_env(env):
    pass
