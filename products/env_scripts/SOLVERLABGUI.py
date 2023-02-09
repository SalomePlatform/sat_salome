#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, product_dir, version):
    env.set('SOLVERLABGUI_ROOT_DIR', product_dir)    
    env.prepend('LD_LIBRARY_PATH', os.path.join(product_dir, 'lib'))
    env.prepend('PYTHONPATH', product_dir)
    env.prepend('PYTHONPATH', os.path.join(product_dir, 'solverlabpy'))
    env.prepend('PYTHONPATH', os.path.join(product_dir, 'bin', 'salome'))
    env.set('SOLVERLABGUI_WORKDIR', r'/tmp')
    env.set('USERLOGIN', "$USER")
 
def set_nativ_env(env):
    pass
