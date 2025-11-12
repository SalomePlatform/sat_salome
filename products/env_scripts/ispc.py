#!/usr/bin/env python
import os.path
import platform

def set_env(env, prereq_dir, version):
    env.set('ISPC_ROOT_DIR', prereq_dir)    # update for cmake
    # access to ispc binary
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
    env.set('ispcrt_DIR', os.path.join(prereq_dir, 'lib', 'cmake', 'ispcrt-' + version))
    if not platform.system() == "Windows" :
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))

