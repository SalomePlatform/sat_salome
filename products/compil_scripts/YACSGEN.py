#!/usr/bin/env python
#-*- coding:utf-8 -*-
import subprocess

def compil(config, builder, logger):
    builder.prepare()
    if not builder.install_dir.exists():
        builder.install_dir.make()
    
    command = "python setup.py install --prefix=" + str(builder.install_dir)
    res = subprocess.call(command,
                          shell=True,
                          #cwd=str(helper.build_dir),
                          cwd=str(builder.source_dir),
                          env=builder.build_environ.environ.environ,
                          stdout=logger.logTxtFile,
                          stderr=subprocess.STDOUT)
    if res != 0:
        res = 1
    return res
