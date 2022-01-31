#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path

def set_env(env, prereq_dir, version):
    env.set('OPENMPIDIR', prereq_dir)
    env.set('OPAL_PREFIX', prereq_dir) # be able to move openmpi install (packages)
    env.set('MPI_ROOT_DIR', prereq_dir)  # update for cmake  
    env.set('MPI_ROOT', prereq_dir)
    env.set('MPI_C_FOUND', os.path.join(prereq_dir,'lib','libmpi.so'))
    root = env.get('OPENMPIDIR')
    
    env.prepend('PATH', os.path.join(root, 'bin'))
    env.prepend('PATH', os.path.join(root, 'include'))
    env.prepend('LD_LIBRARY_PATH', os.path.join(root, 'lib'))
    env.prepend('C_INCLUDE_PATH', os.path.join(root, 'include'))  # needed for parallel h5py

def set_nativ_env(env):
    prereq_dir='/usr'
    try:
        import distro
        if any(distribution in distro.name().lower() for distribution in ["centos", "fedora"]) :
            prereq_dir='/usr/lib64/openmpi'
    except:
        import platform
        if any(distribution in platform.linux_distribution()[0].lower() for distribution in ["centos", "fedora"]) :
            prereq_dir='/usr/lib64/openmpi'
    env.set('MPI_ROOT_DIR', prereq_dir)
    env.set('OPENMPIDIR', prereq_dir)
    env.set('MPI_ROOT', prereq_dir)
    env.set('MPI_C_FOUND', os.path.join(prereq_dir,'lib','libmpi.so'))
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir,'lib'))
