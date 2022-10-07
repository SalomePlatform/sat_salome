#!/usr/bin/env python
import os.path
import platform

def set_env(env, prereq_dir, version):
    env.set('TTK_ROOT_DIR', prereq_dir)
    env.set('TTK_HOME', prereq_dir)
    env.set('TTK_VERSION',version)
    pyver = 'python' + env.get('PYTHON_VERSION')
    if platform.system() == "Windows" :
        env.prepend('PATH', os.path.join(prereq_dir,'bin'))
        env.prepend('PV_PLUGIN_PATH', os.path.join(prereq_dir, 'bin'))
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
    else:
        env.prepend('PATH', os.path.join(prereq_dir,'bin'))
        env.prepend('LD_LIBRARY_PATH',os.path.join(prereq_dir, 'lib'))
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
        env.prepend('PV_PLUGIN_PATH',os.path.join(prereq_dir,'bin','plugins'))

def set_nativ_env(env):
    pass
