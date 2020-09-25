#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
#   this prerequisites is only used on windows platform
    env.set('PTHREAD_ROOT_DIR', prereq_dir)

    env.set('PTHREAD_LIBRARY', os.path.join(prereq_dir, 'lib'))
    env.set('PTHREAD_LIBRARIES', os.path.join(prereq_dir, 'lib'))
    env.set('PTHREAD_INCLUDE_DIR', os.path.join(prereq_dir, 'include'))
    env.prepend('INCLUDE', os.path.join(prereq_dir, 'include'))
    env.prepend('LIB', os.path.join(prereq_dir, 'lib'))
    env.prepend('PATH', os.path.join(prereq_dir, 'lib'))

    if not platform.system() == "Windows" :
        env.set('PTHREAD_BINDIR', os.path.join(prereq_dir, 'bin'))
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))

def set_nativ_env(env):
    pass
    
