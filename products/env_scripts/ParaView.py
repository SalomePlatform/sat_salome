#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform

def set_env(env, prereq_dir, version):
    # keep only the first two version numbers
    ver = '.'.join(version.replace('-', '.').split('.')[:2])

    # BUG WITH 5.0_beta
    if ver == '5.0_beta':
        ver = '5.0'

    if ver == '5.8.0rc2' :
        ver = '5.8'

    env.set('PVHOME', prereq_dir)
    env.set('VTKHOME', prereq_dir)  
    env.set('PVVERSION', ver)
    
    env.set('PARAVIEW_ROOT_DIR', prereq_dir)
    env.set('PARAVIEW_VERSION', ver)

    set_paraview_env(env, ver)
    set_vtk_env(env, ver)

def set_nativ_env(env):
    if os.getenv("PVHOME") is None:
        raise Exception("PVHOME is not set")
    
    if os.getenv("PVVERSION") is None:
        raise Exception("PVVERSION is not set")

    version = env.get("PVVERSION")
    set_paraview_env(env, version)

def set_paraview_env(env, version):
    root = env.get('PVHOME')
    env.set('ParaView_DIR', os.path.join(root, 'lib', 'paraview-%s' % version))
    env.prepend('PATH', os.path.join(root, 'bin'))
    
    if platform.system() == "Windows" :
        env.prepend('PATH', os.path.join(root, 'bin', 'paraview-' + version))
        env.prepend('PV_PLUGIN_PATH', os.path.join(root, 'bin', 'paraview-' + version, 'plugins'))
        # bos #45920
        if version >= '5.13' :
            site_packages = os.path.join(root, 'bin', 'Lib', 'site-packages')
            env.prepend('PYTHONPATH', os.path.join(site_packages, 'vtk'))
            env.prepend('PYTHONPATH', os.path.join(site_packages))
        else:
            site_packages = os.path.join(root, 'bin', 'Lib', 'site-packages')
            env.prepend('PYTHONPATH', os.path.join(site_packages, 'paraview'))
            env.prepend('PYTHONPATH', os.path.join(site_packages, 'vtk'))
            env.prepend('PYTHONPATH', os.path.join(site_packages))
    else:
        paralib = os.path.join(root, 'lib', 'paraview-' + version)
        env.prepend('PV_PLUGIN_PATH', paralib)
        # bos #26828
        env.prepend('PV_PLUGIN_PATH', os.path.join(paralib, 'plugins'))
        env.prepend('PYTHONPATH', os.path.join(paralib, 'site-packages'))
        env.prepend('PYTHONPATH', os.path.join(paralib, 'site-packages', 'vtk'))
        env.prepend('PATH', os.path.join(root, 'include', 'paraview-' + version))
        env.prepend('LD_LIBRARY_PATH', os.path.join(root, 'lib', 'paraview-' + version))
        env.prepend('PYTHONPATH', paralib)

def set_vtk_env(env, version):
    root = env.get('VTKHOME')
    pyver = 'python' + env.get('PYTHON_VERSION')
    env.set('VTK_ROOT_DIR', root)
    env.set('VTK_DIR', os.path.join(root, 'lib', 'cmake', 'paraview-' + version))
    
    if not platform.system() == "Windows" :
        #http://computer-programming-forum.com/57-tcl/1dfddc136afccb94.htm
        #Tcl treats the contents of that variable as a list. Be happy, for you can now use drive letters on windows.
        env.prepend('LD_LIBRARY_PATH', os.path.join(root, 'lib'))
        env.prepend('PYTHONPATH', os.path.join(root, 'lib', pyver, 'site-packages'))
    if version == '3.98':
        cmake_dir = os.path.join(root, 'lib', 'cmake', 'paraview-' + version)
        env.set('VTK_DIR', cmake_dir)
