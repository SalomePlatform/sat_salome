#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path

def set_env(env, prereq_dir, version):
    env.set('PERLROOT', prereq_dir)
    
    env.set('PERL_ROOT_DIR', prereq_dir)

    env.prepend('PATH', prereq_dir)
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
    env.prepend('PATH', os.path.join(prereq_dir, 'lib'))


def set_nativ_env(env):
    pass

