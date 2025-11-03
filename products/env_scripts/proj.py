#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    env.set('PROJ_ROOT', prereq_dir)
    env.set('PROJ_ROOT_DIR', prereq_dir)
    env.set('PROJ_DIR', os.path.join(prereq_dir, 'lib', 'cmake'))

    if not platform.system() == "Windows" :
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
        env.prepend('PKG_CONFIG_PATH', os.path.join(prereq_dir, 'lib', 'pkgconfig'))

def set_nativ_env(env):
    pass
