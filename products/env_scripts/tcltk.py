#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
  env.set('TCL_ROOT_DIR', prereq_dir)
  env.set('TCLHOME', prereq_dir)
  env.set('TK_ROOT_DIR', prereq_dir)
  env.set('TKHOME', prereq_dir)
  env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
  env.prepend('INCLUDE', os.path.join(prereq_dir, 'include'))
  env.set('TCL_SHORT_VERSION', version[:version.rfind('.')])
  env.set('TK_SHORT_VERSION', version[:version.rfind('.')])

  l = []
  l.append(os.path.join(prereq_dir, 'lib'))
  l.append(os.path.join(prereq_dir, 'lib', 'tcl', env.get('TCL_SHORT_VERSION')))
  #http://computer-programming-forum.com/57-tcl/1dfddc136afccb94.htm
  #Tcl treats the contents of that variable as a list. Be happy, for you can now use drive letters on windows.
  env.prepend('TCLLIBPATH',l, sep=" ")
  l = []
  l.append(os.path.join(prereq_dir, 'lib'))
  l.append(os.path.join(prereq_dir, 'lib', 'tk', env.get('TCL_SHORT_VERSION')))
  env.prepend('TKLIBPATH', l, sep=" ")

  if not platform.system() == "Windows" :
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env):
    env.set('TCL_ROOT_DIR', '/usr') # update for cmake
    env.set('TCLHOME', '/usr')
    env.set('TK_ROOT_DIR', '/usr')   # update for cmake
    env.set('TKHOME', '/usr')
