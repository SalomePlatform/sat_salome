#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('MESAROOT', prereq_dir)
  env.set('MESA_ROOT_DIR', prereq_dir)
  env.set('XLIB_SKIP_ARGB_VISUALS', '1')
    
  if platform.system() == "Windows" :
    env.prepend('PATH', os.path.join(prereq_dir, 'x64'))
    env.prepend('PATH', os.path.join(prereq_dir, 'x64','osmesa-gallium'))
  else:
    env.prepend('PATH', os.path.join(prereq_dir, 'include', 'GL'))
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
    if version.startswith('19'):
      env.set('MESA_GL_VERSION_OVERRIDE','4.5')

def set_nativ_env(env):
  env.set('MESAROOT', '/usr')
  env.set('MESA_ROOT_DIR', '/usr')
  env.set('XLIB_SKIP_ARGB_VISUALS', '1')
