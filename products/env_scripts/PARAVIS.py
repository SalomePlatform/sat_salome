#!/usr/bin/env python
import os

def set_env(env, prereq_dir, version):
    fVersions =['V9_11_0', 'V9_10_0', 'V9_9_0', 'V9_8_0']
    fVersions+=['V9_7_0',  'V9_6_0',  'V9_5_0', 'V9_4_0']
    fVersions+=['V9_3_0',  'V9_2_1',  'V9_2_0', 'V9_1_0']
    fVersions+=['V8_5_0',  'V7_8_0', 'V6_6_0']
    if not version in fVersions:
        pyver = 'python' + env.get('PYTHON_VERSION')
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))

def set_nativ_env(env):
    pass
