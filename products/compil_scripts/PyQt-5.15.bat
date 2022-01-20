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
xcopy * %BUILD_DIR%\ /E /I /Q
cd %BUILD_DIR%

echo.
echo --------------------------------------------------------------------------
echo *** python configure.py
echo --------------------------------------------------------------------------

SET BUILD_OPTIONS=
if %SAT_DEBUG% == 1 (
 SET BUILD_OPTIONS= --debug --no-dist-info -u
)

SET BUILD_OPTIONS=%BUILD_OPTIONS% -b %PRODUCT_INSTALL:\=/%/bin
SET BUILD_OPTIONS=%BUILD_OPTIONS% -d %PRODUCT_INSTALL:\=/%
SET BUILD_OPTIONS=%BUILD_OPTIONS% -v %PRODUCT_INSTALL:\=/%/sip
SET BUILD_OPTIONS=%BUILD_OPTIONS% --stubsdir=%PRODUCT_INSTALL:\=/%/lib/site-packages
SET BUILD_OPTIONS=%BUILD_OPTIONS% --designer-plugindir=%PRODUCT_INSTALL:\=/%/plugins/designer
SET BUILD_OPTIONS=%BUILD_OPTIONS% --qml-plugindir=%PRODUCT_INSTALL:\=/%/plugins/qml
SET BUILD_OPTIONS=%BUILD_OPTIONS% --no-qsci-api
SET BUILD_OPTIONS=%BUILD_OPTIONS% --spec=win32-msvc
SET BUILD_OPTIONS=%BUILD_OPTIONS% --confirm-license
SET BUILD_OPTIONS=%BUILD_OPTIONS% --disable=QtNfc --disable=QtNetwork --disable=QtWebSockets 
SET BUILD_OPTIONS=%BUILD_OPTIONS% --target-py-version=%PYTHON_VERSION%

%PYTHONBIN% configure.py %BUILD_OPTIONS:\=/% 
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on python configure.py %BUILD_OPTIONS:\=/% 
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
