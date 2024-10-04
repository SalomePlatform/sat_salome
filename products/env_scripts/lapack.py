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
    env.set('LAPACK_DIR', os.path.join(prereq_dir,'lib', 'cmake', 'lapack-3.8.0'))
    env.set('LAPACKE_DIR', os.path.join(prereq_dir,'lib', 'cmake', 'lapacke-3.8.0'))
    env.set('LAPACKE_INCDIR', os.path.join(prereq_dir,'include'))
    env.set('LAPACKE_LIBDIR', os.path.join(prereq_dir,'lib'))
    env.set('CBLAS_DIR', os.path.join(prereq_dir,'lib', 'cmake', 'cblas-3.8.0'))
    env.set('CBLAS_ROOT_DIR', os.path.join(prereq_dir,'lib', 'cmake', 'cblas-3.8.0'))
  else:
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
    env.set('BLAS', os.path.join(prereq_dir, 'lib'))
    env.set('LAPACK', os.path.join(prereq_dir, 'lib'))
    env.set('ATLAS', os.path.join(prereq_dir, 'lib'))
    env.set('LAPACK_DIR', os.path.join(prereq_dir,'lib', 'cmake', 'lapack-3.8.0'))
    env.set('LAPACKE_DIR', os.path.join(prereq_dir,'lib', 'cmake', 'lapacke-3.8.0'))
    env.set('LAPACKE_INCDIR', os.path.join(prereq_dir,'include'))
    env.set('LAPACKE_LIBDIR', os.path.join(prereq_dir,'lib'))
    env.set('CBLAS_ROOT_DIR', os.path.join(prereq_dir,'lib', 'cmake', 'cblas-3.8.0'))

def set_nativ_env(env):
    env.set('LAPACKHOME', '/usr')
    env.set('LAPACK_ROOT_DIR', '/')

