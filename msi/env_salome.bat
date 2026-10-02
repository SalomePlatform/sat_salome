@echo off
setlocal EnableDelayedExpansion

:: ── Skip if already initialized ──
if defined SALOME_ROOT (
    endlocal
    goto :eof
)

:: ── Detect install root from this script's location ──
set "ROOT=%~dp0"
set "ROOT=%ROOT:~0,-1%"

:: ── Check for spaces in path ──
echo %ROOT%| findstr /C:" " >nul 2>&1
if not errorlevel 1 (
    echo.
    echo   [WARNING] Installation path contains spaces: %ROOT%
    echo   SALOME may not work correctly.
    echo   Recommended: reinstall to C:\SALOME\9.15.0
    echo.
)

:: ── Delegate to SAT-generated environment script ──
endlocal & (
    set "SALOME_ROOT=%ROOT%"
    call "%ROOT%\env_launch.bat"
    set "SALOME_MODULES_ORDER=SHAPER:SHAPERSTUDY:GEOM:SMESH:PARAVIS:YACS:JOBMANAGER:EFICAS:ADAO:HELLO:FIELDS:HEXABLOCK:PYHELLO:OPENTURNS"
)
