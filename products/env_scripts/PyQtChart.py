#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path

def set_env(env, prereq_dir, version):
    pyver = 'python' + env.get('PYTHON_VERSION')
    env.set('PYQTCHART_ROOT_DIR', prereq_dir)
def set_nativ_env(env):
    pass
