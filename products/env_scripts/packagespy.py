#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os
import platform
import os
import getpass

def get_login():
    try:
        return os.getlogin()
    except:
        return getpass.getuser()

def set_env(env, prereq_dir, version):
    env.set("PACKAGESPY_ROOT_DIR",prereq_dir)
    env.set("WORKDIR4LOG",os.path.join('tmp', get_login()))
    env.prepend('PYTHONPATH',os.path.join(prereq_dir, 'packagespy'))
    env.prepend('PATH',os.path.join(prereq_dir,'packagespy','bin'))

def set_nativ_env(env):
    pass
