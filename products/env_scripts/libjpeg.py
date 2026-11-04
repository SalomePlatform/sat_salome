#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    # this prerequisites is only used on windows platform
    if platform.system()=="Windows" :
        env.set('LIBJPEG_DIR', prereq_dir)
        env.set('LIBJPEG_BINDIR', os.path.join(prereq_dir, 'bin'))
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
        env.prepend('LIB', os.path.join(prereq_dir, 'bin'))
    elif platform.system() == "Darwin" :
        env.set('LIBJPEG_DIR', prereq_dir)
        env.set('LIBJPEG_ROOT_DIR', prereq_dir)
        env.prepend('PATH', os.path.join(prereq_dir, 'include'))
        env.prepend('DYLD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
    else :
        pass

def set_nativ_env(env):
    if platform.system() != "Windows":
        env.set('LIBJPEG_DIR', '/usr')
        env.set('LIBJPEG_ROOT_DIR', '/usr')

    
