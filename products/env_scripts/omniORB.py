#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    env.set('OMNIORB_ROOT_DIR', prereq_dir) # update for cmake    

    if platform.system() == "Windows" :
        env.prepend('PATH', os.path.join(prereq_dir, 'bin', 'x86_win32'))
        env.prepend('PATH',os.path.join(prereq_dir, 'lib', 'x86_win32'))
        env.prepend( 'PYTHONPATH', os.path.join(prereq_dir, 'lib', 'python'))
        env.prepend( 'PYTHONPATH', os.path.join(prereq_dir, 'lib', 'x86_win32'))
        env.set("OMNIORB_USER_PATH", "%APPDATA%")
    else:
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
        env.prepend( 'PYTHONPATH', os.path.join(prereq_dir, 'lib'))
        pyver = 'python' + env.get('PYTHON_VERSION')
        env.prepend( 'PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
        env.prepend( 'PYTHONPATH', os.path.join(prereq_dir, 'lib64', pyver, 'site-packages'))
        env.prepend('LD_LIBRARY_PATH',os.path.join(prereq_dir, 'lib'))
        env.set("OMNIORB_USER_PATH", "/tmp")

def set_nativ_env(env):
    env.set('OMNIORB_ROOT_DIR', "/usr") # update for cmake
