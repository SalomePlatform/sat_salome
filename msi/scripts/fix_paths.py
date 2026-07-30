# fix_paths.py - Fix hardcoded paths after SALOME MSI installation
# Called once post-install via silent_setup.vbs
# Usage: python fix_paths.py <install_path>

import os
import sys
import re


def find_old_path(install_root):
    """Detect old SAT build path from env_launch.bat or the salome launcher.

    SAT generates env_launch.bat with lines like:
        set KERNEL_ROOT_DIR=C:\S\SALOME-9.15.0\W64\KERNEL
    We extract the root before \W64\ to get the original build path.
    """
    # Try env_launch.bat first (most reliable — 1000+ lines of hardcoded paths)
    env_launch = os.path.join(install_root, "env_launch.bat")
    if os.path.exists(env_launch):
        try:
            with open(env_launch, "r", encoding="utf-8", errors="ignore") as f:
                content = f.read()
        except (OSError, PermissionError):
            content = ""

        # Match: set KERNEL_ROOT_DIR=C:\S\SALOME-9.15.0\W64\KERNEL
        m = re.search(
            r'set\s+KERNEL_ROOT_DIR\s*=\s*(.+?)\\W64\\',
            content, re.IGNORECASE
        )
        if m:
            found = m.group(1).strip()
            if os.path.normcase(found.rstrip("\\/")) != os.path.normcase(
                install_root.rstrip("\\/")
            ):
                return found

        # Fallback: PRODUCT_ROOT_DIR=...
        m = re.search(
            r'set\s+PRODUCT_ROOT_DIR\s*=\s*(.+)',
            content, re.IGNORECASE
        )
        if m:
            found = m.group(1).strip()
            if os.path.normcase(found.rstrip("\\/")) != os.path.normcase(
                install_root.rstrip("\\/")
            ):
                return found

    # Fallback: check the Python salome launcher script
    salome_launcher = os.path.join(install_root, "salome")
    if os.path.exists(salome_launcher):
        try:
            with open(salome_launcher, "r", encoding="utf-8", errors="ignore") as f:
                content = f.read()
        except (OSError, PermissionError):
            content = ""

        m = re.search(r"r'((?:[A-Z]:\\)[^']*?)\\W64\\", content)
        if m:
            found = m.group(1).strip()
            if os.path.normcase(found.rstrip("\\/")) != os.path.normcase(
                install_root.rstrip("\\/")
            ):
                return found

    # Fallback: scan .cmake files in W64/EXT/cmake for build paths
    cmake_dir = os.path.join(install_root, "W64", "EXT", "cmake")
    if os.path.isdir(cmake_dir):
        for dirpath, dirnames, filenames in os.walk(cmake_dir):
            for fname in filenames:
                if not fname.endswith(".cmake"):
                    continue
                fpath = os.path.join(dirpath, fname)
                try:
                    with open(fpath, "r", encoding="utf-8", errors="ignore") as f:
                        content = f.read(4096)
                except (OSError, PermissionError):
                    continue
                m = re.search(r'(C:/[^";\s]*?)/W64/', content)
                if m:
                    found = m.group(1).replace("/", "\\")
                    if os.path.normcase(found.rstrip("\\/")) != os.path.normcase(
                        install_root.rstrip("\\/")
                    ):
                        return found
            break  # only top level

    return None


