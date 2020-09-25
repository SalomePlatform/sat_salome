#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os
import platform

def set_env(env, prereq_dir, version):
    if not platform.system() == "Windows" :
       versionPython = env.get('PYTHON_VERSION')
       env.prepend('PYTHONPATH',os.path.join(prereq_dir, 'lib', 'python' + versionPython, 'site-packages'))
       env.set("URLLIB3_ROOT_DIR",prereq_dir)

def set_nativ_env(env):
    pass
