#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    env.set('NETGENHOME', prereq_dir)
    env.set('NETGEN_ROOT_DIR', prereq_dir)
    
    env.set('NETGEN_BIN', os.path.join(prereq_dir, 'bin'))
    env.set('NETGEN_LIBRARY', os.path.join(prereq_dir, 'lib'))
    env.set('NETGEN_LIBRARIES', os.path.join(prereq_dir, 'lib'))
    env.set('NETGEN_INCLUDE_DIR', os.path.join(prereq_dir, 'include'))
    env.set('NETGEN_INCLUDE_DIRS', os.path.join(prereq_dir, 'include'))
    
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
    
    if platform.system() == "Windows" :
        env.prepend('INCLUDE', os.path.join(prereq_dir, 'include'))
        env.prepend('LIB', os.path.join(prereq_dir, 'lib'))
    else :
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
    
def set_nativ_env(env):
    env.set('NETGEN_ROOT_DIR', '/usr')    # update for cmake
    env.set('NETGENHOME', '/usr')