def fix_text_files(install_root, old_path):
    """Replace old build paths with install path in all relevant text files."""
    new_path = install_root

    # Backslash variants
    old_back = old_path.replace("/", "\\")
    new_back = new_path.replace("/", "\\")

    # Forward-slash variants
    old_fwd = old_path.replace("\\", "/")
    new_fwd = new_path.replace("\\", "/")

    # JSON-escaped variants (double backslash)
    old_json = old_back.replace("\\", "\\\\")
    new_json = new_back.replace("\\", "\\\\")

    # Python raw-string variants (used in the salome launcher)
    old_pyraw = old_back  # r'C:\S\SALOME-9.15.0' in Python source
    new_pyraw = new_back

    extensions = (
        ".bat", ".cfg", ".py", ".cmake", ".pc", ".pth", ".conf",
        ".json", ".txt", "._pth", ".sh", ".ini", ".xml", ".env",
        ".settings",
    )

    # Also match the extensionless "salome" launcher
    special_files = {"salome"}

    count = 0

    # Root-level files (shallow scan — env_launch.bat, salome, etc.)
    for fname in os.listdir(install_root):
        fpath = os.path.join(install_root, fname)
        if os.path.isfile(fpath) and (fname.endswith(extensions) or fname in special_files):
            count += _fix_file(fpath, old_json, new_json, old_fwd, new_fwd, old_back, new_back)

    # Deep scan of W64
    w64_dir = os.path.join(install_root, "W64")
    if os.path.exists(w64_dir):
        for dirpath, dirnames, filenames in os.walk(w64_dir):
            dirnames[:] = [d for d in dirnames if d != "__pycache__"]
            for fname in filenames:
                if not fname.endswith(extensions):
                    continue
                fpath = os.path.join(dirpath, fname)
                count += _fix_file(
                    fpath, old_json, new_json, old_fwd, new_fwd, old_back, new_back
                )

    return count


