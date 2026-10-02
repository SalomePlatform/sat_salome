#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""SALOME MSI staging fixes, run by ``sat package --build_msi`` in the staging tree.

The generic SAT builder (src/msi.py) has already assembled the staging tree:
project installer resources plus the SALOME install (W64 referenced in place via a
junction, env_launch.bat and salome copied). This script applies the SALOME-specific
runtime fixes the MSI needs, operating on the current working directory (the staging
root). Only additive / in-place patch fixes run; nothing is deleted, because W64 is a
junction to the real install:

  1. fix module display order + os.add_dll_directory + omniORB loopback
     (delegated to scripts/fix_module_order.py)
  2. copy the sip runtime into the PyQt5 package
  3. bundle the VC++ runtime DLLs SAT omits (vcomp140.dll, mfc140.dll)
  4. create sitecustomize.py (Python 3.8+ DLL directory registration)
  5. create python3.exe (SALOME launcher calls the Linux name)

All steps are idempotent and safe to re-run. Requires no third-party module.
"""

import os
import sys
import glob
import shutil
import subprocess

ROOT = os.getcwd()          # staging root (set by the SAT builder)
W64 = os.path.join(ROOT, "W64")


def step(msg):
    print("  [pre_build] " + msg)


# 1 ─ module order / DLL / omniORB loopback -------------------------------------
def fix_module_order():
    script = os.path.join(ROOT, "scripts", "fix_module_order.py")
    if os.path.isfile(script):
        subprocess.call([sys.executable, script])
    else:
        step("WARNING: scripts/fix_module_order.py missing, skipped")


# 2 ─ sip runtime into PyQt5 ----------------------------------------------------
def copy_sip_runtime():
    matches = glob.glob(os.path.join(W64, "sip", "Lib", "site-packages", "PyQt5", "sip*.pyd"))
    dst = os.path.join(W64, "PyQt", "PyQt5")
    if matches and os.path.isdir(dst):
        for m in matches:
            shutil.copy2(m, dst)
    else:
        step("WARNING: sip runtime not found, PyQt5 may be incomplete")


# 4 ─ bundle missing VC++ runtime DLLs ------------------------------------------
def _find_vc_dll(name, keyword):
    """Locate a VC++ redist DLL (x64, matching keyword) or fall back to System32."""
    roots = [os.environ.get("ProgramFiles(x86)", ""), os.environ.get("ProgramFiles", "")]
    for r in roots:
        base = os.path.join(r, "Microsoft Visual Studio")
        if not os.path.isdir(base):
            continue
        for walk_dir, _subdirs, files in os.walk(base):
            low = walk_dir.lower()
            if name in files and "x64" in low and keyword.lower() in low and "onecore" not in low:
                return os.path.join(walk_dir, name)
    sys32 = os.path.join(os.environ.get("windir", r"C:\Windows"), "System32", name)
    return sys32 if os.path.isfile(sys32) else None


def bundle_vc_dlls():
    ext_bin = os.path.join(W64, "EXT", "bin")
    os.makedirs(ext_bin, exist_ok=True)
    for name, keyword in (("vcomp140.dll", "OpenMP"), ("mfc140.dll", "MFC")):
        src_dll = _find_vc_dll(name, keyword)
        if src_dll:
            shutil.copy2(src_dll, os.path.join(ext_bin, name))
        else:
            step("WARNING: %s not found, install VC++ Redistributable x64" % name)
    # vcomp140 must also sit next to the software-GL renderer
    osmesa_dir = os.path.join(W64, "mesa", "x64", "osmesa-swrast")
    vcomp = os.path.join(ext_bin, "vcomp140.dll")
    if os.path.isdir(osmesa_dir) and os.path.isfile(vcomp):
        shutil.copy2(vcomp, osmesa_dir)


# 5 ─ sitecustomize.py ----------------------------------------------------------
SITECUSTOMIZE = '''\
# sitecustomize.py - SALOME DLL directory registration (Python 3.8+)
import sys, os
_dll_handles = []
if sys.platform == "win32" and sys.version_info >= (3, 8):
    for p in os.environ.get("PATH", "").split(os.pathsep):
        if p and os.path.isdir(p):
            try:
                _dll_handles.append(os.add_dll_directory(p))
            except OSError:
                pass
'''


def create_sitecustomize():
    dst_dir = os.path.join(W64, "Python", "lib", "site-packages")
    if os.path.isdir(dst_dir):
        with open(os.path.join(dst_dir, "sitecustomize.py"), "w", encoding="utf-8") as f:
            f.write(SITECUSTOMIZE)


# 6 ─ python3.exe ---------------------------------------------------------------
def create_python3():
    py = os.path.join(W64, "Python", "python.exe")
    py3 = os.path.join(W64, "Python", "python3.exe")
    if os.path.isfile(py) and not os.path.isfile(py3):
        shutil.copy2(py, py3)


def main():
    if not os.path.isdir(W64):
        print("ERROR: W64 not found in staging root %s" % ROOT)
        return 1
    # W64 is referenced in place through a junction (SAT hybrid staging), so only
    # additive / in-place patch fixes run here. Destructive steps (strip_artifacts,
    # clean_data) are intentionally NOT called: through the junction they would
    # delete files from the real install tree. Build artifacts are simply left in
    # the tree (the MSI includes them, as a hand-written WiX build also does).
    fix_module_order()      # patch launcher/env copies + W64 runtime files (os.py, omniORB)
    copy_sip_runtime()      # additive: sip .pyd into PyQt5
    bundle_vc_dlls()        # additive: vcomp140 / mfc140 into W64\EXT\bin
    create_sitecustomize()  # additive: W64\Python DLL-dir registration
    create_python3()        # additive: python3.exe alias
    return 0


if __name__ == "__main__":
    sys.exit(main())
