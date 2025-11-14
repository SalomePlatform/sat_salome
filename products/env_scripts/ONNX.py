#!/usr/bin/env python
import os.path
import platform

def set_env(env, prereq_dir, version):
    env.set('ONNX_ROOT_DIR', prereq_dir)    # update for cmake
    # access to ispc binary
    if platform.system() == "Windows" :
        env.prepend('PATH', os.path.join(prereq_dir, 'lib'))
        env.set('onnxruntime_DIR', os.path.join(prereq_dir, 'lib', 'cmake', 'onnxruntime'))
    else:
        env.set('onnxruntime_DIR', os.path.join(prereq_dir, 'lib64', 'cmake', 'onnxruntime'))
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib64'))
