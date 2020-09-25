#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os
import platform
def set_env(env, prereq_dir, version):
    env.set("KIWISOLVER_ROOT_DIR",prereq_dir)
    if not platform.system() == "Windows" :
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
        versionPython = env.get('PYTHON_VERSION')
        env.prepend('PYTHONPATH',os.path.join(prereq_dir, 'lib', 'python' + versionPython, 'site-packages'))
        env.prepend('PYTHONPATH',os.path.join(prereq_dir, 'bin'))


def set_nativ_env(env):
    pass
