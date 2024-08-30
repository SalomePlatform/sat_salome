#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('PETSCDIR', prereq_dir)
  env.set('PETSC_ROOT_DIR', prereq_dir)
  env.set('PETSC_DIR', prereq_dir)
  env.set('PETSC4PY', os.path.join(prereq_dir, 'lib'))
  env.set('SLEPC4PY', os.path.join(prereq_dir, 'lib'))

  if platform.system() == "Windows" :
    pass
  else:
    env.set('PETSC_ARCH', 'arch-linux-c-opt')
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
    # Setting pythonpath for libraries petsc4py and slepc4py
    petsc4y=env.get('PETSC4PY')
    slepc4y=env.get('SLEPC4PY')
    env.prepend('PYTHONPATH', petsc4y)
    env.prepend('PYTHONPATH', os.path.join(petsc4y, 'lib'))
    env.prepend('PYTHONPATH', slepc4y)
    env.prepend('PYTHONPATH', os.path.join(slepc4y, 'lib'))

def set_nativ_env(env):
  pass
