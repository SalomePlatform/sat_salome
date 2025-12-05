#!/usr/bin/env python
import os.path
import platform
def set_env(env, prereq_dir, version):
    env.set('OT_ROOT_DIR', prereq_dir)
    env.set('OPENTURNS_HOME', prereq_dir)
    env.set('OT_HOME', prereq_dir)
    env.set('OT_VERSION',version)
    env.set('OPENTURNS_CONFIG_PATH', os.path.join(prereq_dir,'etc','openturns'))
    env.prepend('PATH', os.path.join(prereq_dir,'bin'))
    if platform.system() == "Windows" :
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib','site-packages'))
    else:
        pyver = 'python' + env.get('PYTHON_VERSION')
        env.prepend('LD_LIBRARY_PATH',os.path.join(prereq_dir, 'lib'))
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))

def set_nativ_env(env):
    pass
