#!/usr/bin/env python
#-*- coding:utf-8 -*-

def set_env(env, prereq_dir, version):
    env.set('VTK_ROOT_DIR', prereq_dir) # update for cmake
    env.set('VTKHOME', prereq_dir)
    root = env.get('VTKHOME')
    pyver = 'python' + env.get('PYTHON_VERSION')

    env.prepend('PATH', os.path.join(root, 'bin'))
    env.prepend('LD_LIBRARY_PATH', os.path.join(root, 'lib'))
    env.prepend('PYTHONPATH', os.path.join(root, 'lib', pyver, 'site-packages'))
    #http://computer-programming-forum.com/57-tcl/1dfddc136afccb94.htm
    #Tcl treats the contents of that variable as a list. Be happy, for you can now use drive letters on windows.
    env.prepend('TCLLIBPATH', os.path.join(root, 'lib', 'vtk-5.0', 'tcl'), sep=" ")

def set_nativ_env(env):
    pass
