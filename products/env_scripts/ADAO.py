#!/usr/bin/env python
#-*- coding:utf-8 -*-
import os
import platform

def set_env(env, product_dir, version):
    env.set('ADAO_ENGINE_ROOT_DIR', product_dir)
    env.set('ADAO_ROOT_DIR', product_dir)
    env.set('CURRENT_SOFTWARE_INSTALL_DIR',product_dir)
    pyver = 'python' + env.get('PYTHON_VERSION')
    env.prepend('PYTHONPATH', os.path.join(product_dir, 'lib', pyver, 'site-packages'))

def set_nativ_env(env):
    pass
