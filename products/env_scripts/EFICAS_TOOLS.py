#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform
import re

def set_env(env, prereq_dir, version):
    env.set('EFICAS_TOOLS_ROOT_DIR', prereq_dir)   # update for cmake 
    env.set('EFICAS_TOOLS_ROOT', prereq_dir)
    env.append('PYTHONPATH', prereq_dir)
    env.append('LD_LIBRARY_PATH', prereq_dir)
    ld = ['Accas','Aide','convert','Doc','Editeur','Efi2Xsd','Extensions','generator','Ihm','InterfaceQT4','Noyau','Telemac','Traducteur','UiQT5']
    if platform.system() == "Windows" :
        LD_LIBRARY_PATH='PATH'
    else:
       LD_LIBRARY_PATH='LD_LIBRARY_PATH'
        
    env.append(LD_LIBRARY_PATH, prereq_dir)
    for d in ld:
        env.append('PYTHONPATH', os.path.join(prereq_dir, d))
        env.append(LD_LIBRARY_PATH, os.path.join(prereq_dir, d))
    # bos #38877
    pyver = 'python' + env.get('PYTHON_VERSION')
    if re.match(r'^V9_[1][0-5]_[0]$', version):
        env.append('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver,'site-packages', 'salome'))
    else:
        env.append('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver,'site-packages'))

def set_nativ_env(env):
    pass
