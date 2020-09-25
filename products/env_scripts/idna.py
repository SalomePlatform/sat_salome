#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os
import platform

def set_env(env, prereq_dir, version):
    env.set("IDNA_ROOT_DIR",prereq_dir)

    if not platform.system() == "Windows" :
        versionPython = env.get('PYTHON_VERSION')
        env.prepend('PYTHONPATH',os.path.join(prereq_dir, 'lib', 'python' + versionPython, 'site-packages'))

def set_nativ_env(env):
    pass
