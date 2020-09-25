#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path

def set_env(env, prereq_dir, version):
    env.set('FTGLDIR', prereq_dir)
    env.set('FTGL_ROOT_DIR', prereq_dir)    # update for cmake
    root = env.get('FTGLDIR')
    
    env.prepend('PATH', os.path.join(root, 'bin'))
    env.prepend('LD_LIBRARY_PATH', os.path.join(root, 'lib'))
    #env.set('LD_PRELOAD', os.path.join(root, 'lib', 'libftgl.so'))

def set_nativ_env(env):
    env.set('FTGL_ROOT_DIR', '/usr')    # update for cmake
    env.set('FTGLDIR', '/usr')
