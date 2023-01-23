#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os
import platform

def set_env(env, prereq_dir, version):
    env.set("PACKAGESPY_ROOT_DIR",prereq_dir)
    env.prepend('PYTHONPATH',prereq_dir)

def set_nativ_env(env):
    pass
