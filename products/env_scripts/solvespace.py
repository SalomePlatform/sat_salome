#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    if platform.system() == "Darwin" :
        env.set('SOLVESPACE_ROOT_DIR', prereq_dir)
        root = env.get('SOLVESPACE_ROOT_DIR')
        env.prepend('DYLD_LIBRARY_PATH', os.path.join(root, 'lib'))
    else:
        env.set('SOLVESPACE_ROOT_DIR', prereq_dir)
        root = env.get('SOLVESPACE_ROOT_DIR')
        env.prepend('LD_LIBRARY_PATH', os.path.join(root, 'lib'))

def set_nativ_env(env):
    pass
