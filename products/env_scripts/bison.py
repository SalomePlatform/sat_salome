#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    if platform.system() == "Darwin" :
        env.set('BISONDIR', prereq_dir)
        env.set('BISON_ROOT_DIR', prereq_dir)
        env.set('Bison_DIR', os.path.join(prereq_dir,'lib', 'Bison-' + version))
        env.prepend('PATH', os.path.join(prereq_dir, 'include'))
        env.prepend('DYLD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env):
    env.set('BISONROOT', '/usr')
    env.set('BISON_ROOT_DIR', '/usr')
    if platform.system() == "Darwin" :
        env.prepend('PATH', '/opt/homebrew/opt/bison/bin')
