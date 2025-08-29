#!/usr/bin/env python
#-*- coding:utf-8 -*-
import os
import platform

def set_env(env, prereq_dir, version):
    env.set('FREETYPEDIR', prereq_dir)
    env.set('FREETYPE_ROOT_DIR', prereq_dir)    # update for cmake
    
    env.set('FREETYPE_BIN', os.path.join(prereq_dir, 'bin'))
    env.set('FREETYPE_LIBRARY', os.path.join(prereq_dir, 'lib'))
    env.set('FREETYPE_INCLUDE_DIR', os.path.join(prereq_dir, 'include'))

    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))

    if platform.system() == "Windows" :
        env.prepend('INCLUDE', os.path.join(prereq_dir, 'include'))
        env.prepend('LIB', os.path.join(prereq_dir, 'bin'))
        env.prepend('CPLUS_INCLUDE_PATH', os.path.join(prereq_dir, 'include', 'freetype'))
    else:
        env.prepend('PKG_CONFIG_PATH', os.path.join(prereq_dir, 'lib', 'pkgconfig'))
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))      
        env.prepend('freetype_DIR', prereq_dir)

def set_nativ_env(env):
    pass
