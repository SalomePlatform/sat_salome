#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    env.set('CASROOT', prereq_dir)
    
    # [CMake GUI] Nouveau nom pour CASROOT = CAS_ROOT_DIR 22/03/2013
    env.set('OPENCASCADE_ROOT_DIR', prereq_dir)
    env.prepend('PATH', prereq_dir)
    
    if platform.system()=="Windows" :
        env.prepend('PATH', os.path.join(prereq_dir, 'win64', 'vc14' ,'bin'))
    else :
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
   

def set_nativ_env(env):
    pass

