#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('OPENBLASHOME', prereq_dir)
  env.set('OPENBLAS_ROOT_DIR', prereq_dir)
  env.set('OpenBLAS_DIR', prereq_dir)
  env.set('BLAS_ROOT_DIR', prereq_dir)
  env.set('OPENBLAS_SRC', os.path.join(prereq_dir,'SRC'))
  env.set('BLAS_SRC', os.path.join(prereq_dir,'BLAS','SRC'))
    
  if not platform.system() == "Windows" :
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
    # FOR NUMPY AND SCIPY
    env.set('BLAS', os.path.join(prereq_dir, 'lib'))
    env.set('OPENBLAS', os.path.join(prereq_dir, 'lib'))
  else:
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))

def set_nativ_env(env):
    env.set('OPENBLASHOME', '/usr')

