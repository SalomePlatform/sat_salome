#!/usr/bin/env python
import os.path

def set_env(env, prereq_dir, version):
    env.set('OPENTURNS_ROOT_DIR', prereq_dir)
    env.set('OPENTURNS_VERSION',version)
    env.prepend('PATH', os.path.join(prereq_dir,'bin'))
    env.prepend('LD_LIBRARY_PATH',os.path.join(prereq_dir, 'lib'))
    pyver = 'python' + env.get('PYTHON_VERSION')
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
def set_nativ_env(env):
    pass
