#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    env.set('FFTW_DIR', prereq_dir)
    env.set('FFTW_ROOT_DIR', prereq_dir)
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
    if not platform.system() == "Windows" :
        env.prepend('INCLUDE', os.path.join(prereq_dir, 'include'))
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env):
    pass
