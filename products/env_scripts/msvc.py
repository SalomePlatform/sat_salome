#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path

def set_env(env, prereq_dir, version):
    env.set('MSVC_ROOT_DIR', prereq_dir)    
    env.prepend('PATH', prereq_dir)
    
def set_nativ_env(env):
    pass
