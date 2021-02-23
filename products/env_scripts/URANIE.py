#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path, platform

def set_env(env, prereq_dir, version, forBuild=None):
    version = '.'.join(version.replace('-', '.').split('.')[:2])
    env.set('URANIE_VERSION', version)
    
    if platform.system()=="Windows" :
        # URANIE
        uranie_root = os.path.join(prereq_dir, 'uranie-3.9.0')
        env.set('URANIE_ROOT_DIR', uranie_root)
        env.set('URANIESYS', uranie_root)
        env.prepend('PATH', os.path.join(uranie_root, 'bin'))
        env.prepend('PATH', os.path.join(uranie_root, 'lib'))
        
        # ROOT
        root_dir = os.path.join(prereq_dir, 'root5.34.14')
        env.set('ROOT_ROOT_DIR', root_dir)
        env.set('ROOTSYS', root_dir)
        env.set('ROOTSYSLIB', os.path.join(root_dir, 'lib'))
        env.prepend('PATH', os.path.join(root_dir, 'bin'))
        
        env.prepend('PATH', os.path.join(prereq_dir, 'zlib-1.2.5', 'bin'))
        env.prepend('PATH', os.path.join(prereq_dir, 'libxml2-2.7.8.win32', 'bin'))
        env.prepend('PATH', os.path.join(prereq_dir, 'libxml2-2.7.8.win32', 'lib'))
        env.prepend('PATH', os.path.join(prereq_dir, 'iconv-1.9.2.win32', 'bin'))
        env.prepend('PATH', os.path.join(prereq_dir, 'libxslt-1.1.26.win32', 'bin'))
        env.prepend('PATH', os.path.join(prereq_dir, 'fftw-3.3.3-dll32'))
        env.prepend('PATH', os.path.join(prereq_dir, 'nlopt-2.4.2-dll32'))
        env.prepend('PATH', os.path.join(prereq_dir, 'pcl-1.10-modified', 'debug'))
        env.prepend('PATH', os.path.join(prereq_dir, 'optpp-2.4', 'lib'))
        env.prepend('PATH', os.path.join(prereq_dir, 'pthread-win32', 'Pre-built.2', 'dll', 'x86'))
    else :
        env.set('URANIE_ROOT_DIR', prereq_dir)
        uranie = env.get('URANIE_ROOT_DIR') 

        ### 
        # FORMAT URANIE
    
        # URANIE PATH
        env.set('URANIESYS', prereq_dir)  

        # PYTHON PATH
        env.prepend('PYTHONPATH', os.path.join(uranie, 'lib', 'python'))
    
        # LD LIBRARY PATH
        env.prepend('LD_LIBRARY_PATH', os.path.join(uranie, 'lib'))

        # ROOT PATH
        root_env = env.get('ROOT_ROOT_DIR')
        env.set('ROOTSYS', root_env)

        root_lib_env = os.path.join(root_env,'lib','root')
        if os.path.isdir(root_lib_env):
            env.prepend('ROOTSYSLIB', root_lib_env)
        else:
            env.prepend('ROOTSYSLIB', os.path.join(root_env,'lib'))
    
        # PATH
        env.prepend('PATH', os.path.join(uranie,'bin'))
        env.prepend('PATH', os.path.join(root_env,'bin'))

        # OPT
        opt_env = os.path.join(uranie, 'OPT++','optpp-2.4','lib')
        env.prepend('LD_LIBRARY_PATH', opt_env)

def set_nativ_env(env):
    pass
