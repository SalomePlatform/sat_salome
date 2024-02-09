#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    env.set('DXF_ROOT_DIR', prereq_dir)
    env.set('DXF_DIR', prereq_dir)
    env.set('PRODUCTS_DXF_LIBRARIES', os.path.join(prereq_dir, 'lib'))
    env.prepend('PYTHONPATH', env.get('DXF_DIR'))
    env.prepend('PYTHONPATH', env.get('DXF_ROOT_DIR'))
    
    if platform.system()=="Windows" :
        env.prepend('PATH', os.path.join(prereq_dir, 'win64', 'vc14' ,'bin'))
    else :
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env):
    env.set('DXF_ROOT_DIR', '/usr')    # update for cmake
    env.set('DXF_DIR', '/usr')
