#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    env.set('TOGL_ROOT_DIR', prereq_dir)   # update for cmake 
    env.set('TOGL', prereq_dir)
    env.set('TOGL_SHORT_VERSION', version.split('-')[0])
    
    togl = env.get('TOGL_ROOT_DIR')

    env.set('TOGL_LIB_DIR', os.path.join(togl, 'lib', 'Togl' + version.split('-')[0]))
    
    env.prepend('PATH', env.get('TOGL_LIB_DIR'))

    if platform.system() == "Windows" :
        env.prepend('LIB', env.get('TOGL_LIB_DIR'))
        env.prepend('INCLUDE', os.path.join(prereq_dir, 'include'))

def set_nativ_env(env):
    env.set('TOGL_ROOT_DIR', '/usr')   # update for cmake
    env.set('TOGL', '/usr')
    env.set('TOGL_LIB_DIR', '/usr/lib')

