@echo off

echo ##########################################################################
echo omniORBpy %VERSION%
echo ##########################################################################

if NOT defined CYGWIN_ROOT_DIR (
  echo ERROR: Please set the environment variable: CYGWIN_ROOT_DIR
  exit 2
) else (
  echo INFO: Cygwin suite environment variable is set to: %CYGWIN_ROOT_DIR%
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

set OMNIORBPY_WORK_DIR=%OMNIORB_ROOT_DIR%\src\lib\omniORBpy
cd %SOURCE_DIR%
if exist "%OMNIORBPY_WORK_DIR%" rmdir /Q /S "%OMNIORBPY_WORK_DIR%"
mkdir %OMNIORBPY_WORK_DIR%

xcopy * %OMNIORBPY_WORK_DIR% /E /I /Q
if NOT %ERRORLEVEL% == 0 (
  echo ERROR on xcopy
  exit 1
)

cd %OMNIORBPY_WORK_DIR%
echo INFO: compilation starts now...
set PATH=%PATH%;%CYGWIN_ROOT_DIR%\bin;%PYTHON_ROOT_DIR%
make export
if NOT %ERRORLEVEL% == 0 (
   echo ERROR on make export
   exit 2
)

if %SAT_DEBUG% == 1 (
  cd %PRODUCT_INSTALL%
  powershell -Command "Get-ChildItem -File -Recurse *.pyd| ForEach-Object {if ((!$_.Name.EndsWith('_d.pyd'))) {  $_ | Copy-Item -Destination {$_.Name  -replace '.pyd','_d.pyd'}}}"
)
echo.
echo ########## END
