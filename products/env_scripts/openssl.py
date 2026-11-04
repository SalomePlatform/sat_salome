#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    env.set('OPENSSL_ROOT_DIR', prereq_dir)
    env.set('OPENSSL_DIR', prereq_dir)
    if platform.system() == "Darwin" :
        env.prepend('DYLD_LIBRARY_PATH',os.path.join(prereq_dir, 'lib'))
    elif not platform.system() == "Windows" :
        env.prepend('LD_LIBRARY_PATH',os.path.join(prereq_dir, 'lib'))
        # no need to expand PATH since it is embedded in Qt/bin
        # env.prepend('PATH', os.path.join(prereq_dir), 'lib')

def set_nativ_env(env):
    env.set('OPENSSL_DIR', '/usr')
    env.set('OPENSSL_ROOT_DIR', '/usr')
