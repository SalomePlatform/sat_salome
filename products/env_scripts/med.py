#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path, platform

def set_env(env, prereq_dir, version):
    env.set('MED3HOME', prereq_dir)
    env.set('MED2HOME', prereq_dir)
    env.set('MEDFILE_ROOT_DIR', prereq_dir)    # update for cmake
    
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))    
   
    if platform.system() == "Windows" :
        env.prepend('PATH', os.path.join(prereq_dir, 'lib'))
    else :
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env):
    env.set('MEDFILE_ROOT_DIR', '/usr')    # update for cmake
    env.set('MED3HOME', '/usr')
    env.set('MED2HOME', '/usr')
