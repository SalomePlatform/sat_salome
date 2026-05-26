#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path

def set_env(env, prereq_dir, version):
    product_root_dir=env.get("PRODUCT_ROOT_DIR")
    env.set('RESTRICTED_ROOT_DIR', os.path.join(product_root_dir, "SOURCES", "RESTRICTED"))

def set_nativ_env(env):
    pass
