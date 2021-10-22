#!/usr/bin/env python
#-*- coding:utf-8 -*-

import os.path
import platform
from distutils.version import LooseVersion

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
  return

def set_DASSAULT_license(env, version):
  try:
    license_file_prefix = env.environ.get_value("LICENCE_FILE")
    linux_dist = env.environ.get_value("sat_dist")
  except Exception as e:
    return
  env.add_comment("DASSAULT MeshGems KeyGenerator based License")
  if platform.system() == "Windows" :
    license_file_name=license_file_prefix + '-' + version + '.dll'
  else:
    license_file_name=license_file_prefix + '-' + version + '-' + linux_dist + '.so'

  if not os.path.exists(license_file_name):
     print("\nWARNING : DASSAULT license file %s not found!" % license_file_name) 

  env.set('SALOME_MG_KEYGEN_LIB_PATH', license_file_name)
  return

def set_env_build(env, prereq_dir, version):
  env.set('MESHGEMSHOME', prereq_dir)
  env.set('MESHGEMS_ROOT_DIR', prereq_dir)    # update for cmake

  env.prepend('PATH', os.path.join(prereq_dir, 'bin'))

  if platform.system() == "Windows" :
    env.prepend('PATH', os.path.join(prereq_dir, 'lib'))
  else :
    libdir = "Linux_64"
    env.prepend('PATH', os.path.join(prereq_dir, 'bin', libdir))
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib', libdir))

def set_env(env, prereq_dir, version):
  env.add_comment("Here you can define your license parameters for MeshGems")
  if LooseVersion(version) > LooseVersion('2.12-1'):
    set_DASSAULT_license(env,version)
  else:
    env.add_comment("DISTENE license")
    if not env.forBuild:
      # we don't need licence keys at compile time
      set_distene_licence(env)
  set_env_build(env, prereq_dir, version)


def set_nativ_env(env):
  pass
