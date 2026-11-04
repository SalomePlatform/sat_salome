#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    env.set('CAIROROOT', prereq_dir)
    env.set('CAIRO_ROOT_DIR', prereq_dir)

    if platform.system() == "Windows" :
        env.prepend('INCLUDE', os.path.join(prereq_dir, 'include'))
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
        env.prepend('LIB', os.path.join(prereq_dir, 'bin'))

    elif platform.system() == "Darwin" :
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
        env.prepend('DYLD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))

    else :
        env.prepend('PATH', os.path.join(prereq_dir, 'include'))
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env):
    env.set('CAIROROOT', '/usr')
    env.set('CAIRO_ROOT_DIR', '/usr')

