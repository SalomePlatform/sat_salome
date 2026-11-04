#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path, platform

def set_env(env, prereq_dir, version):
    env.set('LIBEVENTDIR', prereq_dir)
    env.set('LIBEVENT_ROOT_DIR', prereq_dir)
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
    env.prepend('PATH', os.path.join(prereq_dir, 'include'))

    if platform.system() == "Darwin" :
        pass
    else :
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env):
    env.set('LIBEVENTDIR', "/usr")
    env.set('LIBEVENT_ROOT_DIR', "/usr")
