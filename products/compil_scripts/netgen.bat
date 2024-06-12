@echo off

echo ##########################################################################
echo NETGEN %VERSION%
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

dos2unix -q %SOURCE_DIR%/libsrc/occ/*
dos2unix -q %SOURCE_DIR%/libsrc/nglib/*

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

set CMAKE_OPTIONS=
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX=%PRODUCT_INSTALL%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE=%PRODUCT_BUILD_TYPE%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DZLIB_ROOT_DIR=%ZLIB_DIR%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCASROOT=%CASROOT%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -G %CMAKE_GENERATOR% -A x64

set MSBUILDDISABLENODEREUSE=1

cd %BUILD_DIR%

echo.
echo --------------------------------------------------------------------------
echo *** %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
echo --------------------------------------------------------------------------

%CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on cmake
    exit 1
)

echo.
echo *********************************************************************
echo *** msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% ALL_BUILD.vcxproj
echo *********************************************************************
echo.

msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% ALL_BUILD.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild ALL_BUILD.vcxproj
    exit 2
)

echo.
echo *********************************************************************
echo *** installation... msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% INSTALL.vcxproj
echo *********************************************************************
echo.

msbuild %MAKE_OPTIONS% /p:Configuration=%PRODUCT_BUILD_TYPE% INSTALL.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild INSTALL.vcxproj
    exit 3
)

REM move DLL to bin, in order to reduce the PATH length..
MOVE /Y %PRODUCT_INSTALL%\lib\nglib.dll  %PRODUCT_INSTALL%\bin\nglib.dll
if NOT %ERRORLEVEL% == 0 (
    echo ERROR could not move DLL to BIN directory...
    exit 4
)

taskkill /F /IM "mspdbsrv.exe"

echo.
echo ########## END
