#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path, platform

def set_env(env, prereq_dir, version):
  if platform.system() == "Windows" :
    pass
  else :
    versionPython = env.get('PYTHON_VERSION')
    env.set("MPI4PY_ROOT_DIR",os.path.join(prereq_dir, 'lib', 'python' + versionPython, 'site-packages'))
    env.prepend("PYTHONPATH",os.path.join(prereq_dir, 'lib', 'python' + versionPython, 'site-packages'))

def set_nativ_env(env):
    try:
        import distro
        if any(distribution in distro.name().lower() for distribution in ["rocky", "centos", "fedora"]) :
            import openmpi.mpi4py as mpi4py
            MPI4PY_ROOT_DIR=os.path.join('/',*mpi4py.__path__[0].split('/')[:-1])
            env.set("MPI4PY_ROOT_DIR", MPI4PY_ROOT_DIR)
        elif any(distribution in distro.name().lower() for distribution in ["debian", "ubuntu", "tuxedo os", "linux mint"]) :
            import mpi4py
            MPI4PY_ROOT_DIR=os.path.join('/',*mpi4py.__path__[0].split('/')[:-1])
            env.set("MPI4PY_ROOT_DIR", MPI4PY_ROOT_DIR)
    except:
        import platform
        if any(distribution in platform.linux_distribution()[0].lower() for distribution in ["rocky", "centos", "fedora"]) :
            import openmpi.mpi4py as mpi4py
            MPI4PY_ROOT_DIR=os.path.join('/',*mpi4py.__path__[0].split('/')[:-1])
            env.set("MPI4PY_ROOT_DIR", MPI4PY_ROOT_DIR)

