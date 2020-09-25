#!/usr/bin/env python
import os.path

def set_env(env, prereq_dir, version):
    env.set('ISPC_ROOT_DIR', prereq_dir)    # update for cmake
    # access to ispc binary
    env.prepend('PATH', os.path.join(prereq_dir,'bin'))
    
