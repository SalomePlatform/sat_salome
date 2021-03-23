@echo off

echo ##########################################################################
echo PyQt %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %SOURCE_DIR%

call :NORMALIZEPATH "%PRODUCT_INSTALL%\..\Python"
set python_exe=%RETVAL%\python.exe
set python_name=python%PYTHON_VERSION%

call :NORMALIZEPATH "%PRODUCT_INSTALL%\..\sip"
set sip_incdir=%RETVAL%\include\%python_name%

echo.
echo --------------------------------------------------------------------------
echo *** python configure.py
echo --------------------------------------------------------------------------

set PRODUCT_BUILD_TYPE=
if %SAT_DEBUG% == 1 (
   python configure.py --confirm-license --no-designer-plugin --debug --bindir=%PRODUCT_INSTALL%\bin --destdir=%PRODUCT_INSTALL%\lib\%python_name%\site-packages --sipdir=%PRODUCT_INSTALL%\sip --spec=win32-msvc --sip-incdir=%sip_incdir% --pyuic5-interpreter=%python_exe% --disable QtNfc --disable=QtNetwork --disable=QtWebSockets 2>&1
) else (
   python configure.py --confirm-license --no-designer-plugin --bindir=%PRODUCT_INSTALL%\bin --destdir=%PRODUCT_INSTALL%\lib\%python_name%\site-packages --sipdir=%PRODUCT_INSTALL%\sip --spec=win32-msvc --sip-incdir=%sip_incdir% --pyuic5-interpreter=%python_exe% --disable QtNfc --disable=QtNetwork --disable=QtWebSockets 2>&1
) 
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on python configure.py
    exit 1
)

REM Compilation
echo.
echo --------------------------------------------------------------------------
echo *** nmake
echo --------------------------------------------------------------------------

nmake VERBOSE=1
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on nmake
    exit 2
)

REM Installation
echo.
echo --------------------------------------------------------------------------
echo *** nmake install
echo --------------------------------------------------------------------------

nmake install
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on nmake install"
    exit 3
)

REM In debug mode, we need to rename all .pyd to _d.pyd.
if %SAT_DEBUG% == 1 (
  cd %PRODUCT_INSTALL%\lib\%python_name%\site-packages\PyQt5
  powershell -Command "Get-ChildItem -File -Recurse *.pyd| ForEach-Object {if ((!$_.Name.EndsWith('_d.pyd'))) {  $_ | Copy-Item -Destination {$_.Name  -replace '.pyd','_d.pyd'}}}"
  powershell -Command "Get-ChildItem -File -Recurse *_d.pyd| ForEach-Object {if (($_.Name.EndsWith('_d.pyd'))) {  $_ | Copy-Item -Destination {$_.Name  -replace '_d.pyd','.pyd'}}}"
)

echo.
echo ########## END

:: ========== FUNCTIONS ==========
EXIT /B

:NORMALIZEPATH
  SET RETVAL=%~dpfn1
  EXIT /B
