#!/usr/bin/env python
import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('OSPRAY_ROOT_DIR', prereq_dir)
  ospray_version = 'ospray-' + version
  env.set('ospray_DIR', os.path.join(prereq_dir,'lib','cmake',ospray_version))
  env.set('OSPRAY_VERSION', version)
  if platform.system() == "Windows":
    env.prepend('PATH',os.path.join(prereq_dir, 'bin'))
  else:
    env.prepend('LD_LIBRARY_PATH',os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env):
    pass
