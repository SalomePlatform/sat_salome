@echo off

echo ##########################################################################
echo bsd-xdr $VERSION
echo ##########################################################################

IF NOT DEFINED SAT_DEBUG (
  SET SAT_DEBUG=0
)

IF NOT DEFINED CMAKE_GENERATOR (
  SET CMAKE_GENERATOR="Visual Studio 15 2017 Win64"
)

SET PRODUCT_BUILD_TYPE=release

if %SAT_DEBUG% == 1 (
  set PRODUCT_BUILD_TYPE=debug
)

if exist "%PRODUCT_INSTALL%" rmdir /Q /S "%PRODUCT_INSTALL%"
mkdir %PRODUCT_INSTALL%

set CMAKE_OPTIONS=-DCMAKE_INSTALL_PREFIX:STRING=%PRODUCT_INSTALL:\=/%
set CMAKE_OPTIONS=%CMAKE_OPTIONS% -DCMAKE_GENERATOR=%CMAKE_GENERATOR%

set MSBUILDDISABLENODEREUSE=1

cd %SOURCE_DIR%

sed -i "s|# Where netcdf will be installed:||g" cmake\ConfigUser.cmake
sed -i "s|set (CMAKE_INSTALL_PREFIX z:/software)||g" cmake\ConfigUser.cmake
sed -i "s|typedef __int8            int8_t;|// typedef __int8            int8_t;|g" rpc\types.h

cd %BUILD_DIR%

echo.
echo --------------------------------------------------------------------------
echo *** %CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
echo --------------------------------------------------------------------------
echo.

%CMAKE_ROOT%\bin\cmake %CMAKE_OPTIONS% %SOURCE_DIR%
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on cmake"
    exit 1
)

echo.
echo --------------------------------------------------------------------------
echo *** %CMAKE_ROOT%\bin\cmake --build . --config Release --target INSTALL
echo --------------------------------------------------------------------------
echo.

%CMAKE_ROOT%\bin\cmake --build . --config Release --target INSTALL
if NOT %ERRORLEVEL% == 0 (
    echo "ERROR on cmake build"
    exit 2
)

taskkill /F /IM "mspdbsrv.exe"

echo.
echo ########## END
