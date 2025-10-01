#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os
import platform
def set_env(env, prereq_dir, version):
    pyver = 'python' + env.get('PYTHON_VERSION')
    env.set("JOBLIB_ROOT_DIR",prereq_dir)
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))


def set_nativ_env(env):
    pass
