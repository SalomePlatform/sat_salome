#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path, platform

def set_env(env, prereq_dir, version):
    env.set('HDF5_OPENMPI_DIR', prereq_dir)
    env.set('HDF5_OPENMPI_ROOT_DIR', prereq_dir)


