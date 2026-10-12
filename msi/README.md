# SALOME Windows MSI installer

This folder holds the SALOME specific files SAT uses to build a **per-user Windows
MSI installer** of SALOME (no admin rights needed), via
[WiX Toolset]:

```bat
sat package <application> --build_msi
```

The build logic itself is generic and lives in the SAT repository (`src/msi.py`). This folder only
provides the SALOME elements (WiX package, launchers, branding, scripts). SAT retrieves them
through the `installer` section in `salome-W10.pyconf`.

---

## Prerequisites

| Requirement | Notes |
|-------------|-------|
| **WiX Toolset v4 (or higher)** on PATH | `dotnet tool install --global wix` (check with `wix --version`) |
| **WiX UI extension** installed | `wix extension add -g WixToolset.UI.wixext` (provides the installer's wizard UI; SAT passes the `-ext` flag for you) |
| A **Windows compiled SALOME install** with launcher | run once: `sat prepare` / `compile` / `environ` / `launcher` (produces `W64/`, `env_launch.bat`, `salome`) |
| **A SAT that has `--build_msi`** | i.e. this feature merged, or the `feat/build-msi` branch |

---

## Step-by-step Instructions


Run these commands from the SAT root (the folder that contains the `sat` script). The Windows project must be registered first: copy `salome-W10.pyconf` to `salome.pyconf`. 

**If SALOME is already compiled** (the `workdir` already contains `W64/`,
`env_launch.bat` and `salome`), you only need the last command:

```bat
py sat package SALOME-9.15.0-windows --build_msi
```

**On a fresh machine** (nothing built yet), run the one-time prerequisites first,
then build the MSI. These four steps produce the compiled install. They are done
once, not on every MSI build:

```bat
:: --- one-time prerequisites (produce the compiled install) ---
:: 1. Fetch the product sources (add --external to use public GitHub mirrors)
py sat prepare  SALOME-9.15.0-windows

:: 2. Compile the products (produces W64/)
py sat compile  SALOME-9.15.0-windows

:: 3. Generate the environment (env_launch.bat) and the launcher (salome)
py sat environ  SALOME-9.15.0-windows
py sat launcher SALOME-9.15.0-windows

:: --- build the MSI (repeatable) ---
py sat package  SALOME-9.15.0-windows --build_msi
```

`prepare`, `compile`, `environ` and `launcher` are standard SAT commands. Only `package --build_msi` is newly added here: it reads the compiled install and never rebuilds it.

### Where the MSI is created

Everything is produced **inside the application's own `workdir`**, the directory
where `sat compile` installed the application (it contains `W64/`, `env_launch.bat`,
`salome`). SAT resolves it as `LOCAL.workdir + APPLICATION.name`, e.g. `C:\S\SALOME-9.15.0`.

By default, under that `workdir`:

```
<workdir>\                              e.g.  C:\S\SALOME-9.15.0\
├─ W64\  env_launch.bat  salome         (your compiled install, layout untouched)
└─ MSI\                                 <- staging (default name "MSI")
   ├─ W64  ->  ..\W64                   (junction, not a copy)
   ├─ Package.wxs, scripts\, …          (installer resources)
   ├─ w64_files.wxs                     (generated)
   └─ build\<APPLICATION.name>-win64.msi   <- THE MSI
```

- Only the sub-folder names `MSI` and `build` are fixed, the rest of the path is
  the user's own `workdir`. Nothing is written to the directory you run `sat` from.
- Change the staging location with `installer.staging_dir`, and the file name with `--name`:

```bat
py sat package SALOME-9.15.0-windows --build_msi --name SALOME-9.15.0.msi
```

---

## What `--build_msi` does

```
sat package <app> --build_msi
   │
   ├─ read the 'installer' section (salome-W10.pyconf)
   ├─ build a lean staging tree in <workdir>\MSI :
   │      • msi/*  (Package.wxs, launchers, branding, scripts, optional clink)  -> copied
   │      • env_launch.bat / salome  (SAT-generated)                                 -> copied
   │      • W64\                                                                       -> JUNCTION to <workdir>\W64  (no copy, to go faster)
   ├─ run  pre_build.py  (SALOME runtime fixes, see below)
   ├─ generate  w64_files.wxs  (one <Component> per directory)
   └─ wix build  Package.wxs  shortcuts.wxs  w64_files.wxs   ->  build\<app>-win64.msi
```

**Hybrid staging.** The multi-GB `W64` tree is NOT copied. It is referenced in
place through a Windows directory junction (`mklink /J`, instant, no admin). Only
the small resources and launcher files are copied. This keeps the build fast and
avoids duplicating several GB on disk.

**One component per directory** (not per file): with one component per file,
SALOME's ~156 000 files would blow past MSI's 65 536-component limit; grouping by
directory keeps it around ~10 000.

### `pre_build.py` staging fixes

These fixes only add files or patch existing ones, and re-running them is safe.
Nothing is deleted since `W64` is a junction, destructive steps (removing build
artifacts or test folders) would erase files from the real install, so they are
deliberately skipped.

1. `scripts/fix_module_order.py`: GUI module order (patched in the launcher
   *copies*), plus `os.add_dll_directory` restore and omniORB loopback binding
   (patched in `W64` **in place**, through the junction, which avoids the admin
   firewall prompt);
2. copy the sip runtime into the PyQt5 package;
3. bundle the VC++ runtime DLLs SAT omits (`vcomp140.dll`, `mfc140.dll`);
4. create `sitecustomize.py` (Python 3.8+ DLL directory registration);
5. create `python3.exe`.

> **Note:** since `W64` is referenced in place, the fixes applied to it (steps 2 to 5,
> and the omniORB/`os.py` part of step 1) touch the **real install**. These are small,
> safe runtime improvements. The launchers `salome` and `env_launch.bat` are
> patched in the staging **copies**, so the originals stay untouched, and nothing is
> deleted from the install.

---

## Directory contents

| Path | Role |
|------|------|
| `Package.wxs` | WiX package: branding, per-user scope, `WixUI_Mondo`, custom actions, **feature tree**. |
| `shortcuts.wxs` | Desktop + Start-menu shortcuts (GUI, Shell). |
| `pre_build.py` | Staging fixes (run by SAT in the staging tree). |
| `scripts/fix_paths.py` | Post-install: rewrite SAT's hardcoded build path to the install path; prune env for unselected features. |
| `scripts/fix_module_order.py` | Module order + DLL + omniORB loopback (pre-build). |
| `scripts/silent_setup.vbs` | VBS bootstrap running `fix_paths.py` (MSI custom action). |
| `scripts/show_deps.py` | Diagnostic: print a PE file's direct DLL imports. |
| `env_salome.bat`, `salome.cmd`, `salome_shell.cmd` | Runtime launchers. |
| `salome.ico`, `License.rtf` | App icon and the LGPL 2.1 license. |
| `clink/` | Optional shell tab-completion. Third-party tool, **not included** here; download it separately to enable the feature (see "Optional: shell tab-completion" below). |

The SAT-generated `env_launch.bat` / `salome` are not stored here; SAT copies
them into the staging tree at build time. The compiled `W64/` tree is neither
stored nor copied: it is referenced in place via a junction.

---

## Installer banner images 

`Package.wxs` uses two images for the wizard, but they are **not included** in this
repository (provide your own branding):

| File | Size | Where it shows |
|------|------|----------------|
| `ui_banner.bmp` | 493 x 58 px | top banner of the wizard pages |
| `ui_dialog.bmp` | 493 x 312 px | left side of the welcome / finish pages |

⚠️ Put both files in `msi/` before building. If they are missing, `wix build` fails with
a "file not found" error. To use the built-in WiX images instead, remove the
`WixUIBannerBmp` and `WixUIDialogBmp` lines from `Package.wxs`.

---

## Configuration (`salome-W10.pyconf` → `installer`)

The `installer` section tells SAT's generic builder how to package this project:

- `resources_dir` → this directory;
- `wxs_sources` → `Package.wxs`, `shortcuts.wxs`;
- `pre_build_script` → `pre_build.py`;
- `tree.product_groups` → maps each `W64/<product>` directory to a WiX
  `ComponentGroup` (which drives the feature tree in `Package.wxs`);
- `tree.skip_products` → build-only products excluded from the MSI
  (`cmake`, `swig`, `sip`, `ispc`, `llvm`, `perl`, `wheel`, `cppunit`,
  `doxygen`, `graphviz`);
- `wix_arch`, `wix_extensions`, `generated_wxs`, `guid_namespace`.

**Adding a new product:** if it needs its own installable feature, add a
`ComponentGroup` mapping under `tree.product_groups` and reference it from a
`<Feature>` in `Package.wxs`. Products with no explicit mapping default to
`CG_<dirname>` and land in the Core feature.

---

## Feature tree

| Feature | Contents |
|---------|----------|
| **Core** (required) | KERNEL, GUI, Python, Qt, OpenCASCADE, MEDCOUPLING, omniORB, … + shortcuts |
| **Geometry** | GEOM, SHAPER (+ CGAL, cork, eigen, libigl, planegcs) |
| **Meshing** | SMESH, Netgen, Gmsh, BLSurf, GHS3D, Hybrid, Hexotic, HexaBlock, MMG |
| **Post-Processing** | PARAVIS (+ ParaView + OpenTURNS runtime), FIELDS |
| **Solvers** | YACS, ADAO, CALCULATOR, EFICAS, Job Manager |
| **Uncertainty** | PERSALYS, OpenTURNS, PyFMI |
| **Shell tab-completion** (optional, not bundled) | clink |

---

## Optional: shell tab-completion (clink)

[clink](https://github.com/chrisant996/clink) adds command-line tab-completion and
history to the SALOME shell. It is a third-party tool and is **not stored in this
repository**. To include it in the MSI, download a clink release and extract it
into `msi/clink/` before building:

```
msi/clink/
├─ clink_x64.exe
├─ clink_dll_x64.dll
├─ clink.bat
├─ default_inputrc
└─ default_settings
```

If `clink/` is absent, the build still succeeds: the "Shell tab-completion" feature
is generated empty and installs nothing, and the shell works normally without it.

---

## Post-install (automatic)

SAT hardcodes the build path (e.g. `C:\S\SALOME-9.15.0`) in 1000+ files. On
install, the MSI runs `scripts/silent_setup.vbs` → `scripts/fix_paths.py`, which:

1. rewrites the build path to the chosen install path in `env_launch.bat`,
   `salome`, and `W64/` text files;
2. strips `env_launch.bat` sections for products whose feature was unchecked
   (prevents DLL-not-found at launch);
3. self-deletes.

---

