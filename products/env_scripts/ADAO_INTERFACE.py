#!/usr/bin/env python
#-*- coding:utf-8 -*-
import os
import platform

def set_env(env, product_dir, version):
    if platform.system() == "Darwin" :
        env.set('ADAO_INTERFACE_ROOT_DIR', product_dir)
        env.prepend('DYLD_LIBRARY_PATH', os.path.join(product_dir, 'lib'))
    else :
        env.set('ADAO_INTERFACE_ROOT_DIR', product_dir)
        env.prepend('LD_LIBRARY_PATH', os.path.join(product_dir, 'lib'))

def set_nativ_env(env):
    pass
