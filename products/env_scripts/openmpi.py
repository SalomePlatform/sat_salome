#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path

def set_env(env, prereq_dir, version):
    env.set('OPENMPIDIR', prereq_dir)
    env.set('OPAL_PREFIX', prereq_dir) # be able to move openmpi install (packages)
    env.set('MPI_ROOT_DIR', prereq_dir)  # update for cmake  
    env.set('MPI_ROOT', prereq_dir)
    env.set('MPI_INCLUDE_DIR', os.path.join(prereq_dir, 'include'))
    env.set('MPI_C_COMPILER', os.path.join(prereq_dir, 'bin', 'mpicc'))
    env.set('MPI_CXX_COMPILER', os.path.join(prereq_dir, 'bin', 'mpicxx'))
    env.set('MPI_Fortran_COMPILER', os.path.join(prereq_dir, 'bin', 'mpifort'))
    env.set('MPI_C_FOUND', os.path.join(prereq_dir,'lib','libmpi.so'))
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
    env.prepend('PATH', os.path.join(prereq_dir, 'include'))
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
    env.prepend('C_INCLUDE_PATH', os.path.join(prereq_dir, 'include'))  # needed for parallel h5py

def set_nativ_env(env):
    prereq_dir='/usr'
    prereq_bin='/usr/bin'
    prereq_inc='/usr/include/openmpi'
    try:
        import distro
        if any(distribution in distro.name().lower() for distribution in ["rocky", "centos", "fedora"]) :
            prereq_dir='/usr/lib64/openmpi'
            prereq_bin='/usr/lib64/openmpi/bin'
            prereq_inc='/usr/include/openmpi-x86_64'
        elif any(distribution in distro.name().lower() for distribution in ["debian", "ubuntu"]) :
            prereq_dir='/usr/lib/x86_64-linux-gnu/openmpi'
            prereq_inc= '/usr/lib/x86_64-linux-gnu/openmpi/include'
    except:
        import platform
        if any(distribution in platform.linux_distribution()[0].lower() for distribution in ["rocky", "centos", "fedora"]) :
            prereq_dir='/usr/lib64/openmpi'
            prereq_bin='/usr/lib64/openmpi/bin'
            prereq_inc='/usr/include/openmpi-x86_64'

    env.set('MPI_ROOT_DIR', prereq_dir)
    env.set('OPENMPIDIR', prereq_dir)
    env.set('MPI_ROOT', prereq_dir)
    env.set('MPI_C_COMPILER', os.path.join(prereq_bin,'mpicc'))
    env.set('MPI_CXX_COMPILER', os.path.join(prereq_bin,'mpicxx'))
    env.set('MPI_C_FOUND', os.path.join(prereq_dir,'lib','libmpi.so'))
    env.set('MPI_INCLUDE_DIR', prereq_inc)
    env.prepend('PATH', prereq_bin)
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir,'lib'))

