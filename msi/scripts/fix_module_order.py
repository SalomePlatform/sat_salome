"""Fix SALOME module display order in the SAT-generated launcher.

SAT's generated `salome` launcher appends modules to SALOME_MODULES in
build order, which differs from the official SALOME toolbar order.
This script patches the launcher so that SALOME_MODULES is set once
with the correct complete order, and all appendVariable calls for
SALOME_MODULES are removed.

Called by pre_build.bat after copying the `salome` file from SAT output.

Usage:
    W64\\Python\\python.exe scripts\\fix_module_order.py
"""

import re
import os
import sys

# Official SALOME 9.15.0 module toolbar order
CORRECT_ORDER = (
    "SHAPER,SHAPERSTUDY,GEOM,SMESH,PARAVIS,YACS,JOBMANAGER,"
    "EFICAS,ADAO,HELLO,FIELDS,HEXABLOCK,PYHELLO,OPENTURNS"
)


def fix_salome_launcher(filepath):
    """Patch the salome launcher to use the correct module order."""
    if not os.path.isfile(filepath):
        print("  ERROR: {} not found".format(filepath))
        return False

    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()

    original = content

    # 1. Replace the initial setVariable for SALOME_MODULES with full correct order
    content = re.sub(
        r'context\.setVariable\(r"SALOME_MODULES",\s*r"[^"]*",\s*overwrite=True\)',
        'context.setVariable(r"SALOME_MODULES", r"{}", overwrite=True)'.format(CORRECT_ORDER),
        content,
    )

    # 2. Remove all appendVariable lines for SALOME_MODULES
    #    (they're now redundant since setVariable has the complete list)
    content = re.sub(
        r'^\s*context\.appendVariable\(r"SALOME_MODULES",[^\n]*\n',
        "",
        content,
        flags=re.MULTILINE,
    )

    if content == original:
        return True

    with open(filepath, "w", encoding="utf-8") as f:
        f.write(content)

    return True


def fix_env_launch(filepath):
    """Patch env_launch.bat to use the correct module order."""
    if not os.path.isfile(filepath):
        print("  WARNING: {} not found (will be created by SAT)".format(filepath))
        return True

    with open(filepath, "r", encoding="utf-8") as f:
        lines = f.readlines()

    new_lines = []
    removed = 0
    for line in lines:
        # Remove intermediate SALOME_MODULES append lines
        if re.match(r'^set SALOME_MODULES=%SALOME_MODULES%,', line, re.IGNORECASE):
            removed += 1
            continue
        # Replace initial SALOME_MODULES= with correct full order
        if re.match(r'^set SALOME_MODULES=', line, re.IGNORECASE) and '%SALOME_MODULES%' not in line:
            new_lines.append("set SALOME_MODULES={}\n".format(CORRECT_ORDER))
            continue
        new_lines.append(line)

    with open(filepath, "w", encoding="utf-8") as f:
        f.writelines(new_lines)

    return True


def fix_os_add_dll_directory(filepath):
    """Remove SAT's '#FIXME SALOME' hack from os.py.

    SAT patches os.add_dll_directory() to return None (bare 'return')
    which breaks any code using 'with os.add_dll_directory(path):'.
    """
    if not os.path.isfile(filepath):
        print("  WARNING: {} not found".format(filepath))
        return True

    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()

    # Remove the two-line hack: "        #FIXME SALOME\n        return\n"
    fixed = content.replace(
        "        #FIXME SALOME\n        return\n        import nt",
        "        import nt",
    )

    if fixed == content:
        return True

    with open(filepath, "w", encoding="utf-8") as f:
        f.write(fixed)

    return True


def fix_orbconfig_loopback(filepath):
    """Force omniORB to bind its CORBA sockets to loopback (127.0.0.1) only.

    SALOME's generated omniORB config has no `endPoint` directive, so omniORB
    binds its listening sockets to ALL interfaces (0.0.0.0). On Windows this
    triggers a Windows Firewall prompt at session-server launch, and allowing
    the rule requires admin credentials, which breaks the no-admin experience.

    SALOME's CORBA traffic is entirely localhost (single-machine desktop use),
    so we add `endPoint = giop:tcp:127.0.0.1:` to fillOrbConfigFileNoNS(), which
    both the SSL and non-SSL config paths call. omniORB then listens only on the
    loopback interface, which the firewall ignores, so no prompt and no admin.
    """
    if not os.path.isfile(filepath):
        print("  WARNING: {} not found".format(filepath))
        return True

    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()

    if "endPoint = giop:tcp:127.0.0.1" in content:
        return True

    anchor = '  orbdata.append("%snativeCharCodeSet = UTF-8"%(prefix))\n'
    if anchor not in content:
        print("  WARNING: ORBConfigFile.py anchor not found, skipped loopback fix")
        return True

    fixed = content.replace(
        anchor,
        anchor
        + '  orbdata.append("%sendPoint = giop:tcp:127.0.0.1:"%(prefix))'
        + "  # bind loopback only (no Windows Firewall prompt)\n",
    )

    with open(filepath, "w", encoding="utf-8") as f:
        f.write(fixed)

    return True


def fix_server_loopback_endpoint(filepath):
    """Force every CORBA server's command line to bind to loopback (127.0.0.1).

    Belt-and-suspenders companion to fix_orbconfig_loopback(): the omniORB
    config file `endPoint` directive should suffice, but SALOME's session
    server may bind before/independently of the config. Passing
    `-ORBendPoint giop:tcp:127.0.0.1:` on the command line has the HIGHEST
    precedence in omniORB (overrides config + defaults), so it is guaranteed
    to be honored. Injected in Server.run() (server.py), the single chokepoint
    through which the session server, containers, registry, etc. are spawned.

    Without this, the unsigned session server binds a LAN-facing socket and
    Windows Firewall prompts at launch, whose "allow" needs admin credentials.
    """
    if not os.path.isfile(filepath):
        print("  WARNING: {} not found".format(filepath))
        return True

    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()

    if "-ORBendPoint" in content:
        return True

    anchor = "        command = myargs + self.CMD\n"
    if anchor not in content:
        print("  WARNING: server.py anchor not found, skipped loopback fix")
        return True

    injection = (
        anchor
        + "        # SALOME MSI: bind CORBA servers to loopback only "
        + "(no Windows Firewall prompt / admin)\n"
        + '        if sys.platform == "win32" and self.CMD '
        + 'and "-ORBendPoint" not in self.CMD:\n'
        + '            command = command + ["-ORBendPoint", "giop:tcp:127.0.0.1:"]\n'
    )
    fixed = content.replace(anchor, injection)

    with open(filepath, "w", encoding="utf-8") as f:
        f.write(fixed)

    return True


if __name__ == "__main__":
    os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
    ok = True
    ok = fix_salome_launcher("salome") and ok
    ok = fix_env_launch("env_launch.bat") and ok
    ok = fix_os_add_dll_directory(os.path.join("W64", "Python", "lib", "os.py")) and ok
    ok = fix_orbconfig_loopback(os.path.join("W64", "KERNEL", "bin", "salome", "ORBConfigFile.py")) and ok
    ok = fix_server_loopback_endpoint(os.path.join("W64", "KERNEL", "bin", "salome", "server.py")) and ok
    if not ok:
        sys.exit(1)
