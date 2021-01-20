#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os

def set_env(env, product_dir, version):
    env.append('SalomeAppConfig', os.path.join(product_dir, 'share', 'salome', 'resources', 'homard'))

def set_nativ_env(env):
    pass
