#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os
import platform
import os
def set_env(env, prereq_dir, version):
    env.set("PACKAGESPY_ROOT_DIR",prereq_dir)
    env.set("WORKDIR4LOG",os.path.join('tmp', os.getlogin()))
    env.prepend('PYTHONPATH',os.path.join(prereq_dir, 'packagespy'))
    env.prepend('PATH',os.path.join(prereq_dir,'packagespy','bin'))

def set_nativ_env(env):
    pass
