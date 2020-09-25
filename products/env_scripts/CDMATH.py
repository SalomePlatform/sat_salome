#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    env.set('CDMATH_ROOT_DIR', prereq_dir)
    
    env.set('CDMATH_DIR', prereq_dir)

    root = env.get('CDMATH_DIR')
    
    env.prepend('PATH', os.path.join(root, 'include'))
    env.prepend('LD_LIBRARY_PATH', os.path.join(root, 'lib'))
    env.prepend('PYTHONPATH', os.path.join(root, 'lib'))
    env.prepend('PYTHONPATH', os.path.join(root, 'lib', 'cdmath'))
    env.prepend('PYTHONPATH', os.path.join(root, 'bin', 'cdmath'))

        
def set_nativ_env(env):
    pass
