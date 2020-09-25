#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    env.set('GLUROOT', prereq_dir)
    env.set('GLU_ROOT_DIR', prereq_dir)

    #l = []
    #l.append(os.path.join(prereq_dir, 'bin'))
    #l.append(os.path.join(prereq_dir, 'include', 'glu'))
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
    env.prepend('PATH', os.path.join(prereq_dir, 'include', 'glu'))

    #l = []
    #l.append(os.path.join(prereq_dir, 'lib'))
    #l.append(os.path.join(prereq_dir, 'lib', 'glu'))
    
    if platform.system() == "Windows" :
        env.prepend('LIB', os.path.join(prereq_dir, 'lib'))
        env.prepend('LIB', os.path.join(prereq_dir, 'lib', 'glu'))
        env.prepend('INCLUDE', os.path.join(prereq_dir, 'include'))
        env.prepend('PATH', os.path.join(prereq_dir, 'lib'))
        env.prepend('PATH', os.path.join(prereq_dir, 'lib', 'glu'))
    else :
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib', 'glu'))

def set_nativ_env(env):
    env.set('GLUROOT', '/usr')
    env.set('GLU_ROOT_DIR', '/usr')
