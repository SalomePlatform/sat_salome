#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path

def set_env(env, prereq_dir, version):
    env.set('CMAKE_ROOT', prereq_dir)
    
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))

def set_nativ_env(env):
    env.set('CMAKE_ROOT', '/usr')

