#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    env.set('PETSCDIR', prereq_dir)
    env.set('PETSC_ROOT_DIR', prereq_dir)
    
    env.set('PETSC_DIR', prereq_dir)
    env.set('PETSC_ARCH', 'arch-linux2-c-debug')

    root = env.get('PETSCDIR')
    
    env.prepend('PATH', os.path.join(root, 'include'))
    env.prepend('LD_LIBRARY_PATH', os.path.join(root, 'lib'))
    #env.prepend('LD_LIBRARY_PATH', os.path.join(root, 'arch-linux2-c-debug', 'lib'))

        
def set_nativ_env(env):
    pass
