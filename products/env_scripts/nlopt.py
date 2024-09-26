#!/usr/bin/env python

import os.path, platform

def set_env(env, prereq_dir, version):
  env.set("NLOPT_ROOT_DIR",prereq_dir)
  pyver = 'python' + env.get('PYTHON_VERSION')
  if platform.system() == "Windows" :
    env.prepend('PATH',os.path.join(prereq_dir, 'bin'))
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
  else :
    env.prepend('LD_LIBRARY_PATH',os.path.join(prereq_dir, 'lib'))
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))

def set_nativ_env(env):
    prereq_dir='/usr'
    prereq_bin='/usr/bin'
    prereq_inc='/usr/include'
    try:
        import distro
        if any(distribution in distro.name().lower() for distribution in ["rocky", "centos", "fedora"]) :
            prereq_dir='/usr/'
            prereq_bin='/usr/bin'
            prereq_inc='/usr/include'
        elif any(distribution in distro.name().lower() for distribution in ["debian", "ubuntu", "tuxedo os", "linux mint"]) :
            prereq_dir='/usr'
            prereq_inc='/usr/include'
    except:
        import platform
        if any(distribution in platform.linux_distribution()[0].lower() for distribution in ["rocky", "centos", "fedora"]) :
            prereq_dir='/usr'
            prereq_bin='/usr/bin'
            prereq_inc='/usr/include'

    env.set('NLOPT_ROOT_DIR', prereq_dir)
    env.set('NLOPT_INCLUDE_DIR', prereq_inc)
    if prereq_bin != "/usr/bin":
        env.prepend('PATH', prereq_bin)
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir,'lib'))
