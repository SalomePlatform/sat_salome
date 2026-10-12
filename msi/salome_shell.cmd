@echo off
if defined SALOME_SHELL_LOADED goto :ready
call "%~dp0env_salome.bat"
set "SALOME_SHELL_LOADED=1"

:: ── ANSI escape for colors (Windows 10+) ──
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

:: ── Welcome message ──
echo.
echo %ESC%[92m SALOME 9.15.0 environment is configured!%ESC%[0m
echo.

:: ── Launch cmd with clink (tab-completion, history) ──
set "CLINK_INJECT=rem"
if exist "%~dp0clink\clink_x64.exe" (
    set "CLINK_INJECT=%~dp0clink\clink_x64.exe inject --quiet"
)
%SystemRoot%\System32\cmd.exe /k "set PROMPT=(SALOME 9.15) $P$G & %CLINK_INJECT% >nul 2>&1"
exit /b

:ready
