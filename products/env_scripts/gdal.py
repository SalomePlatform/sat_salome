#!/usr/bin/env python
import os.path

def set_env(env, prereq_dir, version):
    pyver = 'python' + env.get('PYTHON_VERSION')
    env.set('GDAL_ROOT_DIR', prereq_dir)
    env.set('GDALHOME', prereq_dir)
    env.set('GDAL_ROOT', prereq_dir)
    env.set('GDAL_DIR', prereq_dir)
    env.set('GDAL_VERSION',version)
    env.set('GDAL_DATA', os.path.join(prereq_dir, 'share', 'gdal'))
    env.prepend('PATH', os.path.join(prereq_dir,'bin'))
    env.prepend('LD_LIBRARY_PATH',os.path.join(prereq_dir, 'lib'))
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))

def set_nativ_env(env):
    env.set('GDAL_ROOT_DIR','/usr')
    pass
