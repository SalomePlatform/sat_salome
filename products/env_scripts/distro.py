#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os
import platform

def set_env(env, prereq_dir, version):
    env.set("DISTRO_ROOT_DIR",prereq_dir)

    versionPython = env.get('PYTHON_VERSION')
    if not platform.system() == "Windows" :
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
        env.prepend('PYTHONPATH',os.path.join(prereq_dir, 'lib', 'python' + versionPython, 'site-packages'))
        env.prepend('PYTHONPATH',os.path.join(prereq_dir, 'bin'))

def set_nativ_env(env):
    pass
