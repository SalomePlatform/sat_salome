#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    env.set('SQLITE_DIR', prereq_dir)
    env.set('SQLITE_ROOT_DIR', prereq_dir)
    env.prepend('INCLUDE', os.path.join(prereq_dir, 'include'))
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))

    if platform.system() == "Windows" :
        pass

    elif platform.system() == "Darwin" :
        env.prepend('DYLD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
        env.prepend('PKG_CONFIG_PATH', os.path.join(prereq_dir, 'lib', 'pkgconfig'))

    else :
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
        env.prepend('PKG_CONFIG_PATH', os.path.join(prereq_dir, 'lib', 'pkgconfig'))

def set_nativ_env(env):
    pass
