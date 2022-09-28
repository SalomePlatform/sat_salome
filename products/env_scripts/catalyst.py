#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('CATALYST_ROOT_DIR', prereq_dir)
  env.set('catalyst_DIR', os.path.join(prereq_dir, 'lib', 'cmake', 'catalyst-{}'.format(version)))  
  env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
  env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib', 'catalyst'))

def set_nativ_env(env):
  pass
