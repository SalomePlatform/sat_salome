#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
def set_env(env, prereq_dir, version):
  SCOTCH_HPC=True
  #SCOTCH_HPC=env.get('SCOTCH_HPC') == '1'
  if SCOTCH_HPC: 
    env.set('SCOTCH_ROOT_DIR', prereq_dir)
    env.set('PTSCOTCH_ROOT_DIR', prereq_dir)
    env.set('PTSCOTCHDIR', prereq_dir)
    env.set('SCOTCHDIR', prereq_dir)
    env.set('PTSCOTCH_INCLUDE_DIR',os.path.join(prereq_dir,'include'))
  else:
    env.set('SCOTCHDIR', prereq_dir)
    env.set('SCOTCH_ROOT_DIR', prereq_dir)

def set_nativ_env(env):
  SCOTCH_HPC=True

  #SCOTCH_HPC=env.get('SCOTCH_HPC') == '1'
  if SCOTCH_HPC:
    prereq_dir='/usr'
    prereq_inc='/usr/include'
    prereq_lib= None
    try:
      import distro
      if any(distribution in distro.name().lower() for distribution in ["rocky", "centos", "fedora"]) :
        prereq_dir='/usr'
        prereq_inc= '/usr/include/openmpi-x86_64'
        prereq_lib='/usr/lib64/openmpi/lib'
      elif any(distribution in distro.name().lower() for distribution in ["debian", "ubuntu", "tuxedo os", "linux mint"]) :
        prereq_dir='/usr'
        prereq_inc='/usr/include/scotch-long'
        prereq_lib='/usr/lib/x86_64-linux-gnu/scotch-long'
      else:
        print("Unimplemented distribution (1): {}".format(distro.name.lower()))
    except:
        import platform
        if any(distribution in platform.linux_distribution()[0].lower() for distribution in ["rocky", "centos", "fedora"]) :
            prereq_dir='/usr'
            prereq_inc= '/usr/include/openmpi-x86_64'
            prereq_lib='/usr/lib64/openmpi/lib'
        else:
          print("Unimplemented distribution (2): {}".format(platform.linux_distribution()[0].lower()))

    env.set('SCOTCH_ROOT_DIR', prereq_dir)
    env.set('PTSCOTCH_ROOT_DIR', prereq_dir)
    env.set('PTSCOTCHDIR', prereq_dir)
    env.set('PTSCOTCH_INCLUDE_DIR', prereq_inc)
    if prereq_lib is not None:
        env.prepend('LD_LIBRARY_PATH', prereq_lib)
  else:
    prereq_dir='/usr'
    env.set('SCOTCH_ROOT_DIR', prereq_dir)
