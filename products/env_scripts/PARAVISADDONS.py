#!/usr/bin/env python
import os.path

def set_env(env, prereq_dir, version):
    env.set('PARAVISADDONS', prereq_dir)
    env.append('PV_PLUGIN_PATH', os.path.join(prereq_dir, 'lib','paraview'))
    env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'bin'))

def set_nativ_env(env):
    pass
