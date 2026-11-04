#!/usr/bin/env python
import os.path
import platform

def set_env(env, prereq_dir, version):
    env.set('NETCDF_ROOT_DIR', prereq_dir)
    env.set('NETCDF_INSTALL_DIR', prereq_dir)
    env.set('NETCDF_VERSION',version)
    env.prepend('PATH', os.path.join(prereq_dir,'bin'))
    if platform.system() == "Windows" :
        pass
    elif platform.system() == "Darwin" :
        env.prepend('DYLD_LIBRARY_PATH',os.path.join(prereq_dir, 'lib'))
    else:
        env.prepend('LD_LIBRARY_PATH',os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env):
    pass
