@echo off

echo ##########################################################################
echo URANIE %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

IF NOT DEFINED CMAKE_GENERATOR (
  SET CMAKE_GENERATOR="Visual Studio 15 2017"
)

SET PRODUCT_BUILD_TYPE=Release
IF DEFINED SAT_CMAKE_BUILD_TYPE (
  SET PRODUCT_BUILD_TYPE=%SAT_CMAKE_BUILD_TYPE%
)
if %SAT_DEBUG% == 1 (
  set PRODUCT_BUILD_TYPE=Debug
)

set PLATFORM_TARGET=Win32

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

SET CMAKE_OPTIONS=-DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE:STRING=%PRODUCT_BUILD_TYPE%
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DWITH-OPT++:BOOL=ON
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -DWITH-JSONCPP:BOOL=ON
SET CMAKE_OPTIONS=%CMAKE_OPTIONS% -D--enable-doc:BOOL=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -G %CMAKE_GENERATOR%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -A Win32 -Thost=x64
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -D--enable-WIN32-DEBUG=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPTHREAD_ROOT_DIR=%PTHREAD_ROOT_DIR:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPTHREAD_INCLUDE_DIR=%PTHREAD_ROOT_DIR:\=/%/include
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPTHREAD_DLL_LIBRARY=%PTHREAD_ROOT_DIR:\=/%/lib/pthreadVC2.dll
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DPTHREAD_LIBRARY=%PTHREAD_ROOT_DIR:\=/%/lib/pthreadVCE2.lib


SET INCLUDE=

cd %BUILD_DIR%
echo.
echo --------------------------------------------------------------------------
echo *** %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
echo --------------------------------------------------------------------------

%CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on CMake
    exit 1
)

echo.
echo --------------------------------------------------------------------------
echo *** msbuild %MAKE_OPTIONS% ALL_BUILD.vcxproj /p:Configuration=%PRODUCT_BUILD_TYPE%  /p:Platform=%PLATFORM_TARGET%
echo --------------------------------------------------------------------------

msbuild %MAKE_OPTIONS% ALL_BUILD.vcxproj /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=%PLATFORM_TARGET%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild ALL_BUILD.vcxproj
    exit 2
)

echo.
echo --------------------------------------------------------------------------
echo *** msbuild %MAKE_OPTIONS% INSTALL.vcxproj /p:Configuration=%PRODUCT_BUILD_TYPE%  /p:Platform=%PLATFORM_TARGET%
echo --------------------------------------------------------------------------

msbuild %MAKE_OPTIONS% INSTALL.vcxproj /p:Configuration=%PRODUCT_BUILD_TYPE%  /p:Platform=%PLATFORM_TARGET%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild INSTALL.vcxproj
    exit 3
)

taskkill /F /IM "mspdbsrv.exe"

echo.
echo ########## END
