#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path

def set_env(env, prereq_dir, version):
    env.prepend('PV_PLUGIN_PATH', os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env):
    pass

