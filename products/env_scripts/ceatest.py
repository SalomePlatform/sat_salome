#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path

def set_env(env, prereq_dir, version):
    env.set("CEATESTBASE_ROOT_DIR", prereq_dir)
    root=env.get("CEATESTBASE_ROOT_DIR")
    env.set('TT_BASE_RESSOURCES', os.path.join(root, "bin", "salome", "test", "RESSOURCES")) 
    env.set('TT_TMP_RESULT', os.path.join(root, "bin", "salome", "test", "tmp")) 
    env.prepend('PYTHONPATH', env.get("TT_BASE_RESSOURCES"))

def set_nativ_env(env):
    pass
