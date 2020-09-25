#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    env.set('BSD_XDR_DIR', prereq_dir)
    
    env.set('BSD_XDR_BIN', os.path.join(prereq_dir, 'bin'))
    env.set('BSD_XDR_INCLUDE_DIR', os.path.join(prereq_dir, 'include'))
    env.set('BSD_XDR_LIBRARY', os.path.join(prereq_dir, 'lib'))
    
    env.prepend('INCLUDE', env.get('BSD_XDR_INCLUDE_DIR'))
    env.prepend('PATH', env.get('BSD_XDR_BIN'))

    if not platform.system() == "Windows" :
        env.prepend('PATH', env.get('BSD_XDR_LIBRARY'))
            
def set_nativ_env(env):
    env.set('BSD_XDR_DIR', '/usr')
