#!/usr/bin/env python
import os.path
import platform
def set_env(env, prereq_dir, version):
    pvversion='paraview-' + env.get('PARAVIEW_VERSION')
    env.set('PERSALYS_ROOT_DIR', prereq_dir)
    env.set('PERSALYS_VERSION',version)
    env.set('OTGUI_DIR', prereq_dir)
    env.set('OTGUI_ROOT_DIR', prereq_dir)
    env.prepend('PATH', os.path.join(prereq_dir,'bin'))
    if platform.system() == "Windows" :
        env.prepend('PV_PLUGIN_PATH', os.path.join(prereq_dir, 'bin', pvversion, 'plugins'))
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib','site-packages'))
    else:
        env.prepend('PV_PLUGIN_PATH', os.path.join(prereq_dir, 'lib', pvversion, 'plugins'))
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
        pyver = 'python' + env.get('PYTHON_VERSION')
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
    env.set('OTGUI_HTML_DOCUMENTATION_PATH',os.path.join(prereq_dir,'share','otgui','doc','html/'))
    env.set('PERSALYS_HTML_DOCUMENTATION_PATH', os.path.join(prereq_dir,'share','persalys','doc','html/'))

def set_nativ_env(env):
    pass
