@echo off

echo ##########################################################################
echo omniORB %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

if NOT defined CYGWIN_ROOT_DIR (
  echo ERROR: Please set the environment variable: CYGWIN_ROOT_DIR
  exit 1
) else (
  echo INFO: Cygwin suite environment variable is set to: %CYGWIN_ROOT_DIR%
)

if exist "%BUILD_DIR%" rmdir /Q /S "%BUILD_DIR%"
mkdir %BUILD_DIR%

cd %SOURCE_DIR%
xcopy * %BUILD_DIR% /E /I /Q
if NOT %ERRORLEVEL% == 0 (
  echo ERROR on xcopy
  exit 2
)

REM select the correct platform
set CONFIG_MK=%BUILD_DIR%\config\config.mk
set CONFIG_REF=%BUILD_DIR%\config\config.mk.ref
set CONFIG_DBG=%BUILD_DIR%\config\config.mk.dbg
copy %CONFIG_MK% %CONFIG_REF%
if %SAT_DEBUG% == 0 (
  echo INFO: activating platform target: x86_win32_vs_15
  sed "s/#platform = x86_win32_vs_15/platform = x86_win32_vs_15/g" < %CONFIG_REF% >  %CONFIG_MK%
)

REM target our Python in the configuration file
set PLATFORM_MK=%BUILD_DIR%\mk\platforms\x86_win32_vs_15.mk
set PLATFORM_REF=%BUILD_DIR%\mk\platforms\x86_win32_vs_15.mk.ref
copy %PLATFORM_MK% %PLATFORM_REF%

set CYGWIN_PYTHON_ROOT_DIR=%PYTHON_ROOT_DIR:\=\/%
set CYGWIN_PYTHON_ROOT_DIR=%CYGWIN_PYTHON_ROOT_DIR::=%
echo Setting path to Python binary...
sed "s/#PYTHON = \/cygdrive\/c\/Python36\/python/PYTHON = \/cygdrive\/%CYGWIN_PYTHON_ROOT_DIR%\/python/g" < %PLATFORM_REF% >  %PLATFORM_MK%.1

echo Setting path to openssl binary (don't use /cygwin path approach since it's buggy use path a la windows...
set CYGWIN_OPENSSL_ROOT_DIR=%OPENSSL_ROOT_DIR:\=\/%
sed "s/#OPEN_SSL_ROOT = \/cygdrive\/c\/openssl/OPEN_SSL_ROOT = %CYGWIN_OPENSSL_ROOT_DIR%/g" < %PLATFORM_MK%.1 >  %PLATFORM_MK%
cd %BUILD_DIR%\src
echo INFO: compilation starts now...
set PATH=%PATH%;%CYGWIN_ROOT_DIR%\bin;%PYTHON_ROOT_DIR%
make export
if NOT %ERRORLEVEL% == 0 (
   echo ERROR on make export
   exit 3
)

cd %BUILD_DIR%
xcopy * %INSTALL_DIR% /E /I /Q
if NOT %ERRORLEVEL% == 0 (
   echo ERROR on xcopy
   exit 4
)

echo.
echo ########## END
