@echo off

echo ##########################################################################
echo Cython %VERSION%
echo ##########################################################################

REM install in python directly
SET INSTALL_CENTRALLY=1

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

cd %SOURCE_DIR%

echo.
echo --------------------------------------------------------------------------
echo *** Launching "python.exe setup.py build"
echo --------------------------------------------------------------------------
set BUILD_OPT=
REM not built by OCCT - see spns #20292 attached Excel document
REM if %SAT_DEBUG% == 1 (
REM    set BUILD_OPT=--debug
REM)

%PYTHON_ROOT_DIR%\python.exe setup.py build %BUILD_OPT%


echo.
echo --------------------------------------------------------------------------
echo *** Launching "python.exe setup.py install"
echo --------------------------------------------------------------------------
if %INSTALL_CENTRALLY% == 1 (
    %PYTHON_ROOT_DIR%\python.exe setup.py install 
) else (
    %PYTHON_ROOT_DIR%\python.exe setup.py install  --single-version-externally-managed --root=/ --prefix=%PRODUCT_INSTALL% --install-lib=%PRODUCT_INSTALL%\lib\python%PYTHON_VERSION%\site-packages
)
if NOT %ERRORLEVEL% == 0  (
    echo "ERROR on setup install"
    exit 3
)

REM In debug mode, we need to rename all .pyd to _d.pyd... don't ask why. Seems like a known bug in OmniORB.
if %SAT_DEBUG% == 1 (
  cd %PYTHON_ROOT_DIR%\lib\site-packages\Cython-0.29.12-py3.6-win-amd64.egg
  powershell -Command "Get-ChildItem -File -Recurse *.pyd| ForEach-Object {if ((!$_.Name.EndsWith('_d.pyd'))) {  $_ | Copy-Item -Destination {$_.Name  -replace '.pyd','_d.pyd'}}}"
  cd %PYTHON_ROOT_DIR%lib\site-packages\Cython-0.29.12-py3.6-win-amd64.egg\Cython\Runtime
  powershell -Command "Get-ChildItem -File -Recurse *.pyd| ForEach-Object {if ((!$_.Name.EndsWith('_d.pyd'))) {  $_ | Copy-Item -Destination {$_.Name  -replace '.pyd','_d.pyd'}}}"
)

echo.
echo Product %PRODUCT_NAME% version: %VERSION%> %PRODUCT_INSTALL%\README.txt
echo Installation folder: %PYTHON_ROOT_DIR%>> %PRODUCT_INSTALL%\README.txt

echo.
echo ########## END