def _fix_file(fpath, old_json, new_json, old_fwd, new_fwd, old_back, new_back):
    """Fix a single text file. Returns 1 if modified, 0 otherwise."""
    try:
        with open(fpath, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()
    except (OSError, PermissionError):
        return 0

    original = content
    content = content.replace(old_json, new_json)
    content = content.replace(old_fwd, new_fwd)
    content = content.replace(old_back, new_back)

    if content != original:
        try:
            with open(fpath, "w", encoding="utf-8") as f:
                f.write(content)
            return 1
        except (OSError, PermissionError):
            pass
    return 0


def strip_missing_products(install_root):
    """Remove env_launch.bat sections for products not installed (feature selection).

    env_launch.bat is structured as blocks separated by:
        rem setting environ for <product_name>
    For each block, we check if referenced directories exist. If a product's
    W64 directory is missing (user unchecked the feature), we remove the block
    and clean SALOME_MODULES entries.
    """
    env_launch = os.path.join(install_root, "env_launch.bat")
    if not os.path.exists(env_launch):
        return 0

    try:
        with open(env_launch, "r", encoding="utf-8", errors="ignore") as f:
            lines = f.readlines()
    except (OSError, PermissionError):
        return 0

    w64_dir = os.path.join(install_root, "W64")

    # Parse into sections: (product_name, [lines])
    # Lines before the first "rem setting environ for" go into a preamble
    sections = []  # list of (product_name_or_None, [lines])
    current_product = None
    current_lines = []

    for line in lines:
        m = re.match(r'^rem setting environ for (.+)', line, re.IGNORECASE)
        if m:
            # Save previous section
            sections.append((current_product, current_lines))
            current_product = m.group(1).strip()
            current_lines = [line]
        else:
            current_lines.append(line)
    sections.append((current_product, current_lines))

    # Determine which product directories exist under W64
    # A section references paths like: set XXX=<root>\W64\<dirname>\...
    # We check if W64\<dirname> exists for non-EXT products
    removed = 0
    kept_lines = []

    for product_name, section_lines in sections:
        if product_name is None:
            # Preamble — always keep
            kept_lines.extend(section_lines)
            continue

        # Check if any W64 path in this section references a missing directory
        section_text = "".join(section_lines)
        missing = False

        # Find W64\<dirname> references (but not W64\EXT which is shared)
        w64_refs = re.findall(
            r'\\W64\\([^\\%\s;]+)',
            section_text
        )
        # Unique product dirs referenced (exclude EXT — shared, always present)
        product_dirs = set()
        for ref in w64_refs:
            if ref.upper() not in ("EXT", "PYTHON"):
                product_dirs.add(ref)

        if product_dirs:
            # If ALL referenced non-shared dirs are missing, remove the section
            all_missing = all(
                not os.path.isdir(os.path.join(w64_dir, d))
                for d in product_dirs
            )
            if all_missing:
                missing = True

        if missing:
            removed += 1
        else:
            kept_lines.extend(section_lines)

    if removed == 0:
        return 0

    # Clean SALOME_MODULES lines: remove appended modules whose dirs are gone
    # e.g. "set SALOME_MODULES=%SALOME_MODULES%,OPENTURNS" when OPENTURNS is missing
    final_lines = []
    for line in kept_lines:
        m = re.match(
            r'^set SALOME_MODULES=%SALOME_MODULES%,(\w+)\s*$',
            line, re.IGNORECASE
        )
        if m:
            module = m.group(1)
            module_dir = os.path.join(w64_dir, module)
            if not os.path.isdir(module_dir):
                continue  # skip this module — not installed
        # Also clean the initial SALOME_MODULES= line
        m2 = re.match(r'^set SALOME_MODULES=(.+)$', line, re.IGNORECASE)
        if m2 and '%SALOME_MODULES%' not in line:
            modules = m2.group(1).strip().split(",")
            present = [
                mod for mod in modules
                if os.path.isdir(os.path.join(w64_dir, mod))
            ]
            line = "set SALOME_MODULES=" + ",".join(present) + "\n"
        # Also clean SALOME_MODULES_ORDER
        m3 = re.match(r'^set SALOME_MODULES_ORDER=(.+)$', line, re.IGNORECASE)
        if m3:
            modules = m3.group(1).strip().split(":")
            present = [
                mod for mod in modules
                if os.path.isdir(os.path.join(w64_dir, mod))
            ]
            line = "set SALOME_MODULES_ORDER=" + ":".join(present) + "\n"
        # Clean SalomeAppConfig entries for missing dirs
        m4 = re.match(r'^set SalomeAppConfig=%SalomeAppConfig%;(.+)$', line, re.IGNORECASE)
        if m4:
            config_path = m4.group(1).strip()
            # Extract W64\<product> from the path
            w64_match = re.search(r'\\W64\\([^\\]+)', config_path)
            if w64_match:
                prod = w64_match.group(1)
                if not os.path.isdir(os.path.join(w64_dir, prod)):
                    continue
        final_lines.append(line)

    try:
        with open(env_launch, "w", encoding="utf-8") as f:
            f.writelines(final_lines)
    except (OSError, PermissionError):
        return 0

    return removed


def check_vcredist():
    """Check if VC++ redistributable is likely installed."""
    sysroot = os.environ.get("SystemRoot", r"C:\Windows")
    vc_dlls = [
        os.path.join(sysroot, "System32", "msvcp140.dll"),
        os.path.join(sysroot, "System32", "vcruntime140.dll"),
    ]
    missing = [d for d in vc_dlls if not os.path.exists(d)]
    if missing:
        print("  WARNING: VC++ Runtime may not be installed.")
        print("  Missing: " + ", ".join(os.path.basename(f) for f in missing))
        print("  Download: https://aka.ms/vs/17/release/vc_redist.x64.exe")
        return False
    return True


def main():
    if len(sys.argv) < 2:
        print("Usage: python fix_paths.py <install_path>")
        sys.exit(1)

    install_root = sys.argv[1].rstrip("\\/")

    if " " in install_root:
        print("  WARNING: Installation path contains spaces.")
        print("  Some tools may not work correctly.")

    # Detect and fix old build paths
    old_path = find_old_path(install_root)
    if old_path:
        old_path = old_path.rstrip("\\/")
        print("  Old path: " + old_path)
        print("  New path: " + install_root)
        n = fix_text_files(install_root, old_path)
        print("  " + str(n) + " text files corrected.")
    else:
        print("  No path difference detected — skipping path replacement.")

    # Strip env_launch.bat sections for products not installed (feature selection)
    print("  Checking for uninstalled products...")
    stripped = strip_missing_products(install_root)
    if stripped:
        print("  Removed " + str(stripped) + " product sections from env_launch.bat.")
    else:
        print("  All products present.")

    # Check VC++ runtime
    print("  Checking VC++ Runtime...")
    check_vcredist()

    # Cleanup: remove post-install files that are no longer needed
    print("  Cleaning up post-install files...")
    cleanup_files = [
        os.path.join(install_root, "scripts", "silent_setup.vbs"),
        os.path.join(install_root, "scripts", "fix_paths.py"),
    ]
    for f in cleanup_files:
        try:
            if os.path.exists(f):
                os.remove(f)
        except (OSError, PermissionError):
            pass

    print("  Setup complete.")


if __name__ == "__main__":
    main()
