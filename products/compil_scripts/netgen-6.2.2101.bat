@echo off

echo ##########################################################################
echo NETGEN %VERSION%
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

SET PRODUCT_BUILD_TYPE=Release
if %SAT_DEBUG% == 1 (
  set PRODUCT_BUILD_TYPE=Debug
)

if NOT exist "%PRODUCT_INSTALL%" mkdir %PRODUCT_INSTALL%
REM clean BUILD directory
if exist "%BUILD_DIR%" rmdir /Q /S %BUILD_DIR%
mkdir %BUILD_DIR%

echo **
echo ** Build CMAKE 3.16.7

cd %BUILD_DIR%
7z x -y %SOURCE_DIR%\cmake-3.16.7.tar.gz
7z x -y cmake-3.16.7.tar
mv cmake-v3.16.7 cmake-3.16.7-SRC
set CMAKE_PRODUCT_SOURCE_DIR=%BUILD_DIR%\cmake-3.16.7-SRC
set CMAKE_PRODUCT_BUILD_DIR=%BUILD_DIR%\cmake-3.16.7-BUILD
set CMAKE_PRODUCT_INSTALL_DIR=%BUILD_DIR%\cmake-3.16.7-X64

mkdir %BUILD_DIR%\cmake-3.16.7-BUILD
REM enter cmake build directory
cd %CMAKE_PRODUCT_BUILD_DIR%

set CMAKE_OPTIONS=-DCMAKE_INSTALL_PREFIX:STRING=%CMAKE_PRODUCT_INSTALL_DIR:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE:STRING=Release
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR=%CMAKE_GENERATOR%

echo.
echo --------------------------------------------------------------------------
echo cmake %CMAKE_OPTIONS% %CMAKE_PRODUCT_SOURCE_DIR%
echo --------------------------------------------------------------------------
cmake %CMAKE_OPTIONS% %CMAKE_PRODUCT_SOURCE_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on cmake"
    exit 1
)

echo.
echo --------------------------------------------------------------------------
echo msbuild %MAKE_OPTIONS% /p:Configuration=Release /p:PlatformTarget=%PLATFORM_TARGET% ALL_BUILD.vcxproj
echo --------------------------------------------------------------------------
msbuild %MAKE_OPTIONS% /p:Configuration=Release /p:PlatformTarget=%PLATFORM_TARGET% ALL_BUILD.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild ALL_BUILD.vcxproj
    exit 2
)

echo.
echo --------------------------------------------------------------------------
echo msbuild %MAKE_OPTIONS% /p:Configuration=Release /p:PlatformTarget=%PLATFORM_TARGET% INSTALL.vcxproj
echo --------------------------------------------------------------------------
msbuild %MAKE_OPTIONS% /p:Configuration=Release /p:PlatformTarget=%PLATFORM_TARGET% INSTALL.vcxproj
if NOT %ERRORLEVEL% == 0 (
    echo ERROR on msbuild INSTALL.vcxproj
    exit 3
)

REM expand PATH to use this cmake version
set CMAKE_ROOT=%CMAKE_PRODUCT_INSTALL_DIR%
set PATH=%CMAKE_ROOT%\bin;%PATH%

cd %BUILD_DIR%

cmake --version


set CMAKE_OPTIONS=
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DUSE_GUI=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DUSE_PYTHON=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DUSE_MPI=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DUSE_OCC=ON
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DENABLE_UNIT_TESTS=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DUSE_INTERNAL_TCL=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DBUILD_STUB_FILES=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCASROOT=%CASROOT%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DOCC_INCLUDE_DIR=%CASROOT:\=/%/inc
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DOCC_LIBRARY_DIR=%CASROOT:\=/%/win64/vc14/lib
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DZLIB_ROOT_DIR=%ZLIB_DIR:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DZLIB_INCLUDE_DIR=%ZLIB_INCLUDE_DIR:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DUSE_SUPERBUILD=OFF
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_CXX_STANDARD=17
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_INSTALL_PREFIX=%PRODUCT_INSTALL:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_BUILD_TYPE=%PRODUCT_BUILD_TYPE%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR="Visual Studio 15 2017 Win64"

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

taskkill /F /IM "mspdbsrv.exe"

echo.
echo ########## END
