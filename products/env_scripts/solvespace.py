#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path

def set_env(env, prereq_dir, version):
    env.set('SOLVESPACE_ROOT_DIR', prereq_dir)
    root = env.get('SOLVESPACE_ROOT_DIR')
    env.prepend('LD_LIBRARY_PATH', os.path.join(root, 'lib'))

def set_nativ_env(env):
    pass
