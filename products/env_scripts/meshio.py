#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    pyver = 'python' + env.get('PYTHON_VERSION')
    env.set('MESHIO_ROOT_DIR',prereq_dir)
    env.set('HDF5_DISABLE_VERSION_CHECK', '1')
    env.set("MESHIO_VERSION",version)
    if not platform.system() == "Windows" :
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
        env.prepend('PATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages', 'bin'))
    else:
        # meshio is installed in Python lib directory
        # no need to expand PATH
        pass

def set_nativ_env(env):
    import meshio
    meshio_version=meshio.__version__
    env.set("MESHIO_VERSION",meshio_version)
