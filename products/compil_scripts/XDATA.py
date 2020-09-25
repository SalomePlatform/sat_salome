#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os
import platform

def compil(config, builder, logger):

    res_prepare = builder.prepare()

    if platform.system() == "Windows" :
        res_configure = builder.cmake()
        res_make = builder.wmake()
    else:
        res_configure = builder.configure()
        res_make = builder.make(builder.nb_proc)

    res_install = builder.install()

    res = res_prepare + res_configure + res_install
    if res != 0:
        res = 1

    return res
