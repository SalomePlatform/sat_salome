#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    env.set('LLVMROOT', prereq_dir)
    env.set('LLVM_HOME', prereq_dir)
    env.set('LLVM_ROOT_DIR', prereq_dir)

    if platform.system() == "Windows" :
        env.prepend('LIB', os.path.join(prereq_dir, 'lib'))
        env.prepend('INCLUDE', os.path.join(prereq_dir, 'include'))
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))

    if platform.system() == "Darwin" :
        env.prepend('PATH', os.path.join(prereq_dir, 'include', 'llvm'))
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
        env.prepend('PATH', os.path.join(prereq_dir, 'lib'))
        env.prepend('DYLD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))

    else :
        # OP ???
        env.prepend('PATH', os.path.join(prereq_dir, 'include', 'llvm'))
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
        env.prepend('PATH', os.path.join(prereq_dir, 'lib'))
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env):
    env.set('LLVMROOT', '/usr')
    env.set('LLVM_ROOT_DIR', '/usr')
