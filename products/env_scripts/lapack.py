#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('LAPACKHOME', prereq_dir)
  env.set('LAPACK_ROOT_DIR', prereq_dir)
  env.set('LAPACK_SRC', os.path.join(prereq_dir,'SRC'))
  env.set('BLAS_SRC', os.path.join(prereq_dir,'BLAS','SRC'))
    
  if not platform.system() == "Windows" :
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
    # FOR NUMPY AND SCIPY
    env.set('BLAS', os.path.join(prereq_dir, 'lib'))
    env.set('LAPACK', os.path.join(prereq_dir, 'lib'))
    env.set('ATLAS', os.path.join(prereq_dir, 'lib'))
  else:
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))

def set_nativ_env(env):
    env.set('LAPACKHOME', '/usr')
    env.set('LAPACK_ROOT_DIR', '/')

