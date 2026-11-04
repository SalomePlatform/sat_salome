#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path, platform

def set_env(env, prereq_dir, version):
    env.set('PARMETISDIR', prereq_dir)
    env.set('PARMETIS_ROOT_DIR', prereq_dir)   # update for cmake 
    root = env.get('PARMETISDIR')

    if platform.system() == "Darwin" :
        env.prepend('DYLD_LIBRARY_PATH', root)
    else :
        env.prepend('LD_LIBRARY_PATH', root)
    env.prepend('PATH', root)
#    env.prepend('PATH', os.path.join(root, "Graphs"))

def set_nativ_env(env):
    pass
