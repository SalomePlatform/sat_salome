#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path

def set_env(env, prereq_dir, version):
    env.set('F2C_ROOT_DIR', prereq_dir)
    
    env.set('F2C_BIN', prereq_dir)
    env.set('F2C_LIBRARIES', prereq_dir)
    env.set('F2C_INCLUDE_DIR', prereq_dir)
    
    env.prepend('INCLUDE', prereq_dir)
    env.prepend('LIB', prereq_dir)
    env.prepend('PATH', prereq_dir)
    
def set_nativ_env(env):
    pass

    
