#!/usr/bin/env python
import os.path
import platform

def set_env(env, prereq_dir, version):
    env.set('DILL_ROOT_DIR', prereq_dir)
    env.set('DILL_VERSION',version)
    pyver = 'python' + env.get('PYTHON_VERSION')
    if platform.system() == "Windows" :
        pass
    else:
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))

def set_nativ_env(env):
    pass
