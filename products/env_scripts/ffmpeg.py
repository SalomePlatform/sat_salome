#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path, platform

def set_env(env, prereq_dir, version):
    if platform.system() == "Windows":
        pass

    elif platform.system() == "Darwin":
        env.set("FFMPEG_ROOT_DIR",prereq_dir)
        env.prepend('DYLD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
        env.prepend('PKG_CONFIG_PATH',os.path.join(prereq_dir, 'lib', 'pkgconfig'))

    else:
        env.set("FFMPEG_ROOT_DIR",prereq_dir)
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
        env.prepend('PKG_CONFIG_PATH',os.path.join(prereq_dir, 'lib', 'pkgconfig'))

def set_nativ_env(env):
  pass
