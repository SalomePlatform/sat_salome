#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    pyver = 'python' + env.get('PYTHON_VERSION')

    pyqt = env.get('PYQTDIR')
    env.set('PYQT_SIPS_DIR', pyqt)
    env.set('SIPDIR', prereq_dir)
    env.set('SIP_ROOT_DIR', prereq_dir)

    if not platform.system() == "Windows" :
        # [CMake GUI] Nouveau nom pour SIPDIR = SIP_ROOT_DIR 22/03/2013
        env.set('SIPDIR', prereq_dir)
        env.set('SIP_ROOT_DIR', prereq_dir)
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
        env.prepend('CPLUS_INCLUDE_PATH', os.path.join(prereq_dir, 'include', pyver))
    else:
        env.prepend('CPLUS_INCLUDE_PATH', os.path.join(prereq_dir, 'include', pyver))
        if '5.5.0' in version:
            env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'Lib', 'site-packages'))
            env.prepend('PATH', os.path.join(prereq_dir, 'scripts'))
        else:
            env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
            env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
  
def set_nativ_env(env):
    env.set('SIPDIR', '/usr')
    env.set('SIP_ROOT_DIR','/usr')

