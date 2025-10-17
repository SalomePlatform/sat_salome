@echo off

echo ##########################################################################
echo mpir %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

IF NOT DEFINED CMAKE_GENERATOR (
  SET CMAKE_GENERATOR="Visual Studio 15 2017"
)

SET PRODUCT_BUILD_TYPE=release
IF DEFINED SAT_CMAKE_BUILD_TYPE (
  SET PRODUCT_BUILD_TYPE=%SAT_CMAKE_BUILD_TYPE%
)

if %SAT_DEBUG% == 1 (
  set PRODUCT_BUILD_TYPE=debug
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
if NOT exist "%PRODUCT_INSTALL%\include" mkdir %PRODUCT_INSTALL%\include
if NOT exist "%PRODUCT_INSTALL%\lib" mkdir %PRODUCT_INSTALL%\lib

REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%
cd %SOURCE_DIR%
xcopy * %BUILD_DIR%\ /E /I /Q

cd %BUILD_DIR%\build.vc15\lib_mpir_gc

REM Upgrade to current version of MSVC
echo.
echo *** devenv lib_mpir_gc.vcxproj /upgrade
devenv lib_mpir_gc.vcxproj /upgrade
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on devenv
    exit 1
)

echo.
echo *********************************************************************
echo *** msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64 /p:WindowsTargetPlatformVersion=%WindowsSDKVersion% lib_mpir_gc.vcxproj
echo *********************************************************************
echo.

msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% /p:Platform=x64 /p:WindowsTargetPlatformVersion=%WindowsSDKVersion% lib_mpir_gc.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild  lib_mpir_gc.vcxproj
    exit 2
)

copy /Y x64\%PRODUCT_BUILD_TYPE%\mpir.h %PRODUCT_INSTALL%\include\mpir.h
copy /Y x64\%PRODUCT_BUILD_TYPE%\mpirxx.h %PRODUCT_INSTALL%\include\mpirxx.h
copy /Y /B x64\%PRODUCT_BUILD_TYPE%\mpir_a.lib %PRODUCT_INSTALL%\lib\mpir.lib
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on copy  mpir.lib
    exit 2
)
