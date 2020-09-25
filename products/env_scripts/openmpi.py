#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path

def set_env(env, prereq_dir, version):
    env.set('OPENMPIDIR', prereq_dir)
    env.set('OPAL_PREFIX', prereq_dir) # be able to move openmpi install (packages)
    env.set('MPI_ROOT_DIR', prereq_dir)  # update for cmake  
    env.set('MPI_ROOT', prereq_dir)
    root = env.get('OPENMPIDIR')
    
    env.prepend('PATH', os.path.join(root, 'bin'))
    env.prepend('PATH', os.path.join(root, 'include'))
    env.prepend('LD_LIBRARY_PATH', os.path.join(root, 'lib'))
    env.prepend('C_INCLUDE_PATH', os.path.join(root, 'include'))  # needed for parallel h5py

def set_nativ_env(env):
    env.set('MPI_ROOT_DIR', "/usr")  # update for cmake
    env.set('OPENMPIDIR', "/usr")
    env.set('MPI_ROOT', "/usr")


