#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path, platform

def set_env(env, prereq_dir, version):
    env.set("ALABASTER_ROOT_DIR",prereq_dir)
    versionPython = env.get('PYTHON_VERSION')
    if platform.system() == "Windows" :
        pass
    else :
        env.prepend('PYTHONPATH',os.path.join(prereq_dir, 'lib', 'python' + versionPython, 'site-packages'))

def set_nativ_env(env):
    pass

