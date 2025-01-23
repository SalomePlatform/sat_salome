#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path, platform

def set_env(env,prereq_dir,version,forBuild=None):
    env.set('PYTHONHOME', prereq_dir)

    # [CMake KERNEL] Nouveau nom pour PYTHONHOME = PYTHON_ROOT_DIR 22/03/2013
    env.set('PYTHON_ROOT_DIR', prereq_dir)
    # EDF uses this environment variable
    env.set('PYTHON_INSTALL_DIR', prereq_dir)

    # keep only the first two version numbers
    version = '.'.join(version.replace('-', '.').split('.')[:2])
    env.set('PYTHON_VERSION', version)

    env.prepend('PATH', prereq_dir)

    if platform.system() == "Windows" :
        env.set('PYTHON_INCLUDE', os.path.join(prereq_dir, 'include'))
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib'))
        env.set('PYTHON_SITE_PACKAGES',os.path.join(prereq_dir, 'lib','site-packages'))
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib','site-packages'))
        env.set('PYTHONBIN', os.path.join(prereq_dir, 'python.exe'))  # needed for runSalome.py
        env.prepend('PATH', os.path.join(prereq_dir, 'libs'))
        env.prepend('PATH', os.path.join(prereq_dir, 'Scripts'))
    else :
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
        env.set('PYTHON_INCLUDE', os.path.join(prereq_dir, 'include', 'python' + version))
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', 'python' + version))
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', 'python' + version, 'site-packages'))
        if version[0]=='3':
            env.set('PYTHONBIN', os.path.join(prereq_dir, 'bin','python3'))  # needed for runSalome.py
        else:
            env.set('PYTHONBIN', os.path.join(prereq_dir, 'bin','python'))  # needed for runSalome.py


def set_nativ_env(env):
    import sys, sysconfig
    env.set('PYTHON_ROOT_DIR', "/usr")
    env.set('PYTHON_INCLUDE',  "%s" % sysconfig.get_paths()['include'])
    env.set('PYTHON_LIBRARY',  "%s" % sysconfig.get_config_var("LIBDIR"))
    env.set('PYTHON_VERSION', sysconfig.get_python_version())
    if sys.version_info[0] == 3 :
        env.set('PYTHONBIN','/usr/bin/python3')
    else:
        env.set('PYTHONBIN','/usr/bin/python2')

