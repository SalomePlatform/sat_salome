#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os
import platform
def set_env(env, prereq_dir, version):
    env.set("SCIKITLEARN_ROOT_DIR",prereq_dir)

def set_nativ_env(env):
    pass
