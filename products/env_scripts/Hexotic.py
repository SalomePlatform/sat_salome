#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path

def set_distene_licence(env):
    try:
        license_file = env.environ.get_value("LICENCE_FILE")
    except Exception as e:
        return
    if os.path.exists(license_file):
        env.add_line(1)
        env.add_comment("Set DISTENE License")
        env.set('DISTENE_LICENSE_FILE', 'Use global envvar: DLIM8VAR')

        if os.access(license_file, os.R_OK):
            lines = open(license_file, "r").readlines()
            for line in lines:
                id1=line.find('r"dlim8')
                if id1 != -1:
                    # on a trouvé la clé dlim8 dans line, on extrait sa valeur
                    id2=line.find('"', id1+2)
                    if id2 != -1:
                        env.set("DLIM8VAR", line[id1+2:id2])
                        break

def set_env(env, prereq_dir, version):
    if not env.forBuild:
        # we don't need licence keys at compile time
        set_distene_licence(env)
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))

def set_nativ_env(env):
    pass
