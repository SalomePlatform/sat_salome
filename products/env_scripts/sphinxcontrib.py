#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os

def set_env(env, prereq_dir, version):
    env.set("SPHINXCONTRIB_ROOT_DIR",prereq_dir)
    pyver = 'python' + env.get('PYTHON_VERSION')

    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages/sphinxcontrib_napoleon-0.6.1-py2.7.egg/sphinxcontrib'))
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages/sphinxcontrib_napoleon-0.6.1-py2.7.egg/sphinxcontrib/napoleon'))

def set_nativ_env(env):
    pass
