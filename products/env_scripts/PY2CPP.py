#!/usr/bin/env python
#-*- coding:utf-8 -*-
import os
import platform

def set_env(env, product_dir, version):
    env.set('PY2CPP_ROOT_DIR', product_dir)
    env.set('Py2cpp_DIR', os.path.join(product_dir, 'lib', 'cmake', 'py2cpp'))
    if not platform.system() == "Windows" :
        env.prepend('LD_LIBRARY_PATH', os.path.join(product_dir, 'lib'))
    else:
        env.prepend('PATH', os.path.join(product_dir, 'bin'))

def set_nativ_env(env):
    pass
