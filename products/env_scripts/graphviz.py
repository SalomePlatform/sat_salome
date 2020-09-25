#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    env.set('GRAPHVIZROOT', prereq_dir)
    env.set('GRAPHVIZ_ROOT_DIR', prereq_dir)

    if platform.system() == "Windows" :
        env.prepend('INCLUDE', os.path.join(prereq_dir, 'include'))
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
        env.prepend('LIB', os.path.join(prereq_dir, 'bin'))
        env.set('DOT_PATH',os.path.join(prereq_dir, 'bin'))
    else :
        # OP 16/10/2018 Bug with launcher generation during sat package
        #               Do not set several simultaneous directories
        #               in variables
        #l = []
        #l.append(os.path.join(prereq_dir, 'bin'))
        ## OP ???
        #l.append(os.path.join(prereq_dir, 'include', 'graphviz'))
        #env.prepend('PATH', l)
        #l = []
        #l.append(os.path.join(prereq_dir, 'lib'))
        #l.append(os.path.join(prereq_dir, 'lib', 'graphviz'))
        #env.prepend('LD_LIBRARY_PATH', l)
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
        # OP ???
        env.prepend('PATH', os.path.join(prereq_dir, 'include', 'graphviz'))
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib', 'graphviz'))

def set_nativ_env(env):
    env.set('GRAPHVIZROOT', '/usr')
    env.set('GRAPHVIZ_ROOT_DIR', '/usr')
