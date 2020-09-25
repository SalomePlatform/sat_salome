#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path

def set_env(env, prereq_dir, version):
    product_root_dir=env.get("PRODUCT_ROOT_DIR")
    env.set('SAMPLES_SRC_DIR', os.path.join(product_root_dir, "SOURCES", "SAMPLES"))
    env.set('DATA_DIR', env.get("SAMPLES_SRC_DIR"))

def set_nativ_env(env):
    pass
