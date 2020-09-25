#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path, platform

def set_env(env, prereq_dir, version):
  if not platform.system() == "Windows" :
    env.set('CC', os.path.join(prereq_dir,'bin','gcc'))
    env.set('CXX', os.path.join(prereq_dir,'bin','g++'))
    env.set('FC', os.path.join(prereq_dir,'bin','gfortran'))
    env.set('EBROOTGCC', version)
    env.set('EBVERSIONGCC', version)
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib64'))
    env.prepend('LIBRARY_PATH', os.path.join(prereq_dir, 'lib64'))
    env.prepend('MANPATH', os.path.join(prereq_dir, 'share','man'))
    env.prepend('INCLUDE', os.path.join(prereq_dir, 'include'))
    env.prepend('CPATH', os.path.join(prereq_dir, 'include'))

def set_nativ_env(env):
  pass
