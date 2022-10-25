#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  if platform.system() == "Windows" :
    prereq_dir = prereq_dir.replace('/','\\')
    env.set('BOOSTDIR', prereq_dir)
    env.set('BOOST_ROOT_DIR', prereq_dir)
    env.set('BOOST_ROOT', prereq_dir)
    env.set('BOOST_INCLUDE_DIR',os.path.join(prereq_dir,'include','boost-' + '_'.join(version.split('.')[0:2]),'boost'))
    env.set('Boost_INCLUDE_DIR',os.path.join(prereq_dir,'include','boost-' + '_'.join(version.split('.')[0:2]),'boost'))
    env.set('BOOST_INCLUDEDIR', os.path.join(prereq_dir,'include','boost-' + '_'.join(version.split('.')[0:2]),'boost'))
    env.set('Boost_ADDITIONAL_VERSIONS',"'" + version + " " + '.'.join(version.split('.')[0:2]) + "'")
    env.set('BOOST_LIBRARY_DIR',os.path.join(prereq_dir,'lib'))
    env.set('BOOST_LIBRARYDIR',os.path.join(prereq_dir,'lib'))
    env.prepend('PATH', os.path.join(prereq_dir, 'lib'))
  else :
    env.set('BOOSTDIR', prereq_dir)
    env.set('BOOST_ROOT_DIR', prereq_dir)
    env.prepend('PATH', os.path.join(prereq_dir, 'include'))
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
        
def set_nativ_env(env):
  env.set('BOOSTDIR', '/usr')
  env.set('BOOST_ROOT_DIR', '/usr')
